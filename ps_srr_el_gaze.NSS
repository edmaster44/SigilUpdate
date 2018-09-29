/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Eladrin Gaze */


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    int nHD = GetHitDice(OBJECT_SELF);
    int nDuration = nHD;
    int nDC = 10 + (nHD/2) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
	effect eFear = EffectFrightened();
    effect eDeath = EffectDeath(TRUE, TRUE, FALSE, TRUE);
	effect eFearVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
	effect eLink = EffectLinkEffects( eFear, eFearVis );
	
    object oTarget = GetSpellTargetObject();
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            if(oTarget != OBJECT_SELF && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
            {
               SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				
				if (GetHitDice(oTarget) < 6)
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
				}
				else
				{
					
	                //Spell Resistance and Saving throw
	                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
	                {
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, RoundsToSeconds(nDuration));
	                }
				}
            }
        }
  
}