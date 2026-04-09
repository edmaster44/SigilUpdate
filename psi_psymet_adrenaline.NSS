//::///////////////////////////////////////////////
//:: Animalistic Power
//:: nx2_s0_animalistic_power.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Animalistic Power
	Transmutation
	Level: Cleric 2, Druid 2, duskblade 2, ranger 2, sorceror/wizard 2
	Components: V, S
	Range: Touch
	Target: Creature touched
	Duration 1 minute/level
	 
	You imbue the subject with an aspect of the natural world.  
	The subject gains a +2 bonus to Strength, Dexterity, and Constitution.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

void main()
{
   if (!PsiPrePowerCastCode())
   {
   // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
       return;
   }
	object oManifester = OBJECT_SELF;
   	object oTarget     = GetSpellTargetObject();
   	struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                             GetSpellId(),
                             METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT); //sending metapsionic options

	// Get necessary objects
	if(manif.bCanManifest)
	{
		int nCasterLevel		= manif.nManifesterLevel;
		
		// Spell Duration
		float fDuration			= RoundsToSeconds(nCasterLevel);
		if (GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
		{
			fDuration = fDuration * 2;
		}
		int nAdrenStat = 2;
		if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
		{
			nAdrenStat = 4;
		}
		// Effects
		effect eStrength 		= EffectAbilityIncrease(ABILITY_STRENGTH, nAdrenStat);
		effect eConstitution	= EffectAbilityIncrease(ABILITY_CONSTITUTION, nAdrenStat);
		effect eVisual			= EffectVisualEffect(VFX_DUR_SPELL_ANIMALISTIC_POWER);
		effect eHaste			= EffectMovementSpeedIncrease(150);
		effect eExhaust			= EffectExhausted();
		effect eLink = EffectLinkEffects(eStrength, eConstitution);
		eLink =  EffectLinkEffects(eLink, eHaste);
		eLink =  EffectLinkEffects(eLink, eVisual);
		 
		// Make sure spell target is valid
		if (GetIsObjectValid(oTarget))
		{
			// remove previous usages of this spell
			RemoveEffectsFromSpell(oTarget, GetSpellId());	
			// check to see if ally
			if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oManifester)) 
			{
				// apply linked effect to target
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				DelayCommand(fDuration, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExhaust, oTarget, fDuration/2));
				//Fire cast spell at event for the specified target
	    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			}
			
		}
	}
}