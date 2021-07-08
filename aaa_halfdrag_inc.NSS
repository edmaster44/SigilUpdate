#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"
#include "nwn2_inc_spells"
#include "x2_inc_itemprop"


/*	This is the include file for all half-dragon features.
	Every individual feature in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_dragon, which acts as the universal spell with a case-based system.
*/

// >>>>>>>>>>>>>>>>>>>>>>>>>>Constants<<<<<<<<<<<<<<<<<<<<<<<<<<<<
const int FEAT_DRACONIC_HERITAGE							= 2495;
const int DRACONIC_HERITAGE_WHITE							= 2496;
const int DRACONIC_HERITAGE_BLACK							= 2497;
const int DRACONIC_HERITAGE_GREEN							= 2498;
const int DRACONIC_HERITAGE_BLUE							= 2499;
const int DRACONIC_HERITAGE_RED								= 2500;
const int DRACONIC_HERITAGE_BRASS							= 2501;
const int DRACONIC_HERITAGE_COPPER							= 2502;
const int DRACONIC_HERITAGE_BRONZE							= 2503;
const int DRACONIC_HERITAGE_SILVER							= 2504;
const int DRACONIC_HERITAGE_GOLD							= 2505;
const int DRACONIC_HERITAGE_AMETHYST						= 2506;
const int DRACONIC_HERITAGE_CRYSTAL							= 2507;
const int DRACONIC_HERITAGE_EMERALD							= 2508;
const int DRACONIC_HERITAGE_SAPPHIRE						= 2509;
const int DRACONIC_HERITAGE_TOPAZ							= 2510;
const int DRACONIC_HERITAGE_SHADOW							= 2511;
const int DRACONIC_HERITAGE_FANG							= 2512;
const int FEAT_HALFDRAG_INTHEBLOOD							= 2513;
const int FEAT_HALFDRAG_BREATHWEAPON						= 2514;
const int FEAT_HALFDRAG_DRACONIC_APOTHEOSIS					= 2515;
const int FEAT_HALFDRAG_DRACONIC_MAGIC						= 2517;
const int DRACONIC_MAGIC_SEE_INVISIBILITY					= 2516;
const int DRACONIC_MAGIC_FREEZING_FOG						= 2518;
const int DRACONIC_MAGIC_THORN_BODY							= 2519;
const int DRACONIC_MAGIC_RESINOUS_SKIN						= 2520;
const int DRACONIC_MAGIC_SPARKSHIELD						= 2521;
const int DRACONIC_MAGIC_FLAMESHIELD						= 2522;
const int DRACONIC_MAGIC_AVOID_PLANAR_EFFECTS				= 2523;
const int DRACONIC_MAGIC_SCINTILLATING_SCALES				= 2524;
const int DRACONIC_MAGIC_OBSCURING_MIST						= 2525;
const int DRACONIC_MAGIC_CIRCLE_VS_EVIL						= 2526;
const int DRACONIC_MAGIC_BAHAMUTS_PRAYER					= 2527;
const int DRACONIC_MAGIC_ENERGY_ADAPTION					= 2528;
const int DRACONIC_MAGIC_CONCEALING_AMORPHA					= 2529;
const int DRACONIC_MAGIC_INERTIAL_BARRIER					= 2530;
const int DRACONIC_MAGIC_DIMENSION_DOOR						= 2531;
const int DRACONIC_MAGIC_ECTOPLASMIC_FORM					= 2532;
const int DRACONIC_MAGIC_MIRROR_IMAGE						= 2533;
const int DRACONIC_MAGIC_SHIELD_GREATER						= 2534;
const int FEAT_BACKGROUND_DRACONIC_BLOODLINE				= 2535;

void PS_HD_SetAlignmentsByHeritage(object oPC)
{
	int nHeritage;

	if (GetHasFeat(2496, oPC)) nHeritage = 2496;
	else if (GetHasFeat(2497, oPC)) nHeritage = 2497;
	else if (GetHasFeat(2498, oPC)) nHeritage = 2498;
	else if (GetHasFeat(2499, oPC)) nHeritage = 2499; 
	else if (GetHasFeat(2500, oPC)) nHeritage = 2500;
	else if (GetHasFeat(2501, oPC)) nHeritage = 2501;
	else if (GetHasFeat(2502, oPC)) nHeritage = 2502;
	else if (GetHasFeat(2503, oPC)) nHeritage = 2503;
	else if (GetHasFeat(2504, oPC)) nHeritage = 2504;
	else if (GetHasFeat(2505, oPC)) nHeritage = 2505;
	else if (GetHasFeat(2506, oPC)) nHeritage = 2506;
	else if (GetHasFeat(2507, oPC)) nHeritage = 2507;
	else if (GetHasFeat(2508, oPC)) nHeritage = 2508;
	else if (GetHasFeat(2509, oPC)) nHeritage = 2509;
	else if (GetHasFeat(2510, oPC)) nHeritage = 2510;
	else if (GetHasFeat(2511, oPC)) nHeritage = 2511;
	else if (GetHasFeat(2512, oPC)) nHeritage = 2512;
	else return; //Just in case there's no heritage, we avoid setting the local variable on object.

	object oItem = GetItemPossessedBy(oPC, "ps_essence");

	SetLocalInt(oItem, "Draconic_Heritage", nHeritage);
}


void PS_HD_DraconicHeritage(object oPC, int nSpell, object oItem)
{
	int iHeritage = GetLocalInt(oItem, "Draconic_Heritage");
	if (iHeritage != 0)
	{	return;		}
	else
	{	// Clangeddin UI script.
		AddScriptParameterString("START");
		AddScriptParameterString("");
		ExecuteScriptEnhanced("gui_extra_choices", oPC);	}
	
	SetLocalString(oItem, "Template", "HalfDragon");
	PS_HD_SetAlignmentsByHeritage(oPC);
	PS_TintFixer(oPC); //testing to see if this gives properly tinted wings!
}

void PS_HD_InTheBlood(object oPC, object oItem)
{
	int nHeritage = GetLocalInt(oItem, "Draconic_Heritage");
	int iGood_D;
	int iLaw_D;
	int nOldECL = StringToInt(PS_GetEssenceECL(oPC));
	string sInBlood	= GetLocalString(oItem, "InBlood");
	int iNewECL, iDragon;
	string sNewECL;

	switch (nHeritage)
	{
		case 2496: iLaw_D = 0; iGood_D = 0; break;
		case 2497: iLaw_D = 0; iGood_D = 0; break;
		case 2498: iLaw_D = 100; iGood_D = 0; break;
		case 2499: iLaw_D = 100; iGood_D = 0; break;
		case 2500: iLaw_D = 0; iGood_D = 0; break;
		case 2501: iLaw_D = 0; iGood_D = 100; break;
		case 2502: iLaw_D = 0; iGood_D = 100; break;
		case 2503: iLaw_D = 100; iGood_D = 100; break;
		case 2504: iLaw_D = 100; iGood_D = 100; break;
		case 2505: iLaw_D = 100; iGood_D = 100; break;
		case 2506: iLaw_D = 50; iGood_D = 50; break;
		case 2507: iLaw_D = 0; iGood_D = 50; break;
		case 2508: iLaw_D = 100; iGood_D = 50; break;
		case 2509: iLaw_D = 100; iGood_D = 50; break;
		case 2510: iLaw_D = 0; iGood_D = 50; break;
		case 2511: iLaw_D = 50; iGood_D = 0; break;
		case 2512: iLaw_D = 0; iGood_D = 0; break;
		default: return; //Heritage set to wrong feat or we have no heritage
	}

	int iGood  = GetGoodEvilValue(oPC);
	int iLaw  = GetLawChaosValue(oPC);

	if (GetLocalInt(oItem, "HD_Align") == 0)
	{	SetLocalInt(oItem, "OldGoodEvil", iGood);
		SetLocalInt(oItem, "OldLawChaos", iLaw);
		SetLocalInt(oItem, "HD_Align", 1);	}

	// Good-Evil axis check
	int nDiff_Good = iGood_D - iGood;
	if (nDiff_Good > 70) AdjustAlignment(oPC, ALIGNMENT_GOOD, 35);
	else if (nDiff_Good < -70) AdjustAlignment(oPC, ALIGNMENT_EVIL, 35);

	// Law-Chaos axis check
	int nDiff_Law = iLaw_D - iLaw;
	if (nDiff_Law > 70) AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 35);
	else if (nDiff_Law < -70) AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 35);
	
	// ECL calculation and update
	iDragon = (GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC));
	if (iDragon == 6)
	{	//iNewECL = nOldECL +2;
		//sNewECL = IntToString(iNewECL);
		//SetLocalString(oItem, "ECL", sNewECL);
		//SetLocalString(oPC, "ECL", sNewECL);
		SetLocalString(oItem, "InBlood", "HD+2");		}
	
	else if (iDragon != 0)
	{	//iNewECL = nOldECL + 1;
		//sNewECL = IntToString(iNewECL);
		//SetLocalInt(oItem, "OldECL", nOldECL);
		//SetLocalString(oItem, "ECL", sNewECL);
		//SetLocalString(oPC, "ECL", sNewECL);
		SetLocalString(oItem, "InBlood", "HD+1");	}
		
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
		PS_HalfDragonRaceFix(oPC);
		DelayCommand(1.0f, ForceRest(oPC));	}
}

void PS_HD_BreathWeapon(object oPC, object oItem, int nSpell, location lTarget)
{
    int nHeritage;
	int nDamageType, nSave;
	string sBreath, sImpact;
	
	if(GetIsObjectValid(oItem))
	{	nHeritage = GetLocalInt(oItem, "Draconic_Heritage");	}
	else
	{	SendMessageToPC(oPC, "You appear to be missing your Essence. Unable to access Draconic Heritage. Contact a member of staff.");	}

	if (nHeritage < 1)
	{	SendMessageToPC(oPC, "Draconic heritage not found.");
		return;	}

	{    switch (nHeritage)
	    {	case 2496 : //DRACONIC_HERITAGE_WHITE
	        {	nDamageType = DAMAGE_TYPE_COLD;
				nSave       = SAVING_THROW_TYPE_COLD;
				sBreath		= "sp_ice_cone_mouth";
	            sImpact		= "sp_ice_hit";
	            break;	}
			case 2497 : //DRACONIC_HERITAGE_BLACK
			{	nDamageType = DAMAGE_TYPE_ACID;
				nSave		= SAVING_THROW_TYPE_ACID;
				sBreath		= "sp_acid_cone_mouth";
				sImpact		= "sp_acid_hit";
				break;	}
			case 2498 : //DRACONIC_HERITAGE_GREEN
			{	nDamageType = DAMAGE_TYPE_ACID;
				nSave		= SAVING_THROW_TYPE_ACID;
				sBreath		= "sp_acid_cone_mouth";
				sImpact		= "sp_noxious_hit";
				break;	}
			case 2499 : //DRACONIC_HERITAGE_BLUE
			{	nDamageType = DAMAGE_TYPE_ELECTRICAL;
				nSave		= SAVING_THROW_TYPE_ELECTRICITY;
				sBreath		= "sp_magic_cone_mouth";
				sImpact		= "sp_lightning_hit";
				break;	}
			case 2500 : //DRACONIC_HERITAGE_RED
			{	nDamageType = DAMAGE_TYPE_FIRE;
				nSave		= SAVING_THROW_TYPE_FIRE;
				sBreath		= "sp_fire_cone_mouth";
				sImpact		= "sp_fire_hit";
				break;	}
			case 2501 : //DRACONIC_HERITAGE_BRASS
			{	nDamageType = DAMAGE_TYPE_FIRE;
				nSave		= SAVING_THROW_TYPE_FIRE;
				sBreath		= "sp_fire_cone_mouth";
				sImpact		= "sp_fire_hit";
				break;	}
			case 2502 :	//DRACONIC_HERITAGE_COPPER
			{	nDamageType = DAMAGE_TYPE_ACID;
				nSave		= SAVING_THROW_TYPE_ACID;
				sBreath		= "sp_acid_cone_mouth";
				sImpact		= "sp_acid_hit";
				break;	}
			case 2503 : //DRACONIC_HERITAGE_BRONZE
			{	nDamageType = DAMAGE_TYPE_ELECTRICAL;
				nSave		= SAVING_THROW_TYPE_ELECTRICITY;
				sBreath		= "sp_magic_cone_mouth";
				sImpact		= "sp_lightning_hit";
				break;	}
			case 2504 :	//DRACONIC_HERITAGE_SILVER
			{	nDamageType = DAMAGE_TYPE_COLD;
				nSave       = SAVING_THROW_TYPE_COLD;
				sBreath		= "sp_ice_cone_mouth";
	            sImpact		= "sp_hellrime_hit";
	            break;	}
			case 2505 : //DRACONIC_HERITAGE_GOLD
			{	nDamageType = DAMAGE_TYPE_FIRE;
				nSave		= SAVING_THROW_TYPE_FIRE;
				sBreath		= "sp_fire_cone_mouth";
				sImpact		= "sp_fireball_hit";
				break;	}
			case 2506 : //DRACONIC_HERITAGE_AMETHYST
			{	nDamageType = DAMAGE_TYPE_BLUDGEONING;
				nSave		= SAVING_THROW_TYPE_ALL;
				sBreath		= "sp_magic_cone_mouth"; 
				sImpact		= "fx_ssword_attack_hit";
				break;	}
			case 2507 : //DRACONIC_HERITAGE_CRYSTAL
			{	nDamageType = DAMAGE_TYPE_POSITIVE;
				nSave		= SAVING_THROW_TYPE_POSITIVE;
				sBreath		= "sp_draining_cone"; 
				sImpact		= "sp_frightful_hit";
				break;	}
			case 2508 : //DRACONIC_HERITAGE_EMERALD
			{	nDamageType = DAMAGE_TYPE_SONIC;
				nSave		= SAVING_THROW_TYPE_SONIC;
				sBreath		= "sp_sonic_cone_mouth";
				sImpact		= "sp_sonic_hit";
				break;	}
			case 2509 :	//DRACONIC_HERITAGE_SAPPHIRE
			{	nDamageType = DAMAGE_TYPE_SONIC;
				nSave 		= SAVING_THROW_TYPE_SONIC;
				sBreath		= "sp_sonic_cone_mouth";
				sImpact		= "sp_sonic_hit";
				break;	}
			case 2510 : //DRACONIC_HERITAGE_TOPAZ
			{	nDamageType = DAMAGE_TYPE_MAGICAL;
				nSave		= SAVING_THROW_TYPE_ALL;
				sBreath		= "sp_magic_cone_mouth";
				sImpact		= "sp_dehydrate_hit";
				break;	}
			case 2511 :	//DRACONIC_HERITAGE_SHADOW
			{	nDamageType = DAMAGE_TYPE_NEGATIVE;
				nSave		= SAVING_THROW_TYPE_NEGATIVE;
				sBreath		= "sp_darkness_cone_mouth";
				sImpact		= "sp_beshadowed_hit";
				break;	}
			case 2512 : //DRACONIC_HERITAGE_FANG
			{	nDamageType	= DAMAGE_TYPE_ALL;
				nSave		= SAVING_THROW_TYPE_CHAOS;
				sBreath		= "fx_spell_hindering_blast_cone";
				sImpact		= "fx_spell_hindering_blast_hit";
				break;	}
		}
		
		int nLevel 		= GetHitDice(oPC);
		int nHalfdrag	= GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC);
		int nDC			= nLevel/2 + 10 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
		int nDice;
		
		if (nHalfdrag == 6 && nLevel >= 25)
		{	nDice = 8;	}
		else if (nHalfdrag == 6 && nLevel >= 20)
		{	nDice = 7;	}
		else if (nHalfdrag == 6 && nLevel >= 15)
		{	nDice = 6;	}
		else if (nHalfdrag == 6)
		{	nDice = 5;	}
		else
		{	nDice = 3;	}

		effect eBreath = EffectNWN2SpecialEffectFile(sBreath);
   		effect eImpact = EffectNWN2SpecialEffectFile(sImpact);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0); 

	    int nDamage, nDamStrike;
	    float fDelay;
	    object oTarget;
		effect eDamage;
	    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE);
	    while(GetIsObjectValid(oTarget))
	    {	if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	        {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
	            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				nDamage = d10(nDice);
	            nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
	            if (nDamStrike > 0)
	            {	if (nHeritage == 2512)
					{	eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, (nDice / 2));	}
					else
					{	eDamage = EffectDamage(nDamStrike, nDamageType);	}
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));	}
	        }
	        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
	    }
	}
}

void PS_HD_DraconicApotheosis(object oPC, object oItem, int nSpell)
{
    int nHeritage, nImmunity; 
	
	if(GetIsObjectValid(oItem))
	{	nHeritage = GetLocalInt(oItem, "Draconic_Heritage");	}
	else
	{	SendMessageToPC(oPC, "You appear to be missing your Essence. Unable to access Draconic Heritage. Contact a member of staff.");	}

	if (nHeritage < 1)
	{	SendMessageToPC(oPC, "Draconic heritage not found.");
		return;	}
	
	switch (nHeritage)
	{	case 2496 : //DRACONIC_HERITAGE_WHITE
	    {	nImmunity	= DAMAGE_TYPE_COLD;
	        break;	}
		case 2497 : //DRACONIC_HERITAGE_BLACK
	    {	nImmunity	= DAMAGE_TYPE_ACID;
	        break;	}
		case 2498 : //DRACONIC_HERITAGE_GREEN
	    {	nImmunity	= DAMAGE_TYPE_ACID;
	        break;	}
		case 2499 : //DRACONIC_HERITAGE_BLUE
	    {	nImmunity	= DAMAGE_TYPE_ELECTRICAL;
	        break;	}
		case 2500 : //DRACONIC_HERITAGE_RED
	    {	nImmunity	= DAMAGE_TYPE_FIRE;
	        break;	}
		case 2501 : //DRACONIC_HERITAGE_BRASS
	    {	nImmunity	= DAMAGE_TYPE_FIRE;
	        break;	}
		case 2502 :	//DRACONIC_HERITAGE_COPPER
	    {	nImmunity	= DAMAGE_TYPE_ACID;
	        break;	}
		case 2503 : //DRACONIC_HERITAGE_BRONZE
	    {	nImmunity	= DAMAGE_TYPE_ELECTRICAL;
	        break;	}
		case 2504 :	//DRACONIC_HERITAGE_SILVER
	    {	nImmunity	= DAMAGE_TYPE_COLD;
	        break;	}
		case 2505 : //DRACONIC_HERITAGE_GOLD
	    {	nImmunity	= DAMAGE_TYPE_FIRE;
	        break;	}
		case 2506 : //DRACONIC_HERITAGE_AMETHYST
	    {	break;	} //immune to poison
		case 2507 : //DRACONIC_HERITAGE_CRYSTAL
	    {	nImmunity	= DAMAGE_TYPE_POSITIVE;
	    	break;	}
		case 2508 : //DRACONIC_HERITAGE_EMERALD
	    {	nImmunity	= DAMAGE_TYPE_SONIC;
	        break;	}
		case 2509 :	//DRACONIC_HERITAGE_SAPPHIRE
	    {	nImmunity	= DAMAGE_TYPE_ELECTRICAL;
	        break;	}
		case 2510 : //DRACONIC_HERITAGE_TOPAZ
	    {	nImmunity	= DAMAGE_TYPE_COLD;
	        break;	}
		case 2511 :	//DRACONIC_HERITAGE_SHADOW
	    {	nImmunity	= DAMAGE_TYPE_NEGATIVE;
			break;	}
		case 2512 : //DRACONIC_HERITAGE_FANG
	    {	break;	} //DR 2/ and 5/
	}
	int nHalfdragon		= GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC);
	int nImmune;
	
	if (nHalfdragon == 6)
	{	nImmune = 100;	}
	else
	{	nImmune = 40;	}
	
	effect ePara		= EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eSleep		= EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect eImmune		= EffectDamageImmunityIncrease(nImmunity, nImmune);
	effect eImmune2		= EffectDamageResistance(nImmunity, 9999, 0);
	effect eAmethyst1	= EffectSavingThrowIncrease(SAVING_THROW_ALL, 5, SAVING_THROW_TYPE_POISON); //Amethyst dragon only
	effect eAmethyst2	= EffectImmunity(IMMUNITY_TYPE_POISON); //Amethyst dragon only
	effect eFang1		= EffectDamageReduction(2, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE);
	effect eFang2		= EffectDamageReduction(5, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE);
	effect eLink;
	int nOrigin 		= GetRacialType(oPC);
	int nOriSub 		= GetSubRace(oPC);

	if (nHeritage == DRACONIC_HERITAGE_AMETHYST)
	{	if (nHalfdragon == 6)
		{	eLink = EffectLinkEffects(ePara, eSleep);
			eLink = EffectLinkEffects(eLink, eAmethyst2);
			eLink = ExtraordinaryEffect(eLink);	}
		else
		{	eLink = EffectLinkEffects(eSleep, eAmethyst1);
			eLink = ExtraordinaryEffect(eLink);	}	}
	else if (nHeritage == DRACONIC_HERITAGE_FANG)
		{	if (nHalfdragon == 6)
			{	eLink = EffectLinkEffects(ePara, eSleep);
				eLink = EffectLinkEffects(eLink, eFang2);
				eLink = ExtraordinaryEffect(eLink);	}
			else
			{	eLink = EffectLinkEffects(eSleep, eFang1);
				eLink = ExtraordinaryEffect(eLink);	}	}
		else
		{	if (nHalfdragon == 6)
			{	eLink = EffectLinkEffects(ePara, eSleep);
				eLink = EffectLinkEffects(eLink, eImmune2);
				eLink = ExtraordinaryEffect(eLink);	}
			else
			{	eLink = EffectLinkEffects(eSleep, eImmune);
				eLink = ExtraordinaryEffect(eLink);	}	}
		
	if (!GetHasSpellEffect(nSpell, oPC))
	{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		SendMessageToPC(oPC, "Half-dragon - immunities applied");	}

	if (PS_GetAppWingType(oPC) != 0)
	{	SetLocalInt(oPC, "OldWings", 1);	}
	else
	{	AddScriptParameterString("START");
		AddScriptParameterString("");
		ExecuteScriptEnhanced("gui_extra_choices", oPC);	}			

	if(GetRacialType(oPC) != RACIAL_TYPE_DRAGON)
	{	if (nHalfdragon == 6)
		{	SetLocalInt(oItem, "OldRace", nOrigin);
			SetLocalInt(oItem, "OldSubrace", nOriSub);
			SetLocalString(oItem, "RaceChange", "Dragon");
			SetLocalInt(oItem, "TemplateFix", 0);
			PS_SetRacialType(oPC, RACIAL_TYPE_DRAGON);
			PS_SetSubRacialType(oPC, RACIAL_SUBTYPE_DRAGON);	}	}
}


void PS_HD_DraconicMagic(object oPC, object oItem)
{
    int nHeritage, nFeat; 
	
	if(GetIsObjectValid(oItem))
	{	nHeritage = GetLocalInt(oItem, "Draconic_Heritage");	}
	else
	{	SendMessageToPC(oPC, "You appear to be missing your Essence. Unable to access Draconic Heritage. Contact a member of staff.");	}

	if (nHeritage < 1)
	{	SendMessageToPC(oPC, "Draconic heritage not found.");
		return;	}
	
	switch (nHeritage)
	{	case 2496 : //DRACONIC_HERITAGE_WHITE
	    {	nFeat = DRACONIC_MAGIC_FREEZING_FOG;
	        break;	}
		case 2497 : //DRACONIC_HERITAGE_BLACK
	    {	nFeat = DRACONIC_MAGIC_THORN_BODY;
	        break;	}
		case 2498 : //DRACONIC_HERITAGE_GREEN
	    {	nFeat = DRACONIC_MAGIC_RESINOUS_SKIN;
	        break;	}
		case 2499 : //DRACONIC_HERITAGE_BLUE
	    {	nFeat = DRACONIC_MAGIC_SPARKSHIELD;
	        break;	}
		case 2500 : //DRACONIC_HERITAGE_RED
	    {	nFeat = DRACONIC_MAGIC_FLAMESHIELD;
	        break;	}
		case 2501 : //DRACONIC_HERITAGE_BRASS
	    {	nFeat = DRACONIC_MAGIC_AVOID_PLANAR_EFFECTS;
	        break;	}
		case 2502 :	//DRACONIC_HERITAGE_COPPER
	    {	nFeat = DRACONIC_MAGIC_SCINTILLATING_SCALES;
	        break;	}
		case 2503 : //DRACONIC_HERITAGE_BRONZE
	    {	nFeat = DRACONIC_MAGIC_OBSCURING_MIST;
	        break;	}
		case 2504 :	//DRACONIC_HERITAGE_SILVER
	    {	nFeat = DRACONIC_MAGIC_CIRCLE_VS_EVIL;
	        break;	}
		case 2505 : //DRACONIC_HERITAGE_GOLD
	    {	nFeat = DRACONIC_MAGIC_BAHAMUTS_PRAYER;
	        break;	}
		case 2506 : //DRACONIC_HERITAGE_AMETHYST
	    {	nFeat = DRACONIC_MAGIC_ENERGY_ADAPTION;
			break;	}
		case 2507 : //DRACONIC_HERITAGE_CRYSTAL
	    {	nFeat = DRACONIC_MAGIC_CONCEALING_AMORPHA;
	    	break;	}
		case 2508 : //DRACONIC_HERITAGE_EMERALD
	    {	nFeat = DRACONIC_MAGIC_INERTIAL_BARRIER;
	        break;	}
		case 2509 :	//DRACONIC_HERITAGE_SAPPHIRE
	    {	nFeat = DRACONIC_MAGIC_DIMENSION_DOOR;
	        break;	}
		case 2510 : //DRACONIC_HERITAGE_TOPAZ
	    {	nFeat = DRACONIC_MAGIC_ECTOPLASMIC_FORM;
	        break;	}
		case 2511 :	//DRACONIC_HERITAGE_SHADOW
	    {	nFeat = DRACONIC_MAGIC_MIRROR_IMAGE;
			break;	}
		case 2512 : //DRACONIC_HERITAGE_FANG
	    {	nFeat = DRACONIC_MAGIC_SHIELD_GREATER;
			break;	}
	}
	FeatAdd(oPC, nFeat, FALSE, FALSE, FALSE);
	SetLocalInt(oItem, "Draconic Magic", nFeat);
}

void PS_HDM_SeeInvisibility(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    effect eIcon 	= EffectEffectIcon(54);
    effect eSight 	= EffectSeeInvisible();
    effect eLink 	= EffectLinkEffects(eIcon, eSight);
    float fDuration = RoundsToSeconds(GetHitDice(oPC) * 5);

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_SEE_INVISIBILITY, FALSE));
    RemovePermanencySpells(oPC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_FreezingFog(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}

    effect eAOE 		= EffectAreaOfEffect(AOE_PER_FREEZINGFOG);
    location lTarget 	= GetLocation(oPC);
	float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}

void PS_HDM_ThornBody(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
    effect eDur 		= EffectNWN2SpecialEffectFile("sp_skin_101");
    float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
	int nDamage			= GetHitDice(oPC) / 2;
	effect eThorn		= EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_PIERCING);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    if (GetHasSpellEffect(nSpell, oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);	}

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eThorn, oPC, fDuration);
}

void PS_HDM_ResinousSkin(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
	effect eDR				= EffectDamageReduction(5, DAMAGE_TYPE_PIERCING, 0, DR_TYPE_DMGTYPE);
	effect eSticky			= EffectNWN2SpecialEffectFile("sp_skin_152", oPC);
	effect eLink			= EffectLinkEffects(eDR, eSticky);
	itemproperty ipStuck	= ItemPropertyOnHitCastSpell(131, 10);
	float fDuration			= RoundsToSeconds(GetHitDice(oPC) * 5);
	object oSkin			= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	if (oSkin == OBJECT_INVALID)
	{	SendMessageToPC(oPC, "The adhesive quality will not work if you wear no clothes.");	}
	else
	{	IPSafeAddItemProperty(oSkin, ipStuck, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);	}
}

void PS_HDM_ResinSticky(int nSpell, object oTarget)
{
	int nBonus			= GetAbilityModifier(ABILITY_STRENGTH, oTarget);
	int nStrCheck		= d20(1) + nBonus;
	effect eStuck		= EffectCutsceneParalyze();
	effect eIcon		= EffectEffectIcon(136);
		eStuck			= EffectLinkEffects(eStuck, eIcon);
	
	if (nStrCheck >= 21)
	{	return;		}
	else
	{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, TRUE));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStuck, oTarget, RoundsToSeconds(1));
		
		SendMessageToPC(oTarget, "Your weapon has become stuck to your opponent's skin!");	}
}

void PS_HDM_SparkShield(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
    effect eDur 		= EffectNWN2SpecialEffectFile("sp_stormrage");
    float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
	int nDamage			= GetHitDice(oPC) / 2;
	effect eSpark		= EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL);
	effect eLink		= EffectLinkEffects(eDur, eSpark);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    if (GetHasSpellEffect(nSpell, oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);	}

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_FlameShield(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
    effect eDur 		= EffectNWN2SpecialEffectFile("fire_bird");
    float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
	int nDamage			= GetHitDice(oPC) / 2;
	effect eFlame		= EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    if (GetHasSpellEffect(nSpell, oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);	}

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlame, oPC, fDuration);
}

void PS_HDM_AvoidPlanarEffects(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
	float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
    int nResistance 	= 10;
    effect eCold 		= EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, 0);
    effect eFire 		= EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, 0);
    effect eAcid 		= EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, 0);
    effect eSonic		= EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, 0);
    effect eElec 		= EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, 0);
    effect eDur 		= EffectNWN2SpecialEffectFile("sp_avoidplanareffects", oPC);
	effect eLink 		= EffectLinkEffects(eCold, eFire);
    	eLink			= EffectLinkEffects(eLink, eAcid);
    	eLink 			= EffectLinkEffects(eLink, eSonic);
    	eLink 			= EffectLinkEffects(eLink, eElec);
    	eLink 			= EffectLinkEffects(eLink, eDur);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    RemoveEffectsFromSpell(oPC, GetSpellId());
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_ScintillatingScales(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
	int nBonus			= GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
	if (nBonus > 10)
	{	nBonus = 10;	}
	effect eAC			= EffectACIncrease(nBonus, AC_DEFLECTION_BONUS);
	effect eScint		= EffectNWN2SpecialEffectFile("fx_e_soul_glow", oPC);
	effect eLink		= EffectLinkEffects(eAC, eScint);
	float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_ObscuringMist(object oPC, location lTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
    effect eAOE      	= EffectAreaOfEffect(AOE_PER_OBSCURINGMIST);
   	float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);

	if (GetIsLocationValid(lTarget))
	{	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell));	}
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}

void PS_HDM_MagicCircleVsEvil(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

    effect eAOE 		= EffectAreaOfEffect(AOE_MOB_CIRCGOOD);
    float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDuration);
}

void PS_HDM_BahamutsPrayer(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

	effect eAttack		= EffectAttackIncrease(1, ATTACK_BONUS_MISC);
	effect eDamage		= EffectDamageIncrease(1, DAMAGE_TYPE_DIVINE);
	effect eSkill		= EffectSkillIncrease(SKILL_ALL_SKILLS, 2);
	effect eSave		= EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	effect eVFX			= EffectNWN2SpecialEffectFile("vfx_rds_glowhead", oPC);
	effect eLink		= EffectLinkEffects(eAttack, eDamage);
		eLink			= EffectLinkEffects(eLink, eSkill);
		eLink			= EffectLinkEffects(eLink, eSave);
		eLink			= EffectLinkEffects(eLink, eVFX);
	float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_ConcealingAmorpha(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

    effect eConceal = EffectConcealment(40);
    effect eDur     = EffectNWN2SpecialEffectFile("psi_concealing_amorpha", oPC);
    effect eLink    = EffectLinkEffects(eDur, eConceal);
    float fDuration	= RoundsToSeconds(GetHitDice(oPC) * 5);

	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_InertialBarrier(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
		
    effect eDR		= EffectDamageReduction(5, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE);
	effect eVFX		= EffectNWN2SpecialEffectFile("psi_inertialbarrier");
	effect eLink 	= EffectLinkEffects(eDR, eVFX);
    float fDuration	= RoundsToSeconds(GetHitDice(oPC) * 5);

	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_DimensionDoor(object oPC, location lTarget)
{
	object oManifester = OBJECT_SELF;
   	object oTarget     = oManifester;
	
	string sName = GetName(oManifester);
	AssignCommand(oManifester, ClearAllActions());
	location lTarget = GetSpellTargetLocation();
	location lCaster = GetLocation(oManifester);
	effect eVis = EffectNWN2SpecialEffectFile("fx_spell_planar_rift.sef");
		
	if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
	if (GetLocalInt(oTarget, "DIMENSIONAL_ACHORED"))
	{	SendMessageToPC(oTarget, "A Dimensional Anchor makes it impossible to teleport.");
		return;		}
	SendMessageToPC(oTarget, "Psionic energies whisk you away to your targeted location.");
	AssignCommand(oTarget, ActionJumpToLocation(lTarget));
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, RoundsToSeconds(4));
}

void PS_HDM_EctoplasmicForm(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	effect eVis     = EffectNWN2SpecialEffectFile("fx_ghost_glow", oPC);
    effect eCrit	= EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	effect ePois	= EffectImmunity(IMMUNITY_TYPE_POISON);
	effect eDam		= EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO, 0, DR_TYPE_MAGICBONUS );
	effect eCon		= EffectSkillDecrease(1, 10);
    effect eLink	= EffectLinkEffects(eVis, eCrit);
		eLink    	= EffectLinkEffects(eLink, eCon);
		eLink    	= EffectLinkEffects(eLink, eDam);
		eLink    	= EffectLinkEffects(eLink, ePois);
    float fDuration	= RoundsToSeconds(GetHitDice(oPC) * 5);
	
	int iRules		= GetArmorRulesType(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
	string sAC 		= Get2DAString("armorrulestats", "ACBONUS", iRules);
	int iAC			= StringToInt(sAC);
	effect eACPen	= EffectACDecrease(iAC, AC_ARMOUR_ENCHANTMENT_BONUS);
		eLink		= EffectLinkEffects(eLink, eACPen);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, fDuration);
}

void PS_HDM_MirrorImage(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	if (GetHasSpellEffect(nSpell))
	{	effect eEffect = GetFirstEffect(oPC);
		while (GetIsEffectValid(eEffect))
		{	if (GetEffectSpellId(eEffect) == nSpell)
			{	RemoveEffect( OBJECT_SELF, eEffect );	}
			eEffect = GetNextEffect( OBJECT_SELF );		}
	}

    int nCasterLvl 		= GetHitDice(oPC) / 2;
    float fDuration		= RoundsToSeconds(nCasterLvl * 5);	
	int nACBonus 		= (10 + GetAbilityModifier(ABILITY_DEXTERITY, oPC));
    int nImages 		= d4( 1 ) + (nCasterLvl / 4);
	
	if( nImages > 8 )  
	{	nImages = 8; 	}

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	float fSpin 		= ( 1.5 / nImages );
	float fDelay 		= ( 0.0 );
	string sImg 		= ("sp_mirror_image_1.sef");

    int i;
    for ( i = 0; i < nImages; i++ )
    {	effect eAbsorb	= EffectAbsorbDamage(nACBonus);
        effect eDur		= EffectVisualEffect(876);
		effect eImg 	= EffectNWN2SpecialEffectFile("sp_mirror_image_1", oPC);
        effect eLink 	= EffectLinkEffects(eAbsorb, eDur);
			eLink 		= EffectLinkEffects(eLink, eImg);
        effect eOnDisp	= EffectOnDispel(0.0f, RemoveEffectsFromSpell(oPC, nSpell));
        eLink = EffectLinkEffects(eLink, eOnDisp);

        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration));
		fDelay += fSpin;	}
}

void PS_HDM_ShieldGreater(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int iArmor			= (GetHitDice(oPC))/10 + 5;
	effect eArmor 		= EffectACIncrease(iArmor, AC_SHIELD_ENCHANTMENT_BONUS);
    effect eSpell 		= EffectSpellImmunity(SPELL_MAGIC_MISSILE);
//    effect eDur 		= EffectNWN2SpecialEffectFile("sp_shield_bk", oPC);
    effect eLink		= EffectLinkEffects(eArmor, eSpell);
//    	eLink 			= EffectLinkEffects(eLink, eDur);
    float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HDM_EnergyAdaptation(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}
	
	int nLevel			= GetHitDice(oPC) / 2;
    int nResist;
    if (nLevel < 6)
	{	nResist = 10;	}
    else if (nLevel < 12)
	{	nResist = 20;	}
    else
	{	nResist = 30;	}

	effect eAcid 		= EffectDamageResistance(DAMAGE_TYPE_ACID, nResist);
    effect eCold		= EffectDamageResistance(DAMAGE_TYPE_COLD, nResist);
    effect eElec		= EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist);
    effect eFire		= EffectDamageResistance(DAMAGE_TYPE_FIRE, nResist);
    effect eSoni		= EffectDamageResistance(DAMAGE_TYPE_SONIC, nResist);
    effect eVFX			= EffectNWN2SpecialEffectFile("sp_protection_energy", oPC);
	effect eLink		= EffectLinkEffects(eAcid, eCold);
		eLink			= EffectLinkEffects(eLink, eElec);
		eLink			= EffectLinkEffects(eLink, eFire);
		eLink			= EffectLinkEffects(eLink, eSoni);
		eLink			= EffectLinkEffects(eLink, eVFX);
	object oSkin		= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
	itemproperty ipShn	= ItemPropertyOnHitCastSpell(128, 10);
		
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	if (oSkin == OBJECT_INVALID)
	{	SendMessageToPC(oPC, "The glow effect will not work if you are not wearing clothing.");	}
	else
	{	IPSafeAddItemProperty(oSkin, ipShn, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);	}
}

void PS_HDM_EnergyAdaptGlow(object oPC, int nSpell)
{
	int iRand		= Random(6);
	int iLight;
	
	switch(iRand)
	{	case 0 :
		{	iLight	= VFX_DUR_LIGHT_WHITE_20;
			break;	}
		case 1 :
		{	iLight	= VFX_DUR_LIGHT_BLUE_20;
			break;	}
		case 2 :
		{	iLight	= VFX_DUR_LIGHT_ORANGE_20;
			break;	}
		case 3 :
		{	iLight	= VFX_DUR_LIGHT_PURPLE_20;
			break;	}
		case 4 :
		{	iLight	= VFX_DUR_LIGHT_RED_20;
			break;	}
		case 5 :
		{	iLight	= VFX_DUR_LIGHT_YELLOW_20;
			break;	}
	}
	effect eLight	= EffectVisualEffect(iLight, FALSE);
	RemoveEffectsFromSpell(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLight, oPC, TurnsToSeconds(1));
}

void PS_DraconicBloodline(object oPC, int nSpell)
{
	if(GetHasFeat(FEAT_BACKGROUND_DRACONIC_BLOODLINE, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_DRACONIC_BLOODLINE") <1))
    	SetLocalInt(oPC,"FEAT_BACKGROUND_DRACONIC_BLOODLINE",1);
   
	effect eIntimGood	= EffectSkillIncrease(SKILL_INTIMIDATE, 1);
	effect eFort		= EffectSavingThrowIncrease(SAVING_THROW_FORT, 1);
	effect eTumblBad	= EffectSkillDecrease(SKILL_TUMBLE, 1);
	effect eDiploBad	= EffectSkillDecrease(SKILL_DIPLOMACY, 1);
	effect eEff 		= EffectLinkEffects(eIntimGood, eFort);
		eEff			= EffectLinkEffects(eEff, eTumblBad);
		eEff			= EffectLinkEffects(eEff, eDiploBad);
		eEff 			= SupernaturalEffect(eEff);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_HD_Dragonflight(object oPC, object oItem)
{
	int iCheck		= GetLocalInt(oItem, "DragonFlight");
	int iTemp		= GetLocalInt(oItem, "TempChange");
	if (iTemp == 1) return;
	int iWing, iWingF, iWingM;
	int iRace		= GetLocalInt(oItem, "OldRace");
	int iSub		= GetLocalInt(oItem, "OldSubrace");
	
	if (iRace == RACIAL_TYPE_INVALID)
	{	SendMessageToPC(oPC, "Debug: Error, no racial type found."); return;	}
	
	switch (iRace)
	{
		case 0: iWingF = 44; iWingM = 43; break; // Dwarf
		case 1: iWingF = 56; iWingM = 55; break; // Elf
		case 2: iWingF = 46; iWingM = 45; break; // Gnome
		case 3: iWingF = 56; iWingM = 55; break; // Halfling
		case 4: iWingF = 56; iWingM = 55; break; // Half-elf
		case 5: iWingF = 48; iWingM = 47; break; // Half-orc
		case 6: iWingF = 56; iWingM = 55; break; // Human
		case 10: if (iSub == 61) iWingF= 56; iWingM = 55; break; //Khaasta
		case 14: iWingF = 48; iWingM = 47; break; // Orc
		case 21: iWingF = 56; iWingM = 55; break; // Planetouched
		case 31: if (iSub == 47) iWingF = 56; iWingM = 55; break; //Yuan-ti Pureblood
		case 32: iWingF = 48; iWingM = 47; break; // Grey Orc
		case 33: iWingF = 56; iWingM = 55; break; // Native Outsider
		case 251: iWingF =56; iWingM = 55; break; //Dragonborn

	}
	if (GetGender(oPC) == GENDER_FEMALE) iWing = iWingF;
	else iWing = iWingM;
	
	FeatAdd(oPC, 2120, FALSE);
	PS_RestoreOriginalAppearance(oPC);
		
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.WingVariation = iWing;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
	SetLocalInt(oItem, "DragonFlight", 1);
	DelayCommand(0.1f, PS_TintFixer(oPC));
	DelayCommand(0.2f, PS_RefreshAppearance(oPC));
	DelayCommand(0.3f, PS_SaveOriginalAppearance(oPC));
}

void PS_HD_RemainWingless(object oPC, object oItem)
{
	FeatAdd(oPC, FEAT_STEADFAST_DETERMINATION, FALSE);
	SendMessageToPC(oPC, "Steadfast Determination feat granted.");
	SetLocalInt(oItem, "Wingless", 1);
}