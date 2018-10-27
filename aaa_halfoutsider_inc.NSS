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

void PS_OutsiderBloodlineFiendish(object oPC, int nSpell)
{
	effect eProfane		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
		eProfane		= VersusAlignmentEffect(eProfane, ALIGNMENT_ALL, ALIGNMENT_GOOD);
		eProfane		= ExtraordinaryEffect(eProfane);
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eProfane, oPC);
}

void PS_OutsiderBloodlineCelestial(object oPC, int nSpell)
{
	effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
		eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
		eSacred			= ExtraordinaryEffect(eSacred);
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
}

void PS_HO_PlanarHeritageFiend(object oPC, object oItem)
{
	string sFiend		= GetLocalString(oItem, "Planar");
	int nOldECL 		= StringToInt(PS_GetEssenceECL(oPC));
	int iOutsider 		= 0;
	int iNewECL;
	string sNewECL;
	
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) > 0)
	{	iOutsider = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC);	}
	SetLocalString(oItem, "Planar", "HalfFiend");

	//if (sFiend != "HalfFiend")
	//{	if (iOutsider != 0)
		//{	iNewECL = nOldECL + 3;
			//sNewECL = IntToString(iNewECL);
			//SetLocalInt(oItem, "OldECL", nOldECL);
			//SetLocalString(oPC, "ECL", sNewECL);
			//SetLocalString(oItem, "ECL", sNewECL);
			//SetLocalString(oItem, "Planar", "HalfFiend");	}
	//}	
}

void PS_HO_PlanarHeritageCelestial(object oPC, object oItem)
{
	string sCelest	= GetLocalString(oItem, "Planar");
	int nOldECL 	= StringToInt(PS_GetEssenceECL(oPC));
	int iOutsider 	= 0;
	int iNewECL;
	string sNewECL;
	
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) > 0)
	{	iOutsider = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC);	}
	SetLocalString(oItem, "Planar", "HalfCelestial");

	//if (sCelest != "HalfCelestial")
	//{	if (iOutsider != 0)
		//{	iNewECL = nOldECL + 3;
			//sNewECL = IntToString(iNewECL);
			//SetLocalInt(oItem, "OldECL", nOldECL);
			//SetLocalString(oPC, "ECL", sNewECL);
			//SetLocalString(oItem, "ECL", sNewECL);
			//SetLocalString(oItem, "Planar", "HalfCelestial");	}
	//}
}

void PS_HO_Immunity(object oPC, int nSpell)
{
	effect eImmune;
	if(GetHasFeat(2537, oPC))
	{	eImmune = EffectImmunity(IMMUNITY_TYPE_POISON);	}
	else if (GetHasFeat(2538, oPC))
	{	eImmune = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);	}
	else return;
	eImmune = ExtraordinaryEffect(eImmune);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune, oPC);
}

void PS_HO_Resistance(object oPC, int nSpell)
{
	int nResist = 5;
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) >= 6)
	{	nResist = 10;	}
	effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist);
	effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResist);
	effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist);
	effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist);
	effect eLink = EffectLinkEffects(eAcid, eFire);
		eLink = EffectLinkEffects(eLink, eCold);
		eLink = EffectLinkEffects(eLink, eElec);
		eLink = ExtraordinaryEffect(eLink);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void PS_HO_DR(object oPC, int nSpell)
{
	int nReduct = 5;
	int nDamagePower = DAMAGE_POWER_PLUS_ONE;
	
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) >= 6)
	{	nReduct = 10;
		if (GetHitDice(oPC) >= 15)
		{	nDamagePower = DAMAGE_POWER_PLUS_TWO;	}
		if (GetHitDice(oPC) >= 23)
		{	nDamagePower = DAMAGE_POWER_PLUS_THREE;	}	}
	
	effect eDR = EffectDamageReduction(nReduct, nDamagePower, 0, DR_TYPE_MAGICBONUS);
		eDR = ExtraordinaryEffect(eDR);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);
}

void PS_HO_Apotheosis(object oPC, int nSpell, object oItem)
{
    string sHeritage; 
	int nType;
	int nLevel = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC);
	int nOrigin = GetRacialType(oPC);
	int nOriSub = GetSubRace(oPC);
	int iWings = GetLocalInt(oItem, "DarkFlight");
	
	if(GetIsObjectValid(oItem))
	{	sHeritage = GetLocalString(oItem, "Planar");	}
	else
	{	SendMessageToPC(oPC, "You appear to be missing your Essence. Unable to access Planar Heritage. Contact a member of staff.");	}

	if (sHeritage == "")
	{	SendMessageToPC(oPC, "Planar heritage not found.");
		return;	}
	if (sHeritage == "HalfFiend")
	{	nType = 1;	}
	if (sHeritage == "HalfCelestial")
	{	nType = 2;	}
	
	if (GetRacialType(oPC) != RACIAL_TYPE_OUTSIDER)
	{	if (nLevel == 6)
		{	SetLocalString(oItem, "Template", "HalfOutsider");
			SetLocalInt(oItem, "OldRace", nOrigin);
			SetLocalInt(oItem, "OldSubrace", nOriSub);
			SetLocalString(oItem, "RaceChange", "Outsider");
			SetLocalInt(oItem, "TemplateFix", 0);
			PS_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
			PS_SetSubRacialType(oPC, RACIAL_SUBTYPE_OUTSIDER);	}	}
	
	if (iWings == 1 && !GetHasFeat(2120, oPC))
	{	FeatAdd(oPC, 2120, FALSE);	}		
	
	if (iWings != 1 && !GetHasFeat(2556, oPC))
	{	AddScriptParameterString("START");
		AddScriptParameterString("");
		ExecuteScriptEnhanced("gui_extra_choices", oPC);	}
	
	if (GetHasFeat(2556, oPC))
	{	SetLocalInt(oItem, "SupSight", 1);	}
}

void PS_HOM_FiendishSmiting(object oPC, int nSpell)
{
	int iHitDice 	= GetHitDice(oPC);
	float fDuration = RoundsToSeconds(iHitDice + 5);
	effect eBonus = EffectDamageIncrease(DAMAGE_BONUS_1d8, DAMAGE_TYPE_MAGICAL);
		eBonus = VersusAlignmentEffect(eBonus, ALIGNMENT_ALL, ALIGNMENT_GOOD);
	effect eHands = EffectNWN2SpecialEffectFile("evil_hand_effect", oPC);
	effect eLink = 	EffectLinkEffects(eBonus, eHands);
	eLink = SetEffectSpellId(eLink,nSpell);
		eLink = SupernaturalEffect(eLink);
		
		DelayCommand(0.1f, SAFE_ApplyEffectToObject(nSpell, DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration));	
}

void PS_HOM_CelestialSmiting(object oPC, int nSpell)
{
	int iHitDice 	= GetHitDice(oPC);
	float fDuration = RoundsToSeconds(iHitDice + 5);
	effect eBonus = EffectDamageIncrease(DAMAGE_BONUS_1d8, DAMAGE_TYPE_MAGICAL);
		eBonus = VersusAlignmentEffect(eBonus, ALIGNMENT_ALL, ALIGNMENT_EVIL);
	effect eHands = EffectNWN2SpecialEffectFile("holy_hand_effect", oPC);
	effect eLink = 	EffectLinkEffects(eBonus, eHands);
	eLink = SetEffectSpellId(eLink,nSpell);
		eLink = SupernaturalEffect(eLink);
			
		DelayCommand(0.1f, SAFE_ApplyEffectToObject(nSpell, DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration));
}

void PS_HOM_UnholyBlight(object oPC, int nSpell, location lTarget)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    int nDamage;
	int nLevel = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC);
	int nCasterLvl = (nLevel * 2);
	int nChaBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDC = 20;
    float fDelay;
    effect eDam, eVis, eLink, eSick, eEvil;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    	{	if (nSpell == 1475)
            {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        	    {	if ((GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) && (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER))
					{	nDamage = d6(nCasterLvl);	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
					{	nDamage = d6(nLevel);	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
					{	nDamage = d6(nLevel) / 2;
						if (!WillSave(oTarget, nDC, SAVING_THROW_TYPE_EVIL))
						{	nDamage = nDamage / 2;	}	}
					else
					{	nDamage = 0;	}
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
    				eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
					eLink = EffectLinkEffects(eDam, eVis);
					eSick = EffectSickened();
					eEvil = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
				
					if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEvil, oTarget));	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));	}
                    else
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
						if (!WillSave(oTarget, nDC, SAVING_THROW_TYPE_DISEASE))
						{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSick, oTarget, RoundsToSeconds((1))));	}
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
}	}

void PS_HOM_HolySmite(object oPC, int nSpell, location lTarget)
{
    if (!X2PreSpellCastCode())
    {	return;	}
    int nDamage;
	int nLevel = GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC);
	int nCasterLvl = (nLevel * 2);
	int nChaBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDC = 20;
    float fDelay;
    effect eDam, eVis, eLink, eBlind, eGood;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    	{	if (nSpell == 1649)
            {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        	    {	if ((GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) && (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER))
					{	nDamage = d6(nCasterLvl);	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
					{	nDamage = d6(nLevel);	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
					{	nDamage = d6(nLevel) / 2;
						if (!WillSave(oTarget, nDC, SAVING_THROW_TYPE_GOOD))
						{	nDamage = nDamage / 2;	}	}
					else
					{	nDamage = 0;	}
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
    				eVis = EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
					eLink = EffectLinkEffects(eDam, eVis);
					eBlind = EffectBlindness();
					eGood = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
				
					if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGood, oTarget));	}
					else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));	}
                    else
					{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
						if (!WillSave(oTarget, nDC, SAVING_THROW_TYPE_DISEASE))
						{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(1)));	}
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
}	}

//Helper function for PS_HOM_RaptureOfRupture, does ongoing damage of 1d6 per round until healed
void PS_RunRuptureOngoing(object oTarget, int nCasterLevel)
{
	int nHP				= GetCurrentHitPoints(oTarget);
	int nRuptureHP		= GetLocalInt(oTarget, "RuptureHP");
	int nOngoing		= d6(1);
	int nSaveDC			= 10 + nCasterLevel;
	effect eSecondary	= EffectNWN2SpecialEffectFile("sp_inflict_moderate", oTarget);
	effect eOngoing		= EffectDamage(nOngoing, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, TRUE);
		eOngoing		= EffectLinkEffects(eOngoing, eSecondary);
	effect eStun		= EffectStunned();
	effect eStunIcon	= EffectEffectIcon(18);
	
	if (nHP < nRuptureHP)
	{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eOngoing, oTarget);
		if (nOngoing == 6)
		{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eStunIcon, oTarget);	}
		if (!GetIsSkillSuccessful(oTarget, SKILL_HEAL, nSaveDC))
		{	SetLocalInt(oTarget, "RuptureHP", GetCurrentHitPoints(oTarget));
			PS_RunRuptureOngoing(oTarget, nSaveDC);	}
	}
}

void PS_HOM_RaptureOfRupture(object oPC, int nSpell, object oTarget)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	int nCasterLevel	= GetHitDice(oPC) / 2;
	int nSaveDC			= 10 + nCasterLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDam			= d6(6);
	int nSave			= FortitudeSave(oTarget, nSaveDC, SAVING_THROW_TYPE_ALL, oPC);
	effect eRupture, eImpact, eOngoing;


    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
        if (TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID)>0)
        {	if(!MyResistSpell(OBJECT_SELF, oTarget))
            {	if (nSave == 1)
				{	nDam = nDam / 2;	}	
				eRupture 	= EffectDamage(nDam, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, TRUE);
				eImpact		= EffectNWN2SpecialEffectFile("sp_inflict_serious", oTarget);
    			eRupture	= EffectLinkEffects(eRupture, eImpact);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eRupture, oTarget);
				if (nSave == 0)
				{	SetLocalInt(oTarget, "RuptureHP", GetCurrentHitPoints(oTarget));
					DelayCommand(1.0f, PS_RunRuptureOngoing(oTarget, nCasterLevel));	}

            }
        }
    }
}

void PS_HOM_CrownOfFlame(object oPC, int nSpell)
{
    int iDuration	= GetHitDice(oPC) * 5;
    effect eAOE		= EffectAreaOfEffect(VFX_MOB_CROWN_OF_FLAME);
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(iDuration));
}

void PS_HOM_Fiendform(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    effect eVis = EffectNWN2SpecialEffectFile("sp_beshadowed_doom", oPC);
    effect eFiend;
    int nFiend;
	int nLevel = GetHitDice(oPC);
    int nDuration = nLevel * 5;

	if (nLevel >= 23)
	{	if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
    	{	nFiend = 96;	}	//Greater Baatezu
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
		{	nFiend = 97;	}	//Greater Tanar'ri
		else
		{	nFiend = 98;	}	//Greater Yugoloth
    }
    else
	{	if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
		{	nFiend = 99;	}	//Lesser Baatezu
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
		{	nFiend = 100;	}	//Lesser Tanar'ri
		else
		{	nFiend = 101;	}	//Lesser Yugoloth
	}
    eFiend = EffectPolymorph(nFiend, FALSE, TRUE);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_SELF, FALSE));
    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFiend, oTarget, RoundsToSeconds(nDuration));
}

void PS_HOM_RadiantShield(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
    effect eDur 		= EffectNWN2SpecialEffectFile("fx_aurora_chain_glow");
	effect eLight		= EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20);
		eDur			= EffectLinkEffects(eDur, eLight);
    float fDuration		= RoundsToSeconds(GetHitDice(oPC) * 5);
	int nDamage			= GetHitDice(oPC) / 2;
	effect eRadiant		= EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL);
	effect eResist		= EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 50);
	effect eLink		= EffectLinkEffects(eDur, eRadiant);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    if (GetHasSpellEffect(nSpell, oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);	}

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

void PS_HOM_SummonFiend(object oPC, int nSpell, location lTarget)
{
	int nLevel 			= GetHitDice(oPC);
	int nDuration		= 10 + nLevel;
	string sFiend;
	int nD2;
	effect eSummon;
	
	if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
	{	sFiend = "ps_summon_viii_le";	}
	else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
	{	sFiend = "ps_summon_viii_hfc";	}
	else
	{	nD2				= d2(1);
		if (nD2 == 1)
		{	sFiend = "ps_summon_viii_le";	}
		else
		{	sFiend = "ps_summon_viii_hfc";	}
	}
	
	eSummon = EffectSummonCreature(sFiend, VFX_SPELL_SHADES_SUMMON_CREATURE, 0.1f, 1);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, RoundsToSeconds(nDuration));
}

void PS_HOM_SummonCelestial(object oPC, int nSpell, location lTarget)
{
	int nLevel 			= GetHitDice(oPC);
	int nDuration		= 10 + nLevel;
	string sCelest;
	int nD2;
	effect eSummon;
	
	if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
	{	sCelest = "ps_summon_viii_lg";	}
	else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
	{	sCelest = "ps_summon_viii_cg";	}
	else
	{	nD2				= d2(1);
		if (nD2 == 1)
		{	sCelest = "ps_summon_viii_cg";	}
		else
		{	sCelest = "ps_summon_viii_lg";	}
	}
	
	eSummon = EffectSummonCreature(sCelest, VFX_SPELL_SHADES_SUMMON_CREATURE, 0.1f, 1);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, RoundsToSeconds(nDuration));
}

void PS_HOM_Gutwrench(object oPC, int nSpell, object oTarget)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	effect eDeath 		= EffectDeath(TRUE);
    effect eSpurt 		= EffectNWN2SpecialEffectFile("bloodspurt", oTarget);
		eDeath			= EffectLinkEffects(eDeath, eSpurt);
	effect ePuddle		= EffectNWN2SpecialEffectFile("fx_bloodstain1", oTarget);
	effect eBeam		= EffectBeam(VFX_BEAM_NECROMANCY, oTarget, BODY_NODE_CHEST);
	effect eAbsorb		= EffectNWN2SpecialEffectFile("fx_sp_vampiric_feast_hit01", oPC);
	effect eAbsHeal		= EffectTemporaryHitpoints(d6(4));
	effect eFail		= EffectNWN2SpecialEffectFile("fx_b_spell_failure", oPC);
	int nCasterLevel	= GetHitDice(oPC) / 2;
	int nSaveDC			= 10 + nCasterLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDamage			= d6(10);
    effect eDam			= EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		// Check for "no discernable anatomy"
		if (PS_GetHasDiscernableAnatomy(oTarget) == FALSE)
		{   SendMessageToPCByStrRef(oPC, 16780102);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oPC);
			return;		}
		
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, oPC))
            {	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
				DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePuddle, GetLocation(oTarget), 30.0f));
				DelayCommand(0.6f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPC, 3.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAbsorb, oPC));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbsHeal, oPC, HoursToSeconds(24)));	}
            else
            {	eDam = EffectLinkEffects(eDam, eSpurt);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);	}
        }
    }
}

void PS_HOM_Resurrection(object oPC, int nSpell, object oTarget)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    if (GetIsObjectValid(oTarget))
    {	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, FALSE));
        if (GetIsDead(oTarget))
        {	int nHealed = GetMaxHitPoints(oTarget);
            effect eRaise = EffectResurrection();
            effect eHeal = EffectHeal(nHealed + 10);
            effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));	}
        else
        {   if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {	int nStrRef = GetLocalInt(oTarget,"X2_L_RESURRECT_SPELL_MSG_RESREF");
                if (nStrRef == 0)
                {	nStrRef = 83861;	}
                if (nStrRef != -1)
                {	FloatingTextStrRefOnCreature(nStrRef,OBJECT_SELF);	}
            }
        }
    }
}

void PS_HO_SupernaturalSight(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    effect eEyes;
    effect eSight = EffectTrueSeeing();
	
	if (GetHasFeat(1639, oPC))
	{	eEyes = EffectNWN2SpecialEffectFile("fx_deathknight_eyes", oPC);	}
	if (GetHasFeat(1640, oPC))
	{	eEyes = EffectNWN2SpecialEffectFile("fx_erinyes_eyes", oPC);	}
	
    effect eLink = EffectLinkEffects(eEyes, eSight);
    	eLink = ExtraordinaryEffect(eLink);
	
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    int nDuration = GetHitDice(oPC) * 5;

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));
}

void PS_HO_OutsiderMagic(object oPC, object oItem)
{
	int nSpell4, nSpell6, nSpell10, nSpell15, nSpell20, nSpell25;
	string sHeritage;
	int nClass	= GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC);
	int nLevel	= GetHitDice(oPC);
	
	if(GetIsObjectValid(oItem))
	{	sHeritage = GetLocalString(oItem, "Planar");	}
	else
	{	SendMessageToPC(oPC, "You appear to be missing your Essence. Unable to access Planar Heritage. Contact a member of staff.");	}

	if (sHeritage == "HalfFiend")
	{	nSpell4  = 2544;		//Fiendish Smiting
		nSpell6  = 2546;		//Unholy Blight
		nSpell10 = 2548;		//Rapture of Rupture
		nSpell15 = 2550;		//Fiendform
		nSpell20 = 2552;		//Summon Fiend
		nSpell25 = 2554;	}	//Gutwrench	
	else if (sHeritage == "HalfCelestial")
	{	nSpell4  = 2545;		//Celestial Smiting
		nSpell6  = 2547;		//Holy Smite
		nSpell10 = 2549;		//Crown of Flame
		nSpell15 = 2551;		//Radiant Shield
		nSpell20 = 2553;		//Summon Celestial
		nSpell25 = 2555;	}	//Resurrection
	else
	{	SendMessageToPC(oPC, "Planar heritage not found.");
		return;		}
	
	if (nClass >= 4 && !GetHasFeat(nSpell4, oPC, TRUE))
	{	FeatAdd(oPC, nSpell4, FALSE, TRUE, FALSE);		}
	if (nClass >= 6 && !GetHasFeat(nSpell6, oPC, TRUE))
	{	FeatAdd(oPC, nSpell6, FALSE, TRUE, FALSE);		}
	if (nClass >= 6 && nLevel >= 10 && !GetHasFeat(nSpell10, oPC, TRUE))
	{	FeatAdd(oPC, nSpell10, FALSE, TRUE, FALSE);		}
	if (nClass >= 6 && nLevel >= 15 && !GetHasFeat(nSpell15, oPC, TRUE))
	{	FeatAdd(oPC, nSpell15, FALSE, TRUE, FALSE);		}
	if (nClass >= 6 && nLevel >= 20 && !GetHasFeat(nSpell20, oPC, TRUE))
	{	FeatAdd(oPC, nSpell20, FALSE, TRUE, FALSE);		}
	if (nClass >= 6 && nLevel >= 25 && !GetHasFeat(nSpell25, oPC, TRUE))
	{	FeatAdd(oPC, nSpell25, FALSE, TRUE, FALSE);		}
}