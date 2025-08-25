#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_inc_faction"
#include "x2_inc_itemprop"
#include "x2_inc_toollib"
#include "nwn2_inc_metmag"
#include "ps_inc_time"

/*	This is the include file for cleric domain powers and spells introduced as part of custom domains.

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////					Let The Magic Begin!								//////////
	//////////////////////////////////////////////////////////////////////////////////////////	*/


	
void PS_Balance_InsightfulDefense(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
	{	return;  }

	int iBonus      	= GetAbilityModifier(ABILITY_WISDOM, oPC);
	effect eArmor  		= EffectACIncrease(iBonus, AC_DODGE_BONUS);
	float fDuration		= RoundsToSeconds(10 + PS_GetCasterLevel(OBJECT_SELF));
		fDuration   	= ApplyMetamagicDurationMods(fDuration);
	effect eDur			= EffectVisualEffect(VFX_DUR_INNER_ARMOR);
	int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	effect eLink = EffectLinkEffects(eArmor, eDur);

	if (GetLevelByClass(CLASS_TYPE_MONK, oPC) == 0)
	{
   		RemoveEffectsFromSpell(oPC, GetSpellId());
		RemoveEffectsFromSpell(oPC, 2502);
   		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
   	}
 	else
	{
   		SendMessageToPC(oPC, "This spell cannot be used in conjunction with Monk AC.");
   		return;
 	}
}

void PS_Spell_NegateConcealment(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	    }

	object	oTarget		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE);
	int nGAD            = PS_GetCasterLevel(OBJECT_SELF);
	float fDuration		= RoundsToSeconds(nGAD);
	int	nDurType		= ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	effect eNegate		= EffectConcealmentNegated();
	effect eDur			= EffectNWN2SpecialEffectFile("sp_flamingaura_yellow", oTarget);
	effect eLink		= EffectLinkEffects(eNegate, eDur);
		eLink 			= SupernaturalEffect(eLink);
	
	fDuration			= ApplyMetamagicDurationMods(fDuration);
	
	while (GetIsObjectValid(oTarget))
	{
		//if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
		{	if(!MyResistSpell(OBJECT_SELF, oTarget))
			{	RemoveEffectsFromSpell(oTarget, nSpell);
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
				ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE);
	}
}

void PS_Spell_MassSanctuary(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	    }

    int nCasterLvl 		= PS_GetCasterLevel(OBJECT_SELF);
    int nDuration 		= nCasterLvl;
    int nDurType 		= ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lTarget 	= GetSpellTargetLocation();

	effect eDur 		= EffectVisualEffect(VFX_DUR_SPELL_SANCTUARY);
    effect eSanc 		= EffectSanctuary(GetSpellSaveDC());
    effect eLink 		= EffectLinkEffects(eDur, eSanc);

    object oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    effect eHit			= EffectNWN2SpecialEffectFile("sp_sanctuary_cess", oTarget);

	int nMetaMagic		= GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {	nDuration		= nDuration *2;	}
	
	float fDuration		= RoundsToSeconds(nDuration);
	int nCount			= (nCasterLvl +1) / 2;
	
	while (GetIsObjectValid(oTarget) && nCount > 0)
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
		{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
   			RemoveEffectsFromSpell(oTarget, SPELL_SANCTUARY);
   			RemoveEffectsFromSpell(oTarget, nSpell);

    		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			nCount --;
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}

void PS_Spell_WeighedInTheBalance(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	    }
	
	int nCasterLevel	= PS_GetCasterLevel(OBJECT_SELF);
	int nEdgeLevel		= nCasterLevel;
	int nUndeadLevel	= nCasterLevel;

	location lTarget	= GetSpellTargetLocation();

	int nHealCenter		=  (nCasterLevel*5);
	int nDamCorner, nDamEdge, nDamUndead, nGoodEvil, nLawChaos;
	
	effect eDamCorner, eDamEdge, eDamUndead, eHealCenter;

	object oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	
	while (GetIsObjectValid(oTarget))
	{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
		{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
			nDamCorner			= d12(nCasterLevel);
			nDamEdge			= d8(nCasterLevel);
			nDamUndead			= nUndeadLevel * 5; 
						
			if (!MyResistSpell(OBJECT_SELF, oTarget))
			{	if (MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC))
				{	nDamCorner 	= nDamCorner / 2;
					nDamEdge 	= nDamEdge / 2;
					nDamUndead 	= nDamUndead / 2;
				}
				nGoodEvil	= GetAlignmentGoodEvil(oTarget);
				nLawChaos	= GetAlignmentLawChaos(oTarget);
				
				eDamCorner	= EffectDamage(nDamCorner, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL);
				eDamEdge	= EffectDamage(nDamEdge, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL);
				eDamUndead	= EffectDamage(nDamUndead, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL);
				eHealCenter	= EffectHeal(nHealCenter);
			
				if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamUndead, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_GOOD && nLawChaos == ALIGNMENT_LAWFUL)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamCorner, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_GOOD && nLawChaos == ALIGNMENT_CHAOTIC)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamCorner, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_EVIL && nLawChaos == ALIGNMENT_LAWFUL)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamCorner, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_EVIL && nLawChaos == ALIGNMENT_CHAOTIC)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamCorner, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_GOOD && nLawChaos == ALIGNMENT_NEUTRAL)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamEdge, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_EVIL && nLawChaos == ALIGNMENT_NEUTRAL)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamEdge, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_NEUTRAL && nLawChaos == ALIGNMENT_LAWFUL)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamEdge, oTarget);	}
				else if (nGoodEvil == ALIGNMENT_NEUTRAL && nLawChaos == ALIGNMENT_CHAOTIC)
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamEdge, oTarget);	}
				else
				{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealCenter, oTarget);	}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}	
}

void PS_Spell_Demonflesh(object oPC, object oTarget, int nSpell)
{   if (!X2PreSpellCastCode())
	{	return;		}

	int nCasterLevel	= PS_GetCasterLevel(OBJECT_SELF);
    int nBonus;
    float fDuration		= HoursToSeconds(nCasterLevel);
    effect eVis			= EffectNWN2SpecialEffectFile("sp_skin_102", oPC);
    effect eAC;

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));
    	fDuration 		= ApplyMetamagicDurationMods(fDuration);
    int nDurType 		= ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Determine AC Bonus based Level.
    if (nCasterLevel <= 3)
    {	nBonus = 1;		}
    else if (nCasterLevel <= 7)
    {   nBonus = 2;		}
    else if (nCasterLevel <=11)
    {   nBonus = 3;		}
    else if (nCasterLevel <=15)
	{	nBonus = 4;		}
	else
	{	nBonus = 5;		}

    eAC = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
    effect eLink = EffectLinkEffects(eVis, eAC);

	if ((GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER) && (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL))
	{	SendMessageToPC(oTarget,"This spell has no effect upon evil Outsiders.");	}
	else
	{	ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);	}
}

void PS_Spell_Hellfire(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLvl 		= PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic 		= GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    
    effect eFire 		= EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	effect eDark 		= EffectVisualEffect(VFX_HIT_SPELL_EVIL);
    effect eDam;
    //Limit Caster level for the purposes of damage
    
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    	{	if ((GetSpellId() == 1604))
            {	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        	    {	nDamage = d8(3) + nCasterLvl;
            	    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {	nDamage = nDamage + ((3*nDamage)/4);;	}
        	        else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {	nDamage = nDamage + nDamage / 2;	}
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                    if(nDamage > 0)
                    {	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDark, oTarget));	}
                 }
             }
        }
    	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void PS_Spell_HellfireStorm(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLvl 		= PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic 		= GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eFire 		= EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	effect eDark 		= EffectVisualEffect(VFX_HIT_SPELL_EVIL);
    effect eDam;

    

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
    	{	if ((GetSpellId() == 1605))
            {	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!MyResistSpell(oPC, oTarget, fDelay))
        	    {	nDamage = d6(nCasterLvl);
            	    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {	nDamage = nDamage + ((3*nDamage)/4);;	}
        	        else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {	 nDamage = nDamage + nDamage / 2;	}
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                    if(nDamage > 0)
                    {	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDark, oTarget));	}
                 }
             }
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void PS_Spell_PlanarCall(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLevel	= PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic		= GetMetaMagicFeat();
    float fDuration		= IntToFloat(nCasterLevel)/2 * 30.0f;
    effect eSummon;
	effect eVFX			= EffectNWN2SpecialEffectFile("sp_summon_creature_1", oPC);
	int iDomain;
	// Ascertain the caster has one of the four planar domain feats.
	if(GetHasFeat(2602,OBJECT_SELF,TRUE)) //Celestial
	{	iDomain 	= 0;		}
	else if(GetHasFeat(2604,OBJECT_SELF,TRUE)) //Arboreal
	{	iDomain		= 1;		}
	else if(GetHasFeat(2606,OBJECT_SELF,TRUE)) //Demonic
	{	iDomain 	= 2;		}
	else if(GetHasFeat(2608,OBJECT_SELF,TRUE)) //Diabolic
	{	iDomain 	= 3;		}
	else 
	{	SendMessageToPC(OBJECT_SELF,"You do not have the planar domain necessary to cast this spell.");
		return;		}
		
    if (nMetaMagic == METAMAGIC_EXTEND)
    {	fDuration 	= fDuration *2;	}
    float fDelay 	= 2.0;

	switch (iDomain)
    {
        case 0:
			eSummon = EffectSummonCreature("ps_summ_planarcall_lg",VFX_HIT_SPELL_SUMMON_CREATURE, fDelay);
        break;
		
        case 1:
            eSummon = EffectSummonCreature("ps_summ_planarcall_cg", VFX_HIT_SPELL_SUMMON_CREATURE, fDelay);
         break;
		
        case 2:
            eSummon = EffectSummonCreature("ps_summ_planarcall_ce", VFX_HIT_SPELL_SUMMON_CREATURE, fDelay);
        break;
		
        case 3:
            eSummon = EffectSummonCreature("ps_summ_planarcall_le", VFX_HIT_SPELL_SUMMON_CREATURE, fDelay);
        break;    
	}
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
}

void PS_Celestial_CelestialGlory(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nDuration	= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
	
    effect eCha		= EffectAbilityIncrease(ABILITY_CHARISMA, 6);
    effect eDR		= EffectDamageReduction(10, ALIGNMENT_EVIL, 0, DR_TYPE_ALIGNMENT);
	effect eAC		= EffectACDecrease(1, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    effect eDur		= EffectVisualEffect( VFX_DUR_SPELL_AURA_OF_GLORY );
    effect eLink	= EffectLinkEffects(eCha, eDR);
		eLink		= EffectLinkEffects(eLink, eAC);
		eLink		= EffectLinkEffects(eLink, eDur);
    eLink = SupernaturalEffect(eLink);

   	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds (nDuration));
}

void PS_Arboreal_WhirlingFury(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;	}

    int nDuration	= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    effect eDex 	= EffectAbilityIncrease(ABILITY_DEXTERITY, 6);
	effect eHaste 	= EffectHaste();
    effect eDur 	= EffectVisualEffect( VFX_DUR_SPELL_HASTE );
    effect eLink 	= EffectLinkEffects(eDex, eHaste);
		eLink 		= EffectLinkEffects(eLink, eDur);
	    eLink 		= SupernaturalEffect(eLink);

   	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds (nDuration));
}

void PS_Demonic_AbyssalFrenzy(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nDuration 	= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    effect eStr 	= EffectAbilityIncrease(ABILITY_STRENGTH, 6);
	effect eCon 	= EffectAbilityIncrease(ABILITY_CONSTITUTION, 6);
    effect eDR 		= EffectDamageReduction(10, ALIGNMENT_GOOD, 0, DR_TYPE_ALIGNMENT);
	effect eAC 		= EffectACDecrease(1, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    effect eDur 	= EffectVisualEffect( VFX_DUR_SPELL_RAGE );
    effect eLink 	= EffectLinkEffects(eStr, eCon);
		eLink 		= EffectLinkEffects(eLink, eDR);
		eLink 		= EffectLinkEffects(eLink, eAC);
		eLink 		= EffectLinkEffects(eLink, eDur);
	    eLink = SupernaturalEffect(eLink);

   	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds (nDuration));
}

void PS_Diabolic_InfernalDeceit(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nDuration	= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    effect eBluff	= EffectSkillIncrease(SKILL_BLUFF, nDuration);
    effect eDiplo	= EffectSkillIncrease(SKILL_DIPLOMACY, nDuration);
    effect eIntim	= EffectSkillIncrease(SKILL_INTIMIDATE, nDuration);
    effect eDR		= EffectDamageReduction(10, ALIGNMENT_CHAOTIC, 0, DR_TYPE_ALIGNMENT);
    effect eDur		= EffectVisualEffect( VFX_DUR_SPELL_EVIL_AURA );
    effect eLink	= EffectLinkEffects(eBluff, eDiplo);
		eLink		= EffectLinkEffects(eLink, eIntim);
		eLink		= EffectLinkEffects(eLink, eDR);
		eLink		= EffectLinkEffects(eLink, eDur);
	    eLink		= SupernaturalEffect(eLink);

   	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds (nDuration));
}

void PS_Spell_WretchedBlight(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLvl	= PS_GetCasterLevel(OBJECT_SELF);
	if (nCasterLvl > 15)
	{	nCasterLvl 	= 15;	}
	int nMetaMagic 	= GetMetaMagicFeat();
    int nDamage;
    int nVariable 	= nCasterLvl/3;
    float fDelay;
    effect eDark 	= EffectVisualEffect(VFX_DUR_DARKNESS);
	effect eVis 	= EffectVisualEffect(VFX_HIT_SPELL_EVIL);
    effect eDam;
	effect eStun 	= EffectStunned();
	float fDur 		= RoundsToSeconds(d4(1));

    object oTarget 	= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    DelayCommand(0.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDark, lTarget));	
	
	while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    	{   SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
            if (!MyResistSpell(oPC, oTarget, fDelay))
    	    {	nDamage = d8(nCasterLvl);
    	    	if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {	nDamage = nDamage + ((3*nDamage)/4);;;	 }
    	        else if (nMetaMagic == METAMAGIC_EMPOWER)
                {	nDamage = nDamage + (nDamage / 2);	}
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
				if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)	
                {	int nSave = FortitudeSave( oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC);                
					if ( nSave == 0 ) // Saving Throw failed
					{	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                		DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDur));
                		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	}
					else if ( nSave == 1 )
					{	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	}
				}
             	else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)	
                {	int nSave = FortitudeSave( oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC );                
					eDam = EffectDamage(nDamage/2, DAMAGE_TYPE_DIVINE);
                	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void PS_Spell_GhaeleRay(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLevel 	= PS_GetCasterLevel(OBJECT_SELF);
	int nTouch      	= TouchAttackRanged(oTarget);
	int nMetaMagic = GetMetaMagicFeat();
	if (nCasterLevel <= 0)
		nCasterLevel = 1;
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
	{   SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
	    {   if (!MyResistSpell(oPC, oTarget))
	        {	int nDamage;
	            //Check for evil outsider
	            if (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
	            {	nDamage = d4(nCasterLevel);
					nDamage = ApplyMetamagicVariableMods(nDamage, nCasterLevel*6);
					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
					{	nDamage = d4(nCasterLevel*2);
						//Resolve metamagic
						if (nMetaMagic == METAMAGIC_MAXIMIZE)
						{
						nDamage = nDamage + ((3*nDamage)/4);
						}
						else if (nMetaMagic == METAMAGIC_EMPOWER)
						{
						nDamage = nDamage + nDamage / 2;
						}
						
					}					
				}
	            else
	            {   
	                nDamage = d4(nCasterLevel/2);
					nDamage = ApplyMetamagicVariableMods(nDamage, nCasterLevel*8);
					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
					{	nDamage = d4(nCasterLevel);
						//Resolve metamagic
						if (nMetaMagic == METAMAGIC_MAXIMIZE)
						{
						nDamage = nDamage + ((3*nDamage)/4);
						}
						else if (nMetaMagic == METAMAGIC_EMPOWER)
						{
						nDamage = nDamage + nDamage / 2;
						}
						
					}					
				}
	
	            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
    			effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SEARING_LIGHT );
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	        }
		}
    }
    effect eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}

void PS_Spell_StormOfShards(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLvl 		= PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic 		= GetMetaMagicFeat();
    int nDamage;
    int nVariable 		= nCasterLvl/3;
    float fDelay;
    effect eVis 		= EffectVisualEffect(VFX_HIT_SPELL_HOLY);
    effect eDam;
	effect eBlind 		= EffectNewBlindness();
    location lTarget 	= GetSpellTargetLocation();
    object oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    while (GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    	{	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	    {	nDamage = d8(nCasterLvl);
        	    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {	nDamage = nDamage + ((3*nDamage)/4);;	}
    	        else if (nMetaMagic == METAMAGIC_EMPOWER)
                {	nDamage = nDamage + (nDamage / 2);	}
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
				if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)	
                {	int nSave = FortitudeSave( oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC );                
					if ( nSave == 0 ) // Saving Throw failed
					{	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                		DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget));
                		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	}
					else if ( nSave == 1 )
					{	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	}
				}
             }
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void PS_Spell_HeavenlyLightning(object oPC, object oFirstTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLevel 	= PS_GetCasterLevel(OBJECT_SELF);
    int nDamage 		= (d8(3)) + (nCasterLevel);
    int nDamStrike;
    int nNumAffected 	= 0;
    int nMetaMagic 		= GetMetaMagicFeat();
    effect eLightning 	= EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_HAND);;
    effect eVis  		= EffectVisualEffect(VFX_HIT_SPELL_HOLY);
    effect eDamage;
    object oHolder;
    object oTarget;
    location lSpellLocation;

    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {	nDamage = nDamage + ((3*nDamage)/4);;	}	//Damage is at max
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {	nDamage = nDamage + (nDamage/2);	}	//Damage/is +50%
    if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
    {   SignalEvent(oFirstTarget, EventSpellCastAt(oPC, SPELL_CHAIN_LIGHTNING));
        if (!MyResistSpell(oPC, oFirstTarget))
        {	eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            if(nDamStrike > 0)
            {   ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oFirstTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);	}
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);
    float fDelay = 0.2;
    int nCnt = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget) && nCnt < (nCasterLevel)/2)
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && oTarget != oPC)
        {	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
            SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));

            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {   nDamage = (d8(3)) + (nCasterLevel) ;
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {	nDamage = nDamage + ((3*nDamage)/4);;	}	//Damage is at max
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {	nDamage = nDamage + (nDamage/2);	}	//Damage/is +50%
                nDamStrike = nDamage;
                eDamage = EffectDamage(nDamStrike, DAMAGE_TYPE_DIVINE);
                if(nDamStrike > 0) //age > 0)
                {	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));	}
            }
            oHolder = oTarget;
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {	eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);	}
            else
            {	effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning))
                {	eLightning =  eNewLightning;	}
            }
            fDelay = fDelay + 0.1f;
			if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        	{	nCnt++;		}
		}
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
	}
}

void PS_Spell_HeavenlyLightningStorm(object oPC, object oFirstTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nCasterLevel 	= PS_GetCasterLevel(OBJECT_SELF);
    int nDamage 		= d6(nCasterLevel);
    int nDamStrike;
    int nNumAffected 	= 0;
    int nMetaMagic 		= GetMetaMagicFeat();
    effect eLightning 	= EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_HAND);;
    effect eVis  		= EffectVisualEffect(VFX_HIT_SPELL_HOLY);
    effect eDamage;
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;

    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {	nDamage = nDamage + ((3*nDamage)/4);;	}	//Damage is at max
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {	nDamage = nDamage + (nDamage/2);	}	//Damage/is +50%
    if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC))
    {	SignalEvent(oFirstTarget, EventSpellCastAt(oPC, nSpell));
        if (!MyResistSpell(OBJECT_SELF, oFirstTarget))
        {	eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            if(nDamStrike > 0)
            {	ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oFirstTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);	}
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);
    float fDelay = 0.2;
    int nCnt = 0;
	
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget) && nCnt < (nCasterLevel))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && oTarget != oPC)
        {   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_CHAIN_LIGHTNING));
            //Do an SR check
            if (!MyResistSpell(oPC, oTarget, fDelay))
            {	nDamage = (d6(nCasterLevel));
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {	nDamage = nDamage + ((3*nDamage)/4);;	}	//Damage is at max	
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {	nDamage = nDamage + (nDamage/2);	}	//Damage/is +50%
                nDamStrike = nDamage;
                eDamage = EffectDamage(nDamStrike, DAMAGE_TYPE_DIVINE);
                if(nDamStrike > 0) //age > 0)
                {	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));	}
            }
            oHolder = oTarget;
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {	eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);	}
            else
            {	effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning))
                {	eLightning =  eNewLightning;	}
            }
            fDelay = fDelay + 0.1f;
	        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    	    {	nCnt++;		}
		}
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
	}
}

void PS_Spell_DragonAlly(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nMetaMagic 		= GetMetaMagicFeat();
    int nCasterLevel 	= GetCasterLevel(OBJECT_SELF);
    float fDuration 	= GetCasterLevel(OBJECT_SELF) * 60.0f;
    effect eSummon;
    int nRacial 		= GetRacialType(oTarget);
    int nAlign 			= GetAlignmentGoodEvil(OBJECT_SELF);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {	fDuration 		= fDuration *2;	}	//Duration is +100%
    float fDelay = 3.0;
    switch (nAlign)
    {	case ALIGNMENT_EVIL:
		{	eSummon = EffectSummonCreature("ps_summon_da_evil",VFX_HIT_SPELL_SUMMON_CREATURE, fDelay);
        	break;	}
        case ALIGNMENT_GOOD:
        {	eSummon = EffectSummonCreature("ps_summon_da_good", VFX_HIT_SPELL_SUMMON_CREATURE, fDelay);
        	break;	}
		case ALIGNMENT_NEUTRAL:
        {	eSummon = EffectSummonCreature("ps_summon_da_neut",VFX_HIT_SPELL_SUMMON_CREATURE, 1.0);
	        break;	}
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}

void PS_Wrath_RetributiveStrike(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	
	object oTarget 		= GetLastDamager(oPC);
	int nLevel			= (PS_GetCasterLevel(OBJECT_SELF) + 1) / 2;
	int nDamage			= d8(nLevel);
	effect eDamage		= EffectDamage(nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);
	effect eVis			= EffectNWN2SpecialEffectFile("sp_frightful_hit", oTarget);
	effect eLink		= EffectLinkEffects(eDamage, eVis);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
}

void PS_Entropy_EntropicBolt(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	object oTarget = GetSpellTargetObject();
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
	int nDice = nCasterLevel / 2;
	int nDamage = 0;
	// Calculate max damage.
		
	int nTouch = TouchAttackRanged(oTarget);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{	nDice = nDice * 2;	}
	nDamage = d8(nDice);
	nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_SONIC);
	effect eNormal, eLink;
	effect eUnresi	= EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	effect eVFX = EffectNWN2SpecialEffectFile("sp_sonic_hit", oTarget);
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	int iSave = MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC());
			if(iSave = 2)
			{	eLink = EffectLinkEffects(eUnresi, eVFX);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);	}
			else if (iSave = 1)
			{	eNormal = EffectDamage(nDamage / 2, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL);
				eLink = EffectLinkEffects(eNormal, eUnresi);
				eLink = EffectLinkEffects(eLink, eVFX);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);	}
			else
			{	eNormal = EffectDamage(nDamage, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL);
				eLink = EffectLinkEffects(eNormal, eUnresi);
				eLink = EffectLinkEffects(eLink, eVFX);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);	}
		}
	}
}

void PS_Spell_RadiantShield(object oPC, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}
	
    effect eDur 		= EffectNWN2SpecialEffectFile("fx_aurora_chain_glow");
	effect eLight		= EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20);
		eDur			= EffectLinkEffects(eDur, eLight);
    float fDuration		= TurnsToSeconds(PS_GetCasterLevel(OBJECT_SELF));
	int nDamage			= PS_GetCasterLevel(OBJECT_SELF) / 2;
	effect eRadiant		= EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL);
	effect eResist		= EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 50);
	effect eLink		= EffectLinkEffects(eDur, eRadiant);

    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
    if (GetHasSpellEffect(nSpell, oPC))
    {	RemoveSpellEffects(nSpell, oPC, oPC);	}

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
}

// Helper function for PS_Spell_VengeanceHalo
// Runs "fake heartbeat" to determine if 
void PS_VengeanceHaloContingency(object oTarget, int nDuration, int nLevel, int nSaveDC)
{
	int nDam			= d6(nLevel*2);
	effect eVengeance;
	effect eBeam		= EffectBeam(VFX_BEAM_HOLY, oTarget, BODY_NODE_CHEST);
	effect eImpact		= EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	object oKiller		= GetLastKiller();

	if (!PS_GetHasTimePassed_Seconds(oTarget, "HaloVeng", nDuration))
	{	if (GetIsDead (oTarget))
		{	DeleteLocalInt(oTarget, "HaloVeng");
			if (!MyResistSpell(oTarget, oKiller))
			{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeam, oTarget);
				if (MySavingThrow(SAVING_THROW_REFLEX, oKiller, nSaveDC) == 1)
				{	eVengeance	= EffectDamage(nDam/2, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL);
					eVengeance	= EffectLinkEffects(eVengeance, eImpact);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVengeance, oKiller);	}
				else
				{	eVengeance	= EffectDamage(nDam, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL);
					eVengeance	= EffectLinkEffects(eVengeance, eImpact);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVengeance, oKiller);	}
			}
		}
	}
	else
	{	DelayCommand(6.0f, PS_VengeanceHaloContingency(oTarget, nDuration, nLevel, nSaveDC));	}
}

void PS_Spell_VengeanceHalo(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	
	effect eHalo		= EffectNWN2SpecialEffectFile("vfx_rds_glowhead", oTarget);
	int nStamp;
	int nLevel			= PS_GetCasterLevel(OBJECT_SELF);
	float fDuration		= TurnsToSeconds(nLevel);
	int nDuration		= FloatToInt(fDuration);
	int nSaveDC			= GetSpellSaveDC();
	
	if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	{	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		PS_Timestamp_UNIX(oTarget, "HaloVeng");
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHalo, oTarget, fDuration);
		AssignCommand(oTarget, PS_VengeanceHaloContingency(oTarget, nDuration, nLevel, nSaveDC));
	}	
}

// Helper function for PS_Spell_LastJudgment
// Returns TRUE if target is evil humanoid, monstrous humanoid, or giant
int PS_GetIsLastJudgmentTarget(object oTarget)
{
	int nTarget			= GetRacialType(oTarget);
	int nAlign			= GetAlignmentGoodEvil(oTarget);
	
	if (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL)
	{	return FALSE;	}
	
	switch (nTarget)
	{
		case 0:		return TRUE;	// Dwarf
		case 1:		return TRUE;	// Elf
		case 2:		return TRUE;	// Gnome
		case 3:		return TRUE;	// Halfling
		case 4:		return TRUE;	// Half-elf
		case 5:		return TRUE;	// Half-Orc
		case 6:		return TRUE;	// Human
		case 12:	return TRUE;	// Goblinoid
		case 13:	return TRUE;	// Monstrous
		case 14:	return TRUE;	// Orc
		case 15:	return TRUE;	// Reptilian
		case 18:	return TRUE;	// Giant
		case 21:	return TRUE;	// Planetouched
		case 26:	return TRUE;	// Humanoid
		case 31:	return TRUE;	// Yuan-ti
		case 32:	return TRUE;	// Orc
		case 33:	return TRUE;	// Native Outsider
	}
	return FALSE;
}

void PS_Spell_LastJudgment(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	
	effect eDeath		= EffectDeath(FALSE, FALSE, FALSE, TRUE);
	effect eDrain		= EffectAbilityDecrease(ABILITY_WISDOM, d6(3));
	effect eVFX			= EffectNWN2SpecialEffectFile("fx_akachi_eater_hit", oTarget);
	effect eFail		= EffectNWN2SpecialEffectFile("fx_b_spell_failure01", oPC);
	
	if (!PS_GetIsLastJudgmentTarget(oPC))
	{	SendMessageToPC(oPC, "Last Judgment only effects evil humanoids, monstrous humanoids, and giants.");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oPC);
		return;	}	
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
	{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		if (!MyResistSpell(oPC, oTarget))
		{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
			if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH))
			{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);	}
			else
			{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDrain, oTarget);	}
		}
	}
}

void PS_Spell_RayOfExhaustion(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nDuration	= PS_GetCasterLevel(OBJECT_SELF);
    effect eExhaust	= EffectExhausted();
	effect eFatigue = EffectFatigue();
	effect eVFX		= EffectNWN2SpecialEffectFile("fx_spell_fatigue02");
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    {	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS) 
		{	if (!MyResistSpell(oPC, oTarget))
        	{	RemoveEffectsFromSpell(oTarget, nSpell);
    			int nMetaMagic = GetMetaMagicFeat();
                if (nMetaMagic == METAMAGIC_EXTEND)
                {	nDuration = nDuration * 2;	}
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
				if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
				{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExhaust, oTarget, TurnsToSeconds(nDuration));	}
				else
				{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFatigue, oTarget, TurnsToSeconds(nDuration));	}
			}
        }
 	    effect eRay = EffectBeam(VFX_BEAM_NECROMANCY, oPC, BODY_NODE_HAND);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
    }
}

void PS_Spell_ScintillatingPattern(object oPC, location lTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
	
	effect ePattern		= EffectAreaOfEffect(AOE_MOB_SCINTILLATING_PATTERN);
	effect eVFX			= EffectNWN2SpecialEffectFile("sp_scintillating_pattern"); 
	float fDuration		= RoundsToSeconds(PS_GetCasterLevel(OBJECT_SELF));

	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lTarget, fDuration);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePattern, lTarget, fDuration);
}