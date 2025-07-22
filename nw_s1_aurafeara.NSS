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
	
	//if the target is immune to fear or mind affecting, they should not be affected, duh
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) ||
			    GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCreator))
				 return;
	
   
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
        
        SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
		
        if(MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR) && 
			nHD - GetHitDice(oTarget) >= 5){
			
				//Apply Shaken Effect 
				//Characters who are shaken take a -2 penalty on attack rolls, 
				//saving throws, and skill checks
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, RoundsToSeconds(nDuration));
		} else {
	            // Apply Fear
	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(nDuration));

		}
    }
}