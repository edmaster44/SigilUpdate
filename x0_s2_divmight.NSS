//::///////////////////////////////////////////////
//:: Divine Might
//:: x0_s2_divmight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Up to (turn undead amount) per day the character may add his Charisma bonus to all
    weapon damage for a number of rounds equal to the Charisma bonus.

    MODIFIED JULY 3 2003
    + Won't stack
    + Set it up properly to give correct + to hit (to a max of +20)

    MODIFIED SEPT 30 2003
    + Made use of new Damage Constants
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Sep 13 2002
//:://////////////////////////////////////////////
//:: RPGplayer1 12/22/2008: Increased duration by 1 round, since activating this feat makes you unable to attack for 1 round

#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "nwn2_inc_spells"



void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(STR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
		return;
   }
   // this is an unnecessary condition because DM is made not to stack by removing fx b4
   // applying new, so all this was doing was preventing re-upping duration
   //else
  // if(GetHasFeatEffect(413) == FALSE) 
   //{
        //Declare major variables
        //object oTarget = GetSpellTargetObject(); //self only spell, we dont need to get the target
        //int nLevel = PS_GetCasterLevel(OBJECT_SELF); // caster lvl not used

        effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        if (nCharismaBonus < 1)
        {
			FloatingTextStringOnCreature("You must have at least 12 Charisma to use this ability.", OBJECT_SELF, FALSE);
			return;
		}


	   // AFW-OEI 02/08/2007: If you have Epic Divine Might, your CHA bonus is doubled.
		if (GetHasFeat(FEAT_EPIC_DIVINE_MIGHT, OBJECT_SELF, TRUE))
		{
			nCharismaBonus *= 2;
		}
		float fDur = RoundsToSeconds(nCharismaBonus+1);
		int nDamage1 = IPGetDamageBonusConstantFromNumber(nCharismaBonus);

		effect eDamage1 = EffectDamageIncrease(nDamage1,DAMAGE_TYPE_DIVINE);
		effect eLink = EffectLinkEffects(eDamage1, eDur);
		eLink = SupernaturalEffect(eLink);

		// * Do not allow this to stack
		int nId = GetSpellId();
		RemoveEffectsFromSpell(OBJECT_SELF, nId);

		//Fire cast spell at event for the specified target
		SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_MIGHT, FALSE));

		//Apply Link and VFX effects to the target
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDur);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD); 
		ReportEffectFade(fDur);

   // }
}