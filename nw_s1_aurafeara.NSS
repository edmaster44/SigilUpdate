//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:: Modified By: Constant Gaw - OEI 7/31/06; Protoss119 3/22/20
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();
	
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
    effect eFear = EffectFrightened();
		eFear = EffectLinkEffects(eDur, eFear);
   
	effect eAttackPen = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
	effect eSavePen = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	effect eSkillPen = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	effect eShaken = EffectLinkEffects(eAttackPen, eSavePen);
		eShaken = EffectLinkEffects(eSkillPen, eShaken);

    int nHD = GetHitDice(oCreator);
//  int nDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;
//  int nDC = 10 + GetHitDice(GetAreaOfEffectCreator());
	int nReduceHD = nHD / 2;
    int nDC = nReduceHD;
    int nDuration = GetScaledDuration(nReduceHD, oTarget);
		
	if(GetIsEnemy(oTarget, oCreator)){
       
       
        //Make a saving throw check
		
        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oCreator, 0.1f, 198)){
			 // Apply Fear
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_AURA_FEAR));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(nDuration));
		} else if (nHD - GetHitDice(oTarget) >= 5 && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, oCreator) &&
				!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCreator)){
			//Apply Shaken Effect if target is 5 HD or more lower than caster and is not immune to Fear
			// or mind spells.
			//Characters who are shaken take a -2 penalty on attack rolls, 
			//saving throws, and skill checks
			SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_AURA_FEAR));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, RoundsToSeconds(nDuration));
			
		}
    }
}