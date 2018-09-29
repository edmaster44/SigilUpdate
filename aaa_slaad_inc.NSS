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


/*	This is the include file for all Slaad features.
	Every individual feature in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_slaad, which acts as the universal spell with a case-based system.
*/

void PS_StunningCroak(object oPC, int nSpell)
{
   if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLvl 		= PS_GetLevel(oPC);
	int	nEffLvl			= (nCasterLvl / 2);
	int nDC 			= (10 + nEffLvl);
	int nSave;
    effect eVis 		= EffectVisualEffect(VFX_HIT_AOE_SONIC);
    effect eStun		= EffectStunned();
	location lCenter	= GetLocation(oPC);
	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCenter, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oPC) //Additional target check to make sure that the caster cannot be harmed by this spell
        {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
            if (GetSubRace(oTarget) != 168)
			{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				nSave = MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_CHAOS, oPC);
				if (nSave == 0)
				{	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eStun, oTarget));
                } 
             }
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCenter, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void PS_SlaadImmune(object oPC, int nSpell)
{
	effect eSonic 	= EffectDamageResistance(DAMAGE_TYPE_SONIC, 9999);
	effect eAcid 	= EffectDamageResistance(DAMAGE_TYPE_ACID, 5);
	effect eCold 	= EffectDamageResistance(DAMAGE_TYPE_COLD, 5);
	effect eElec 	= EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 5);
	effect eFire 	= EffectDamageResistance(DAMAGE_TYPE_FIRE, 5);
	effect eLink 	= EffectLinkEffects(eSonic, eAcid);
		eLink		= EffectLinkEffects(eLink, eCold);
		eLink		= EffectLinkEffects(eLink, eElec);
		eLink		= EffectLinkEffects(eLink, eFire);
		eLink 		= ExtraordinaryEffect(eLink);
		eLink 		= SetEffectSpellId(eLink, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void PS_SlaadCompletelyChaotic(object oPC, int nSpell)
{
	if (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
	{	int nLawChaos = GetLawChaosValue(oPC);
		AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, nLawChaos);
	}
}

void PS_SlaadRegen_Gray(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int nLevel		= GetLevelByClass(CLASS_TYPE_GRAY_SLAAD, oPC);
		int nBonus		= (nLevel +1) / 2;
		effect eRegen	= EffectRegenerate(nBonus, 6.0f);
			eRegen		= ExtraordinaryEffect(eRegen);
			eRegen		= SetEffectSpellId(eRegen, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPC);	}
}

void PS_SlaadRegen_CoC(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int nLevel		= GetLevelByClass(CLASS_TYPE_CHAMPION_OF_CHAOS, oPC);
			nLevel		= nLevel - 2;
		if (nLevel <0) nLevel = 0;
		int nBonus		= 1 + nLevel;
		effect eRegen	= EffectRegenerate(nBonus, 6.0f);
			eRegen		= ExtraordinaryEffect(eRegen);
			eRegen		= SetEffectSpellId(eRegen, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPC);	}
}

void PS_OnHit_ChaosDamage(int nSpell, int nRank)
{
	object oTarget = GetSpellTargetObject();
    int nDamage, nType, nVFX, nRandom;
	effect eDamage, eVFX;
    
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    switch (nRank)
		{	case 1: nDamage = d4(1); break;
			case 2: nDamage = d6(1); break;
			case 3: nDamage = d8(1); break;	}
		nRandom = Random(7);
	switch (nRandom)
		{	case 0: nType = DAMAGE_TYPE_ACID;		nVFX = VFX_IMP_HEAD_ACID; break;
			case 1: nType = DAMAGE_TYPE_COLD; 		nVFX = VFX_IMP_HEAD_COLD; break;
			case 2: nType = DAMAGE_TYPE_ELECTRICAL; nVFX = VFX_IMP_HEAD_ELECTRICITY; break;
			case 3: nType = DAMAGE_TYPE_FIRE; 		nVFX = VFX_IMP_HEAD_FIRE;  break;
			case 4: nType = DAMAGE_TYPE_NEGATIVE; 	nVFX = VFX_IMP_HEAD_EVIL;  break;
			case 5: nType = DAMAGE_TYPE_POSITIVE; 	nVFX = VFX_IMP_HEAD_HOLY; break;
			case 6: nType = DAMAGE_TYPE_SONIC; 		nVFX = VFX_IMP_HEAD_SONIC; break;	}
	eDamage = EffectDamage(nDamage, nType, DAMAGE_POWER_NORMAL, FALSE);
	eVFX = EffectVisualEffect(nVFX);
	eDamage = EffectLinkEffects(eDamage, eVFX);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
}

void PS_SlaadClawsOfChaos(object oPC, int nSpell)
{
	float fDuration 	= TurnsToSeconds(3);
	object oRight 		= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oLeft 		= GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int nDamage, nIPRP;
	int nLevel 			= GetLevelByClass(CLASS_TYPE_CHAMPION_OF_CHAOS, oPC);
	effect eCast 		= EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	
	if (nLevel >= 6) 		nIPRP = IP_CONST_ONHIT_CASTSPELL_CHAOSDAM3;
	else if (nLevel >= 4) 	nIPRP = IP_CONST_ONHIT_CASTSPELL_CHAOSDAM2;
	else					nIPRP = IP_CONST_ONHIT_CASTSPELL_CHAOSDAM1;
	
	itemproperty ipEff	= ItemPropertyOnHitCastSpell(nIPRP, 1);
	
	SignalEvent(GetItemPossessor(oRight), EventSpellCastAt(oPC, GetSpellId(), FALSE));
	if (GetIsObjectValid(oRight) && GetWeaponType(oRight) != WEAPON_TYPE_NONE)
    {	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, oPC);	
		IPSafeAddItemProperty(oRight, ipEff, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		if (GetIsObjectValid(oLeft) && GetWeaponType(oLeft) != WEAPON_TYPE_NONE)
		{	IPSafeAddItemProperty(oLeft, ipEff, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);	
		}
	}
}

void PS_SlaadDR(object oPC, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int nGrayLevel	= GetLevelByClass(CLASS_TYPE_GRAY_SLAAD, oPC);
		int nCoCLevel	= GetLevelByClass(CLASS_TYPE_CHAMPION_OF_CHAOS, oPC);
		int nAmount		= 5;
		if (nGrayLevel >= 6 || nCoCLevel >= 6)
		{	nAmount 	= 10;	}
		if (GetHasFeat(FEAT_EPITHET_DEATH_SLAAD, oPC))
		{	nAmount		= 15;	}
		
		effect eDR		= EffectDamageReduction(nAmount, DR_TYPE_ALIGNMENT, 0, ALIGNMENT_LAWFUL);
			eDR			= ExtraordinaryEffect(eDR);
			eDR			= SetEffectSpellId(eDR, nSpell);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);	}
}

void PS_SlaadChaosHammer(object oPC, int nSpell, location lTarget)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLvl = PS_GetLevel(oPC);
    int nMaxLvl;
    if ( nCasterLvl > 10 )
    {	nMaxLvl = 10;	}
    else
    {	nMaxLvl = nCasterLvl;	}
	int nMaxLvlLawful = (nMaxLvl / 2);
	int nDamage;
	int nDamage2;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_AOE_ILLUSION);
    effect eDam, eDam2;
	int nVariable;
	int nDC = (14 + GetAbilityModifier(ABILITY_CHARISMA, oPC));
	int nSave;
	int nSlow = 1;
	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oPC) //Additional target check to make sure that the caster cannot be harmed by this spell
        {	fDelay = GetRandomDelay(0.15, 0.35);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
			{	if (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER && GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL)
				{	nDamage = d6(nMaxLvl);			}
				else if (GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL)
				{	nDamage = d8(nMaxLvlLawful);	}
				else if (GetAlignmentLawChaos(oTarget) == ALIGNMENT_NEUTRAL)
				{	nDamage = d8(nMaxLvlLawful) / 2;	}
				else
				{	nDamage = 0;	}
				nSave = MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_CHAOS, oPC);
				if (nSave == 1)
				{	nDamage = (nDamage / 2);
					nSlow = 0;	}
				
				if ( nDamage > 0 )
                {	eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
					if (nSlow != 0)
					{	eDam2 = EffectSlow();
						eDam = EffectLinkEffects(eDam, eDam2);	}
						
					eDam = EffectLinkEffects(eDam, eVis);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                } 
             }
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void PS_SlaadSummon(object oPC, int nSpell)
{
    int nLevel = GetTotalLevels(oPC, FALSE);
/*	Destroy any henchmen already commanded by the PC. This is required, as otherwise additional
	summonned henchmen will appear as hostile and attempt to attack the PC or the existant henchman. */
	object oOldHench= GetHenchman(oPC);
	DestroyObject(oOldHench);
	string sCritter;
	location lCaster = GetLocation(oPC);	
	
 	if (nLevel >= 23)
    {	sCritter = "ps_summslaad_gs3";	}
	else if (nLevel >= 15)
	{	sCritter = "ps_summslaad_gs2";	}
	else
	{	sCritter = "ps_summslaad_gs1";	}

    object oHench = CreateObject(OBJECT_TYPE_CREATURE, sCritter, lCaster);
	string sName = GetName(oHench);
	
//	Add the created creature as a henchman and apply the "henchman" script set
	DelayCommand(0.21, AddHenchman(oPC, oHench));
	DelayCommand(0.22, SetCreatureScriptsToSet(oHench, 10));
	SendMessageToPC(oPC,"A " + sName + " has answered your summons. Use the Release Binding feat to return it to Limbo.");
}

void PS_SlaadDiminution_Gray(object oPC, object oItem, int nSpell)
{
	object oItem	= GetItemPossessedBy(oPC,"ps_essence");	
	int nAppVar = 3399;
	PS_RestoreOriginalAppearance(oPC);
	
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.AppearanceType = nAppVar;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "Diminution", 1);
	PS_RefreshAppearance(oPC);
	DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));
}

void PS_SlaadChaoticCrafting(object oPC, object oItem, int nSpell)
{
	AddScriptParameterString("START");
	AddScriptParameterString("");
	ExecuteScriptEnhanced("gui_extra_choices", oPC);
}

void PS_SlaadApotheosis(object oPC, object oItem, int nSpell)
{
	if (!GetHasFeat(FEAT_DS_CIRCLE_OF_DEATH, oPC, TRUE))
	{	FeatAdd(oPC, FEAT_DS_CIRCLE_OF_DEATH, FALSE, TRUE, FALSE);	}
	if (!GetHasFeat(FEAT_DS_CLOAK_OF_CHAOS, oPC, TRUE))
	{	FeatAdd(oPC, FEAT_DS_CLOAK_OF_CHAOS, FALSE, TRUE, FALSE);	}
	if (!GetHasFeat(FEAT_DS_POWER_WORD_BLIND, oPC, TRUE))
	{	FeatAdd(oPC, FEAT_DS_POWER_WORD_BLIND, FALSE, TRUE, FALSE);	}
}

void PS_SlaadCircleOfDeath(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

    object oTarget;
    object oLowest;
    effect eDeath =  EffectDeath();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    int nHD = d4(PS_GetLevel(OBJECT_SELF)); //Roll to see how many HD worth of creature will be killed
	if (nHD >= 20)	nHD = 20;
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 8;
    int bContinueLoop = FALSE;
    float fDelay;
    string sIdentifier = GetTag(OBJECT_SELF);

    //Check for at least one valid object to start the main loop
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.  If no value target exists we do not enter the loop.

    while ((nHD > 0) && GetIsObjectValid(oTarget))
    {   int nLow = nMax; //Set nLow to the lowest HD creature in the last pass through the loop
        bContinueLoop = FALSE; //Set this to false so that the loop only continues in the case of new low HD creature
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
        while (GetIsObjectValid(oTarget))
        {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        	{	bAlreadyAffected = GetLocalInt(oTarget, "bDEATH" + sIdentifier);
                if (!bAlreadyAffected)
                {	nCurrentHD = GetHitDice(oTarget);
                     if(nCurrentHD < nLow && nCurrentHD <= nHD)
                     {	nLow = nCurrentHD;
                        oLowest = oTarget;
                        bContinueLoop = TRUE;
                     }
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
        }
        if(bContinueLoop == TRUE)
        {	SignalEvent(oLowest, EventSpellCastAt(OBJECT_SELF, nSpell));
            fDelay = GetRandomDelay();
            if(!MyResistSpell(OBJECT_SELF, oLowest, fDelay))
            {	if(!MySavingThrow(SAVING_THROW_FORT, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oLowest));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest));
                }
            }
            SetLocalInt(oLowest, "bDEATH" + sIdentifier, TRUE);
            DelayCommand(fDelay + 0.25, DeleteLocalInt(oLowest, "bDEATH" + sIdentifier));
            nHD = nHD - GetHitDice(oLowest);
            oLowest = OBJECT_INVALID;
        }
    }
}

void PS_SlaadCloakOfChaos(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    effect eDur 		= EffectVisualEffect(VFX_DUR_DEATH_ARMOR);
    int nDuration 		= PS_GetLevel(oPC);
	int nTargets		= PS_GetLevel(oPC);
	int nSR				= GetSpellResistance(oPC);
	int nSRBonus		= (25 - nSR);
	if (nSR <= 0) 	nSR = 0;
	int nSROther, nSRBonusOther;
	location lPC		= GetLocation(oPC);
	float fDur			= RoundsToSeconds(nDuration);

	effect eAC 			= EffectACIncrease(4, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    effect eSave 		= EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
	effect eSRSelf		= EffectSpellResistanceIncrease(nSRBonus);
		eSRSelf			= VersusAlignmentEffect(eSRSelf, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
	effect eImmune 		= EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect eShield		= EffectDamageShield(1, DAMAGE_BONUS_2d4, DAMAGE_TYPE_MAGICAL);
    effect eLink 		= EffectLinkEffects(eAC, eSave);
    	eLink 			= EffectLinkEffects(eLink, eImmune);
    	eLink 			= EffectLinkEffects(eLink, eDur);
		eLink			= EffectLinkEffects(eLink, eShield);
	effect eLinkSelf	= EffectLinkEffects(eLink, eSRSelf);
	effect eSROther, eLinkOther;

    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    if (GetHasSpellEffect(nSpell, oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);	}
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
		nTargets		= nTargets - 1;

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lPC, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{	if (spellsIsTarget( oTarget, SPELL_TARGET_ALLALLIES, oPC ))
		{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, FALSE));
			if (GetHasSpellEffect(nSpell, oPC))
			{	RemoveSpellEffects(nSpell, oPC, oTarget);	}
				nSROther 		= GetSpellResistance(oTarget);
				nSRBonusOther 	= (25 - nSROther);
				eSROther		= VersusAlignmentEffect(EffectSpellResistanceIncrease(nSRBonusOther), ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eLinkOther		= EffectLinkEffects(eLink, eSROther);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkOther, oTarget, fDur);
				nTargets		= nTargets - 1;
		}
		if (nTargets <= 0)	return;
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lPC, TRUE, OBJECT_TYPE_CREATURE);
	}	
}

void PS_SlaadPWBlind(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	object oTarget		= GetSpellTargetObject();
	int nTargetHP		= GetCurrentHitPoints(oTarget);
	effect eBlind		= EffectBlindness();
	effect eVis			= EffectVisualEffect(VFX_DUR_SPELL_POWER_WORD_BLIND);
	effect eEyes		= EffectNWN2SpecialEffectFile("fx_wraith_eyes", oTarget);
	effect eFail		= EffectNWN2SpecialEffectFile("fx_hit_spark_parry", oTarget);
	float fDuration;
	effect	eLink		= EffectLinkEffects(eBlind, eVis);
		eLink			= EffectLinkEffects(eLink, eEyes);
		eLink			= ExtraordinaryEffect(eLink);

	if (GetIsObjectValid(oTarget))
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
		{	if (!MyResistSpell(oPC, oTarget))
			{	int iTargetMaxHP = GetMaxHitPoints(oTarget);
				int iTargetHPHigh = 200;
				int iTargetHPMed = 100;
				int iTargetHPLow = 50;
	
				if	(nTargetHP > iTargetHPHigh)
				{	SendMessageToPC(oPC, "<COLOR=red>Target has too many HPs to be affected.");
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget, fDuration);
				}
				else if (nTargetHP > iTargetHPMed)
				{	fDuration = RoundsToSeconds(d4() + 1);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
				}
				else if (nTargetHP > iTargetHPLow)
				{	fDuration = TurnsToSeconds(d4() + 1);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
				}
				else
				{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
				}
			}
		}
	}
}