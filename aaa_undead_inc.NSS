#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"

/*	This is the include file for all undead features for Racial PrCs.
	Every individual feature in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_undead, which acts as the universal spell with a case-based system.
*/


// Apply a level adjustment to the character for the template class.
// Do not use this by itself; there should be a check to ensure it has not been previously applied
// Called by PS_Undead_TouchOfEvil (see below)
void PS_Template_LevelAdjustment(object oPC, object oItem)
{	

	if (ALLOW_ECL_LEVEL_30) return;
	// Listing of all template class values; set a new int and new if statement for each
	int nOldECL = PS_GetEssenceECL(oPC);

	int iLich = 0;
	int iVamp = 0;
	int iDKnt = 0;
	int iNewECL;
	string sNewECL;
	
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
	{	iLich = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0)
	{	iLich = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0)
	{	iLich = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) > 0)
	{	iVamp = GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC) > 0)
	{	iVamp = GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) > 0)
	{	iVamp = GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) > 0)
	{	iDKnt = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);	}

	if (iLich != 0)
	{	//iNewECL = nOldECL + 3;
		//sNewECL = IntToString(iNewECL);
		//PS_SetLocalInt(oItem, "OldECL", nOldECL);
		//PS_SetLocalString(oPC, "ECL", sNewECL);
		//PS_SetLocalString(oItem, "ECL", sNewECL);
		PS_SetLocalString(oItem, "Template", "Lich");
		SetFirstName(oItem, "My Phylactery");
		SetItemIcon(oItem, 2711);	}
		
	if (iVamp != 0)
	{	//iNewECL = nOldECL + 3;
		//sNewECL = IntToString(iNewECL);
		//PS_SetLocalInt(oItem, "OldECL", nOldECL);
		//PS_SetLocalString(oPC, "ECL", sNewECL);
		//PS_SetLocalString(oItem, "ECL", sNewECL);
		PS_SetLocalString(oItem, "Template", "Vampire");	}
		
	if (iDKnt != 0)
	{	//iNewECL = nOldECL + 3;
		//sNewECL = IntToString(iNewECL);
		//PS_SetLocalInt(oItem, "OldECL", nOldECL);
		//PS_SetLocalString(oPC, "ECL", sNewECL);
		//PS_SetLocalString(oItem, "ECL", sNewECL);
		PS_SetLocalString(oItem, "Template", "DeathKnight");	}
	
	// Remove one level if total ECL results in a value greater than 30
	if (PS_GetLevel(oPC) > 30 )
	{	int nextlvl = 1000;
		int totalxp = 0;
		int whatlevel = GetHitDice(oPC) - 1; // decrease level by 1
		// set your level
		int i=0;
		for (i = 1; i < whatlevel; i++) 
		{	totalxp += nextlvl;
			nextlvl += 1000;	}
		SetXP(oPC, totalxp + nextlvl - 1);
		//Template Class Fix
		PS_UndeadRaceFix(oPC);
		DelayCommand(1.0f, ForceRest(oPC));	}
}

/*
//Deprecated. This uses GetDistanceBetween() which measures the distance between the centres of two
// models, not the edge to edge. Therefore there's been many times when I've been standing on the toes
// of large opponents and been told they're out of range.
// Use this to fix infinite range for instant feats.
int CancelIfNotInMeleeRange(object oCaller, object oTarget, int nFeatID)
{
	if (GetDistanceBetween(oCaller, oTarget) > 3.5f) // Melee range seems to be around a little less then 3.0f, so picked a number
	{                                                // a little higher to give some loose.
		SendMessageToPC(oCaller, "Target out of range.");
		ResetFeatUses(oCaller, nFeatID, FALSE, TRUE);
		return FALSE;
	}	
	return TRUE;
}
*/ 


// Upon becoming undead, move the character 35 points towards evil and apply template ECL adjustment
void PS_Undead_TouchOfEvil(object oPC)
{
	object 	oItem	= PS_GetEssence(oPC);
	
	int iUndead = 0;
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
	{	iUndead = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0)
	{	iUndead = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0)
	{	iUndead = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) > 0)
	{	iUndead = GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC) > 0)
	{	iUndead = GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) > 0)
	{	iUndead = GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) > 0)
	{	iUndead = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);	}
	
	if(iUndead != 0)
	
    {	if(GetIsObjectValid(oItem))
    	{
	 		int nUndead = PS_GetLocalInt(oItem,"IsUndead"); //verifies this will not be set twice
			int nGoodEvil = GetGoodEvilValue(oPC);
			if(nUndead != 1)
			{	if(GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC) > 0)
				{	AdjustAlignment(oPC, ALIGNMENT_EVIL, 75);	}
				else
				{	AdjustAlignment(oPC, ALIGNMENT_EVIL, 35);	}
				SendMessageToPC(oPC, "As you begin your undeath, evil has left its mark on your soul.");
				PS_Template_LevelAdjustment(oPC, oItem);
				PS_SetLocalInt(oItem, "IsUndead", 1);
				PS_SetLocalInt(oItem, "OldGoodEvil", nGoodEvil);
			}	
		}
	}	
}

// Changes the character's racial type to Undead, and applies an evil little effect.
void PS_UndeadRacialType(object oPC)
{
	object oEssence = PS_GetEssence(oPC);

	if(GetRacialType(oPC) != RACIAL_TYPE_UNDEAD)
	{
		int nOrigin = GetRacialType(oPC);
		int nOriSub = GetSubRace(oPC);
		PS_RestoreOriginalAppearance(oPC);
		PS_SetLocalInt(oEssence, VAR_OLD_RACE, nOrigin);
		PS_SetLocalInt(oEssence, "OldSubrace", nOriSub);
		PS_SetLocalInt(oEssence, "TemplateFix", 0);
		effect eUndead 	= EffectNWN2SpecialEffectFile("fx_coven_murder", oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUndead, oPC, 6.0f);
		effect eUndead2 = EffectNWN2SpecialEffectFile("fx_black_cloud", oPC);
		DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eUndead2, oPC, 4.0f));

		// Set Death Knight appearance if needed.
		if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) > 0)
		{
			int nAppVar;

			switch(GetRacialType(oPC))
			{
				case RACIAL_TYPE_DWARF:
					nAppVar = 991; break;
				case RACIAL_TYPE_ELF:
					nAppVar = 992; break;
				case RACIAL_TYPE_GNOME:
					nAppVar = 993; break;
				case RACIAL_TYPE_HALFLING:
					nAppVar = 989; break;
				case RACIAL_TYPE_HUMANOID_ORC:
				case RACIAL_TYPE_HALFORC:
				case RACIAL_TYPE_GRAYORC:
					nAppVar = 994; break;
				default:
					nAppVar = 1008; break;
			}

			int iAppearance = GetAppearanceType(oPC);
			PS_SetLocalInt(oEssence, "OldAppearance", iAppearance);
			struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
			app.AppearanceType = nAppVar;
			PS_SetCreatureCoreAppearance(oPC, app);
			PS_RefreshAppearance(oPC);
			DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));
		}

		PS_SetRacialType(oPC, RACIAL_TYPE_UNDEAD);
		PS_SetSubRacialType(oPC, RACIAL_SUBTYPE_UNDEAD);
	}
}

// Applies undead properties, dependent upon level in Lich PRC
void PS_UndeadProperties(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

	int iLevel = 0;
	int iLevelV = 0;
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) > 0)
	{	iLevelV = GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC) > 0)
	{	iLevelV = GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);	}

	effect eSleep	= EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect eMindS	= EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect eCharm	= EffectImmunity(IMMUNITY_TYPE_CHARM);
	effect eDeath	= EffectImmunity(IMMUNITY_TYPE_DEATH);
	effect eDrain	= EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
//	effect eRott	= EffectVisualEffect("TBD", oPC);
	effect eIcon	= EffectEffectIcon(137);
	effect eOne		= EffectLinkEffects(eSleep, eMindS);
		eOne		= EffectLinkEffects(eOne, eCharm);
		eOne		= EffectLinkEffects(eOne, eDeath);
		eOne		= EffectLinkEffects(eOne, eDrain);
//		eOne		= EffectLinkEffects(eOne, eRott);
		eOne		= EffectLinkEffects(eOne, eIcon);
	effect eOneGo	= SupernaturalEffect(eOne);
		
	effect ePoiso	= EffectImmunity(IMMUNITY_TYPE_POISON);
	effect eDisea	= EffectImmunity(IMMUNITY_TYPE_DISEASE);
	effect eParal	= EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eAblty	= EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
	effect eFive	= EffectLinkEffects(eOne, ePoiso);
		eFive		= EffectLinkEffects(eFive, eDisea);
		eFive		= EffectLinkEffects(eFive, eParal);
		eFive		= EffectLinkEffects(eFive, eAblty);
	effect eFiveGo	= SupernaturalEffect(eFive);
		
	effect eCriti	= EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	effect eSneak	= EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eTen		= EffectLinkEffects(eFive, eCriti);
		eTen		= EffectLinkEffects(eTen, eSneak);
	effect eTenGo	= SupernaturalEffect(eTen);

		if(iLevel >= 10 || iLevelV >= 7){
			eTenGo = SetEffectSpellId(eTenGo, nSpell);
			RemoveEffectsFromSpell(oPC, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTenGo, oPC);	
		} else if(iLevel >= 5 || iLevelV >= 4){
			eFiveGo = SetEffectSpellId(eFiveGo, nSpell);
			RemoveEffectsFromSpell(oPC, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFiveGo, oPC);	
		} else {
			eOneGo = SetEffectSpellId(eOneGo, nSpell);
			RemoveEffectsFromSpell(oPC, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eOneGo, oPC);	
		}
}		

// Determines if character is halfling, gnome, or dwarf.
int GetIsShortRace(object oPC)
{
	object oEssence	= PS_GetEssence(oPC);
	switch(PS_GetLocalInt(oEssence, VAR_OLD_RACE))
	{	case RACIAL_TYPE_DWARF:
		case RACIAL_TYPE_GNOME:
		case RACIAL_TYPE_HALFLING:
			return TRUE; break;
	}
	return FALSE;
}

// Helper function for PS_RottingVisage
// Determines if character is an elf or drow
int GetIsElf(object oPC)
{
	object oEssence	= PS_GetEssence(oPC);
	int nRace		= PS_GetLocalInt(oEssence, VAR_OLD_RACE);
	return nRace == TRUE;
}

// Helper function for PS_RottingVisage
// Appearance Change to Lich model
void PS_RottingVisage(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
	object oItem	= PS_GetEssence(oPC);
	int nTemp		= PS_GetLocalInt(oItem, "TempChange");
	int iForm = 102;
	effect eVis 	= EffectNWN2SpecialEffectFile("fx_shadowjump", oPC);
	effect eScale;
	
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

	if (nTemp == 1)
	{	PS_RestoreOriginalAppearance(oPC);
		RemoveSpellEffects(nSpell, oPC, oPC);
		return;	}
	else
	{	PS_ChangeSelf_AppearanceType(oPC, iForm);
		PS_ChangeSelf_HeadVariation(oPC, 1);
		PS_RefreshAppearance(oPC);
		PS_SetLocalInt(oItem, "TempChange", 1);
		if (GetIsShortRace(oPC))
		{	eScale = EffectSetScale(0.68f, 0.68f, 0.68f);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eScale, oPC, HoursToSeconds(24));	}
		if (GetIsElf(oPC))
		{	eScale = EffectSetScale(0.88f, 0.88f, 0.88f);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eScale, oPC, HoursToSeconds(24));	}
	}
}

// Applies non-stacking natural armor based on level
void PS_NatArmor_Lich(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

	int iLevel = 0;
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}
	
	int iBonus = 0;
// Determine AC bonus granted based on PRC class level
	if (iLevel >= 10) 		//+5 bonus at 10th level
	{	iBonus = 5;		} 
	else if (iLevel >= 7)	//+3 bonus at 7th level
	{	iBonus = 3;		} 
	else if (iLevel >= 4)	//+1 bonus at 4rd level
	{	iBonus = 1;		}
	if (iBonus > 0){	
		effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
		eAC = SupernaturalEffect(eAC);
		eAC = SetEffectSpellId(eAC, nSpell);
		RemoveEffectsFromSpell(oPC, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);		
	}
}

// Damaging and Paralyzing Touch
void PS_LichParalyzingTouch(object oPC, object oTarget, int nSpell)
{
	int iLevel = 0;
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}

	int iPale = 0;
	if (GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0)
	{	iPale = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_PALEMASTER_W, oPC) > 0)
	{	iPale = GetLevelByClass(CLASS_TYPE_PALEMASTER_W, oPC);	}

	int iLevels		= iLevel + iPale;
	SendMessageToPC(oPC, "Total levels: " + IntToString(iLevel));
	int iTouch		= TouchAttackMelee(oTarget, TRUE);

	if (iTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	iLevels = iLevels * 2;	}
	
	int iDam		= d6(1) + iLevels;
	SendMessageToPC(oPC, "Total damage: " + IntToString(iDam));
	int iChaMod		= GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int iSave		= 10 + iLevels + iChaMod;
	int iDur		= d4(1) + iLevel;
	float fDur		= RoundsToSeconds(iDur);
	effect eDam 	= EffectDamage(iLevels, DAMAGE_TYPE_NEGATIVE);
	effect eVisD 	= EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
		eDam		= EffectLinkEffects(eDam, eVisD);
		
	int bSaveEveryRound;
	if (GetIsPC(oTarget))
		bSaveEveryRound = TRUE;
	else
		bSaveEveryRound = FALSE;
		
    effect ePara	= EffectParalyze(iSave, SAVING_THROW_FORT, bSaveEveryRound);
	effect eVisP	= EffectVisualEffect(VFX_DUR_PARALYZED);
    if (iTouch > 0)
    {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iSave, SAVING_THROW_TYPE_NEGATIVE))
        {   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);	}	
		if(!GetIsDead(oTarget))
		{	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iSave, SAVING_THROW_TYPE_NEGATIVE))
			{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, fDur);	}
}	}	}

// Do not use this as a stand-alone command. It is bundled inside PS_LichImmunity.
void ApplyLichImmunities(object oPC, int nImm)
{
	effect eCold 	= EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, nImm);
	effect eElec	= EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, nImm);
	effect eLink	= EffectLinkEffects(eCold, eElec);
	eLink = SupernaturalEffect(eLink);
	int nSpell = GetSpellId();
	eLink = SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Cold and Electrical immunity of " + IntToString(nImm) + "% applied.");
}

// Do not use this as a stand-alone command. It is bundled inside PS_LichImmunity.
void ApplyLichFullImmunities(object oPC, int nImm)
{
	effect eColdF	= EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
	effect eElecF	= EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999, 0);
	effect eLink 	= EffectLinkEffects(eColdF, eElecF);
		eLink = SupernaturalEffect(eLink);
	int nSpell = GetSpellId();
	eLink = SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Cold and Electrical immunity of " + IntToString(nImm) + "% applied.");
}

// Applies immunities based on class level
void PS_LichImmunity(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iLevel = 0;
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}
	
	int nImm;
	if (GetHasSpellEffect(nSpell,oPC))	
	{	RemoveSpellEffects(nSpell, oPC, oPC);	}
	
	if (iLevel >= 10)
	{	nImm = 100;	
		if (!GetHasSpellEffect(nSpell, oPC))
		{	ApplyLichFullImmunities(oPC, nImm);	}	}
	else 
	{	if (iLevel >= 8)
		{  	nImm = 75;	}
		else if (iLevel >= 5)
		{	nImm = 50;	}
		else
		{	nImm = 25;	}	}
		
		if (!GetHasSpellEffect(nSpell, oPC))
		{	ApplyLichImmunities(oPC, nImm);	}
}

// Applies damage reduction based on class level
void PS_LichDR(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {    return;    }
    
    int iLevel = 0;
    if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
    {    iLevel = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);    }

    int iDR;
    
    if (iLevel >= 10) iDR = 10;   
    else if (iLevel >= 7) iDR = 7;    
    else iDR = 3;
            
    effect eGood    = EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_GOOD);
	
	eGood = SupernaturalEffect(eGood);
	eGood = SetEffectSpellId(eGood, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGood, oPC);
	if (PS_GetLocalInt(oPC, "drGood") != iDR){
		SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/good applied.");
		PS_SetLocalInt(oPC, "drGood", iDR);
	}
        
}

// Are you scared yet? You will be after the Lich unleashes his Fear Aura!
void PS_LichFearAura(object oPC, int nSpell)
{
	int iLevel = 0;
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0)
	{	iLevel = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}

	int iCLev = GetTotalLevels(oPC, FALSE);
	
    effect eFear	= EffectFrightened();
    effect eDur		= EffectVisualEffect( VFX_DUR_SPELL_CAUSE_FEAR );
    effect eLink	= EffectLinkEffects(eFear, eDur);
	effect ePulse	= EffectNWN2SpecialEffectFile("fx_shockwave", oPC);
    float fDelay;
	int nDC 		= 10 + (iCLev / 2) + GetAbilityModifier(ABILITY_CHARISMA);

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, ePulse, oPC);
    while(GetIsObjectValid(oTarget))
    {  	if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
    	{	fDelay = GetDistanceToObject(oTarget)/10;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_AURA_FEAR));
            if (GetHitDice(oTarget) <= 100)
			{	if(!MyResistSpell(oPC, oTarget, fDelay))
            	{	//Make a saving throw check
	            	if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
	            	{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iLevel)));	}
		}	}	}
	//Get next target in spell area
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));	}
}

void PS_DKAbyssalBlast(object oPC, int iLevel, int nSpell)
{
    if (!X2PreSpellCastCode())
    {    return;	}
    int nDamage, nFDam, nDDam;
    float fDelay;
    effect eVisF			= EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	effect eVisE 			= EffectVisualEffect(VFX_HIT_SPELL_EVIL);
    effect eFDam, eDDam;
	int nDC 				= (10 + iLevel + GetAbilityModifier(ABILITY_CHARISMA));
    location lTarget 		= GetLocation(oPC);
    object oTarget 			= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oPC) //Additional target check to make sure that the caster cannot be harmed by this spell
        {	fDelay 			= GetDistanceToObject(oTarget)/10;
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {	nDamage 	= (d6(iLevel));
				nFDam 	= GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
				nDDam 	= GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_DIVINE);
				if (nFDam > 0)
                {	eFDam 	= EffectDamage(nFDam, DAMAGE_TYPE_FIRE);
					eFDam	= EffectLinkEffects(eFDam, eVisF);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFDam, oTarget));	}
				if (nDDam > 0)
				{	eDDam	= EffectDamage(nDDam, DAMAGE_TYPE_DIVINE);
					eDDam	= EffectLinkEffects(eDDam, eVisE);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDDam, oTarget));	}
       	}	}
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void PS_DKImmunity(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iLevel = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);
	int nImm;
	
	if (GetHasSpellEffect(nSpell,oPC))	
	{	RemoveSpellEffects(nSpell, oPC, oPC);	}
	
	if (iLevel >= 10)
	{	nImm = 100;	
		if (!GetHasSpellEffect(nSpell, oPC))
		{	ApplyLichFullImmunities(oPC, nImm);	}	}
	else 
	{	if (iLevel >= 8)
		{  	nImm = 75;	}
		else if (iLevel >= 5)
		{	nImm = 50;	}
		else
		{	nImm = 25;	}	}
		
		if (!GetHasSpellEffect(nSpell, oPC))
		{	ApplyLichImmunities(oPC, nImm);	}
}

void PS_DKNegativeWeapon(object oPC, int nSpell)
{	
	int iLevel		= GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);
	int iSaveDC		= IP_CONST_ONHIT_SAVEDC_22;
	if (iLevel == 10)
	{	iSaveDC		= IP_CONST_ONHIT_SAVEDC_26;	}
	float fDuration = RoundsToSeconds(600 + iLevel);
	if (GetHasSpellEffect(nSpell,oPC))	
	{	RemoveSpellEffects(nSpell, oPC, oPC);
		return;	}
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (GetIsObjectValid(oWeapon))
    {	SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(oPC, GetSpellId(), FALSE));
		effect eCast = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);	
			itemproperty ipEff1 = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d8);
			itemproperty ipEff2 = ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN, iSaveDC, IP_CONST_ABILITY_CON);
			itemproperty ipGlow = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);
			itemproperty ipClas = ItemPropertyLimitUseByClass(CLASS_TYPE_DEATH_KNIGHT_PRC);
				IPSafeAddItemProperty(oWeapon, ipEff1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
				IPSafeAddItemProperty(oWeapon, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
				IPSafeAddItemProperty(oWeapon, ipClas, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);	
			if (iLevel >= 8)
			{	IPSafeAddItemProperty(oWeapon, ipEff2, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);	}
}	}

void PS_DKDamageReduction(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {    return;    }
    
    int iLevel = 0;
    if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) > 0)
    {    iLevel = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);    }

    int iDR;
    
    if (iLevel >= 10) iDR = 10;
    else if (iLevel >= 7) iDR = 7;
    else iDR = 3;
            
    effect eGood    = EffectDamageReduction(iDR, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_GOOD);
	// Dae: This block is weird, was there supposed to be a conditional here?
	eGood = SupernaturalEffect(eGood);
	eGood = SetEffectSpellId(eGood, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGood, oPC);
	if (PS_GetLocalInt(oPC, "drGood") != iDR){
		SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/good applied.");
		PS_SetLocalInt(oPC, "drGood", iDR);
	}	
}

void PS_DKSymbolOfPain(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	effect eSymbol	= EffectNWN2SpecialEffectFile("fx_map_spawn_hostile", oPC);
	effect eAttPen	= EffectAttackDecrease(4);
	effect eSklPen	= EffectSkillDecrease(4, SKILL_ALL_SKILLS);
	effect eSavPen	= EffectSavingThrowDecrease(SAVING_THROW_ALL, 4);
	effect eDur		= EffectVisualEffect(VFX_DUR_SPELL_DOOM);
	effect eLink	= EffectLinkEffects(eAttPen, eSklPen);
		eLink 		= EffectLinkEffects(eLink, eSavPen);
		eLink		= EffectLinkEffects(eLink, eDur);
	float fDelay;
	int nDC			= 10 + (GetTotalLevels(oPC, FALSE)/2) + GetAbilityModifier(ABILITY_CHARISMA);
	object oTarget	= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eSymbol, oPC);
	while(GetIsObjectValid(oTarget))
	{	if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
		{	fDelay = GetDistanceToObject(oTarget)/10;
			SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
			if(!MyResistSpell(oPC, oTarget, fDelay))
			{	if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
				{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,HoursToSeconds(1)));
		}	}	} 
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation (oPC));	}
}

void PS_DKFearAura(object oPC, int nSpell)
{
	int iLevel = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);
	int iCLev = GetTotalLevels(oPC, FALSE);
	
    effect eFear	= EffectFrightened();
    effect eDur		= EffectVisualEffect( VFX_DUR_SPELL_CAUSE_FEAR );
    effect eLink	= EffectLinkEffects(eFear, eDur);
	effect ePulse	= EffectNWN2SpecialEffectFile("fx_shockwave", oPC);
    float fDelay;
	int nDC 		= 10 + (iCLev / 2) + GetAbilityModifier(ABILITY_CHARISMA);

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, ePulse, oPC);
    while(GetIsObjectValid(oTarget))
    {  	if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
    	{	fDelay = GetDistanceToObject(oTarget)/10;
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_AURA_FEAR));
            if (GetHitDice(oTarget) <= 100)
			{	if(!MyResistSpell(oPC, oTarget, fDelay))
            	{	//Make a saving throw check
	            	if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
	            	{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iLevel)));	}
		}	}	}
	//Get next target in spell area
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));	}
}

void PS_VampArmor(object oPC)
{
//Determine class level of prestige classes which use this feat	
	int iPRCLvl_Lup		= GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
	int iPRCLvl_Dra		= GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);
	int iPRCLvl_Mal		= GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);
	int iPRCLvl_other	= iPRCLvl_Lup + iPRCLvl_Dra;
	int iBonus;

//Determine AC bonus granted based on PRC class level
	if (iPRCLvl_Mal > 0)
	{	iBonus = iPRCLvl_Mal / 2;}
	else if (iPRCLvl_other >= 3)
	{	iBonus = iPRCLvl_other - 2;	}
	else
	{	iBonus = 0;		}
	
	//Calculate and apply AC bonus
	effect eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
	eAC = SupernaturalEffect(eAC);
	int nSpell = GetSpellId();
	eAC = SetEffectSpellId(eAC, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
}

void PS_VampSlam(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	} 
	
	if (!PS_GetTargetInRange(oPC, oTarget, GetSpellFeatId(), FALSE))
		return;
		
	int iPRCLvl	= GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
	iPRCLvl += GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);
	iPRCLvl += GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);
	iPRCLvl += GetLevelByClass(CLASS_TYPE_HALF_UNDEAD, oPC);
	int nDamage;
	if (GetCreatureSize(oPC) == CREATURE_SIZE_LARGE)
	{	nDamage = d8(1);	}
	else if (GetCreatureSize(oPC) == CREATURE_SIZE_SMALL)
	{	nDamage = d4(1);	}
	else
	{	nDamage = d6(1);	}
		nDamage = nDamage + (iPRCLvl * 2);
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC) >= 7) nDamage += d6(1);
	int nTouch      = TouchAttackMelee(oTarget, GetSpellCastItem() == OBJECT_INVALID);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nDamage = nDamage * 2;	}

	int iDrain = d2(1);
    effect eDrain	= EffectNegativeLevel(iDrain);
	int iHeal = iDrain * 5;
	effect eHeal 	= EffectTemporaryHitpoints(iHeal);
	effect eVisHeal = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
	int nRace = GetRacialType(oTarget);
	int bImmuneNeg = (nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_INCORPOREAL ||
		nRace == RACIAL_TYPE_INVALID || GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget));
	int bImmuneBlood = (bImmuneNeg || nRace == RACIAL_TYPE_OOZE || nRace == RACIAL_TYPE_CONSTRUCT ||
		nRace == RACIAL_TYPE_ELEMENTAL);
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))	
        {	if (nTouch > 0)
            {	nDamage += PS_AddSneakDmgToSpell(oPC, oTarget, DAMAGE_TYPE_NEGATIVE);
    			effect eDamage	= EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    			effect eVis;
				if (!bImmuneNeg){
					eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
					eDamage = EffectLinkEffects(eDamage, eDrain);
				} else {
					eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
				}
				eDamage	= EffectLinkEffects(eDamage, eVis);
				 
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				if (!bImmuneBlood){
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oPC);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, oPC, RoundsToSeconds(180));	}
			}
}	}	}

void PS_VampDrainBlood(object oPC, object oTarget, int nSpell) {

	int nRace = GetRacialType(oTarget);
	if (nRace == RACIAL_TYPE_CONSTRUCT || nRace == RACIAL_TYPE_ELEMENTAL || 
		nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_OOZE ||
		nRace == RACIAL_TYPE_INCORPOREAL || nRace == RACIAL_TYPE_INVALID ||
		GetObjectType(oTarget) != OBJECT_TYPE_CREATURE){
		SendMessageToPC(oPC, "Don't bite "+GetName(oTarget)+"s. They don't taste good.");
		return;
	}
	
	if (GetCurrentHitPoints(oPC) >= (2 * GetMaxHitPoints(oPC))){
		SendMessageToPC(oPC, "You're really quite full and couldn't drink another drop.");
		return;
	}

	int nTouch			= TouchAttackMelee(oTarget);
	int iPRCLvl_Lup		= GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
	int iPRCLvl_Dra		= GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);
	int iPRCLvl_Mal		= GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);
	int iLevel			= iPRCLvl_Mal;
	int iLevelV			= iPRCLvl_Lup + iPRCLvl_Dra + iPRCLvl_Mal;
	int iVBAB			= GetBaseAttackBonus(oPC) + GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int iTBAB			= GetBaseAttackBonus(oTarget);
	int bTargetHelpless = FALSE;
	
	iTBAB = iTBAB + (4 * GetCreatureSize(oTarget) - 4 * GetCreatureSize(oPC));
	
	int iTSMd	= GetAbilityModifier(ABILITY_STRENGTH, oTarget);
		iTBAB = iTBAB + iTSMd;
	string sGend;
	if (GetGender(oPC) == GENDER_FEMALE)
	{	sGend = "her";	}
	else {	sGend = "his";	}
	int nDrain = 1;
	if (iLevel >= 10 || iLevelV >= 7)
	{	nDrain = 2;	} 

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) ||
		(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) && !GetHasEffect(EFFECT_TYPE_DOMINATED, oTarget) == TRUE))
    {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
		if (GetHasEffect(EFFECT_TYPE_STUNNED, oTarget) || GetHasEffect(EFFECT_TYPE_PARALYZE, oTarget) ||
			GetHasEffect(EFFECT_TYPE_SLEEP, oTarget) || GetHasEffect(EFFECT_TYPE_DOMINATED, oTarget))
		{
			nDrain += 3;	
			bTargetHelpless = TRUE;
			}
		if (nTouch != TOUCH_ATTACK_RESULT_MISS || bTargetHelpless)
		{	int iCaster = d20(1) + iVBAB;
			int iTarget = d20(1) + iTBAB;
			if (iCaster > iTarget || bTargetHelpless)
				{	effect eFreeze	= EffectCutsceneImmobilize();
	   	 			effect eDrain	= EffectAbilityDecrease(ABILITY_CONSTITUTION, nDrain);
					effect eVis		= EffectVisualEffect(VFX_INVOCATION_UTTERDARK_HIT);
					effect eLink	= EffectLinkEffects(eFreeze, eVis);
					int iHeal		= nDrain  * 5;
	
					effect eDam = EffectDamage(iHeal, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);
					
					// now get the amount of hp gained based on how much got past target resistance
					int nHpBefore = GetCurrentHitPoints(oTarget);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					int nHpAfter = 0;
					if (oTarget != OBJECT_INVALID) nHpAfter = GetCurrentHitPoints(oTarget);
					iHeal = nHpBefore - nHpAfter;
					if (iHeal <= 0) iHeal = 1;
					
					effect eHeal	= EffectTemporaryHitpoints(iHeal);
						eHeal		= SupernaturalEffect(eHeal);
						
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(24));
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHeal, oPC, RoundsToSeconds(180));
					SpeakString(GetFirstName(oPC) + "'s fangs pierce their victim's throat, draining " + sGend + " blood!");	}
	}	}
}

void PS_VampAltForm_Bat(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_VAMPIRE_BAT);
	effect eSpeed = EffectMovementSpeedIncrease(50);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = EffectLinkEffects(ePoly, eSpeed);
		ePoly = SupernaturalEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_VAMPIRE_BAT);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_VampAltForm_Wolf(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_VAMPIRE_WOLF);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = SupernaturalEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_VAMPIRE_WOLF);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_VampAltForm_Gas(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_VAMPIRE_GASEOUS);
	effect eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE, 0, DR_TYPE_MAGICBONUS);
	effect eConceal = EffectConcealment(50);
	effect eMiss = EffectAttackDecrease(5);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = EffectLinkEffects(ePoly, eDR);
		ePoly = EffectLinkEffects(ePoly, eConceal);
		ePoly = EffectLinkEffects(ePoly, eMiss);
		ePoly = SupernaturalEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_VAMPIRE_GASEOUS);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_VampAltForm_DireWolf(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_VAMPIRE_DIREWOLF);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = SupernaturalEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_VAMPIRE_DIREWOLF);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_VampResistance(object oPC, int nSpell)
{
	int iPRCLvl_Lup		= GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
	int iPRCLvl_Dra		= GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);
	int iPRCLvl_Mal		= GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);
	int iPRCLvl			= iPRCLvl_Mal;
	int iPRCLvlV		= iPRCLvl_Lup + iPRCLvl_Dra;
	int iBonus;
	if (iPRCLvl >= 8 || iPRCLvlV >= 6) 	
	{	iBonus = 10;		} 
	else if (iPRCLvl >= 2 || iPRCLvlV >= 2)	
	{	iBonus = 5;		} 
	else					//no bonus
	{	iBonus = 0;		}

	effect eColdRes = EffectDamageResistance(DAMAGE_TYPE_COLD, iBonus);
	effect eElecRes = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, iBonus);
	effect eLink	= EffectLinkEffects(eColdRes, eElecRes);
	eLink		= SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);	
}

void PS_VampFastHealing(object oPC, int nSpell)
{
	int iPRCLvl_Dra		= GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);
	int iPRCLvl_Lup		= GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
	int iPRCLvl_Mal		= GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);
	int iPRCLvl_other	= iPRCLvl_Lup + iPRCLvl_Dra;
	int iBonus;

	
	if (iPRCLvl_Mal >= 10 || iPRCLvl_other >= 7)
	{	iBonus = 3;		}
	else if (iPRCLvl_Mal >= 7 || iPRCLvl_other >= 5)
	{	iBonus = 2;		}
	else if (iPRCLvl_Mal >= 4 || iPRCLvl_other >= 3)
	{	iBonus = 1;		}
	else
	{	iBonus = 0;		}
	if (iBonus > 0){	
		effect eRegen	= EffectRegenerate(iBonus, 6.0f);
		eRegen		= SupernaturalEffect(eRegen);
		eRegen = SetEffectSpellId(eRegen, nSpell);
		RemoveEffectsFromSpell(oPC, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPC);	
	}
}

void PS_VampDR(object oPC, int nSpell)
{
	int iPRCLvl_Lup		= GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
	int iPRCLvl_Dra		= GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);
	int iPRCLvl_Mal		= GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);
	int iPRCLvl			= iPRCLvl_Mal;
	int iPRCLvlV		= iPRCLvl_Lup + iPRCLvl_Dra;
	int iBonus;
	if (iPRCLvl >= 10 || iPRCLvlV >= 7)
	{	iBonus = 10;	}
	else if (iPRCLvl >= 4 || iPRCLvlV >= 4)
	{	iBonus = 5;		}
	else
	{	iBonus = 0;		}
    if (iBonus > 0){	
		effect eDR		= EffectDamageReduction(iBonus, GMATERIAL_METAL_ALCHEMICAL_SILVER, 0, DR_TYPE_GMATERIAL);
		effect eCold	= EffectDamageResistance(DAMAGE_TYPE_COLD, iBonus);
		effect eElec	= EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, iBonus);
		effect eLink	= EffectLinkEffects(eDR, eCold);
			eLink		= EffectLinkEffects(eLink, eElec);
			eLink		= SupernaturalEffect(eLink);

		eLink = SetEffectSpellId(eLink, nSpell);
		RemoveEffectsFromSpell(oPC, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		if (PS_GetLocalInt(oPC, "vampDr") != iBonus){
			SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iBonus) + "/alchemical silver and resistance of " + IntToString(iBonus) + " to cold and electricity applied.");
			PS_SetLocalInt(oPC, "vampDr", iBonus);
		}
	}
}

void PS_VampDominatingGaze(object oPC, int nSpell, object oTarget)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC)){
		SendMessageToPC(oPC, "Target is immune to mind spells.");
		return;
	}
    effect eDom 		= EffectDominated();
    	eDom = GetScaledEffect(eDom, oTarget);
    effect eVis 		= EffectVisualEffect(VFX_DUR_SPELL_DOM_PERSON);
	effect eLink 		= EffectLinkEffects(eDom, eVis);
	effect eEyes		= EffectNWN2SpecialEffectFile("fx_vampire_gaze", oPC);
	int iPRCLvl_Lup		= GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
	int iPRCLvl_Dra		= GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);
	int iPRCLvl_Mal		= GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);
	int nCasterLevel	= (iPRCLvl_Lup + iPRCLvl_Dra + iPRCLvl_Mal) * 2;
	int nCharLevel		= GetHitDice(oPC);
    int nDuration 		= nCasterLevel;
	int iChaBonus		= GetAbilityModifier(ABILITY_CHARISMA, oPC);
	if (iPRCLvl_Mal > 0) iChaBonus += d6(1);
	int nDC 			= 10 + (nCharLevel / 2) + iChaBonus;
    nDuration = GetScaledDuration(nDuration, oTarget);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEyes, oPC, 3.0f);
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)){
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC))
			SendMessageToPC(oPC, "Target Immune");
		else if (!MyResistSpell(OBJECT_SELF, oTarget)){
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0)){
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCasterLevel * 3));
			}
		}	
	} else if (GetIsPC(oTarget)){
		string sCasterMessage = "<c=red>" + GetFirstName(oTarget);
		string sTargetMessage = "<c=red>" + GetFirstName(oPC);
		int bImmune = FALSE;
		int bResist = FALSE;
		int bSave = FALSE;
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC)){
			sCasterMessage += " is immune to mind spells!";
			sTargetMessage += " tried to dominate you but you're immune.";
		} else if (MyResistSpell(oPC, oTarget) > 0 || 
				MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC, 1.0) > 0){
			sCasterMessage += " has resisted your domination effect!";
			sTargetMessage += " tried to use a charm effect upon you but you resisted.";
		} else {
			sCasterMessage += " has succumbed to your dominating gaze!";
			sTargetMessage += " has dominated you!";
		}
		SendMessageToPC(oPC, sCasterMessage + "</c>");
		SendMessageToPC(oTarget, sTargetMessage + "</c>");
	}
}

void PS_Vamp_AltForm_Wyvern(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_VAMPIRE_WYVERN);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = SupernaturalEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_VAMPIRE_WYVERN);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_Vamp_AltForm_TerrorWolf(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    effect ePoly = EffectPolymorph(POLYMORPH_VAMPIRE_TWOLF);
		ePoly = EffectLinkEffects(ePoly, eVis);
		ePoly = SupernaturalEffect(ePoly);
	string sVFX = Get2DAString("polymorph", "VFX", POLYMORPH_VAMPIRE_TWOLF);
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oPC);	
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(24));
	if (sVFX != "")
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, HoursToSeconds(24));	}
}

void PS_Vamp_BloodFrenzy(object oPC, int iLevel, int nSpell)	
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
	int nDur		= iLevel * 5;
	
	effect eStr		= EffectAbilityIncrease(ABILITY_STRENGTH, 6);
	effect eWis		= EffectAbilityDecrease(ABILITY_WISDOM, 2);
	effect eAC		= EffectACDecrease(4);
	effect eFast	= EffectHaste();
	effect eVFX		= EffectNWN2SpecialEffectFile("ajoc_20_fx_lorne_frenzy", oPC);
	effect eLink	= EffectLinkEffects(eStr, eWis);
		eLink		= EffectLinkEffects(eLink, eAC);
		eLink		= EffectLinkEffects(eLink, eFast);
		eLink		= EffectLinkEffects(eLink, eVFX);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDur));
}

void PS_VampMal_BonusFeat(object oPC, object oItem, int nSpell)
{

	int iHasBonus = PS_GetLocalInt(oItem, "VML5");

	if (iHasBonus != 0)
	{
		return;
	}
	else
	{	// Clangeddin UI script.
		AddScriptParameterString("START");
		AddScriptParameterString("");
		ExecuteScriptEnhanced("gui_extra_choices", oPC);
	}

	PS_SetLocalInt(oItem, "VML5", 1);
}