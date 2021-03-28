//::///////////////////////////////////////////////
//:: Living Undeath
//:: nx2_s0_living_undeath.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Living Undeath
	Necromancy
	Level: Cleric 2
	Components: V, S
	Range: Touch
	Target: Creature Touched
	Duration: 1 minute/level
	 
	The spell imparts a physical transformation upon the subject, not unlike the process that produces a zombie.  
	While the subject does not actually become undead, its vital processes are temporarily bypassed with no seeming ill effect.  
	The subject is not subject to sneak attacks and critical hits for the duration of this spell, as though it were undead.
	 
	While the spell is in effect, the subject takes a -4 penalty to Charisma score (to a minimum of 1).
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic
//:: RPGplayer1 11/22/2008: Will properly set CHA to 1, if below 5

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
//	SendMessageToPC(GetFirstPC(), "xxx");	

    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	// Get necessary objects
	object oTarget			= GetSpellTargetObject();
	object oCaster			= OBJECT_SELF;
	int nCasterLevel		= GetCasterLevel(oCaster);
	
	
	// Spell Duration
	float fDuration			= TurnsToSeconds(1);
	fDuration			= ApplyMetamagicDurationMods(fDuration);

	// Effects
	int nDecrease 			= 4;
	int nTemp 				= GetAbilityScore(oTarget, ABILITY_CHARISMA) - nDecrease;
	if (nTemp < 1)
		//nDecrease = abs(nTemp) + 1;
		nDecrease = nTemp + 3;
	if(GetAbilityScore(oTarget, ABILITY_CHARISMA) == 1)
		nDecrease = 0;
	effect eImmuneSA 		= EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eImmuneCH		= EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	effect eDecreaseChar	= EffectAbilityDecrease(ABILITY_CHARISMA, nDecrease);
	effect eVisual			= EffectVisualEffect(VFX_HIT_SPELL_LIVING_UNDEATH);
	effect eFrame			= EffectVisualEffect(VFX_DUR_SPELL_LIVING_UNDEATH);
	effect eLink 			= EffectLinkEffects(eImmuneSA, eImmuneCH);
	eLink 					= EffectLinkEffects(eLink, eFrame);
	 
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		RemoveEffectsFromSpell(oTarget, GetSpellId());	
		// check to see if ally
		
			//____________________________________________________
			// pelhikano fix
	int hadDW = 0;
	if (GetHasSpellEffect(SPELL_DEATH_WARD, oTarget))
	{
		RemoveSpellEffectsFromCaster(SPELL_DEATH_WARD, oTarget, OBJECT_INVALID);
		hadDW = 1;
	}
	
	int hadMDW = 0;
	if (GetHasSpellEffect(SPELL_MASS_DEATH_WARD, oTarget))
	{
		RemoveSpellEffectsFromCaster(SPELL_MASS_DEATH_WARD, oTarget, OBJECT_INVALID);
		hadMDW = 1;
	}
	
	int hadUEF = 0;
	if (GetHasSpellEffect(SPELL_UNDEATHS_ETERNAL_FOE, oTarget))
	{
		RemoveSpellEffectsFromCaster(SPELL_UNDEATHS_ETERNAL_FOE, oTarget, OBJECT_INVALID);
		hadUEF = 1;
	}
			//____________________________________________________
			
			// apply linked effect to target
			//_________________
			// pelhikano fix: Delay the command so the FoM and DW removal works
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
			// Re-apply DW with reset durations
	if (hadDW)
	{
		DelayCommand(0.75, 
		ActionCastSpellAtObject(SPELL_DEATH_WARD, 
			oTarget, 
			METAMAGIC_NONE, 
			TRUE, 
			nCasterLevel, 
			PROJECTILE_PATH_TYPE_DEFAULT, 
			TRUE));
	}
	
	if (hadMDW)
	{
		DelayCommand(0.75, 
		ActionCastSpellAtObject(SPELL_MASS_DEATH_WARD, 
			oTarget, 
			METAMAGIC_NONE, 
			TRUE, 
			nCasterLevel, 
			PROJECTILE_PATH_TYPE_DEFAULT, 
			TRUE));
	}

	if (hadUEF)
	{
		DelayCommand(0.75, 
		ActionCastSpellAtObject(SPELL_UNDEATHS_ETERNAL_FOE, 
			oTarget, 
			METAMAGIC_NONE, 
			TRUE, 
			nCasterLevel, 
			PROJECTILE_PATH_TYPE_DEFAULT, 
			TRUE));
	}
		}

}