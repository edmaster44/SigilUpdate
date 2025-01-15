/*
	New Feats that modify the number of attacks per round. Methodical Defense = lose half attacks gain that much AC
	max 3. Considered Strike is lose half attacks and gain that much AB, max 3. And Staff Fighting is like double-weapon
	from nwn1 for polearms: Get -2 AB and +1 attack per round. Problem is that EffectModifyAttacks() doesn't stack, 
	so I can't have staff and the other two be separate effects. I have to add them up and apply them as a single effect. 
	Also I simply don't want people to be able to use both Methodical Defense and Considered Strike at the same time as
	that would give double the benefit with the same penalty. Solution: use local ints to track what effect is intended to 
	be on and use a single spell id for the effect, the actual ids only used to identify which effect is being activated.
	

*/
#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "ff_feat_tactical_weapon_inc"


const int MODE_STAFF 	= 14709;
const int MODE_DEF 		= 14719;
const int MODE_STRIKE	= 14720;
const int ALL_OFF		= 0;
const int DEF_ON 		= 1;
const int DEF_OFF		= 2;
const int STRIKE_ON		= 3;
const int STRIKE_OFF	= 4;
const int STAFF_ON		= 5;
const int STAFF_OFF		= 6;
const string DEF_STATE_ON 	= "MethodicalDefenseState";
const string STRIKE_STATE_ON = "ConsideredStrikeOn";
const string STAFF_STATE_ON = "StaffFightingOn";
const string sDefOffFb 	= "Deactivating Methodical Defense";
const string sDefOnFb	= "Activating Methodical Defense";
const string sStrikeOffFb = "Deactivating Considered Strike";
const string sStrikeOnFb = "Activating Considered Strike";
const string sStaffOffFb = "Deactivating Staff-Fighting Mode";
const string sStaffOnFb = "Activating Staff-Fighting Mode";
const string sBabError = "You can only use this ability if your Base Attack Bonus is 6 or higher";

void UpdateCombatMods(object oPC, int nAction = NULL, object oChanged = OBJECT_INVALID, int bOnEquip = FALSE);
int GetHalfAttacks(object oPC, object oRHAND);
int GetQualifiesForStaffFighting(object oPC, object oRHAND, object oLHAND);
struct CombatMods PerformToggleFunctions(struct CombatMods data);
struct CombatMods PerformNonToggleFunctions(struct CombatMods data);
struct CombatMods ConsideredStrike(struct CombatMods data);
struct CombatMods MethodicalDefense(struct CombatMods data);
struct CombatMods StaffFighting(struct CombatMods data);
struct CombatMods CreatureTWF(struct CombatMods data);
struct CombatMods OversizeTwoWeaponFighting(struct CombatMods data);
struct CombatMods TwoSwordsAsOne(struct CombatMods data);
struct CombatMods XbowAndSharpshooter(struct CombatMods data);
void ApplyCombatMods(struct CombatMods data);
void IajaitsuMaster(struct CombatMods data);
void FrightfulPresence(object oPC);
void FrightfulPresence(object oPC);
void GiveFeedback(object oPC, string sMessage);

struct CombatMods{
	int nAPR; // attacks per round
	int nAB; //attack bonus/penalty
	int nDam; // damage bonus
	int nDamType; // damage bonus type
	int nAC; // AC bonus
	object oPC;
	object oSkin;
	object oRHAND;
	object oLHAND;
	object oChanged; // from ps_inc_equipment, only need for IajaitsuMaster
	int bOnEquip; // as above
	int nAction;
	int bUsingDef;
	int bUsingStrike;
	int bUsingStaff;
};




// this needs to be updated on login, level up, and when weapons change because BAB and what weapon is equipped affects this,
// so it's called as the final step in ff_tactical_weapon_inc (which is called from ps_inc_equipment), ff_update_feats, and ps_onpcloaded
void UpdateCombatMods(object oPC, int nAction = NULL, object oChanged = OBJECT_INVALID, int bOnEquip = FALSE){
	

	object oTarget = OBJECT_INVALID;
	if (GetIsInCombat(oPC)) oTarget = GetAttackTarget(oPC);
	
	object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC); 
	object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	object oSkin = PS_GetCreatureSkin(oPC);
	object oEss = PS_GetEssence(oPC);
	// get current state of modes
	int bUsingDef = GetLocalInt(oEss, DEF_STATE_ON);
	int bUsingStrike = GetLocalInt(oEss, STRIKE_STATE_ON);
	int bUsingStaff = GetLocalInt(oEss, STAFF_STATE_ON);

	
	// remove all fx and confirm for intentional ones that will not 
	// be reapplied
	PS_RemoveEffects(oPC, COMBAT_MODS_FX); // reserved spell id, defined in aaa_constants
	if (bUsingDef && (nAction == DEF_OFF || nAction == STRIKE_ON))
		GiveFeedback(oPC, sDefOffFb);
	if (bUsingStrike && (nAction == STRIKE_OFF || nAction == DEF_ON))
		GiveFeedback(oPC, sStrikeOffFb);
	if (bUsingStaff && nAction == STAFF_OFF)
		GiveFeedback(oPC, sStaffOffFb);
	
	
	// figure out what we want these states to be. If the action is NULL we're just
	// double checking that the current states are still valid, so we don't change
	// anything from the current states unless they're not.
	switch (nAction){
		case DEF_ON: bUsingDef = TRUE; bUsingStrike = FALSE; break;
		case DEF_OFF: bUsingDef = FALSE; break;
		case STRIKE_ON: bUsingDef = FALSE; bUsingStrike = TRUE; break;
		case STRIKE_OFF: bUsingStrike = FALSE; break;
		case STAFF_ON: bUsingStaff = TRUE; break;
		case STAFF_OFF: bUsingStaff = FALSE; break;
	}
	// a de-leveled pc might have a state saved that they can no longer use
	// so turn off any states that they don't have the feat for.
	if (!GetHasFeat(FEAT_METHODICAL_DEFENSE, oPC, TRUE)) bUsingDef = FALSE;
	if (!GetHasFeat(FEAT_CONSIDERED_STRIKE, oPC, TRUE)) bUsingStrike = FALSE;
	if (!GetHasFeat(FEAT_STAFF_FIGHTING, oPC, TRUE)) bUsingStaff = FALSE;
	
	// only the weirdest unforseen bug could result in both def and strike active at the same time
	// but just in case...
	if (bUsingDef && bUsingStrike){
		bUsingDef = FALSE;
		bUsingStrike = FALSE; 
	}
	
	struct CombatMods data;
	data.nAPR = 0;
	data.nAB = 0;
	data.nAC = 0;
	data.nDam = 0;
	data.nDamType = DAMAGE_TYPE_BLUDGEONING;
	data.oPC = oPC;
	data.oSkin = oSkin;
	data.oRHAND = oRHAND;
	data.oLHAND = oLHAND;
	data.oChanged = oChanged;
	data.bOnEquip = bOnEquip;
	data.nAction = nAction;
	data.bUsingDef = bUsingDef;
	data.bUsingStrike = bUsingStrike;
	data.bUsingStaff = bUsingStaff;
	
	if (nAction == ALL_OFF){
		SetLocalInt(oEss, DEF_STATE_ON, FALSE);
		SetLocalInt(oEss, STRIKE_STATE_ON, FALSE);
		SetLocalInt(oEss, STAFF_STATE_ON, FALSE);
		data = PerformNonToggleFunctions(data);
		ApplyCombatMods(data);
		return;
	}
	
	data = PerformToggleFunctions(data);
	data = PerformNonToggleFunctions(data);
	
	// now align the local integers with our results
	SetLocalInt(oEss, DEF_STATE_ON, data.bUsingDef);
	SetLocalInt(oEss, STRIKE_STATE_ON, data.bUsingStrike);
	SetLocalInt(oEss, STAFF_STATE_ON, data.bUsingStaff);
	
	ApplyCombatMods(data);
	
	if (oTarget != OBJECT_INVALID){
		ClearAllActions(TRUE);
		DelayCommand(0.1f, ActionAttack(oTarget));
	}
}

struct CombatMods PerformToggleFunctions(struct CombatMods data){

	if (data.bUsingDef) data = MethodicalDefense(data);
	if (data.bUsingStrike) data = ConsideredStrike(data);
	if (data.bUsingStaff) data = StaffFighting(data);
	return data;
}

struct CombatMods PerformNonToggleFunctions(struct CombatMods data){
	data = CreatureTWF(data);
	data = OversizeTwoWeaponFighting(data);
	data = XbowAndSharpshooter(data);
	data = TwoSwordsAsOne(data);
	IajaitsuMaster(data);
	return data;
}

/*******************************************************************************************************
						toggle
********************************************************************************************************/

struct CombatMods MethodicalDefense(struct CombatMods data){
	int nHalfAttacks = GetHalfAttacks(data.oPC, data.oRHAND);
	if (nHalfAttacks > 0){
		data.nAPR -= nHalfAttacks;
		data.nAC += nHalfAttacks;
		if (data.nAction == DEF_ON) GiveFeedback(data.oPC, sDefOnFb);
	} else {
		data.bUsingDef = FALSE;
		SendMessageToPC(data.oPC, sBabError);
		GiveFeedback(data.oPC, sDefOffFb);
	}
	return data;
}

struct CombatMods ConsideredStrike(struct CombatMods data){
	int nHalfAttacks = GetHalfAttacks(data.oPC, data.oRHAND);
	if (nHalfAttacks > 0){
		data.nAPR -= nHalfAttacks;
		data.nAB += nHalfAttacks;
		if (data.nAction == STRIKE_ON) GiveFeedback(data.oPC, sStrikeOnFb);
	} else {
		data.bUsingStrike = FALSE;
		SendMessageToPC(data.oPC, sBabError);
		GiveFeedback(data.oPC, sStrikeOffFb);
	}
	return data;
}

struct CombatMods StaffFighting(struct CombatMods data){
	int bQualifies = GetQualifiesForStaffFighting(data.oPC, data.oRHAND, data.oLHAND);
	if (!bQualifies){
		SendMessageToPC(data.oPC, "You can only use Staff-Fighting Mode while wielding a Staff or Spear that is a normal size for your character in both hands. If you are using a Scythe or Halberd, you also need Weapon Focus in that weapon.");
		data.bUsingStaff = FALSE;
		GiveFeedback(data.oPC, sStaffOffFb);
		return data;
	}
	data.nAPR += 1;
	data.nAB -= 2;
	if (data.nAction == STAFF_ON) GiveFeedback(data.oPC, sStaffOnFb);
	return data;
}
/*******************************************************************************************************
				non - toggle
********************************************************************************************************/

// Feat that reduces the penalty for using a larger than normal offhand weapon by 2. 
struct CombatMods OversizeTwoWeaponFighting(struct CombatMods data){
	// We're not going to check for regular twf because that's 
	// already a requirement in feat.2da to have oversize twf. Bail if they don't have it.
	if (!GetHasFeat(FEAT_OVERSIZE_TWF, data.oPC, TRUE)) return data;
	
	// bail if not dual wielding.
	if (!IPGetIsMeleeWeapon(data.oLHAND)) return data;
	
	if (IPGetWeaponSize(data.oLHAND) >= GetCreatureSize(data.oPC))
	{
		data.nAB += 2;
	}
	return data;
}


struct CombatMods XbowAndSharpshooter(struct CombatMods data){
	//RemoveBonusFeats(data.oSkin, FEAT_RAPID_RELOAD);
	int nRightId = GetBaseItemType(data.oRHAND);
	int bIsXbow = (nRightId == BASE_ITEM_HEAVYCROSSBOW || 
		nRightId == BASE_ITEM_LIGHTCROSSBOW);
	int bSharpshooter = GetHasFeat(FEAT_SHARPSHOOTER, data.oPC, FALSE);
	if (!bSharpshooter && !bIsXbow) return data;
	
	int nAB = 0;
	// check for crossbow features. +1 ab because they're easy to aim, 
	// temp rapid reload if strong enough
	if (bIsXbow){
		nAB += 1;
		int bGetsRR = FALSE;
		int nReqStr = 13;
		if (nRightId == BASE_ITEM_HEAVYCROSSBOW) nReqStr = 15;
		bGetsRR = (GetAbilityScore(data.oPC, ABILITY_STRENGTH, FALSE) >= nReqStr);
		
		if (bGetsRR && !GetHasFeat(FEAT_RAPID_RELOAD, data.oPC, TRUE))
			ApplyTacticalBonusFeat(data.oSkin, FEAT_RAPID_RELOAD);
	}
	// now check for Sharpshooter
	if (bSharpshooter){
		int nDex = GetAbilityModifier(ABILITY_DEXTERITY, data.oPC);
		int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, data.oPC);
	
		if (nInt > nDex){
			if (nDex > 0) nAB += nInt - nDex; // don't count dex if it's a negative
			else nAB += nInt;
		}
	}
	if (nAB > 0){
		data.nAB += nAB;
	}
	return data;
}

// gain twf automatically if the off hand is a creature weapon. if you have twf already you get 
// no penalty for a creature weapon (though you still have normal penalties for non creature weapons 
// if one is creature and one is not). If your offhand creature weapon is the same size category as 
// character negate additional penalties for oversize twf unless it's already negated by oversize twf 
// feat. These bonuses do not apply to creature weapons that are larger category than the character 
// because a monkey-gripped creature weapon isn't one that the character has natural use of.
struct CombatMods CreatureTWF(struct CombatMods data){
	int bLisCreature = IPGetIsCreatureEquippedWeapon(data.oLHAND);
	
	//RemoveBonusFeats(data.oSkin, FEAT_TWO_WEAPON_FIGHTING);
	// bail if off hand is not a creature weap
	if (!bLisCreature) return data;

	int nBonus = 0;
	int nPCsize = GetCreatureSize(data.oPC);
	int nLWeaponSize = IPGetWeaponSize(data.oLHAND);
	int bHasTWF = GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, data.oPC, TRUE);

	// if they don't have twf and the left is a creature weapon of normal size, give them twf
	if (nLWeaponSize <= nPCsize && !bHasTWF)
		ApplyTacticalBonusFeat(data.oSkin, FEAT_TWO_WEAPON_FIGHTING);
	// if they're using an off hand creature weapon that is the same size cat as themselves
	// reduce penalty by 2 unless oversize twf is doing that already
	if (nLWeaponSize == nPCsize && !GetHasFeat(FEAT_OVERSIZE_TWF, data.oPC, TRUE))
		nBonus = 2;
	
	data.nAB += nBonus;

	return data;
}


//Samurais get AB and damage bonus when they dual wield katana/longsword in main hand and shortsword or ninjato in off hand.
struct CombatMods TwoSwordsAsOne(struct CombatMods data){
    int nSAMURAI = GetLevelByClass(65, data.oPC);
    if (nSAMURAI < 2) return data;
	
	int nPCsize = GetCreatureSize(data.oPC);
	int bRightQualifies = FALSE;
	int bLeftQualifies = FALSE;
	
	int nRIGHT = GetBaseItemType(data.oRHAND);
	int nLEFT = GetBaseItemType(data.oLHAND);
	
	// Whoever came up with the rules for TSAO didn't think about the fact that in nwn weapons do not
	// change size to accomodate the character. So I fix that here.
	
	// large Samurai can use a falchion, greatsword, or odachi in the right hand
	// and katana in left
	if (nPCsize > 3){
		bRightQualifies = (nRIGHT == BASE_ITEM_FALCHION || nRIGHT == BASE_ITEM_GREATSWORD ||
			nRIGHT == BASE_ITEM_ODACHI);
		bLeftQualifies = (nLEFT == BASE_ITEM_KATANA || nLEFT == BASE_ITEM_LONGSWORD);
	// small samurai can use a ninjato or shortsword in the right hand and dagger or kukri in the left
	// otherwise they would have massive penalties making a small samurai unplayable
	} else if (nPCsize < 3){
		bRightQualifies = (nRIGHT == BASE_ITEM_NINJATO || nRIGHT == BASE_ITEM_SHORTSWORD);
		bLeftQualifies = (nLEFT == BASE_ITEM_DAGGER || nLEFT == BASE_ITEM_KUKRI);
	} 
	// the orginal weapons still qualify, but added ninjato as a left hand option
	if (nRIGHT == BASE_ITEM_KATANA || nRIGHT == BASE_ITEM_LONGSWORD) bRightQualifies = TRUE;
	if (nLEFT = BASE_ITEM_SHORTSWORD || nLEFT == BASE_ITEM_NINJATO) bLeftQualifies = TRUE;
	
	
	if (!bRightQualifies || !bLeftQualifies) return data;
	 
    int nBONUS = 1;
    int nDMG_TYPE = DAMAGE_TYPE_BLUDGEONING;
    if (nSAMURAI >= 30) nDMG_TYPE = DAMAGE_TYPE_DIVINE;
    if (nSAMURAI >= 26) nBONUS = 5;
    else if (nSAMURAI >= 21) nBONUS = 4;
    else if (nSAMURAI >= 16) nBONUS = 3;
    else if (nSAMURAI >= 11) nBONUS = 2;
	data.nAB += nBONUS;
	data.nDam = nBONUS;
	data.nDamType = nDMG_TYPE;
	return data;
}

//At level 5, when the Samurai draws a longsword or katana (in right hand) they gain an attack bonus 
//equal to their charisma bonus for 1 round. They also gain 1 extra attack for that round as well. 
// Because attack bonuses do not stack this need to be last and take the longer duration bonuses
// into account when applying the 1 round bonus. EffectModifyAttacks also doesn't stack, so the
// character won't get the bonus attack if using methodical defense or considered strike, which makes
// sense, considering that those are supposed to grant their bonuses because the character is moving
// cautiously
void IajaitsuMaster(struct CombatMods data){

	if (!data.bOnEquip) return;
	if (data.oChanged != data.oRHAND) return;
	
	int bQualifies = FALSE;
	int nPCsize = GetCreatureSize(data.oPC);
	int nITEM = GetBaseItemType(data.oRHAND);
    if ((nITEM == BASE_ITEM_KATANA) || (nITEM == BASE_ITEM_LONGSWORD) || 
		(nITEM == BASE_ITEM_ODACHI) || nITEM == (BASE_ITEM_NINJATO))
			bQualifies = TRUE;
	if (nPCsize > 3 && (nITEM == BASE_ITEM_FALCHION || nITEM == BASE_ITEM_GREATSWORD || 
		nITEM == BASE_ITEM_ODACHI)) bQualifies == TRUE;
	if (nPCsize < 3 && (nITEM == BASE_ITEM_SHORTSWORD)) bQualifies = TRUE;
	if (!bQualifies) return;
	
    if (GetHasFeat(2414, data.oPC, TRUE))
    {
        int nCHA = GetAbilityModifier(ABILITY_CHARISMA, data.oPC);
        float fDUR = RoundsToSeconds(1);
        effect eFX = EffectModifyAttacks(1);
        if (nCHA > 0) eFX = EffectLinkEffects(eFX, EffectAttackIncrease(nCHA + data.nAB));
        eFX = ExtraordinaryEffect(eFX);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, data.oPC, fDUR);
    }
    DelayCommand(0.01f, FrightfulPresence(data.oPC));
}

//When a Samurai draws their weapon (a katana or longsword) foes can be frightened by it.
void FrightfulPresence(object oPC){
    if (GetHasFeat(2419, oPC, TRUE) == FALSE) return;
    location lPC = GetLocation(oPC);
    int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    float fDUR = RoundsToSeconds(nCHA);
    int nDC = 20 + nCHA;
    int nHD;
    effect eFX_1 = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_STUN));
    effect eFX_2 = EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_SPELL_FEAR));
    effect eFX_3 = EffectLinkEffects(EffectLinkEffects(EffectACDecrease(2), EffectAttackDecrease(2)), EffectVisualEffect(VFX_DUR_SPELL_DOOM));
    object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
    while (oTARGET != OBJECT_INVALID)
    {
        if (GetIsEnemy(oTARGET, oPC) == TRUE)
        {
            if (WillSave(oTARGET, nDC, SAVING_THROW_TYPE_FEAR, oPC) == SAVING_THROW_CHECK_FAILED)
            {
                nHD = GetHitDice(oTARGET);
                if (nHD >= 20) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_3, oTARGET, fDUR);
                else if (nHD >= 5) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_2, oTARGET, fDUR);
                else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_1, oTARGET, fDUR);    
            }
        }
        oTARGET = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
    }
}

/*******************************************************************************************************

********************************************************************************************************/

int GetHalfAttacks(object oPC, object oRHAND){
	int nBab = GetBaseAttackBonus(oPC);
	if (nBab < 6){
		SendMessageToPC(oPC, "Cannot use this feat with a base attack bonus lower than 6");
		return -1;
	}
	int nMaxLoss = 3;
	int nItem = GetBaseItemType(oRHAND);
	if (nItem == BASE_ITEM_HEAVYCROSSBOW || nItem == BASE_ITEM_LIGHTCROSSBOW){
		if (GetHasFeat(FEAT_RAPID_RELOAD, oPC, TRUE)) nMaxLoss = 1;
		else {
			SendMessageToPC(oPC, "Cannot use this feat with a crossbow unless you have Rapid Reload");
			return -1;
		}
	}
	int nNumAttacks = ((nBab - 1) / 5) + 1;
	int nHalfAttacks = nNumAttacks / 2;
	if (nHalfAttacks > nMaxLoss) nHalfAttacks = nMaxLoss;
	return nHalfAttacks;
}

void GiveFeedback(object oPC, string sMessage){
	string sPrevious = GetLocalString(oPC, "previous_toggle_message");
	if (sMessage != sPrevious){
		FloatingTextStringOnCreature(sMessage, oPC);
		//SendMessageToPC(oPC, sMessage);
		SetLocalString(oPC, "previous_toggle_message", sMessage);
	}
}

void ApplyCombatMods(struct CombatMods data){
	effect eFX = EffectDarkVision(); // EffectDarkVision doesnt work, so I'll use it as ab
	// placeholder effect to build an effect chain off of

	int bApplyChange = FALSE;
	if (data.nAPR != 0){
		bApplyChange = TRUE;
		// not currently possible to be >5 or < -5, but who knows what future devs will do.
		// the effect breaks if you try to add or subtract more than 5.
		if (data.nAPR > 5) data.nAPR = 5;
		else if (data.nAPR < -5) data.nAPR = -5;
		effect eAPR = EffectModifyAttacks(data.nAPR);
		eFX = EffectLinkEffects(eAPR, eFX);
	}
	if (data.nAB != 0){
		bApplyChange = TRUE;
		effect eAB;
		if (data.nAB > 0) eAB = EffectAttackIncrease(data.nAB);
		else eAB = EffectAttackDecrease(data.nAB * -1); // accepts a positive integer for the nerf
		eFX = EffectLinkEffects(eAB, eFX);
	}
	
	if (data.nDam != 0){
		bApplyChange = TRUE;
		effect eDAM;
		if (data.nDam > 0) eDAM = EffectDamageIncrease(data.nDam, data.nDamType);
		else eDAM = EffectDamageDecrease(data.nDam * -1, data.nDamType);
		eFX = EffectLinkEffects(eDAM, eFX);
	}
	if (data.nAC != 0){
		bApplyChange = TRUE;
		effect eAC;
		if (data.nAC > 0) eAC =  EffectACIncrease(data.nAC);
		else eAC = EffectACDecrease(data.nAC * -1);  // accepts a positive integer for the nerf
		eFX = EffectLinkEffects(eAC, eFX);
	}
	
	if (bApplyChange){
		eFX = SupernaturalEffect(eFX);
		eFX = SetEffectSpellId(eFX, COMBAT_MODS_FX);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, data.oPC);
	}
}

int GetQualifiesForStaffFighting(object oPC, object oRHAND, object oLHAND){

	if (oLHAND != OBJECT_INVALID || oRHAND == OBJECT_INVALID) return FALSE;
	
	if (IPGetWeaponSize(oRHAND) - GetCreatureSize(oPC) >= 2) return FALSE;
	
	if (!GetWeaponIsTwoHanded(oPC, oRHAND, oLHAND)) return FALSE;
	
	int nType = GetBaseItemType(oRHAND);
	
	// weapon is either ok, not ok, or needs a weapon focus feat to be ok,
	int bWeaponOk = FALSE;
	switch (nType){
		case BASE_ITEM_GIANT_SPEAR: bWeaponOk = TRUE; break;
		case BASE_ITEM_GIANT_STAFF: bWeaponOk = TRUE; break;
		case BASE_ITEM_QUARTERSTAFF: bWeaponOk = TRUE; break;
		case BASE_ITEM_SHORTSPEAR: bWeaponOk = TRUE; break;
		case BASE_ITEM_SHORT_STAFF: bWeaponOk = TRUE; break;
		case BASE_ITEM_SPEAR: bWeaponOk = TRUE; break;
		case BASE_ITEM_HALBERD:  bWeaponOk = 112; break;
		case BASE_ITEM_GIANT_SCYTHE: bWeaponOk = 121; break;
		case BASE_ITEM_SCYTHE: bWeaponOk = 121; break;
	}
		// so if we need a feat we set bWeaponOk to that feat id and return
	// whether or not we have it.
	if (bWeaponOk > 2) return GetHasFeat(bWeaponOk, oPC, TRUE);
	
	return bWeaponOk;
}


