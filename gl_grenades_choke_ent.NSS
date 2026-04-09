/*
	On enter script for choking bomb AoE.
	If fails the save - daze for X rounds.
*/

#include "gl_grenades_inc"
#include "x2_I0_SPELLS"
#include "NW_I0_SPELLS"

void main()
{
	effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );    
    effect eLink = EffectLinkEffects(eMind, eStink);    

    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_CONJURATION);
	
	object oTarget = GetEnteringObject();
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId()));
		if (!MySavingThrow(SAVING_THROW_FORT, oTarget, CHOKING_BOMB_SAVE_DC, SAVING_THROW_TYPE_POISON, GetAreaOfEffectCreator()))
		{
			if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
            {
				float fDelay = GetRandomDelay(0.75, 1.75);
        		//Apply the VFX impact and linked effects
        		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(CHOKING_BOMB_EFFECT_DURATION)));
            }
		}
	}
}