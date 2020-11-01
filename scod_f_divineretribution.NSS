#include "x0_i0_spells"
#include "x2_inc_itemprop"
#include "nwn2_inc_spells"
#include "aaa_constants"
void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(STR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
   }
   else
   
   
   if(GetHasFeatEffect(FEAT_DIVINE_RETRIBUTION) == FALSE)
   {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nLevel = GetCasterLevel(OBJECT_SELF);

        effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        if (nCharismaBonus>0)
        {
       
        
            int nDamage1 = IPGetDamageBonusConstantFromNumber(nCharismaBonus);

            effect eDamage1 = EffectDamageShield(0,nDamage1,DAMAGE_TYPE_DIVINE);
            effect eLink = EffectLinkEffects(eDamage1, eDur);
            eLink = SupernaturalEffect(eLink);

            // * Do not allow this to stack
            RemoveEffectsFromSpell(oTarget, GetSpellId());

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_RETRIBUTION, FALSE));

            //Apply Link and VFX effects to the target
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCharismaBonus+1));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    }
}