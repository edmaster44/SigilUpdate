//:://////////////////////////////////////////////
//:: Sigil Equip system
//:://////////////////////////////////////////////
//:: Runs the Custom OnEquip and OnUnEquip Scripts.
//:://////////////////////////////////////////////
//:: Created By: Clangeddin
//:: Created On: December 29, 2017

#include "aaa_constants"
#include "ginc_2da"
#include "nw_i0_spells"
#include "class_monk_shatteringblows"
#include "ps_inc_equipmentprops"
#include "ps_inc_functions"
#include "ff_combat_mods"
#include "ff_feat_tactical_weapon_feat"
#include "ff_update_feats_inc"
#include "x2_inc_spellhook"
#include "ps0_classes2015_inc"


/*----------------------------------------------------------------------------------------
			DECLARATIONS
-----------------------------------------------------------------------------------------*/
void ApplyEquipmentEffect(object oPC, effect eFX, int nDUR = DURATION_TYPE_PERMANENT);
void SigilEquipment(object oPC, object oItem, int nEquip);
void EquipmentEffects(object oPC, object oChanged, int bOnEquip);
void ConDrainProtection(object oItem, object oPC);
int GetACProvidedByShield(object oShield);
void DrunkMasterImprovised(object oPC, int nRight);
void ShieldRangedConceal(object oPC, int nSHIELD);
void SpellResistFix(object oPC, string s2DA = "iprp_srcost", string sCOLUMN = "Value");
//void MonkDruidPenalty(object oPC);
//void UnearthlyGrace(object oPC, object oChest);
int GetArmorQualifiesForArmorOpt(object oARMOR);
void ArmorOptimizations(object oPC, object oARMOR);
void SilentMetal(object oPC, object oARMOR, object oSHIELD, int nSHIELD, string s2DA = "armorrulestats", string sCOLUMN = "ACCHECK");
int CheckDragonForms(object oPC, object oItem, int nItem);
int CheckManualDexterity(object oPC, object oItem, int nItem);
void CheckForTempProperties(object oItem, object oPC);
int MonkeyGripAbuse(object oPC, object oItem);
void FixARMOR(object oPC, object oARMOR);
void FixSHIELD(object oPC, object oSHIELD, int nSHIELD);
void RemoveElementalWeapon(object oPC,object oItem);
void ApplyElementalWeapon(object oPC, object oItem);
void RemoveAustereStrikes(object oPC,object oItem);
void ApplyAustereStrikes(object oPC,object oItem);
void RemoveMeditativeStrikes(object oPC,object oItem);
void ApplyMeditativeStrikes(object oPC,object oItem);
int DervishCanUseDance(object oPC);
int NoHeavyArmorOrShield(object oPC);
int GetMonkWeapon(object oItem);
void MurderousIntent(object oPC, object oRHand);
void HandAndAHalfWeapon(object oPC, object oRHand, object oLHand);
void BucklerFinesse(object oPC, object oLHand);
void BojutsuKenjutsu(object oPC, object oRHand, object oLHand, object oArmor);
void FlorentineTWF(object oPC, object oRHand, object oLHand);
void TwoSwordsAsOne(object oPC, object oRHand, object oLHand);
void IajaitsuMaster(object oPC, object oRHand, object oChanged, int bOnEquip);
void FrightfulPresence(object oPC, int nCHA);
void CheckTacticalWeapons(object oPC, object oSkin, int nCount = 0);
void UpdateWeaponBenefits(object oPC, object oRHand, object oLHand, object oChest, object oChanged, int bOnEquip);
void NaturalMultiattack(object oPC, object oRHand, object oLHand);
void CheckCreatureShieldProficiency(object oPC, object oItem, int nItem);

//int GetCreatureWeapons(object oItem);
//int GetIsSpecialFinessable(int nTYPE);
//int GetIsShields(object oItem)
//void TatooedMonk(object oPC, int nRight, int nLeft);
//void DrunkMasterImprovised(object oPC, int nRight);


/*----------------------------------------------------------------------------------------
			IMPLEMENTATIONS
-----------------------------------------------------------------------------------------*/


//This starts all the various checks and effects to be applied based on equipment, as per Sigil's custom rules.
//nEquip: TRUE when called from OnEquip and FALSE when called from OnUnEquip.
//Found in "ps_inc_equipment.nss".
void SigilEquipment(object oPC, object oItem, int nEquip){

	// we shouldn't have to do ANY processing for creature skin, so just skip all this if 
	// that's what it is
	int nItem = GetBaseItemType(oItem);
	if (nItem == BASE_ITEM_CREATUREITEM) return; // base item 73, creature skin
	
    //RemoveEffectsFromSpell(oPC, EQUIP_FX);
	PS_RemoveEffects(oPC, EQUIP_FX);
    if (nEquip == TRUE)
    {
      CheckForTempProperties(oItem, oPC);
        
      DelayCommand(0.1f,ApplyMeditativeStrikes(oPC,oItem));
	  
	  DelayCommand(0.1f,ApplyAustereStrikes(oPC,oItem));
    
      DelayCommand(0.1f,ApplyElementalWeapon(oPC,oItem));
        
        /*	 if (GetIsFinessable(oItem))
			 DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oItem));

            if (!GetExistingFinesse(oItem)&&  GetSubRace(oPC) == 243) 
            DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oItem));
				
			if (GetDervishWeapon(oItem) && (GetLevelByClass(CLASS_DERVISH,oPC)>4))
				 DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oItem)); */

        
        if (nItem == BASE_ITEM_GLOVES) SetGlovesOnHitProperty(oPC);
        //{  // weird orphan brackets
		if (MonkeyGripAbuse(oPC, oItem) == TRUE) return;
		if (CheckManualDexterity(oPC, oItem, nItem) == TRUE) return;
		if (CheckDragonForms(oPC, oItem, nItem) == TRUE) return;

        //}
    }
    else
    {
        ConDrainProtection(oItem, oPC);
        if (nItem == BASE_ITEM_GLOVES) RemoveTempOnHitProperty(oItem);
            //PS_RemoveSpecialWeaponFinesse(oPC, oItem);
            RemoveElementalWeapon(oPC,oItem);
            RemoveMeditativeStrikes(oPC,oItem);
			RemoveAustereStrikes(oPC,oItem);
        
    }
	if (nEquip) CheckCreatureShieldProficiency(oPC, oItem, nItem);
    DelayCommand(0.5f, EquipmentEffects(oPC, oItem, nEquip));
	

}

//When all is said and done, the various custom effects dependant on equipment are applied.
void EquipmentEffects(object oPC, object oChanged, int bOnEquip)
{

    object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	FixARMOR(oPC, oChest);
	
	//update gatecrasher ac to make sure it never stacks with duelist or
	//invis blade
	PS_Feat_GC_DODGE_AC(oPC, 1817);
	
    object oLHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int nLeft = GetBaseItemType(oLHand);
	FixSHIELD(oPC, oLHand, nLeft);
	
    object oRHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nRight = GetBaseItemType(oRHand);   
    SpellResistFix(oPC);
    ShieldRangedConceal(oPC, nLeft);
    SilentMetal(oPC, oChest, oLHand, nLeft);
    ArmorOptimizations(oPC, oChest);
   // UnearthlyGrace(oPC, oChest);
	//MonkDruidPenalty(oPC);
	HandAndAHalfWeapon(oPC, oRHand, oLHand);
	UpdateWeaponBenefits(oPC, oRHand, oLHand, oChest, oChanged, bOnEquip);

	
    //TatooedMonk(oPC, nRight, nLeft);
    //DrunkMasterImprovised(oPC, nRight, nLeft);
}

// unequip a "creature shield" if the player does not have creature weapon proficiency
void CheckCreatureShieldProficiency(object oPC, object oItem, int nItem){
	if (GetTag(oItem) != "creature_invis") return;
	if (GetHasFeat(289, oPC, TRUE)) return;
	if (nItem != BASE_ITEM_TOWERSHIELD && nItem != BASE_ITEM_LARGESHIELD &&
		nItem != BASE_ITEM_SMALLSHIELD)
			return;
	AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oItem));	
}

void UpdateWeaponBenefits(object oPC, object oRHand, object oLHand, object oChest, object oChanged, int bOnEquip){

	PS_RemoveEffects(oPC, FF_AC_FX);
	BucklerFinesse(oPC, oLHand);
	BojutsuKenjutsu(oPC, oRHand, oLHand, oChest);
	
	// this only relates to weapons, but we want it called every time to correct
	// legacy applications of multiattack feat 1784 instead of nat multi feat 4000
	NaturalMultiattack(oPC, oRHand, oLHand);

	//the rest only relate to weapons
	if (!IPGetIsWeapon(oChanged)) return;
	
	MurderousIntent(oPC, oRHand);
	FlorentineTWF(oPC, oRHand, oLHand);
	TwoSwordsAsOne(oPC, oRHand, oLHand);
	IajaitsuMaster(oPC, oRHand, oChanged, bOnEquip);
	UpdateCombatMods(oPC, NULL);
	object oSkin = PS_GetCreatureSkin(oPC);
	CheckTacticalWeapons(oPC, oSkin);
}

void NaturalMultiattack(object oPC, object oRHand, object oLHand){
	if (GetHasFeat(1784, oPC, TRUE)) FeatRemove(oPC, 1784);
	
	if (!GetHasFeat(4000, oPC, TRUE)) return;

	if ((IPGetIsCreatureEquippedWeapon(oRHand) || oRHand == OBJECT_INVALID) && 
		(IPGetIsCreatureEquippedWeapon(oLHand) || oLHand == OBJECT_INVALID))
			FeatAdd(oPC, 1784, FALSE);
}

//Samurais get AB and damage bonus when they dual wield katana/longsword in main hand and shortsword or ninjato in off hand.
void TwoSwordsAsOne(object oPC, object oRHand, object oLHand){

    int nSAMURAI = GetLevelByClass(65, oPC);
    if (nSAMURAI < 2) return;

	int nPCsize = GetCreatureSize(oPC);
	int bRightQualifies = FALSE;
	int bLeftQualifies = FALSE;
	
	if (oRHand == OBJECT_INVALID || oLHand == OBJECT_INVALID)
		return;
	
	int nRight = GetBaseItemType(oRHand);
	int nLeft = GetBaseItemType(oLHand);
	
	// Whoever came up with the rules for TSAO didn't think about the fact that in nwn weapons do not
	// change size to accomodate the character. So I fix that here.
	
	// large Samurai can use a falchion, greatsword, or odachi in the right hand
	// and katana, longsword, ninjato, or shortsword in left
	if (nPCsize > 3){
		bRightQualifies = (nRight == BASE_ITEM_FALCHION || nRight == BASE_ITEM_GREATSWORD ||
			nRight == BASE_ITEM_ODACHI );
		bLeftQualifies = (nLeft == BASE_ITEM_KATANA || nLeft == BASE_ITEM_LONGSWORD ||
			nLeft == BASE_ITEM_SHORTSWORD || nLeft == BASE_ITEM_NINJATO);
	// small samurai can use a ninjato, shortsword, katana, or longsword in the right hand 
	// and dagger or kukri in the left otherwise they would have -2 penalties making 
	// a small samurai unfairly penalized
	} else if (nPCsize < 3){
		bRightQualifies = (nRight == BASE_ITEM_NINJATO || nRight == BASE_ITEM_SHORTSWORD || 
			nRight == BASE_ITEM_KATANA || nRight == BASE_ITEM_LONGSWORD);
		bLeftQualifies = (nLeft == BASE_ITEM_DAGGER || nLeft == BASE_ITEM_KUKRI);
	} else { //medium characters
		bRightQualifies = (nRight == BASE_ITEM_KATANA || nRight == BASE_ITEM_LONGSWORD);
		bLeftQualifies = (nLeft == BASE_ITEM_SHORTSWORD || nLeft == BASE_ITEM_NINJATO || 
		nLeft == BASE_ITEM_DAGGER || nLeft == BASE_ITEM_KUKRI);
	}
	
	if (!bRightQualifies || !bLeftQualifies) return;
	
	int nDMG_TYPE = DAMAGE_TYPE_BLUDGEONING;
	if (nSAMURAI >= 30) nDMG_TYPE = DAMAGE_TYPE_DIVINE;
	
	int nBonus = (nSAMURAI - 1) / 5;
	if (nBonus < 1) nBonus = 1;
	
	effect eAB = EffectAttackIncrease(nBonus);
	eAB = EffectLinkEffects(EffectDamageIncrease(nBonus, nDMG_TYPE), eAB);
	ApplyEquipmentEffect(oPC, eAB);
}

//At level 5, when the Samurai draws a longsword or katana (in right hand) they gain an attack bonus 
//equal to their charisma bonus for 1 round. They also gain 1 extra attack for that round as well. 
// Because attack bonuses do not stack this need to be last and take the longer duration bonuses
// into account when applying the 1 round bonus. EffectModifyAttacks also doesn't stack, so the
// character won't get the bonus attack if using methodical defense or considered strike, which makes
// sense, considering that those are supposed to grant their bonuses because the character is moving
// cautiously
void IajaitsuMaster(object oPC, object oRHand, object oChanged, int bOnEquip){

    if (GetLevelByClass(65, oPC) < 5) return;
	if (!GetHasFeat(2414, oPC, TRUE)) return;

	if (!bOnEquip) return;
	if (oChanged != oRHand) return;
	
	// don't allow ppl to spam this ability by constantly swapping between two katanas
	if (GetLocalInt(oPC, "Iajaitsu")) return;
	
	// set the int that shows we've done this recently
	SetLocalInt(oPC, "Iajaitsu", TRUE);
	
	int bQualifies = FALSE;
	int nPCsize = GetCreatureSize(oPC);
	int nItem = GetBaseItemType(oRHand);
    if ((nItem == BASE_ITEM_KATANA) || (nItem == BASE_ITEM_LONGSWORD) || 
		(nItem == BASE_ITEM_ODACHI) || nItem == (BASE_ITEM_NINJATO))
			bQualifies = TRUE;
	if (nPCsize > 3 && (nItem == BASE_ITEM_FALCHION || nItem == BASE_ITEM_GREATSWORD || 
		nItem == BASE_ITEM_ODACHI)) bQualifies == TRUE;
	if (nPCsize < 3 && (nItem == BASE_ITEM_SHORTSWORD)) bQualifies = TRUE;
	if (!bQualifies) return;
	
    
	int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	float fDUR = RoundsToSeconds(1);
	effect eFX_4 = EffectModifyAttacks(1);
	if (nCHA > 0){
		int nBonus = GetWeaponBonus(oRHand) + nCHA;
		eFX_4 = EffectLinkEffects(EffectAttackIncrease(nBonus, ATTACK_BONUS_ONHAND), eFX_4);
	}
	eFX_4 = SetEffectSpellId(eFX_4, 1839);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_4, oPC, fDUR);
    DelayCommand(0.01f, FrightfulPresence(oPC, nCHA));
	// set the int that shows we've done this recently to false
	DelayCommand(30.0f, SetLocalInt(oPC, "Iajaitsu", FALSE));
}

//When a Samurai draws their weapon (a katana or longsword) foes can be frightened by it.
void FrightfulPresence(object oPC, int nCHA){
	if (nCHA < 1) return;
    if (GetHasFeat(2419, oPC, TRUE) == FALSE) return;
    location lPC = GetLocation(oPC);
    float fDUR = RoundsToSeconds(nCHA);
    int nDC = 20 + nCHA;
    int nHD;
    effect eFX_1 = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_STUN));
    effect eFX_2 = EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_SPELL_FEAR));
    effect eFX_3 = EffectLinkEffects(EffectLinkEffects(EffectACDecrease(2), EffectAttackDecrease(2)), EffectVisualEffect(VFX_DUR_SPELL_DOOM));
	eFX_1 = SetEffectSpellId(eFX_1, 1407);
	eFX_2 = SetEffectSpellId(eFX_2, 1407);
	eFX_3 = SetEffectSpellId(eFX_3, 1407);
    object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
    while (oTARGET != OBJECT_INVALID)
    {
        if (GetIsEnemy(oTARGET, oPC)){
			if (!MySavingThrow(SAVING_THROW_WILL, oTARGET, nDC, SAVING_THROW_TYPE_FEAR, oPC, 0.1f, 1407)){
                nHD = PS_GetLevel(oTARGET);
                if (nHD >= 20) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_3, oTARGET, fDUR);
                else if (nHD >= 5) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_2, oTARGET, fDUR);
                else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX_1, oTARGET, fDUR);    
            }
        }
        oTARGET = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lPC, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void CheckTacticalWeapons(object oPC, object oSkin, int nCount = 0){
	int nTac;
	object oRHand;
	// There appears to be a slight delay when adding or removing item properties
	// so make sure this waits a bit if it's doing that in case of rapid calls,
	// such as equipping 2 items at once from hotbar
    if (nCount >= 2000 || !GetLocalInt(oPC, "tacbusy")){
		oRHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		nTac = GetTacSuiteByWeaponCategory(oPC, oRHand);
		// don't change tac weapons feat if the feat granted by the weapons doesn't change
		if (GetLocalInt(oPC, "tacweapon") != nTac){
			SetLocalInt(oPC, "tacbusy", TRUE);
			SetLocalInt(oPC, "tacweapon", nTac);
			RemoveBonusFeats(oSkin, NULL, oPC);
			if (!GetHasFeat(FEAT_COMBAT_EXPERTISE, oPC, TRUE))
				SetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE, FALSE);
			if (!GetHasFeat(FEAT_POWER_ATTACK, oPC, TRUE))
				SetActionMode(oPC, ACTION_MODE_POWER_ATTACK, FALSE);
			FF_TacticalWeapons(oPC, oRHand, oSkin);
			DelayCommand(0.1, SetLocalInt(oPC, "tacbusy", FALSE));
		}
        return;
    }
    // Still busy, check again after delay
    DelayCommand(0.001, CheckTacticalWeapons(oPC, oSkin, nCount + 1));
}


// Gain defense improvements to twf if using the smallest possible off hand weapon
// and a normal sized, or smaller, main hand and the character has twd feat. 
// 10% - 25% concealment vs melee, depending on combo of weapons and feats. 
void FlorentineTWF(object oPC, object oRHand, object oLHand){

	if (!GetHasFeat(FEAT_TWO_WEAPON_DEFENSE, oPC, TRUE)) return;
	
	if (!IPGetIsMeleeWeapon(oRHand) || !IPGetIsMeleeWeapon(oLHand)) return;
	
	int nPCsize = GetCreatureSize(oPC);
	if (IPGetWeaponSize(oRHand) > nPCsize) return;
	
	int nSmallestWeap = nPCsize - 2;
	if (nSmallestWeap < 1) nSmallestWeap = 1;
	// bail if they're not using the smallest off-hand they can
	if (IPGetWeaponSize(oLHand) > nSmallestWeap) return;
	
	int bIsMainGauche = FALSE;
	int nLeftId = GetBaseItemType(oLHand);
	if (nPCsize > 3){
		if (nLeftId == BASE_ITEM_SHORTSWORD || nLeftId == BASE_ITEM_LIGHTMACE ||
			nLeftId ==  BASE_ITEM_CREATURECLAW_SML || nLeftId == BASE_ITEM_CREATURESLAM_SML) 
				bIsMainGauche = TRUE;
	} else {
		if (nLeftId == BASE_ITEM_DAGGER || nLeftId == BASE_ITEM_LIGHTHAMMER ||
			nLeftId ==  BASE_ITEM_CREATURECLAW_TINY  || nLeftId == BASE_ITEM_CREATURESLAM_TINY) 
				bIsMainGauche = TRUE;
	}
	int nMiss = 10;
	if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_DEFENSE, oPC, TRUE)) nMiss += 10;
	if (bIsMainGauche) nMiss += 5;

	effect eMainGauche = EffectConcealment(nMiss, MISS_CHANCE_TYPE_VS_MELEE);
	ApplyEquipmentEffect(oPC, eMainGauche);
}


// If base dex 17 and 7 levels of swash or rogue then can use a light shield
// as effectively as a normal sized shield. Gain +1 ac. Had a problem with this
// double-applying when equipped from hotbar, so I gave it its own spellid =
// buckler prof feat * -1 
void BucklerFinesse(object oPC, object oLHand){

	
	if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) < 17) return;
	int nItem = GetBaseItemType(oLHand);
	if (nItem != BASE_ITEM_SMALLSHIELD) return;

	if (GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) < 7 && 
		GetLevelByClass(CLASS_TYPE_ROGUE, oPC) < 7)
			return;
			
	effect eFX = EffectACIncrease(1);
	eFX = SupernaturalEffect(eFX);
    eFX = SetEffectSpellId(eFX, FF_AC_FX);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
}

// had to give this its own spell id for ac for the same reason as buckler
void BojutsuKenjutsu(object oPC, object oRHand, object oLHand, object oArmor){
	int bQualifies = TRUE;

	// must be two handed
	if (!GetWeaponIsTwoHanded(oPC, oRHand, oLHand))
		bQualifies = FALSE;
		
	// no heavy armor
	if (GetArmorRank(oArmor) == ARMOR_RANK_HEAVY) bQualifies = FALSE;
	
	// find out it's a qualifying sword or a qualifying staff
	int nType = GetBaseItemType(oRHand);
	int bKenjutsu = FALSE;
	int bBojutsu = FALSE;
	switch (nType){
		case BASE_ITEM_SCIMITAR: bKenjutsu = TRUE; break;
		case BASE_ITEM_KATANA: bKenjutsu = TRUE; break;
		case BASE_ITEM_FALCHION: bKenjutsu = TRUE; break;
		case BASE_ITEM_NINJATO: bKenjutsu = TRUE; break;
	}
	if (!bKenjutsu) bBojutsu = GetQualifiesForStaffFighting(oPC, oRHand, oLHand);
	if (!bKenjutsu && !bBojutsu) bQualifies = FALSE;

	int bGetsAC = FALSE;
	int bMartialArtist = (GetLevelByClass(CLASS_TYPE_MONK, oPC) + 
		GetLevelByClass(CLASS_SAMURAI, oPC) +
			GetLevelByClass(CLASS_KENSAI, oPC) > 0);
	int nSizeDifference = IPGetWeaponSize(oRHand) - GetCreatureSize(oPC);
	if (bKenjutsu){
		if (nSizeDifference == 1 && !GetHasFeat(FEAT_MONKEY_GRIP, oPC, TRUE))
			bQualifies = FALSE;
		else if (nSizeDifference >= 2) bQualifies = FALSE;
	}
	int nId = -21912;

	if (!bQualifies){
		if (GetHasFeat(FEAT_BOJUTSU, oPC, TRUE)) FeatRemove(oPC, FEAT_BOJUTSU);
		if (GetHasFeat(FEAT_KENJUTSU, oPC, TRUE))FeatRemove(oPC, FEAT_KENJUTSU);
		return;
	} else {
		if (bBojutsu){
			if (!GetHasFeat(FEAT_BOJUTSU, oPC, TRUE))
				FeatAdd(oPC, FEAT_BOJUTSU, FALSE);
		} else {
			if (!GetHasFeat(FEAT_KENJUTSU, oPC, TRUE))
				FeatAdd(oPC, FEAT_KENJUTSU, FALSE);
		}
		
		if (bMartialArtist) bGetsAC = TRUE;
		else if (bBojutsu && (GetHasFeat(FEAT_TWO_WEAPON_DEFENSE, oPC, TRUE) ||
			GetHasFeat(FEAT_COMBAT_EXPERTISE))) bGetsAC = TRUE;
		else {
			string WeapSpec = Get2DAString("baseitems", "FEATWpnSpec", nType);
			string WeapCh = Get2DAString("baseitems", "FEATWpnOfChoice", nType);
			string GrWeapFoc = Get2DAString("baseitems", "FEATGrtrWpnFocus", nType);
			string PwrCrit = Get2DAString("baseitems", "FEATPowerCrit", nType);
			if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oPC, TRUE) ||
				GetHasFeat(StringToInt(WeapSpec), oPC, TRUE) ||
				GetHasFeat(StringToInt(WeapCh), oPC, TRUE) ||
				GetHasFeat(StringToInt(GrWeapFoc), oPC, TRUE) ||
				GetHasFeat(StringToInt(PwrCrit), oPC, TRUE))
					bGetsAC = TRUE;
		}
	
		if (bGetsAC){
			effect eFX = EffectACIncrease(1);
			eFX = SupernaturalEffect(eFX);
			eFX = SetEffectSpellId(eFX, FF_AC_FX);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
		}
	}
}

// Ninjato and stiletto grant +1d6 stacking sneak attack if wielded in the main hand and if the 
// character has sneak attack from race or class. "Murderous Intent" was what I renamed the feat
// for NeverWinter 9 Agent sneak attack 1. Nw9 Agent is a class that was supposed to be a rogue-ish
// alternative PrC for nwn9, but Bioware never finished it and it's not in the game. But the feat works. 
void MurderousIntent(object oPC, object oRHand){
	int nType = GetBaseItemType(oRHand);
	if (nType != BASE_ITEM_NINJATO && nType != BASE_ITEM_STILETTO){
		if (GetHasFeat(FEAT_MURDEROUS_INTENT, oPC, TRUE))
			FeatRemove(oPC, FEAT_MURDEROUS_INTENT);
		return;
	}
	// check if they have sneak dice (or equivalent) from class or race. We're giving them additional dice
	// if they already have some naturally, not giving a non-sneak-attacker a free sneak attack
	int nSneakDice = fCalcOtherSneakFeats(oPC);
	if (nSneakDice < 1) nSneakDice += fCalcDeathDice(oPC);
	if (nSneakDice < 1) nSneakDice += fCalcSneakDice(oPC);
	
	if (nSneakDice > 0){
		if (!GetHasFeat(FEAT_MURDEROUS_INTENT, oPC, TRUE))
			FeatAdd(oPC, FEAT_MURDEROUS_INTENT, FALSE);
	} else if (GetHasFeat(FEAT_MURDEROUS_INTENT, oPC, TRUE))
		FeatRemove(oPC, FEAT_MURDEROUS_INTENT);
}

void HandAndAHalfWeapon(object oPC, object oRHand, object oLHand){
	// giants can one-hand these weapons with only martial feat.
	int nPCsize = GetCreatureSize(oPC);
	if (nPCsize > 3) return;
	
	int nRtype = GetBaseItemType(oRHand);
	int nLtype = GetBaseItemType(oLHand);
	
	int bRightBastard = (nRtype == BASE_ITEM_BASTARDSWORD || nRtype == BASE_ITEM_MAUL ||
		nRtype == BASE_ITEM_INFANTRYFLAIL || nRtype == BASE_ITEM_DWARVENWARAXE);
	int bLeftBastard = (nLtype == BASE_ITEM_BASTARDSWORD || nLtype == BASE_ITEM_MAUL ||
		nLtype == BASE_ITEM_INFANTRYFLAIL || nLtype == BASE_ITEM_DWARVENWARAXE);
	
	// if they're not using any of the Hand and a half weapons, bail.
	if (!bRightBastard && !bLeftBastard) return;
	
	int bHasExotic = GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC, TRUE);
	int bHasMonkey = GetHasFeat(FEAT_MONKEY_GRIP, oPC, TRUE);
	
	string sMessage = "This weapon is slightly larger than normal weapons of its type (though not as big as a large weapon)";
	int bUnEquipR = FALSE;
	int bUnEquipL = FALSE;
	
	// small characters need either exotic or monkey grip to use
	// two handed, and both to use 1 handed.
	if (nPCsize < 3){
		// small character who has nothing in off hand and has either feat is golden. bail.
		if ((bHasExotic || bHasMonkey) && oLHand == OBJECT_INVALID) return;
		if (bHasExotic && bHasMonkey) return; // small char with both feats also golden. bail.
		if (oLHand == OBJECT_INVALID){
			sMessage += " You need either exotic weapon proficiency or monkey grip to wield this weapon in two hands.";
			sMessage += " (You will not suffer the large weapon -2 penalty for using this weapon two-handed if doing so via monkey grip.)";
			bUnEquipR = TRUE;	
		} else {
			sMessage += " You need both monkey grip and exotic weapon proficiency to wield this weapon in one hand.";
			if (bRightBastard) bUnEquipR = TRUE;
			if (bLeftBastard) bUnEquipL = TRUE;
		}
	} else { // medium chars only, we've already bailed for large and handled small
		// if either hand is empty then this doesn't concern us, we only need to check
		// medium characters for one-handing a bastard or dwarfaxe
		if (oLHand == OBJECT_INVALID) return;
	
		// if a medium char has exotic or monkey, they're all set. bail.
		if (bHasExotic || bHasMonkey) return;
	
		// dwarves have special rules due to being culturally accustomed to dwarfaxe
		if (GetRacialType(oPC) == RACIAL_TYPE_DWARF){
			if (bRightBastard && nRtype != BASE_ITEM_DWARVENWARAXE) bUnEquipR = TRUE;
			if (bLeftBastard && nLtype != BASE_ITEM_DWARVENWARAXE) bUnEquipL = TRUE;
		} else {
			if (bRightBastard) bUnEquipR = TRUE;
			if (bLeftBastard) bUnEquipL = TRUE;
		} // end racial check
		if (bUnEquipR || bUnEquipL){
			sMessage += " You need to have either monkey grip or exotic weapon proficiency to use this weapon in one hand.";
			sMessage += " (You will not suffer the large weapon -2 penalty for using this weapon one-handed if doing so via monkey grip.)";
		}
	} // end of pc size conditional
	
	if (bUnEquipR || bUnEquipL){
		if (bUnEquipR) AssignCommand(oPC, ActionUnequipItem(oRHand));
		if (bUnEquipL) AssignCommand(oPC, ActionUnequipItem(oLHand));
		SendMessageToPC(oPC, sMessage);
	}
}

//This gets the weapons that qualify for Meditative Strikes
int GetMonkWeapon(object oItem){ 
    int iBaseItem = GetBaseItemType(oItem);
	if (IPGetIsCreatureEquippedWeapon(OBJECT_INVALID, iBaseItem)) return TRUE;
	
    return iBaseItem ==  BASE_ITEM_SHURIKEN || iBaseItem == BASE_ITEM_GLOVES || iBaseItem == BASE_ITEM_KAMA || 
		iBaseItem == BASE_ITEM_QUARTERSTAFF || iBaseItem == BASE_ITEM_SHORT_STAFF || iBaseItem == BASE_ITEM_GIANT_STAFF ||
		iBaseItem == BASE_ITEM_STILETTO || iBaseItem == BASE_ITEM_DAGGER || iBaseItem == BASE_ITEM_KUKRI;
}


int NoHeavyArmorOrShield(object oPC)
{
	int chest = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oPC));
	if(chest == ARMOR_RANK_HEAVY || chest == ARMOR_RANK_MEDIUM) return FALSE;

	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	if (oShield == OBJECT_INVALID) return TRUE;
	
	int shield = GetBaseItemType(oShield);
	if(shield == BASE_ITEM_SMALLSHIELD || shield == BASE_ITEM_LARGESHIELD || shield == BASE_ITEM_TOWERSHIELD)
		return FALSE;		
		
	return TRUE;
}


// Checks to see if Dervish meets the requirements to activate the Dervish Dance ability.
int DervishCanUseDance(object oPC){
    // Armor Rank must be none or light.
    int nArmorRank = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
	if(nArmorRank == ARMOR_RANK_HEAVY || nArmorRank == ARMOR_RANK_MEDIUM) {
        SendMessageToPC(oPC, "Dervish Dance cannot be activated while wearing medium or heavy armor.");
        return FALSE;
    }

    // Both Mainhand and Offhand must be slashing weapons.
    object oMainHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    if(!GetIsObjectValid(oMainHand))
    {
        SendMessageToPC(oPC, "Dervish Dance cannot be activated without a weapon equipped.");
        return FALSE;
    }

    if( GetWeaponType(oMainHand) != WEAPON_TYPE_SLASHING &&
        GetWeaponType(oMainHand) != WEAPON_TYPE_PIERCING_AND_SLASHING)
    {
        SendMessageToPC(oPC, "Dervish Dance requires the mainhand weapon be of slashing type.");
        return FALSE;
    }

    object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    int nOffhandBaseType = GetBaseItemType(oOffHand);

    // if an offhand is equipped.
    if(GetIsObjectValid(oOffHand))
    {
        // Offhand cannot be a shield.
        if(nOffhandBaseType == BASE_ITEM_LARGESHIELD || 
            nOffhandBaseType == BASE_ITEM_SMALLSHIELD || 
            nOffhandBaseType == BASE_ITEM_TOWERSHIELD) 
        {
            SendMessageToPC(oPC, "Dervish Dance cannot be activated while holding a shield.");
            return FALSE;
        }

        // Offhand must be a slashing type.
        if( GetWeaponType(oMainHand) != WEAPON_TYPE_SLASHING &&
            GetWeaponType(oMainHand) != WEAPON_TYPE_PIERCING_AND_SLASHING)
        {
            SendMessageToPC(oPC, "Dervish Dance requires both weapons be of slashing type.");
            return FALSE;
        }
    }

    // We passed all the checks.  Yippee!
	return TRUE;
}


//Gets the Property from wisdom, converts into Magical Damage, and applies it on correct weapons
void ApplyMeditativeStrikes(object oPC,object oItem){    
    int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    
    if(nWis <= 0)return;
    else if(!GetMonkWeapon(oItem)) return;
    
    itemproperty ipAdd = GetItemPropertyReference(oItem, "MeditativeStrikes");
	if (GetIsItemPropertyValid(ipAdd) != FALSE) {
		SendMessageToPC(oPC, "Meditative strikes already active.");
		return;
	}

    int nDamageConstant = IPGetDamageBonusConstantFromNumber(nWis);    
    int nDamageType = IP_CONST_DAMAGETYPE_DIVINE;
    float fDUR = 9999.9f;    
    ipAdd  = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, nDamageConstant);
    
    if(GetHasFeat(2840,oPC, TRUE))
    {
        if(!GetIsItemPropertyValid(ipAdd)){
        
            SendMessageToPC(oPC, "Itemproperty was not valid");
            return;
        }
    
        SendMessageToPC(oPC, "Applying damage constant: "+IntToString(nDamageConstant));    
        IPSafeAddItemProperty(oItem, ipAdd, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        SaveItemPropertyReference(oItem, "MeditativeStrikes", ipAdd);

        SendMessageToPC(oPC, "Wisdom Damage bonus of " + IntToString(nWis) + " applied to your Monk Weapon");
    }
}

//Removes Meditative Strikes off propertry
void RemoveMeditativeStrikes(object oPC,object oItem)
{
	if(GetHasFeat(2840,oPC, TRUE)){
		itemproperty ipAdd = GetItemPropertyReference(oItem, "MeditativeStrikes");
		if (GetIsItemPropertyValid(ipAdd) == FALSE) {
			SendMessageToPC(oPC, "Item Property no longer exists on the Item itself");
			return;
		}
		DeleteItemPropertyReference(oItem, "MeditativeStrikes");
	}
}

//Adds Austere One levels as flat Slashing Damage to gloves
void ApplyAustereStrikes(object oPC,object oItem)
{    
    int nRak = GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC);
    
    if(nRak <= 0){
    
    //    SendMessageToPC(oPC, "Austere One PRC levels = 0");
        return;
    }
    else if(!GetBaseItemType(oItem) == BASE_ITEM_GLOVES){                 
    
      //  SendMessageToPC(oPC, "PC is using a weapon, not unarmed");
        return;
    }
    itemproperty ipAdd = GetItemPropertyReference(oItem, "AustereStrikes");
        if (GetIsItemPropertyValid(ipAdd) != FALSE) {
        SendMessageToPC(oPC, "Austere Strikes already active.");
        return;
}


    
    int nDamageConstant = GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC);    
    int nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
    float fDUR = 9999.9f;    
    ipAdd  = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, nDamageConstant);
    
    if(GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC)> 0)
    {
        if(!GetIsItemPropertyValid(ipAdd)){
        
            SendMessageToPC(oPC, "Item property was not valid");
            return;
        }
    
        SendMessageToPC(oPC, "Applying damage constant: "+IntToString(nDamageConstant));    
        IPSafeAddItemProperty(oItem, ipAdd, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        SaveItemPropertyReference(oItem, "AustereStrikes", ipAdd);

        SendMessageToPC(oPC, "Slashing Damage bonus of " + IntToString(nDamageConstant) + " applied to your Gloves");
    }

}

//Removes Austere Strikes off propertry
void RemoveAustereStrikes(object oPC,object oItem)
{
	if(GetLevelByClass(CLASS_TYPE_AUSTERE_ONE, oPC)> 0){
		itemproperty ipAdd = GetItemPropertyReference(oItem, "AustereStrikes");
		if (GetIsItemPropertyValid(ipAdd) == FALSE) {
			SendMessageToPC(oPC, "Item Property no longer exists on the Item itself");
			return;
		}
		DeleteItemPropertyReference(oItem, "AustereStrikes");
	}
}


//Elemental Weapon - Applies Elemental Damage based on feat.
void ApplyElementalWeapon(object oPC, object oItem)
{   
    int nLevel=GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR, oPC);
	if (nLevel < 1) return;
	if (GetWeaponRanged(oItem)==TRUE){
		SendMessageToPC(oPC,"Elemental Weapon only works with Melee Weapons");
		return; 
	}
	
    itemproperty ipAdd = GetItemPropertyReference(oItem, "ElementalWeapon");
    int nDamage = IP_CONST_DAMAGEBONUS_1d6;
    if (nLevel >= 5 ){   
		nDamage = IP_CONST_DAMAGEBONUS_3d6;
	}
	// int nItemVisual;
    int DamageType;     
    //itemproperty iGlow = ItemPropertyVisualEffect(nItemVisual);
    if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR,oPC,TRUE))
    {   
        DamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
       // nItemVisual = ITEM_VISUAL_ELECTRICAL;
    }
    else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH,oPC,TRUE))
    {   
        DamageType = IP_CONST_DAMAGETYPE_ACID;
       // nItemVisual = ITEM_VISUAL_ACID;             
    }
    else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE,oPC,TRUE))
    {
        DamageType = IP_CONST_DAMAGETYPE_FIRE;
      //  nItemVisual = ITEM_VISUAL_FIRE;         
    }
    else if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER,oPC,TRUE))
    {
        DamageType = IP_CONST_DAMAGETYPE_COLD;
      //  nItemVisual = ITEM_VISUAL_COLD; 
    }
    ipAdd =ItemPropertyDamageBonus(DamageType,nDamage);
    float fDUR = 9999.9f;   
    if(GetHasFeat(FEAT_ELEMWAR_WEAPON,oPC, TRUE))
    {   
		if(!GetIsItemPropertyValid(ipAdd)){
			// SendMessageToPC(oPC, "Itemproperty was not valid");
			return;
        }
   // SendMessageToPC(oPC, "Applying damage constant: "+IntToString(nDamage));    
    IPSafeAddItemProperty(oItem,ipAdd,fDUR,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    //IPSafeAddItemProperty(oItem, iGlow, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
    SaveItemPropertyReference(oItem, "ElementalWeapon", ipAdd);
  //  SendMessageToPC(oPC, "Elemental Damage has been added to your weapon");
	}
}

//Removes Elemental Weapon Property off Weapon
void RemoveElementalWeapon(object oPC,object oItem)
{
	if(GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR,oPC)> 0 ){
		itemproperty ipAdd = GetItemPropertyReference(oItem, "ElementalWeapon");
		if (GetIsItemPropertyValid(ipAdd) == FALSE) {
			//SendMessageToPC(oPC, "Item Property no longer exists on the Item itself");
			return;
		}
    DeleteItemPropertyReference(oItem, "ElementalWeapon");
	}
}

//Wrapper to equip effects from equipment in the proper manner.
void ApplyEquipmentEffect(object oPC, effect eFX, int nDUR = DURATION_TYPE_PERMANENT)
{
    eFX = SupernaturalEffect(eFX);
    eFX = SetEffectSpellId(eFX, EQUIP_FX);
    ApplyEffectToObject(nDUR, eFX, oPC);
}

//Removes Shield if you don't have the feat required for it. To prevent exploit.
void FixSHIELD(object oPC, object oSHIELD, int nSHIELD)
{
	if (oSHIELD == OBJECT_INVALID) return;
	
	// new rogue and swash only feat allows use of small shields without
	// full shield profi, but does not allow use of any other shields
	if (nSHIELD == BASE_ITEM_SMALLSHIELD && 
		GetHasFeat(FEAT_BUCKLER_PROFICIENCY, oPC, TRUE))
			return;
			
    int nFEAT;
    switch (nSHIELD)
    {
        case BASE_ITEM_SMALLSHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
        case BASE_ITEM_LARGESHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
        case BASE_ITEM_TOWERSHIELD: nFEAT = FEAT_TOWER_SHIELD_PROFICIENCY; break;
        default: return;
    }
    if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return;
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oSHIELD));
}

//Removes Armor if you don't have the feat required for it. To prevent exploit.
void FixARMOR(object oPC, object oARMOR)
{
	if (oARMOR == OBJECT_INVALID) return;
    int nARMOR = GetArmorRank(oARMOR);
    int nFEAT;
    switch (nARMOR)
    {
        case ARMOR_RANK_LIGHT: nFEAT = FEAT_ARMOR_PROFICIENCY_LIGHT; break;
        case ARMOR_RANK_MEDIUM: nFEAT = FEAT_ARMOR_PROFICIENCY_MEDIUM; break;
        case ARMOR_RANK_HEAVY: nFEAT = FEAT_ARMOR_PROFICIENCY_HEAVY; break;
        default: return;
    }
    if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return;
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionUnequipItem(oARMOR));
}

// Check for giant weapons and monkey grip abuse
// returns FALSE if no abuse is taking place, true if there is
int MonkeyGripAbuse(object oPC, object oItem){

	// if the equipped item isn't in one of the hand slots, bail
	object oLHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oItem && oLHand != oItem)
			return FALSE;
	
	int bIsAbuse = FALSE;
	int bEmptyOffHand = (oLHand == OBJECT_INVALID);
	int bHasMonkey = GetHasFeat(FEAT_MONKEY_GRIP, oPC, TRUE);
	int nPCsize = GetCreatureSize(oPC);
	int nWeaponSize = IPGetWeaponSize(oItem);
	
	if (nWeaponSize >= nPCsize + 3) bIsAbuse = TRUE;
	else if (nWeaponSize == nPCsize + 2){
		if (bHasMonkey && bEmptyOffHand) bIsAbuse = FALSE;
		else bIsAbuse = TRUE;
	} else if (nWeaponSize == nPCsize + 1){
		if (bHasMonkey || bEmptyOffHand) bIsAbuse = FALSE;
		else bIsAbuse = TRUE;
	} else bIsAbuse = FALSE;
	
	if (bIsAbuse == TRUE){
		string sMessage = "This weapon is too large to be wielded in this way";
		if (nWeaponSize >= nPCsize + 3) 
			sMessage = "This weapon is too large for you to wield, even with Monkey Grip";
		if (nWeaponSize == nPCsize + 2)
			sMessage = "This weapon is so large you can only wield it 2-handed and only with Monkey Grip";
		else sMessage = "You need Monkey Grip to wield this weapon in this way";
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionUnequipItem(oItem));
		SendMessageToPC(oPC, sMessage);
	}
	return bIsAbuse;
}

// once per day any temp properties stuck on the item will be cleared. Basically first time it is equipped between resets.
// might fire again if player has relogged as object ID can change, but at least won't fire every time.
void CheckForTempProperties(object oItem, object oPC)
{
    string sID = ObjectToString(oItem);
    if (GetLocalInt(oPC, sID) == TRUE) return;
    itemproperty ipProp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipProp))
    {
        if (GetItemPropertyDurationType(ipProp) == DURATION_TYPE_TEMPORARY) RemoveItemProperty(oItem, ipProp);
        ipProp = GetNextItemProperty(oItem);
    }
    SetLocalInt(oPC, sID, TRUE);
}

// Check No Manual Dexterity. With it you can only equip creature weapons.
int CheckManualDexterity(object oPC, object oItem, int nItem)
{

    if (IPGetIsCreatureEquippedWeapon(oItem) == TRUE) return FALSE;
	// base item type of creature skin is 73
	if (nItem == 73) return FALSE;
	// new "creature shields" have tag "creature_invis"
	if (GetTag(oItem) == "creature_invis") return FALSE;
    
    switch (nItem)
    {
        case BASE_ITEM_AMULET:
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BELT:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BOOTS:
        case BASE_ITEM_BRACER:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_CLOAK:
        case BASE_ITEM_GLOVES:
        case BASE_ITEM_HELMET:
        case BASE_ITEM_RING:
        case BASE_ITEM_ARMOR:
            return FALSE;
    }
    
    if (GetHasFeat(2340, oPC, TRUE) == FALSE) return FALSE;
    
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oItem));
    SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons, shields, or any other object in their hands due to the No Manual Dexterity feat");
    return TRUE;    
}

// No Weapons and Shields for Dragons in Natural Form
// Creature weapons are 160-180. Others are not allowed unless "in humanoid form (=1)".
int CheckDragonForms(object oPC, object oItem, int nItem){	

	if (GetRacialType(oPC) != RACIAL_TYPE_DRAGON)
		return FALSE;
		
    switch (nItem)
    {
        case BASE_ITEM_AMULET:
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BELT:
        case BASE_ITEM_BOLT:
		case BASE_ITEM_ARMOR:
        case BASE_ITEM_BOOTS:
        case BASE_ITEM_BRACER:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_CLOAK:
        case BASE_ITEM_GLOVES:
        case BASE_ITEM_HELMET:
        case BASE_ITEM_RING:
            return FALSE;
    }
   
    if (GetHasFeat(3623, oPC, TRUE) == FALSE) return FALSE;
    
    object oESSENCE = GetItemPossessedBy(oPC, "ps_essence");
    if (GetLocalInt(oESSENCE, "TempChange") == 1){
        if ((IPGetIsCreatureEquippedWeapon(oItem) == TRUE || GetTag(oItem) == "creature_invis") &&
			!GetHasFeat(FEAT_PSYWAR_FERAL, oPC, TRUE)){
            SendMessageToPC(oPC, "<c=red>Your character does not have claws or a bite in humanoid form.");
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionUnequipItem(oItem));
            return TRUE;
        }
    } else if (IPGetIsCreatureEquippedWeapon(oItem) == FALSE && GetTag(oItem) != "creature_invis"){
        SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons or shields in natural form.");
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionUnequipItem(oItem));
        return TRUE;
    }
    
    return FALSE;
}

// Marquis Cambion Silent Metal
void SilentMetal(object oPC, object oARMOR, object oSHIELD, int nSHIELD, string s2DA = "armorrulestats", string sCOLUMN = "ACCHECK")
{
    if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC, TRUE) == FALSE) return;
    int nCACHE = GetNum2DARows(s2DA); //Faster if cached.
    int nRULES;
    int nACCHECK;
    int nPENALTY;
    
    if (GetArmorRank(oARMOR) != ARMOR_RANK_NONE)
    {
        nRULES = GetArmorRulesType(oARMOR);
        nACCHECK = Get2DAInt(s2DA, sCOLUMN, nRULES);
        if (nACCHECK != 0) nPENALTY = abs(nACCHECK);
    }
    
    if (nSHIELD == BASE_ITEM_SMALLSHIELD || nSHIELD == BASE_ITEM_LARGESHIELD || nSHIELD == BASE_ITEM_TOWERSHIELD)
    {
        nRULES = GetArmorRulesType(oSHIELD);
        nACCHECK = Get2DAInt(s2DA, sCOLUMN, nRULES);
        if (nACCHECK != 0) nPENALTY = nPENALTY + abs(nACCHECK);
    }
    
    if (nPENALTY < 1) return;
    effect eFX = EffectSkillIncrease(SKILL_HIDE, nPENALTY);
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nPENALTY));
    ApplyEquipmentEffect(oPC, eFX);
}

int GetArmorQualifiesForArmorOpt(object oARMOR){
	int nArmorRulesRow = GetArmorRulesType(oARMOR);

	// basic armors, part 1
	if (nArmorRulesRow >= 1 && nArmorRulesRow <= 8)
		return TRUE;
		
	// basic armors, part 2
	if (nArmorRulesRow >= 12 && nArmorRulesRow <= 15)
		return TRUE;
		
	//masterwork armors
	if (nArmorRulesRow >= 24 && nArmorRulesRow <= 35)
		return TRUE;
		
	// crafted mithral, NOT base game mithral with enhanced dex
	if (nArmorRulesRow >= 42 && nArmorRulesRow <= 46)
		return TRUE;
		
	// base game mithral, shields
	return FALSE;
}


// Armor Optimization Feats
void ArmorOptimizations(object oPC, object oARMOR){

	//Remove previous optimization skill effects
	if (GetHasSpellEffect(ARMOR_OPT_FX, oPC)) 
		PS_RemoveEffects(oPC, ARMOR_OPT_FX);
	
	int bHasEpicAO = GetHasFeat(2838, oPC, TRUE);
	int bHasGreaterAO = GetHasFeat(2837, oPC, TRUE);
	int bHasAO = GetHasFeat(2836, oPC, TRUE);
	
	// remove the Armor Opt AC feats if the armor isn't heavy or they
	// do not have Armor Opt
	if (GetBaseItemType(oARMOR) != BASE_ITEM_ARMOR ||
		!GetArmorQualifiesForArmorOpt(oARMOR) ||
		(!bHasEpicAO && !bHasGreaterAO && !bHasAO)){
			if (GetHasFeat(FEAT_ARMOR_OPT_AC_4, oPC, TRUE))
				FeatRemove(oPC, FEAT_ARMOR_OPT_AC_4);
			if (GetHasFeat(FEAT_ARMOR_OPT_AC_2, oPC, TRUE))
				FeatRemove(oPC, FEAT_ARMOR_OPT_AC_2);
			if (GetHasFeat(FEAT_ARMOR_OPT_AC_1, oPC, TRUE))
				FeatRemove(oPC, FEAT_ARMOR_OPT_AC_1);
			return;
	}
	
	//On to calculations
   // int nAC;
	int nDUR = DURATION_TYPE_PERMANENT;
    int nSKILL;
    if (bHasEpicAO){
		if (GetHasFeat(FEAT_ARMOR_OPT_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_ARMOR_OPT_AC_1);
		if (GetHasFeat(FEAT_ARMOR_OPT_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_ARMOR_OPT_AC_2);
		if (!GetHasFeat(FEAT_ARMOR_OPT_AC_4, oPC, TRUE))
			FeatAdd(oPC, FEAT_ARMOR_OPT_AC_4, FALSE);
        nSKILL = 5;
    } else if (bHasGreaterAO){
        if (GetHasFeat(FEAT_ARMOR_OPT_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_ARMOR_OPT_AC_1);
		if (GetHasFeat(FEAT_ARMOR_OPT_AC_4, oPC, TRUE))
			FeatRemove(oPC, FEAT_ARMOR_OPT_AC_4);
		if (!GetHasFeat(FEAT_ARMOR_OPT_AC_2, oPC, TRUE))
			FeatAdd(oPC, FEAT_ARMOR_OPT_AC_2, FALSE);
        nSKILL = 3;
    } else if (bHasAO){
        if (GetHasFeat(FEAT_ARMOR_OPT_AC_4, oPC, TRUE))
			FeatRemove(oPC, FEAT_ARMOR_OPT_AC_4);
		if (GetHasFeat(FEAT_ARMOR_OPT_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_ARMOR_OPT_AC_2);
		if (!GetHasFeat(FEAT_ARMOR_OPT_AC_1, oPC, TRUE))
			FeatAdd(oPC, FEAT_ARMOR_OPT_AC_1, FALSE);
        nSKILL = 1;
    } else return;
	
	//Make sure skill bonus does not exceed armor penalty
	int nPENALTY = StringToInt(
		Get2DAString("armorrulestats", "ACCHECK", GetArmorRulesType(oARMOR))
		);
	// convert penalty to positive and compare
	if (nPENALTY < 0) nPENALTY *= -1;
	if (nSKILL > nPENALTY) nSKILL = nPENALTY;
	
 
    //effect eFX = EffectACIncrease(nAC);
	if (nSKILL > 0){
		effect eFX = EffectSkillIncrease(SKILL_PARRY, nSKILL);
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_SET_TRAP, nSKILL));
		eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_TUMBLE, nSKILL));
		if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC, TRUE) == FALSE){
			eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_HIDE, nSKILL));
			eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSKILL));
		}
		
		eFX = SupernaturalEffect(eFX);
		eFX = SetEffectSpellId(eFX, ARMOR_OPT_FX);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
	}
}
/* race removed
// Unearthly grace feat for Nymphs. CHA bonus to Saves and Dodge AC.
void UnearthlyGrace(object oPC, object oChest)
{
    if (GetHasFeat(2367, oPC, TRUE) == FALSE) return;
    if (GetArmorRank(oChest) > ARMOR_RANK_LIGHT) return;
    int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    if (nCHA < 1) return;
    effect eFX = EffectSavingThrowIncrease(SAVING_THROW_ALL, nCHA);
    eFX = EffectLinkEffects(eFX, EffectACIncrease(nCHA));
    ApplyEquipmentEffect(oPC, eFX);
}
*/

/*
// Keep monk AC from affecting druids
void MonkDruidPenalty(object oPC)
{

    if (!GetHasFeat(4727, oPC, TRUE)) return;
	
	int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    effect eFX = EffectACDecrease(nWis, AC_SHIELD_ENCHANTMENT_BONUS);
    ApplyEquipmentEffect(oPC, eFX);
	SendMessageToPC(oPC, "Both Druid and Monk levels detected. Applying AC penalty based on WIS mod");
} */

//Fixes the Spell Resistance bug from items.
void SpellResistFix(object oPC, string s2DA = "iprp_srcost", string sCOLUMN = "Value")
{
    object oItem;
    int nEquip;
    int nSR;
    int nMAX;
    int nTYPE;
    int nTABLE;
    int nCACHE = GetNum2DARows(s2DA);
    itemproperty iPROP;
    while (nEquip < 18)
    {
        oItem = GetItemInSlot(nEquip, oPC);
        if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPELL_RESISTANCE) == TRUE)
        {
            iPROP = GetFirstItemProperty(oItem);
            while (GetIsItemPropertyValid(iPROP))
            {
                nTYPE = GetItemPropertyType(iPROP);
                if (nTYPE == ITEM_PROPERTY_SPELL_RESISTANCE)
                {
                    nTABLE = GetItemPropertyCostTableValue(iPROP);
                    nSR = Get2DAInt(s2DA, sCOLUMN, nTABLE);
                    if (nSR > nMAX) nMAX = nSR;
                }
                iPROP = GetNextItemProperty(oItem);
            }
        }
        nEquip = nEquip + 1;
    }
    if (nMAX > 0)
	{
    effect eFX = EffectSpellResistanceIncrease(nMAX);
    ApplyEquipmentEffect(oPC, eFX);
	}	
}

//Shields provide concealment against ranged attacks.
void ShieldRangedConceal(object oPC, int nSHIELD)
{
    int nCONCEAL;
    switch (nSHIELD)
    {
        case BASE_ITEM_SMALLSHIELD: nCONCEAL = 10; break;
        case BASE_ITEM_LARGESHIELD: nCONCEAL = 30; break;
        case BASE_ITEM_TOWERSHIELD: nCONCEAL = 60; break;
        default: return;
    }
    effect eFX = EffectConcealment(nCONCEAL, MISS_CHANCE_TYPE_VS_RANGED);
    ApplyEquipmentEffect(oPC, eFX);
}

//Gets the AC provided by the equipped shield
//oShield should be the item equipped in the left hand
int GetACProvidedByShield(object oShield) {
    if (!GetIsObjectValid(oShield))
        return 0;
        
    int nIndex = GetArmorRulesType(oShield);
    int nAC = Get2DAInt("armorrulestats", "ACBONUS", nIndex);
    
    //we have the base AC, now to check enchantment bonus
    itemproperty ip = GetFirstItemProperty(oShield);
    while (GetIsItemPropertyValid(ip)) {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS) {
            nAC += GetItemPropertyCostTableValue(ip);
            break;
        }
        ip = GetNextItemProperty(oShield);
    }
    
    return nAC;
}

//Con Drain Protection in OOC rooms.
void ConDrainProtection(object oItem, object oPC)
{   
    string sArea = GetTag(GetArea(oPC));
    if (sArea == "ooc_appearance_changer_room" || sArea == "ps_area_s_cw_festhall-changing")
    {   
        if (IPGetItemHasItemAbilityBonusPropertySubType(oItem, ABILITY_CONSTITUTION)) ForceRest(oPC);
    }   
}




/* 


Following 2 functions currently disabled, so no sense in compiling them.

// Do bonus damage when unarmed or wielding a creature weapon (new creature weapons)
// need to check on-equip script and cancel these effects if a weapon is equipped.
// Not implemented yet (TatooedMonk)
void TatooedMonk(object oPC, int nRight, int nLeft)
{
    if (GetLevelByClass(998, oPC) < 1) return;
    
}
//Drunk Masters get bonuses with improvised weapons.
//Not implemented yet
void DrunkMasterImprovised(object oPC, int nRight)
{
    int nDRUNK = GetLevelByClass(999, oPC);
    if (nDRUNK < 1) return;
    if (nRight != BASE_ITEM_INVALID && nRight != BASE_ITEM_CLUB && nRight != 152) return;
    int nLEVEL = nDRUNK + GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nATTACKS = 2;
    if (nLEVEL < 11) nATTACKS = 1;
    
    int nDMG = DAMAGE_BONUS_1d8;
    int nAB = 1;
    int nAC = 1;
    
    if (GetHasFeat(12468, oPC, TRUE)) 
    {
        nDMG = DAMAGE_BONUS_2d12;
        nAB = 4;
        nAC = 7;
    }   
    else if (GetHasFeat(12467, oPC, TRUE))
    {
        nDMG = DAMAGE_BONUS_2d8;
        nAB = 3;
        nAC = 5;
    }
    else if (GetHasFeat(12466, oPC, TRUE))
    {
        nDMG = DAMAGE_BONUS_1d12;
        nAB = 2;
        nAC = 3;
    }
    
    effect eFX = EffectModifyAttacks(nATTACKS);
    eFX = EffectLinkEffects(eFX, EffectAttackIncrease(nAB));
    eFX = EffectLinkEffects(eFX, EffectDamageIncrease(nDMG));
    eFX = EffectLinkEffects(eFX, EffectACIncrease(nAC, AC_DEFLECTION_BONUS));
    ApplyEquipmentEffect(oPC, eFX);
}

// Deprecated. References to this changed to IPGetIsCreatureEquippedWeapon() in x2_inc_itemprop
int GetCreatureWeapons(object oItem)
{
	return IPGetIsCreatureEquippedWeapon(oItem);
}

//Wrapper to check if nTYPE is a creature weapon. Item Type from 160 to 180
int GetIsCreatureWeapon(int nTYPE)
{
	string sType = Get2DAString("baseitems", "WeaponCategory", nTYPE);
	if (FindSubString(GetStringLowerCase(sType), "creature") != -1) return TRUE;
	else return FALSE;
}




A file search reveals that these functions aren't called from anywhere.

// Check if the weapon is finessable. Custom finessables from 160 to 174 and 202.
int GetIsSpecialFinessable(int nTYPE)
{
    if (GetIsCreatureWeapon(nTYPE) == TRUE) return TRUE;
    switch (nTYPE)
    {
        case 202:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CBLUDGWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
            return TRUE;
    }
    return FALSE;
}


int GetIsShields(object oItem)
{
  int iBaseItem = GetBaseItemType(oItem);
   return iBaseItem = BASE_ITEM_LARGESHIELD || BASE_ITEM_SMALLSHIELD || BASE_ITEM_TOWERSHIELD;

}

*/