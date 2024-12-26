//:://////////////////////////////////////////////
//:: Sigil Equip system
//:://////////////////////////////////////////////
//:: Runs the Custom OnEquip and OnUnequip Scripts.
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





const int SIGIL_EQUIP_FX = -9444;
const int SIGIL_ARMOR_OPTIMIZATION_FX = -9544;

/*----------------------------------------------------------------------------------------
			DECLARATIONS
-----------------------------------------------------------------------------------------*/
void ApplyEquipmentEffect(object oPC, effect eFX, int nDUR = DURATION_TYPE_PERMANENT);
void SigilEquipment(object oPC, object oITEM, int nEQUIP);
void EquipmentEffects(object oPC, object oChanged, int bOnEquip);
void ConDrainProtection(object oItem, object oPC);
int GetACProvidedByShield(object oShield);
void DrunkMasterImprovised(object oPC, int nRIGHT);
void FrightfulPresence(object oPC);
void FIX_BLINDFIGHT(object oPC);
void ShieldRangedConceal(object oPC, int nSHIELD);
void SpellResistFix(object oPC, string s2DA = "iprp_srcost", string sCOLUMN = "Value");
void MonkDruidPenalty(object oPC);
void UnearthlyGrace(object oPC, object oCHEST);
void HeavyArmorOptimizations(object oPC, object oARMOR);
void SilentMetal(object oPC, object oARMOR, object oSHIELD, int nSHIELD, string s2DA = "armorrulestats", string sCOLUMN = "ACCHECK");
int CheckDragonForms(object oPC, object oITEM, int nITEM);
int CheckManualDexterity(object oPC, object oITEM, int nITEM);
void CheckForTempProperties(object oItem, object oPC);
int MonkeyGripAbuse(object oPC, object oITEM);
int FixARMOR(object oPC, object oARMOR);
int FixSHIELD(object oPC, object oSHIELD, int nSHIELD);
void RemoveElementalWeapon(object oPC,object oItem);
void ApplyElementalWeapon(object oPC, object oItem);
void RemoveAustereStrikes(object oPC,object oItem);
void ApplyAustereStrikes(object oPC,object oItem);
void RemoveMeditativeStrikes(object oPC,object oItem);
void ApplyMeditativeStrikes(object oPC,object oItem);
int DervishCanUseDance(object oPC);
int NoHeavyArmorOrShield(object oPC);
int GetMonkWeapon(object oItem);
void MurderousIntent(object oPC, object oRHAND);
void HandAndAHalfWeapon(object oPC, object oRHAND, object oLHAND);
void BucklerFinesse(object oPC, object oLHAND);
void BojutsuKenjutsu(object oPC, object oRHAND, object oLHAND, object oArmor);
void FlorentineTWF(object oPC, object oRHAND, object oLHAND);
void UpdateWeaponBenefits(object oPC, object oRHAND, object oLHAND, object oCHEST, object oChanged, int bOnEquip);


//int GetCreatureWeapons(object oItem);
//int GetIsSpecialFinessable(int nTYPE);
//int GetIsShields(object oItem)
//void TatooedMonk(object oPC, int nRIGHT, int nLEFT);
//void DrunkMasterImprovised(object oPC, int nRIGHT);


/*----------------------------------------------------------------------------------------
			IMPLEMENTATIONS
-----------------------------------------------------------------------------------------*/


//This starts all the various checks and effects to be applied based on equipment, as per Sigil's custom rules.
//nEQUIP: TRUE when called from OnEquip and FALSE when called from OnUnequip.
//Found in "ps_inc_equipment.nss".
void SigilEquipment(object oPC, object oITEM, int nEQUIP){

	// we shouldn't have to do ANY processing for creature skin, so just skip all this if 
	// that's what it is
	int nITEM = GetBaseItemType(oITEM);
	if (nITEM == BASE_ITEM_CREATUREITEM) return; // base item 73, creature skin
	
    RemoveEffectsFromSpell(oPC, SIGIL_EQUIP_FX);
    if (nEQUIP == TRUE)
    {
      CheckForTempProperties(oITEM, oPC);
        
      DelayCommand(0.1f,ApplyMeditativeStrikes(oPC,oITEM));
	  
	  DelayCommand(0.1f,ApplyAustereStrikes(oPC,oITEM));
    
      DelayCommand(0.1f,ApplyElementalWeapon(oPC,oITEM));
        
        /*	 if (GetIsFinessable(oITEM))
			 DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oITEM));

            if (!GetExistingFinesse(oITEM)&&  GetSubRace(oPC) == 243) 
            DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oITEM));
				
			if (GetDervishWeapon(oITEM) && (GetLevelByClass(CLASS_DERVISH,oPC)>4))
				 DelayCommand(0.05f,PS_ApplySpecialWeaponFinesse(oPC, oITEM)); */

        
        if (nITEM == BASE_ITEM_GLOVES) SetGlovesOnHitProperty(oPC);
        //{  // weird orphan brackets
		if (MonkeyGripAbuse(oPC, oITEM) == TRUE) return;
		if (CheckManualDexterity(oPC, oITEM, nITEM) == TRUE) return;
		if (CheckDragonForms(oPC, oITEM, nITEM) == TRUE) return;

        //}
    }
    else
    {
        ConDrainProtection(oITEM, oPC);
        if (nITEM == BASE_ITEM_GLOVES) RemoveTempOnHitProperty(oITEM);
            //PS_RemoveSpecialWeaponFinesse(oPC, oITEM);
            RemoveElementalWeapon(oPC,oITEM);
            RemoveMeditativeStrikes(oPC,oITEM);
			RemoveAustereStrikes(oPC,oITEM);
        
    }
	
    DelayCommand(0.1f, EquipmentEffects(oPC, oITEM, nEQUIP));
}

//When all is said and done, the various custom effects dependant on equipment are applied.
void EquipmentEffects(object oPC, object oChanged, int bOnEquip)
{
    object oCHEST = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (FixARMOR(oPC, oCHEST) == TRUE) return;
    
    object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    int nLEFT = GetBaseItemType(oLHAND);
    if (FixSHIELD(oPC, oLHAND, nLEFT) == TRUE) return;
    
    object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nRIGHT = GetBaseItemType(oRHAND);   
    SpellResistFix(oPC);
    ShieldRangedConceal(oPC, nLEFT);
	FIX_BLINDFIGHT(oPC);
    SilentMetal(oPC, oCHEST, oLHAND, nLEFT);
    HeavyArmorOptimizations(oPC, oCHEST);
    UnearthlyGrace(oPC, oCHEST);
	MonkDruidPenalty(oPC);
	HandAndAHalfWeapon(oPC, oRHAND, oLHAND);
	MurderousIntent(oPC, oRHAND);
	UpdateWeaponBenefits(oPC, oRHAND, oLHAND, oCHEST, oChanged, bOnEquip);

	
    //TatooedMonk(oPC, nRIGHT, nLEFT);
    //DrunkMasterImprovised(oPC, nRIGHT, nLEFT);
}

// because EffectAttackIncrease() doesn't stack and multiple conditions could result
// in multiple applications (forexample, a samurai drawing a katana while using
// oversized twf feat, all functions that involve an attack bonus have been moved
// to ff_combat_mods (which also does the heavy lifting for Methodical Strike, Considered Strike,
// and Staff Fighting). This function checks if it's necessary and then calls it if it is.
// Likewise we call the script that adds the tactical bonus feats from here, if needed.
void UpdateWeaponBenefits(object oPC, object oRHAND, object oLHAND, object oCHEST, object oChanged, int bOnEquip){
	// compare current armor and weapons to previous. No need to use essence, they
	// don't need to persist across logins
	string sCurrentArmor = ObjectToString(oCHEST);
	string sCurrentWeapon = ObjectToString(oRHAND);
	string sCurrentWeaponLeft = ObjectToString(oLHAND);
	string sLastTacArmor = GetLocalString(oPC, "TacArmor");
	string sLastTacWeapon = GetLocalString(oPC, "TacWeapon");
	string sLastTacWeaponLeft = GetLocalString(oPC, "TacWeaponLeft");
	
	// if we haven't changed armor or weapons since the last time this was
	// called, we don't need to do any of this.
	if (sCurrentArmor == sLastTacArmor && sCurrentWeapon == sLastTacWeapon &&
		sCurrentWeaponLeft == sLastTacWeaponLeft) return;
		
	BucklerFinesse(oPC, oLHAND);
	BojutsuKenjutsu(oPC, oRHAND, oLHAND, oCHEST);
	FlorentineTWF(oPC, oRHAND, oLHAND);

	UpdateCombatMods(oPC, -1, oChanged, bOnEquip);
	
	int bSameMainHand = (sCurrentWeapon == sLastTacWeapon);
		
	// reset the stored data for armor and weapons
	SetLocalString(oPC, "TacArmor", sCurrentArmor);
	SetLocalString(oPC, "TacWeapon", sCurrentWeapon);
	SetLocalString(oPC, "TacWeaponLeft", sCurrentWeaponLeft);
	
	// Tac only cares about the main hand weapon, so if that hasn't changed bail
	if (bSameMainHand) return;
	object oSkin = PS_GetCreatureSkin(oPC);
	FF_TacticalWeapons(oPC, oRHAND, oSkin);
}


// Gain defense improvements to twf if using the smallest possible off hand weapon
// and a normal sized, or smaller, main hand and the character has twd feat. 
// 10% - 25% concealment vs melee, depending on combo of weapons and feats. 
void FlorentineTWF(object oPC, object oRHAND, object oLHAND){

	if (!GetHasFeat(FEAT_TWO_WEAPON_DEFENSE, oPC, TRUE)) return;
	
	if (!IPGetIsMeleeWeapon(oRHAND) || !IPGetIsMeleeWeapon(oLHAND)) return;
	
	int nPCsize = GetCreatureSize(oPC);
	if (IPGetWeaponSize(oRHAND) > nPCsize) return;
	
	int nSmallestWeap = nPCsize - 2;
	if (nSmallestWeap < 1) nSmallestWeap = 1;
	// bail if they're not using the smallest off-hand they can
	if (IPGetWeaponSize(oLHAND) > nSmallestWeap) return;
	
	int bIsMainGauche = FALSE;
	int nLeftId = GetBaseItemType(oLHAND);
	if (nPCsize > 3){
	if (nLeftId == BASE_ITEM_SHORTSWORD || nLeftId == BASE_ITEM_LIGHTMACE ||
		nLeftId ==  BASE_ITEM_CREATURECLAW_SML) bIsMainGauche = TRUE;
	} else {
		if (nLeftId == BASE_ITEM_DAGGER || nLeftId == BASE_ITEM_LIGHTHAMMER ||
		nLeftId ==  BASE_ITEM_CREATURECLAW_TINY) bIsMainGauche = TRUE;
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
void BucklerFinesse(object oPC, object oLHAND){
	int nId = -21915;
	RemoveEffectsFromSpell(oPC, nId);
	if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) < 17) return;
	if (GetBaseItemType(oLHAND) != BASE_ITEM_SMALLSHIELD) return;

	if (GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) < 7 && 
		GetLevelByClass(CLASS_TYPE_ROGUE, oPC) < 7)
			return;
			
	effect eFX = EffectACIncrease(1);
	eFX = SupernaturalEffect(eFX);
    eFX = SetEffectSpellId(eFX, nId);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
}

// had to give this its own spell id for ac for the same reason as buckler
void BojutsuKenjutsu(object oPC, object oRHAND, object oLHAND, object oArmor){
	int bQualifies = TRUE;

	// must be two handed
	if (!GetWeaponIsTwoHanded(oPC, oRHAND, oLHAND))
		bQualifies = FALSE;
		
	// no heavy armor
	if (GetArmorRank(oArmor) == ARMOR_RANK_HEAVY) bQualifies = FALSE;
	
	// find out it's a qualifying sword or a qualifying staff
	int nType = GetBaseItemType(oRHAND);
	int bKenjutsu = FALSE;
	int bBojutsu = FALSE;
	switch (nType){
		case BASE_ITEM_SCIMITAR: bKenjutsu = TRUE; break;
		case BASE_ITEM_KATANA: bKenjutsu = TRUE; break;
		case BASE_ITEM_FALCHION: bKenjutsu = TRUE; break;
		case BASE_ITEM_NINJATO: bKenjutsu = TRUE; break;
	}
	if (!bKenjutsu) bBojutsu = GetQualifiesForStaffFighting(oPC, oRHAND, oLHAND);
	if (!bKenjutsu && !bBojutsu) bQualifies = FALSE;

	int bGetsAC = FALSE;
	int bMartialArtist = (GetLevelByClass(CLASS_TYPE_MONK, oPC) + 
		GetLevelByClass(CLASS_SAMURAI, oPC) +
			GetLevelByClass(CLASS_KENSAI, oPC) > 0);
	int nSizeDifference = IPGetWeaponSize(oRHAND) - GetCreatureSize(oPC);
	if (bKenjutsu){
		if (nSizeDifference == 1 && !GetHasFeat(FEAT_MONKEY_GRIP, oPC, TRUE))
			bQualifies = FALSE;
		else if (nSizeDifference >= 2) bQualifies = FALSE;
	}
	int nId = -21912;
	RemoveEffectsFromSpell(oPC, nId);
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
			eFX = SetEffectSpellId(eFX, nId);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
		}
	}
}

// Ninjato and stiletto grant +1d6 stacking sneak attack if wielded in the main hand and if the 
// character has sneak attack from race or class. "Murderous Intent" was what I renamed the feat
// for NeverWinter 9 Agent sneak attack 1. Nw9 Agent is a class that was supposed to be a rogue-ish
// alternative PrC for nwn9, but Bioware never finished it and it's not in the game. But the feat works. 
void MurderousIntent(object oPC, object oRHAND){
	int nType = GetBaseItemType(oRHAND);
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

void HandAndAHalfWeapon(object oPC, object oRHAND, object oLHAND){
	// giants can one-hand these weapons with only martial feat.
	int nPCsize = GetCreatureSize(oPC);
	if (nPCsize > 3) return;
	
	int nRtype = GetBaseItemType(oRHAND);
	int nLtype = GetBaseItemType(oLHAND);
	
	int bRightBastard = (nRtype == BASE_ITEM_BASTARDSWORD || nRtype == BASE_ITEM_MAUL ||
		nRtype == BASE_ITEM_INFANTRYFLAIL || nRtype == BASE_ITEM_DWARVENWARAXE);
	int bLeftBastard = (nLtype == BASE_ITEM_BASTARDSWORD || nLtype == BASE_ITEM_MAUL ||
		nLtype == BASE_ITEM_INFANTRYFLAIL || nLtype == BASE_ITEM_DWARVENWARAXE);
	
	// if they're not using any of the Hand and a half weapons, bail.
	if (!bRightBastard && !bLeftBastard) return;
	
	int bHasExotic = GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC, TRUE);
	int bHasMonkey = GetHasFeat(FEAT_MONKEY_GRIP, oPC, TRUE);
	
	string sMessage = "This weapon is slightly larger than normal weapons of its type (though not as big as a large weapon)";
	int bUnequipR = FALSE;
	int bUnequipL = FALSE;
	
	// small characters need either exotic or monkey grip to use
	// two handed, and both to use 1 handed.
	if (nPCsize < 3){
		// small character who has nothing in off hand and has either feat is golden. bail.
		if ((bHasExotic || bHasMonkey) && oLHAND == OBJECT_INVALID) return;
		if (bHasExotic && bHasMonkey) return; // small char with both feats also golden. bail.
		if (oLHAND == OBJECT_INVALID){
			sMessage += " You need either exotic weapon proficiency or monkey grip to wield this weapon in two hands.";
			sMessage += " (You will not suffer the large weapon -2 penalty for using this weapon two-handed if doing so via monkey grip.)";
			bUnequipR = TRUE;	
		} else {
			sMessage += " You need both monkey grip and exotic weapon proficiency to wield this weapon in one hand.";
			if (bRightBastard) bUnequipR = TRUE;
			if (bLeftBastard) bUnequipL = TRUE;
		}
	} else { // medium chars only, we've already bailed for large and handled small
		// if either hand is empty then this doesn't concern us, we only need to check
		// medium characters for one-handing a bastard or dwarfaxe
		if (oLHAND == OBJECT_INVALID) return;
	
		// if a medium char has exotic or monkey, they're all set. bail.
		if (bHasExotic || bHasMonkey) return;
	
		// dwarves have special rules due to being culturally accustomed to dwarfaxe
		if (GetRacialType(oPC) == RACIAL_TYPE_DWARF){
			if (bRightBastard && nRtype != BASE_ITEM_DWARVENWARAXE) bUnequipR = TRUE;
			if (bLeftBastard && nLtype != BASE_ITEM_DWARVENWARAXE) bUnequipL = TRUE;
		} else {
			if (bRightBastard) bUnequipR = TRUE;
			if (bLeftBastard) bUnequipL = TRUE;
		} // end racial check
		if (bUnequipR || bUnequipL){
			sMessage += " You need to have either monkey grip or exotic weapon proficiency to use this weapon in one hand.";
			sMessage += " (You will not suffer the large weapon -2 penalty for using this weapon one-handed if doing so via monkey grip.)";
		}
	} // end of pc size conditional
	
	if (bUnequipR || bUnequipL){
		if (bUnequipR) AssignCommand(oPC, ActionUnequipItem(oRHAND));
		if (bUnequipL) AssignCommand(oPC, ActionUnequipItem(oLHAND));
		SendMessageToPC(oPC, sMessage);
	}
}

//This gets the weapons that qualify for Meditative Strikes
int GetMonkWeapon(object oItem)
{ 
    int iBaseItem = GetBaseItemType(oItem);
    return iBaseItem ==  BASE_ITEM_SHURIKEN || iBaseItem == BASE_ITEM_GLOVES ||    iBaseItem == BASE_ITEM_KAMA || iBaseItem == BASE_ITEM_QUARTERSTAFF;
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
    eFX = SetEffectSpellId(eFX, SIGIL_EQUIP_FX);
    ApplyEffectToObject(nDUR, eFX, oPC);
}

//Removes Shield if you don't have the feat required for it. To prevent exploit.
int FixSHIELD(object oPC, object oSHIELD, int nSHIELD)
{
	// new rogue and swash only feat allows use of small shields without
	// full shield profi, but does not allow use of any other shields
	if (nSHIELD == BASE_ITEM_SMALLSHIELD && 
		GetHasFeat(FEAT_BUCKLER_PROFICIENCY, oPC, TRUE))
			return FALSE;
			
    int nFEAT;
    switch (nSHIELD)
    {
        case BASE_ITEM_SMALLSHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
        case BASE_ITEM_LARGESHIELD: nFEAT = FEAT_SHIELD_PROFICIENCY; break;
        case BASE_ITEM_TOWERSHIELD: nFEAT = FEAT_TOWER_SHIELD_PROFICIENCY; break;
        default: return FALSE;
    }
    if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return FALSE;
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oSHIELD));
    return TRUE;
}

//Removes Armor if you don't have the feat required for it. To prevent exploit.
int FixARMOR(object oPC, object oARMOR)
{
    int nARMOR = GetArmorRank(oARMOR);
    int nFEAT;
    switch (nARMOR)
    {
        case ARMOR_RANK_LIGHT: nFEAT = FEAT_ARMOR_PROFICIENCY_LIGHT; break;
        case ARMOR_RANK_MEDIUM: nFEAT = FEAT_ARMOR_PROFICIENCY_MEDIUM; break;
        case ARMOR_RANK_HEAVY: nFEAT = FEAT_ARMOR_PROFICIENCY_HEAVY; break;
        default: return FALSE;
    }
    if (GetHasFeat(nFEAT, oPC, TRUE) == TRUE) return FALSE;
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionUnequipItem(oARMOR));
    return TRUE;
}

// Check for giant weapons and monkey grip abuse
// returns FALSE if no abuse is taking place, true if there is
int MonkeyGripAbuse(object oPC, object oITEM){

	// if the equipped item isn't in one of the hand slots, bail
	object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oITEM && oLHAND != oITEM)
			return FALSE;
	
	int bIsAbuse = FALSE;
	int bEmptyOffHand = (oLHAND == OBJECT_INVALID);
	int bHasMonkey = GetHasFeat(FEAT_MONKEY_GRIP, oPC, TRUE);
	int nPCsize = GetCreatureSize(oPC);
	int nWeaponSize = IPGetWeaponSize(oITEM);
	
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
		AssignCommand(oPC, ActionUnequipItem(oITEM));
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
int CheckManualDexterity(object oPC, object oITEM, int nITEM)
{

    if (IPGetIsCreatureEquippedWeapon(oITEM) == TRUE) return FALSE;
	// base item type of creature skin is 73
	if (nITEM == 73) return FALSE;
    
    switch (nITEM)
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
    AssignCommand(oPC, ActionUnequipItem(oITEM));
    SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons, shields, or any other object in their hands due to the No Manual Dexterity feat");
    return TRUE;    
}

// No Weapons and Shields for Dragons in Natural Form and no Armor in both forms (exept clothes)
// Creature weapons are 160-180. Others are not allowed unless "in humanoid form (=1)".
int CheckDragonForms(object oPC, object oITEM, int nITEM)
{		//TODO ADD EXCEPTION FOR CREATURE SKIN AND CHECK FOR OTHER PROBS, TEST WRAITH
    switch (nITEM)
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
    if (GetLocalInt(oESSENCE, "TempChange") == 1)
    {
        if (IPGetIsCreatureEquippedWeapon(oITEM) == TRUE)
        {
            SendMessageToPC(oPC, "<c=red>Your character does not have claws or a bite in humanoid form.");
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionUnequipItem(oITEM));
            return TRUE;
        }
    }
    else if (IPGetIsCreatureEquippedWeapon(oITEM) == FALSE)
    {
        SendMessageToPC(oPC, "<c=red>Your character cannot wield weapons or shields in natural form.");
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionUnequipItem(oITEM));
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


// Heavy Armor Optimization Feats
void HeavyArmorOptimizations(object oPC, object oARMOR){

	//Remove previous optimization effect
	if ( GetHasSpellEffect(SIGIL_ARMOR_OPTIMIZATION_FX, oPC) ) {
		effect eEffect = GetFirstEffect( oPC );
		while ( GetIsEffectValid(eEffect) ) {
		
			if ( GetEffectSpellId(eEffect) == SIGIL_ARMOR_OPTIMIZATION_FX){
				RemoveEffect( oPC, eEffect );
			}
				
			eEffect = GetNextEffect( oPC );
		}
	}
	
	if (GetBaseItemType(oARMOR) != BASE_ITEM_ARMOR) return;
    if (GetArmorRank(oARMOR) != ARMOR_RANK_HEAVY) return;
	
	//On to calculations
    int nAC;
	int nDUR = DURATION_TYPE_PERMANENT;
    int nSKILL;
    if (GetHasFeat(2838, oPC, TRUE) == TRUE)
    {
        nAC = 4;
        nSKILL = 5;
    }
    else if (GetHasFeat(2837, oPC, TRUE) == TRUE)
    {
        nAC = 2;
        nSKILL = 3;
    }
    else if (GetHasFeat(2836, oPC, TRUE) == TRUE)
    {
        nAC = 1;
        nSKILL = 1;
    }
    else return;
    
    effect eFX = EffectACIncrease(nAC);
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_PARRY, nSKILL));
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_SET_TRAP, nSKILL));
    eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_TUMBLE, nSKILL));
    if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC, TRUE) == FALSE)
    {
        eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_HIDE, nSKILL));
        eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSKILL));
    }
	
	
    eFX = SupernaturalEffect(eFX);
    eFX = SetEffectSpellId(eFX, SIGIL_ARMOR_OPTIMIZATION_FX);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
}

// Unearthly grace feat for Nymphs. CHA bonus to Saves and Dodge AC.
void UnearthlyGrace(object oPC, object oCHEST)
{
    if (GetHasFeat(2367, oPC, TRUE) == FALSE) return;
    if (GetArmorRank(oCHEST) > ARMOR_RANK_LIGHT) return;
    int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    if (nCHA < 1) return;
    effect eFX = EffectSavingThrowIncrease(SAVING_THROW_ALL, nCHA);
    eFX = EffectLinkEffects(eFX, EffectACIncrease(nCHA, AC_DEFLECTION_BONUS));
    ApplyEquipmentEffect(oPC, eFX);
}


// Keep monk AC from affecting druids
void MonkDruidPenalty(object oPC)
{

    if (!GetHasFeat(4727, oPC, TRUE)) return;
	
	int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    effect eFX = EffectACDecrease(nWis, AC_SHIELD_ENCHANTMENT_BONUS);
    ApplyEquipmentEffect(oPC, eFX);
	SendMessageToPC(oPC, "Both Druid and Monk levels detected. Applying AC penalty based on WIS mod");
}

//Fixes the Spell Resistance bug from items.
void SpellResistFix(object oPC, string s2DA = "iprp_srcost", string sCOLUMN = "Value")
{
    object oITEM;
    int nEQUIP;
    int nSR;
    int nMAX;
    int nTYPE;
    int nTABLE;
    int nCACHE = GetNum2DARows(s2DA);
    itemproperty iPROP;
    while (nEQUIP < 18)
    {
        oITEM = GetItemInSlot(nEQUIP, oPC);
        if (GetItemHasItemProperty(oITEM, ITEM_PROPERTY_SPELL_RESISTANCE) == TRUE)
        {
            iPROP = GetFirstItemProperty(oITEM);
            while (GetIsItemPropertyValid(iPROP))
            {
                nTYPE = GetItemPropertyType(iPROP);
                if (nTYPE == ITEM_PROPERTY_SPELL_RESISTANCE)
                {
                    nTABLE = GetItemPropertyCostTableValue(iPROP);
                    nSR = Get2DAInt(s2DA, sCOLUMN, nTABLE);
                    if (nSR > nMAX) nMAX = nSR;
                }
                iPROP = GetNextItemProperty(oITEM);
            }
        }
        nEQUIP = nEQUIP + 1;
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

void FIX_BLINDFIGHT(object oPC)
{
	if (GetHasFeat(FEAT_BLIND_FIGHT,oPC, TRUE) == FALSE) return;
	effect eEBLIND = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
	eEBLIND = SupernaturalEffect(eEBLIND);
	eEBLIND = SetEffectSpellId(eEBLIND, 9005);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEBLIND, oPC);
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
void TatooedMonk(object oPC, int nRIGHT, int nLEFT)
{
    if (GetLevelByClass(998, oPC) < 1) return;
    
}
//Drunk Masters get bonuses with improvised weapons.
//Not implemented yet
void DrunkMasterImprovised(object oPC, int nRIGHT)
{
    int nDRUNK = GetLevelByClass(999, oPC);
    if (nDRUNK < 1) return;
    if (nRIGHT != BASE_ITEM_INVALID && nRIGHT != BASE_ITEM_CLUB && nRIGHT != 152) return;
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