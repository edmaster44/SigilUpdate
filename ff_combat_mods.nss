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

//void UpdateCombatMods(object oPC, int nAction = NULL, object oChanged = OBJECT_INVALID, int bOnEquip = FALSE);
void UpdateCombatMods(object oPC, int nAction = NULL);
void ApplyCombatMods(object oPC, int nAPR, int nAB);
int GetMethodicalDefenseMod(struct CombatMods ModData);
int GetConsideredStrikeMod(struct CombatMods ModData);
int GetIsStaffFighting(struct CombatMods ModData);
int GetOversizeTwoWeaponFightingMod(struct CombatMods ModData);
int GetXbowAndSharpshooterMods(struct CombatMods ModData);
int GetCreatureTWFMod(struct CombatMods ModData);
int GetHalfAttacks(object oPC, object oRHAND);
int GetQualifiesForStaffFighting(object oPC, object oRHAND, object oLHAND);
void GiveFeedback(object oPC, string sMessage);
void RemoveMethodicalDefenseFeats(object oPC);
int GetWeaponBonus(object oItem);

struct CombatMods{
	object oPC;
	object oSkin;
	object oRHAND;
	object oLHAND;
	int nAction;
	int bUsingDef;
	int bUsingStrike;
	int bUsingStaff;
};




// this needs to be updated on login, level up, and when weapons change because BAB and what weapon is equipped affects this,
// so it's called as the final step in ff_tactical_weapon_inc (which is called from ps_inc_equipment), ff_update_feats, and ps_onpcloaded
//void UpdateCombatMods(object oPC, int nAction = NULL, object oChanged = OBJECT_INVALID, int bOnEquip = FALSE){
void UpdateCombatMods(object oPC, int nAction = NULL){
	

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
	
	// figure out what we want these states to be. If the action is NULL we're just
	// double checking that the current states are still valid, so we don't change
	// anything from the current states unless they're not.
	switch (nAction){
		case DEF_ON:{
			if (bUsingStrike) GiveFeedback(oPC, sStrikeOffFb);
			bUsingDef = TRUE; 
			bUsingStrike = FALSE; 
			break;
		}
		case DEF_OFF:{
			if (bUsingDef) GiveFeedback(oPC, sDefOffFb);
			bUsingDef = FALSE; 
			break;
		}
		case STRIKE_ON: {
			if (bUsingDef) GiveFeedback(oPC, sDefOffFb);
			bUsingDef = FALSE; 
			bUsingStrike = TRUE; 
			break;
		}
		case STRIKE_OFF:{
			if (bUsingStrike) GiveFeedback(oPC, sStrikeOffFb);
			bUsingStrike = FALSE; 
			break;
		}
		case STAFF_ON: bUsingStaff = TRUE; break;
		case STAFF_OFF:{
			if (bUsingStaff) GiveFeedback(oPC, sStaffOffFb); 
			bUsingStaff = FALSE; 
			break;
		}
		case ALL_OFF:{
			if (bUsingStaff) GiveFeedback(oPC, sStaffOffFb); 
			if (bUsingStrike) GiveFeedback(oPC, sStrikeOffFb);
			if (bUsingDef) GiveFeedback(oPC, sDefOffFb);
			bUsingStaff = FALSE; 
			bUsingStrike = FALSE; 
			bUsingDef = FALSE; 
		}
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
	
	struct CombatMods ModData;
	ModData.oPC = oPC;
	ModData.oSkin = oSkin;
	ModData.oRHAND = oRHAND;
	ModData.oLHAND = oLHAND;
	ModData.nAction = nAction;
	ModData.bUsingDef = bUsingDef;
	ModData.bUsingStrike = bUsingStrike;
	ModData.bUsingStaff = bUsingStaff;
	
	int nAPR = 0; // attacks per round
	int nAB = 0; //attack bonus/penalty

	
	int nDefMod = GetMethodicalDefenseMod(ModData);
	if (nDefMod > 0){
		SetLocalInt(oEss, DEF_STATE_ON, TRUE);
		nAPR -= nDefMod;
	} else SetLocalInt(oEss, DEF_STATE_ON, FALSE);
	
	int nConMod = GetConsideredStrikeMod(ModData);
	if (nConMod > 0){
		SetLocalInt(oEss, STRIKE_STATE_ON, TRUE);
		nAPR -= nConMod;
		nAB += nConMod;
	} else SetLocalInt(oEss, STRIKE_STATE_ON, FALSE);
	
	if (GetIsStaffFighting(ModData)){
		SetLocalInt(oEss, STAFF_STATE_ON, TRUE);
		nAPR += 1;
		nAB -= 2;
	} else SetLocalInt(oEss, STAFF_STATE_ON, FALSE);
	
	nAB += GetCreatureTWFMod(ModData);
	nAB += GetOversizeTwoWeaponFightingMod(ModData);
	nAB += GetXbowAndSharpshooterMods(ModData);
	
	DelayCommand(0.3f, ApplyCombatMods(oPC, nAPR, nAB));
	
	if (oTarget != OBJECT_INVALID){
		ClearAllActions(TRUE);
		DelayCommand(0.1f, ActionAttack(oTarget));
	}
}


void ApplyCombatMods(object oPC, int nAPR, int nAB){
	PS_RemoveEffects(oPC, COMBAT_MODS_FX);
	if (nAPR != 0){
		// not currently possible to be >5 or < -5, but who knows what future devs will do.
		// the effect breaks if you try to add or subtract more than 5.
		if (nAPR > 5) nAPR = 5;
		else if (nAPR < -5) nAPR = -5;
		effect eAPR = EffectModifyAttacks(nAPR);
		eAPR = SetEffectSpellId(eAPR, COMBAT_MODS_FX);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAPR, oPC);

	}
	if (nAB != 0){
		effect eAB;
		if (nAB > 0) eAB = EffectAttackIncrease(nAB);
		else eAB = EffectAttackDecrease(nAB * -1); // accepts a positive integer for the nerf
		eAB = SetEffectSpellId(eAB, COMBAT_MODS_FX);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC);
	}
}

/*******************************************************************************************************
						toggle
********************************************************************************************************/

void RemoveMethodicalDefenseFeats(object oPC){
	if (GetHasFeat(FEAT_METHODICAL_DEF_AC_1, oPC, TRUE))
		FeatRemove(oPC, FEAT_METHODICAL_DEF_AC_1);
	if (GetHasFeat(FEAT_METHODICAL_DEF_AC_2, oPC, TRUE))
		FeatRemove(oPC, FEAT_METHODICAL_DEF_AC_2);
	if (GetHasFeat(FEAT_METHODICAL_DEF_AC_3, oPC, TRUE))
		FeatRemove(oPC, FEAT_METHODICAL_DEF_AC_3);
}

int GetMethodicalDefenseMod(struct CombatMods ModData){
	
	if (!ModData.bUsingDef){
		RemoveMethodicalDefenseFeats(ModData.oPC);
		return 0;
	}
	
	int nHalfAttacks = GetHalfAttacks(ModData.oPC, ModData.oRHAND);
	if (nHalfAttacks > 0){
		if (nHalfAttacks >= 3){
			if (GetHasFeat(FEAT_METHODICAL_DEF_AC_1, ModData.oPC, TRUE))
				FeatRemove(ModData.oPC, FEAT_METHODICAL_DEF_AC_1);
			if (GetHasFeat(FEAT_METHODICAL_DEF_AC_2, ModData.oPC, TRUE))
				FeatRemove(ModData.oPC, FEAT_METHODICAL_DEF_AC_2);
			if (!GetHasFeat(FEAT_METHODICAL_DEF_AC_3, ModData.oPC, TRUE))
				FeatAdd(ModData.oPC, FEAT_METHODICAL_DEF_AC_3, FALSE);
		} else if (nHalfAttacks == 2){
			if (GetHasFeat(FEAT_METHODICAL_DEF_AC_1, ModData.oPC, TRUE))
				FeatRemove(ModData.oPC, FEAT_METHODICAL_DEF_AC_1);
			if (GetHasFeat(FEAT_METHODICAL_DEF_AC_3, ModData.oPC, TRUE))
				FeatRemove(ModData.oPC, FEAT_METHODICAL_DEF_AC_3);
			if (!GetHasFeat(FEAT_METHODICAL_DEF_AC_2, ModData.oPC, TRUE))
				FeatAdd(ModData.oPC, FEAT_METHODICAL_DEF_AC_2, FALSE);
		} else {
			if (GetHasFeat(FEAT_METHODICAL_DEF_AC_3, ModData.oPC, TRUE))
				FeatRemove(ModData.oPC, FEAT_METHODICAL_DEF_AC_3);
			if (GetHasFeat(FEAT_METHODICAL_DEF_AC_2, ModData.oPC, TRUE))
				FeatRemove(ModData.oPC, FEAT_METHODICAL_DEF_AC_2);
			if (!GetHasFeat(FEAT_METHODICAL_DEF_AC_1, ModData.oPC, TRUE))
				FeatAdd(ModData.oPC, FEAT_METHODICAL_DEF_AC_1, FALSE);
		}
		if (ModData.nAction == DEF_ON) GiveFeedback(ModData.oPC, sDefOnFb);
		return nHalfAttacks;
	} else {
		RemoveMethodicalDefenseFeats(ModData.oPC);
		SendMessageToPC(ModData.oPC, sBabError);
		GiveFeedback(ModData.oPC, sDefOffFb);
	}
	return 0;
}

int GetConsideredStrikeMod(struct CombatMods ModData){

	if (!ModData.bUsingStrike) return 0;
	
	int nHalfAttacks = GetHalfAttacks(ModData.oPC, ModData.oRHAND);
	if (nHalfAttacks > 0){
		if (ModData.nAction == STRIKE_ON) GiveFeedback(ModData.oPC, sStrikeOnFb);
		return nHalfAttacks;
	} else {
		SendMessageToPC(ModData.oPC, sBabError);
		GiveFeedback(ModData.oPC, sStrikeOffFb);
	}

	return 0;
}

int GetIsStaffFighting(struct CombatMods ModData){


	if (!ModData.bUsingStaff) return FALSE;
	
	int bQualifies = GetQualifiesForStaffFighting(ModData.oPC, ModData.oRHAND, ModData.oLHAND);
	if (!bQualifies){
		SendMessageToPC(ModData.oPC, "You can only use Staff-Fighting Mode while wielding a Staff or Spear that is a normal size for your character in both hands. If you are using a Scythe or Halberd, you also need Weapon Focus in that weapon. You also need either Two Weapon Fighting or at least 1 level of Monk, Samurai, or Kensai");
		GiveFeedback(ModData.oPC, sStaffOffFb);
		return FALSE;
	}
	if (ModData.nAction == STAFF_ON){
		GiveFeedback(ModData.oPC, sStaffOnFb);
		return TRUE;
	} else return FALSE;

	return FALSE;
}
/*******************************************************************************************************
				non - toggle
********************************************************************************************************/

// Feat that reduces the penalty for using a larger than normal offhand weapon by 2. 
int GetOversizeTwoWeaponFightingMod(struct CombatMods ModData){


	// We're not going to check for regular twf because that's 
	// already a requirement in feat.2da to have oversize twf. Bail if they don't have it.
	if (!GetHasFeat(FEAT_OVERSIZE_TWF, ModData.oPC, TRUE)) return 0;
	
	// bail if not dual wielding.
	if (!IPGetIsMeleeWeapon(ModData.oLHAND)) return 0;
	
	if (IPGetWeaponSize(ModData.oLHAND) >= GetCreatureSize(ModData.oPC))
		return 2;

	return 0;
}

int GetXbowAndSharpshooterMods(struct CombatMods ModData){

	int nRightId = GetBaseItemType(ModData.oRHAND);
	int bIsXbow = (nRightId == BASE_ITEM_HEAVYCROSSBOW || 
		nRightId == BASE_ITEM_LIGHTCROSSBOW);
	int bSharpshooter = GetHasFeat(FEAT_SHARPSHOOTER, ModData.oPC, FALSE);
	if (!bSharpshooter && !bIsXbow){
		RemoveBonusFeats(ModData.oSkin, FEAT_RAPID_RELOAD);
		return 0;
	}
	int bGetsRR = FALSE;
	int nAB = 0;
	// check for crossbow features. +1 ab because they're easy to aim, 
	// temp rapid reload if strong enough
	if (bIsXbow){
		nAB += 1;
		int nReqStr = 13;
		if (nRightId == BASE_ITEM_HEAVYCROSSBOW) nReqStr = 15;
		bGetsRR = (GetAbilityScore(ModData.oPC, ABILITY_STRENGTH, FALSE) >= nReqStr);
	}
	// now check for Sharpshooter
	if (bSharpshooter){
		int nDex = GetAbilityModifier(ABILITY_DEXTERITY, ModData.oPC);
		int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, ModData.oPC);
	
		if (nInt > nDex){
			if (nDex > 0) nAB += nInt - nDex; // don't count dex if it's a negative
			else nAB += nInt;
		}
	}
	if (bGetsRR) ApplyTacticalBonusFeat(ModData.oSkin, FEAT_RAPID_RELOAD);
	else RemoveBonusFeats(ModData.oSkin, FEAT_RAPID_RELOAD);
										
	return nAB;
}

// gain twf automatically if the off hand is a creature weapon. if you have twf already you get 
// no penalty for a creature weapon (though you still have normal penalties for non creature weapons 
// if one is creature and one is not). If your offhand creature weapon is the same size category as 
// character negate additional penalties for oversize twf unless it's already negated by oversize twf 
// feat. These bonuses do not apply to creature weapons that are larger category than the character 
// because a monkey-gripped creature weapon isn't one that the character has natural use of.
int GetCreatureTWFMod(struct CombatMods ModData){

	struct CombatMods CTWF = ModData;
										
	int bLisCreature = IPGetIsCreatureEquippedWeapon(ModData.oLHAND);
	
	// bail if off hand is not a creature weap
	if (!bLisCreature){
		RemoveBonusFeats(ModData.oSkin, FEAT_TWO_WEAPON_FIGHTING);
		return 0;
	}
	int nBonus = 0;
	int nPCsize = GetCreatureSize(ModData.oPC);
	int nLWeaponSize = IPGetWeaponSize(ModData.oLHAND);
	
	int bGetsTWF = FALSE;
	// if the left is a creature weapon of normal size, give them twf
	if (nLWeaponSize <= nPCsize) bGetsTWF = TRUE;

	// if they're using an off hand creature weapon that is the same size cat as themselves
	// reduce penalty by 2 unless oversize twf is doing that already
	if (nLWeaponSize == nPCsize && !GetHasFeat(FEAT_OVERSIZE_TWF, ModData.oPC, TRUE))
		nBonus = 2;
	if (bGetsTWF) ApplyTacticalBonusFeat(ModData.oSkin, FEAT_TWO_WEAPON_FIGHTING);
	else RemoveBonusFeats(ModData.oSkin, FEAT_TWO_WEAPON_FIGHTING);
	return nBonus;
}

/*******************************************************************************************************

********************************************************************************************************/

int GetWeaponBonus(object oItem){
    int nBonus = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
    
	int nCurrent = 0;
    while (GetIsItemPropertyValid(ip)){
        int nIpType = GetItemPropertyType(ip);
        
        if (nIpType == ITEM_PROPERTY_ATTACK_BONUS || nIpType == ITEM_PROPERTY_ENHANCEMENT_BONUS){
            nCurrent = GetItemPropertyParam1(ip);
            if (nCurrent > nBonus) nBonus = nCurrent;
        }
        ip = GetNextItemProperty(oItem);
    }
    
    return nBonus;
}

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
		SetLocalString(oPC, "previous_toggle_message", sMessage);
	}
}

int GetQualifiesForStaffFighting(object oPC, object oRHAND, object oLHAND){

	if (oLHAND != OBJECT_INVALID || oRHAND == OBJECT_INVALID) return FALSE;
	
	if (IPGetWeaponSize(oRHAND) - GetCreatureSize(oPC) >= 2) return FALSE;
	
	if (!GetWeaponIsTwoHanded(oPC, oRHAND, oLHAND)) return FALSE;
	
	if (!GetHasFeat(1734, oPC, TRUE) && !GetHasFeat(41, oPC, TRUE) && 
		(GetLevelByClass(CLASS_TYPE_MONK, oPC) + 
		GetLevelByClass(CLASS_SAMURAI, oPC) +
		GetLevelByClass(CLASS_KENSAI, oPC) < 1))
			return FALSE;
	
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