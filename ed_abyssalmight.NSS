#include "nw_i0_spells"
#include "x2_i0_spells"
#include "ps_inc_functions"
#include "x2_inc_spellhook"

//Abyssal Might
//The caster summons evil energy from the Abyss and imbues himself with its might.
//The caster gains a +2 enhancement bonus to Strength, Constitution, and Dexterity.
//The caster's existing spell resistance improves by +2.
//Duration 10 Minutes/Level


void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	// Get necessary objects
	object oTarget			= GetSpellTargetObject();
	object oCaster			= OBJECT_SELF;
	int nCasterLevel		= PS_GetCasterLevel(oCaster);
	// Spell Duration
	float fDuration			= TurnsToSeconds(nCasterLevel)* 10;
	fDuration			= ApplyMetamagicDurationMods(fDuration);
	// Effects
	effect eStrength 		= EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eDexterity		= EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
	effect eConstitution	= EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
	effect eVisual			= EffectVisualEffect(VFX_INVOCATION_BESHADOWED_DOOM);
	effect eLink = EffectLinkEffects(eStrength, eDexterity);
	eLink =  EffectLinkEffects(eLink, eConstitution);
	eLink =  EffectLinkEffects(eLink, eVisual);
	 
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		RemoveEffectsFromSpell(oTarget, GetSpellId());	
		// check to see if ally
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) 
		{
			// apply linked effect to target
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
		
	}
}