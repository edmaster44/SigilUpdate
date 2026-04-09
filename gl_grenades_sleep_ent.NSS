/*
	On enter script for sleep bomb AoE.
	If fails the save - sleep for X rounds.
*/

#include "gl_grenades_inc"
#include "x2_I0_SPELLS"
#include "NW_I0_SPELLS"

void main()
{
	effect eStink = EffectSleep();
    effect eMind = EffectVisualEffect( VFX_DUR_SLEEP );    
    effect eLink = EffectLinkEffects(eMind, eStink);    

    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
	
	object oTarget = GetEnteringObject();
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId()));
		if (!MySavingThrow(SAVING_THROW_WILL, oTarget, SLEEP_BOMB_SAVE_DC, SAVING_THROW_TYPE_NONE, GetAreaOfEffectCreator()))
		{
			if (GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP) == FALSE)
            {
				float fDelay = GetRandomDelay(0.75, 1.75);
        		//Apply the VFX impact and linked effects
        		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(SLEEP_BOMB_EFFECT_DURATION)));
            }
		}
	}
}