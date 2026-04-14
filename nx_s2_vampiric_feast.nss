//::///////////////////////////////////////////////
//:: Vampiric Feast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Spellcraft Required: 27
	Caster Level: Epic
	Innate Level: Epic
	School: Necromancy
	Components: Verbal, Somatic
	Range: Personal
	Area of Effect / Target: All hostile creatures within 20 ft. of caster.
	Duration: Instant
	Save: Fortitude ½ (DC +5)
	Spell Resistance: Yes
	 
	When this spell is cast, you drink in the life force of all enemies in
	the area of effect. Creatures who succeed at a Fortitude save (DC +5)
	lose half their remaining hit points. Those who fail their saving
	throw are instantly slain. 
	
	You are only able to absorb sufficient hit points to return you to full
	health. Any remaining life force is used to lure to your plane one Greater
	Shadow to fight by your side for every 30 hp of life force over what heals
	you (rounded up). These shadows are level 12 Rogue Undead with 90 hit points 
	each and will not interfere with your ability to summon other creatures.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/13/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//::	Remove hard HD caps, reduce radius to 20'.
//:: AFW-OEI 07/12/2007: NX1 VFX.


#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_epicsave"
#include "nw_i0_invocatns"


void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	    return;
	}
	object oCaster = OBJECT_SELF;
	int nId = GetSpellId();
	int nSaveDC = PS_GetSpellSaveDC(oCaster) + 5;
	int nMaxHeal = GetMaxHitPoints() - GetCurrentHitPoints();
	// if caster has a temp hp effect, current hp might be higher than max which would make
	// nMaxHeal a negative number
	if (nMaxHeal < 0) nMaxHeal = 0;
	int nLeftoverHP = 0;
	int nTotalDamage = 0;
	int nCurrentHP, nDamage;
	float fDelay;
	int nTargets = 0;
	string sLocVar = "ShadowLocation";
	location lCaster = GetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_VAMPIRIC_FEAST);
	effect eDamage;
	
	float fShadowDuration = RoundsToSeconds(PS_GetLevel(oCaster));
	
   	//Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE);
	location lTarget;
    while (GetIsObjectValid(oTarget)){
		// Only ever effects enemies
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)){
			SignalEvent(oTarget, EventSpellCastAt(oCaster, nId));
			
			if (!MyResistSpell(oCaster, oTarget, fDelay)){
				lTarget = GetLocation(oTarget);
				// Create a delay so that all creatures seem to be hit at the same time.
				fDelay = GetDistanceBetweenLocations(lCaster, lTarget) / 20.0;	
				nCurrentHP = GetCurrentHitPoints(oTarget);
					// Fail save, lose all your remaining HP
				if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL, oCaster, fDelay)){
					nDamage = nCurrentHP;
				} else {	// Make save, lose half of remaining HP.
					nDamage = nCurrentHP / 2;
				}
				//store the locations where shadows will spawn by being lured to this world by 
				//the life force stolen, max 8 shadows
				if (nTargets < 8){
					nTargets++;
					SetLocalLocation(oCaster, sLocVar + IntToString(nTargets), lTarget);
				}
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);	
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				nTotalDamage += nDamage;	// Accumulate total damage done for healing later.
			}		
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE);
	}

	if (nTotalDamage < 1) return;
	
	// We drained some life.
	if (nTotalDamage > nMaxHeal){
		nLeftoverHP = nTotalDamage - nMaxHeal;
	} else {
		nMaxHeal = nTotalDamage;
	}
	if (nMaxHeal > 0){		
		effect eHeal = EffectHeal(nMaxHeal);
		int nHealFX = VFX_IMP_HEALING_L;
		if (nMaxHeal >= 100) nHealFX = VFX_IMP_HEALING_X;
		else if (nMaxHeal >= 75) nHealFX = VFX_IMP_HEALING_G;
		else if (nMaxHeal >= 50) nHealFX = VFX_IMP_HEALING_S;
		else if (nMaxHeal >= 25) nHealFX = VFX_IMP_HEALING_M;
		effect eHealVis = EffectVisualEffect(nHealFX);
		eHeal = EffectLinkEffects(eHealVis, eHeal);

		DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster));
	}
	if (nLeftoverHP < 1) return;
	
	int nShadows = PS_RoundToInt(IntToFloat(nLeftoverHP) / 30.0, 1);
	if (nShadows > 8) nShadows = 8;
	if (nShadows > 0){
		location lSpawn;
		object oShadow;
		effect eShadow = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
		int nCalled = GetLocalInt(oCaster,"WARLOCK_UNDEAD_CALLED");  
		int i = 0;
		for (i = 0; i < nShadows; i++){
			nCalled++;
			lTarget = GetLocalLocation(oCaster, sLocVar + IntToString(i));
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShadow, lTarget);
			oShadow = CreateObject(OBJECT_TYPE_CREATURE, "ps_summon_warlockshadow", lTarget);
			SetLocalObject(oShadow, abilityCaster, oCaster);
			SetLocalObject(oShadow, "FOLLOW_MASTER", oCaster);
			SetLocalInt(oShadow, "IS_SUMMONED", 1);
			SetLocalObject(oCaster, "WARLOCK_UNDEAD_"+IntToString(nCalled), oShadow);
			SetLocalInt(oCaster, "WARLOCK_UNDEAD_CALLED", nCalled);
			//Sanity destroy so you can keep summoning more
			DestroyObject(oShadow, fShadowDuration); 
		}
	}

	
}

/* original

#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_epicsave"
#include "nw_i0_invocatns"


void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	    return;
	}
	
	int nSaveDC = PS_GetSpellSaveDC(OBJECT_SELF) + 5;
	int nTotalDamage = 0;
	int bSummonShadow = 0;
	//int nHD, nCurrentHP, nDamage;
	int nCurrentHP, nDamage;
	float fDelay;

	location lCaster = GetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_VAMPIRIC_FEAST);
	effect eShadow = EffectSummonCreature("c_greater_shadow", VFX_FNF_SUMMON_UNDEAD);
	effect eDamage;
	
	float fShadowDuration = RoundsToSeconds(GetTotalLevels(OBJECT_SELF, TRUE));
	
   	//Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))	// Only ever effects enemies
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
			//nHD = PS_GetLevel(oTarget);
			nCurrentHP = GetCurrentHitPoints(oTarget);
			fDelay = GetDistanceBetweenLocations(lCaster, GetLocation(oTarget))/20;	// Create a delay so that all creatures seem to be hit at the same time.
			
			//if (nHD <= 22 && !MyResistSpell(OBJECT_SELF, oTarget, fDelay))	// Creatures under over 22 HD are immune.
			if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
				if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
				{	// Fail save, lose all your remaining HP
					nDamage = nCurrentHP;
					//bSummonShadow++;	// We killed at least one person.
					DelayCommand(fDelay, DoWraithExtraction(OBJECT_SELF, oTarget, GetLocation(oTarget), fShadowDuration));
				}
				else
				{	// Make save, lose half of remaining HP.
					nDamage = nCurrentHP/2;
				}
				
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);	// Last flag is to ignore all resistances & immunities.
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				
				nTotalDamage += nDamage;	// Accumulate total damage done for healing later.
			}		
		}
	
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lCaster, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	if (nTotalDamage > 0)	// We drained some life.
	{
		effect eHeal = EffectHeal(nTotalDamage);
		DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF));
	}
	
//	if (bSummonShadow)	// Somone got killed, so summon a Greater Shadow.
//	{
//		float fDuration = RoundsToSeconds(GetTotalLevels(OBJECT_SELF, TRUE));
//		DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, OBJECT_SELF, fDuration));
//	}
}
*/