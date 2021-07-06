#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"

/*	This is the include file for all immunities given as part of a Racial PrC.
	Every individual racial spell in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_racial_armor, which acts as the universal spell with a case-based system.
*/

/*	********************************************************************************
	********************************************************************************
	********		Immunity Applications - Do not run these alone!			********
	********************************************************************************
	********************************************************************************	*/
	
/*void ApplyFireGiantImmunities(object oPC, int nImm)
{
	effect eImm = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, nImm);
	effect eLink = ExtraordinaryEffect(eImm);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Fire immunity of " + IntToString(nImm) + "% applied.");
}

void ApplyFireGiantPRCImmunities(object oPC, int nImm, int nVul)
{
	effect eImm = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999, 0);
	effect eVul = EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, nVul);
	effect eLink = EffectLinkEffects(eImm, eVul);
	eLink = ExtraordinaryEffect(eLink);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Fire immunity of " + IntToString(nImm) + "% applied.");
	SendMessageToPC(oPC, "Cold vulnerability of " + IntToString(nVul) + "% applied.");
}

void ApplyFrostGiantImmunities(object oPC, int nImm)
{
	effect eImm = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, nImm);
	effect eLink = ExtraordinaryEffect(eImm);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Cold immunity of " + IntToString(nImm) + "% applied.");
}

void ApplyFrostGiantPRCImmunities(object oPC, int nImm, int nVul)
{
	effect eImm = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
	effect eVul = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, nVul);
	effect eLink = EffectLinkEffects(eImm, eVul);
		eLink = ExtraordinaryEffect(eLink);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Cold immunity of " + IntToString(nImm) + "% applied.");
	SendMessageToPC(oPC, "Fire vulnerability of " + IntToString(nVul) + "% applied.");
}*/

void ApplyCoreDevaImmunities(object oPC, int iImmCore, int nSpell)
{
	effect ePar1 = EffectSpellImmunity(SPELL_STONE_TO_FLESH);
	effect ePar2 = EffectSpellImmunity(SPELL_POWORD_PETRIFY);
	effect ePar3 = EffectSpellImmunity(SPELLABILITY_BREATH_PETRIFY);
	effect ePar4 = EffectSpellImmunity(SPELLABILITY_GAZE_PETRIFY);
	effect ePar5 = EffectSpellImmunity(SPELLABILITY_TOUCH_PETRIFY);
	effect ePar6 = EffectSpellImmunity(EFFECT_TYPE_PETRIFY);
	effect eAcid = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, iImmCore);
	effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, iImmCore);
	if (iImmCore == 100)
	{
		eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, 9999);
		eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999);
	}
	effect eCore = EffectLinkEffects(ePar1, ePar2);
	eCore = EffectLinkEffects(eCore, ePar3);
	eCore = EffectLinkEffects(eCore, ePar4);
	eCore = EffectLinkEffects(eCore, ePar5);
	eCore = EffectLinkEffects(eCore,ePar6);
	eCore = EffectLinkEffects(eCore, eAcid);
	eCore = EffectLinkEffects(eCore, eCold);
	eCore = ExtraordinaryEffect(eCore);
	eCore = SetEffectSpellId(eCore, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCore, oPC);
	SendMessageToPC(oPC, "Immunity to petrification and " + IntToString(iImmCore) + "% core immunities applied.");
}

void ApplyMonadicImmunities(object oPC, int iImmFire, int nSpell)
{
	if (GetLevelByClass(88, oPC) >= 3)
	{
		effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, iImmFire);
		if (iImmFire == 100) eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999);
		eFire = ExtraordinaryEffect(eFire);
		eFire = SetEffectSpellId(eFire, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFire, oPC);
		SendMessageToPC(oPC, "Monadic Deva - " + IntToString(iImmFire) + "% fire immunity applied");
	}
}

void ApplyMovanicImmunities(object oPC, int iImmPoNe, int nSpell)
{
	if (GetLevelByClass(89, oPC) >= 3)
	{
		effect ePos = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, iImmPoNe);
		effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, iImmPoNe);
		if (iImmPoNe == 100)
		{
			ePos = EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 9999);
			eNeg = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 9999);
		}
		effect ePoNe = EffectLinkEffects(ePos, eNeg);
		ePoNe = ExtraordinaryEffect(ePoNe);
		ePoNe = SetEffectSpellId(ePoNe, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoNe, oPC);
		SendMessageToPC(oPC, "Movanic Deva - " + IntToString(iImmPoNe) + "% positive/negative immunity applied");
	}
}

/*	********************************************************************************
	********************************************************************************
	********		Immunity Scripts - Called by aaa_racial_immune			********
	********************************************************************************
	********************************************************************************	*/

void PS_Immunity_Giant(object oPC, int nSpell)
{
	int iSubrace = GetSubRace(oPC);
	int nELEMENT;
	string sTXT;
	if (iSubrace == RACIAL_SUBTYPE_FIRE_GIANT)
	{
		nELEMENT = DAMAGE_TYPE_FIRE;
		sTXT = "Fire Giant - 50% Fire Immunity applied.";
	}
	else if (iSubrace == RACIAL_SUBTYPE_FROST_GIANT)
	{
		nELEMENT = DAMAGE_TYPE_COLD;
		sTXT = "Frost Giant - 50% Cold Immunity applied.";
	}
		if (iSubrace == RACIAL_SUBTYPE_FIRE_GIANT_NEW)
	{
		nELEMENT = DAMAGE_TYPE_FIRE;
		sTXT = "Fire Giant - 50% Fire Immunity applied.";
	}
	else if (iSubrace == RACIAL_SUBTYPE_FROST_GIANT_NEW	)
	{
		nELEMENT = DAMAGE_TYPE_COLD;
		sTXT = "Frost Giant - 50% Cold Immunity applied.";
	}
	
	effect eFX = EffectDamageImmunityIncrease(nELEMENT, 50);
	//Determine class level of prestige classes which use this feat
	if (GetLevelByClass(CLASS_TYPE_FIRE_GIANT_PRC, oPC) >= 4)
	{
		eFX = EffectDamageResistance(nELEMENT, 9999,0);
		eFX = EffectLinkEffects(eFX, EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 50));
		sTXT = "Fire Giant - 100% Fire Immunity and 50% Cold Vulnerability applied.";
	}
	else if (GetLevelByClass(CLASS_TYPE_FROST_GIANT_PRC, oPC) >= 4)
	{
		eFX = EffectDamageResistance(nELEMENT, 9999,0);
		eFX = EffectLinkEffects(eFX, EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50));
		sTXT = "Frost Giant - 100% Cold Immunity and 50% Fire Vulnerability applied.";
	}
	eFX = ExtraordinaryEffect(eFX);
	eFX = SetEffectSpellId(eFX, nSpell);
	//Now we finally apply all the appropriate bonuses
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
	SendMessageToPC(oPC, sTXT);
}

void PS_Immunity_Rakshasa(object oPC, int nSpell)
{
	//Rakshasa piercing vulnerability, DR/Good.
	effect eDR = EffectDamageImmunityDecrease(DAMAGE_TYPE_PIERCING, 25);
	effect eDR2 = EffectDamageReduction(10, ALIGNMENT_GOOD, 0, DR_TYPE_ALIGNMENT);
	effect eLink = EffectLinkEffects(eDR, eDR2);
	
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void PS_Immunity_Khayal(object oPC, int nSpell)
{
	//Cold Immunity
	effect eImm = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
	
	effect eLink = SupernaturalEffect(eImm);
	eLink = SetEffectSpellId(eLink, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void PS_Immunity_Deva(object oPC, int nSpell)
{
	int iImmCore = 25;
	int iImmFire;
	int iImmPoNe;
	int iPRCLvl;
	//Let's calculate how many racial prestige class levels the character has.
	if (GetLevelByClass(CLASS_TYPE_MONADIC_DEVA_PRC, oPC) > 0)
	{
		iPRCLvl = GetLevelByClass(CLASS_TYPE_MONADIC_DEVA_PRC, oPC);
		//Monadic
	}
	else if (GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC, oPC) > 0)
	{
		iPRCLvl = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC, oPC); 
		//Movanic
	}
	else iPRCLvl = GetLevelByClass(CLASS_TYPE_ASTRAL_DEVA_PRC, oPC); //Astral
	//Calculate the bonus percentages...
	if (iPRCLvl >= 10)
	{	
		iImmCore = 100;
		iImmFire = 100;
		iImmPoNe = 100;
	}
	else if (iPRCLvl >= 6)
	{	
		iImmCore = 75;
		iImmFire = 60;
		iImmPoNe = 60;
	}
	else if (iPRCLvl >= 3)
	{	
		iImmCore = 50;
		iImmFire = 30;
		iImmPoNe = 30;
	}
	//Now we finally apply all the appropriate bonuses
    ApplyCoreDevaImmunities(oPC, iImmCore, nSpell);
	ApplyMonadicImmunities(oPC, iImmFire, nSpell);
	ApplyMovanicImmunities(oPC, iImmPoNe, nSpell);
}

void PS_Immunity_Baatezu(object oPC, int nSpell)
{
	int iImmFire = 25;
	int iPRCLvl;
	//Let's calculate how many racial prestige class levels the character has.
	if (GetLevelByClass(CLASS_TYPE_BRACHINA, oPC) > 0) 			//Brachina
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_BRACHINA, oPC);
		if (iPRCLvl >= 10) iImmFire = 100;
		else if (iPRCLvl >= 6) iImmFire = 75;
		else if (iPRCLvl >= 3) iImmFire = 50;
	}
	else if (GetLevelByClass(CLASS_TYPE_ERINYES, oPC) > 0) 		//Erinyes
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_ERINYES, oPC);	
		if (iPRCLvl >= 5) iImmFire = 100;
		else if (iPRCLvl >= 2) iImmFire = 50;
	}
	//Calculate the bonus percentages...
	effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, iImmFire);
	if (iImmFire == 100) eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999);
	effect ePois = EffectImmunity(IMMUNITY_TYPE_POISON);
	effect eLink = EffectLinkEffects(eFire, ePois);
	eLink = ExtraordinaryEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	//Now we finally apply all the appropriate bonuses
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Baatezu - " + IntToString(iImmFire) + "% fire immunity and poison immunity applied");
}

void PS_Immunity_Tanarri(object oPC, int nSpell)
{
	int iImmElec = 25;
	int iPRCLvl;
	//Let's calculate how many racial prestige class levels the character has.
	if (GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC) > 0) 			//Succubus|Incubus
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC);
		if (iPRCLvl >= 10) iImmElec = 100;
		else if (iPRCLvl >= 6) iImmElec = 75;
		else if (iPRCLvl >= 3) iImmElec = 50;
	}
	else if (GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION, oPC) > 0) 		//Marquis Cambion
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION, oPC);	
		if (iPRCLvl >= 5) iImmElec = 100;
		else if (iPRCLvl >= 2) iImmElec = 50;
	}
	else if (GetLevelByClass(CLASS_TYPE_HEZROU, oPC) > 0) 				//Hezrou
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_HEZROU, oPC);
		if (iPRCLvl >= 10) iImmElec = 100;
		else if (iPRCLvl >= 6) iImmElec = 75;
		else if (iPRCLvl >= 3) iImmElec = 50;
	}
	//Calculate the bonus percentages...
	effect eElec = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, iImmElec);
	if (iImmElec == 100) eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999);
	effect ePois = EffectImmunity(IMMUNITY_TYPE_POISON);
	effect eLink = EffectLinkEffects(eElec, ePois);
	eLink = ExtraordinaryEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	//Now we finally apply all the appropriate bonuses
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Tanar'ri - " + IntToString(iImmElec) + "% electrical immunity and poison immunity applied");
}

void PS_Immunity_Archon(object oPC, int nSpell)
{
	int iImmElec = 50;
	int iPRCLvl;
	//Let's calculate how many racial prestige class levels the character has.
	if (GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oPC) > 0) 				//Hound Archon Hero
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oPC);
		if (iPRCLvl >= 6) iImmElec = 100;
		else if (iPRCLvl >= 2) iImmElec = 75;
	}
	else if (GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC) > 0)			//Trumpet Archon
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC);
		if (iPRCLvl >= 10) iImmElec = 100;	
		else if (iPRCLvl >= 3) iImmElec = 75;
	}
	else if (GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC) > 0)				//Word Archon
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC);
		if (iPRCLvl >= 8) iImmElec = 100;
		else if (iPRCLvl >= 3) iImmElec = 75;
	}
	//Calculate the bonus percentages...
	effect eElec = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, iImmElec);
	if (iImmElec == 100) eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999);
	effect ePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eLink = EffectLinkEffects(eElec, ePara);
	eLink = ExtraordinaryEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	//Now we finally apply all the appropriate bonuses
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Archon - " + IntToString(iImmElec) + "% electrical immunity and paralysis immunity applied");
}

void PS_Immunity_Eladrin(object oPC, int nSpell)
{
	int iImmElec = 25;
	int iPRCLvl;
	//Let's calculate how many racial prestige class levels the character has.
	if (GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC) > 0) 				//Bralani
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC);
		if (iPRCLvl >= 6) iImmElec = 100;
		else if (iPRCLvl >= 3) iImmElec = 50;
	}
	else if (GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC) > 0)			//Firre
	{	
		iPRCLvl = GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC);
		if (iPRCLvl >= 8) iImmElec = 100;
		else if (iPRCLvl >= 6) iImmElec = 75;
		else if (iPRCLvl >= 3) iImmElec = 50;
	}
	else if (GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC) > 0)			//Ghaele
	{	
		iPRCLvl	= GetLevelByClass(CLASS_TYPE_GHAELE_PRC, oPC);
		if (iPRCLvl >= 10) iImmElec = 100;
		else if (iPRCLvl >= 6) iImmElec = 75;
		else if (iPRCLvl >= 3) iImmElec = 50;
	}
	//Calculate the bonus percentages...
	effect eElec = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, iImmElec);
	if (iImmElec == 100) eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999);
	effect ePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eLink = EffectLinkEffects(eElec, ePara);
	eLink = ExtraordinaryEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	//Now we finally apply all the appropriate bonuses
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Eladrin - " + IntToString(iImmElec) + "% electrical immunity and paralysis immunity applied");
}

void PS_Immunity_NightHag(object oPC, int nSpell)
{
	int nDR = 5;
	if (GetLevelByClass(CLASS_TYPE_MISSCAULDRON, oPC) >= 2)	nDR = 10;
	effect eCharm	= EffectImmunity(IMMUNITY_TYPE_CHARM);
	effect eSleep	= EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect eFear	= EffectImmunity(IMMUNITY_TYPE_FEAR);
	effect eDR		= EffectDamageReduction(nDR, GMATERIAL_METAL_COLD_IRON, 0, DR_TYPE_GMATERIAL);
	effect eLink	= EffectLinkEffects(eCharm, eSleep);
	eLink = EffectLinkEffects(eLink, eFear);
	eLink = EffectLinkEffects(eLink, eDR);
	eLink = ExtraordinaryEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Night Hag - immunity to charm, sleep, fear, and DR " + IntToString(nDR) + "/Cold Iron applied");
}

void PS_Immunity_NightHag_MOTC(object oPC, int nSpell)
{
	int iResist = 25;
	if (GetLevelByClass(CLASS_TYPE_MISSCAULDRON, oPC) >= 8)	iResist	= 100;
	else if (GetLevelByClass(CLASS_TYPE_MISSCAULDRON, oPC) >= 4) iResist = 50;
	effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, iResist);
	effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, iResist);
	if (iResist == 100)
	{
		eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999);
		eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999); 
	}
	effect eLink = EffectLinkEffects(eFire, eCold);
	eLink = ExtraordinaryEffect(eLink);
	eLink = SetEffectSpellId(eLink, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	SendMessageToPC(oPC, "Night Hag - " + IntToString(iResist) + "% resistance to fire and cold applied");
}