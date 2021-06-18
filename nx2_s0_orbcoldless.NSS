//::///////////////////////////////////////////////
//:: Orb of Cold, Lesser.
//:: NX2_S0_OrbColdLess.nss
//:://////////////////////////////////////////////
/*
    An orb of acid about 2 inches across
	shoots from your palm at its target,
	dealing 1d8 points of acid damage. You
	must succeed on a ranged touch attack
	to hit your target.
	For every two caster levels beyond
	1st, your orb deals an additional 1d8
	points of damage: 2d8 at 3rd level,
	3d8 at 5th level, 4d8 at 7th level, and
	the maximum of 5d8 at 9th level or
	higher.
	
	Fort Save failure = blinded for one round
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: July 30 2008
//:://////////////////////////////////////////////
//:: RPGplayer1 12/22/2008: Added support for critical hits
//:: RPGplayer1 12/22/2008: Removed secondary effect
//:: Mymothersmeatloaf 6/20/20: Uncapped spell to 10d8 at 19'th level.
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_functions"

void main()
{
	if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

		
	object oTarget = GetSpellTargetObject();
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    int nDice = 1;
    int nDamage = 0;
    // Calculate damage.
    if (nCasterLevel >= 12)
        nDice = 12;
    else if (nCasterLevel <= 11)
        nDice = nCasterLevel;
		
	int nTouch = TouchAttackRanged(oTarget);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDice = nDice*2;
	}

	// calculate base damage	
	nDamage = d4(nDice);	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_ORB_OF_ELECTRICITY));
		 //if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS)
		 if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		 {
		 // Orb spells are not resisted!!
		 	int nMetaMagic = GetMetaMagicFeat();
			if (nMetaMagic == METAMAGIC_MAXIMIZE)
     	    {
      		   	// do MAXIMIZE 8 * nDice
				nDamage = nDamage*2;
       	 	}
         	if (nMetaMagic == METAMAGIC_EMPOWER)
         	{
            	// DO EMPOWER damage * 1.5
				nDamage = nDamage + (nDamage/2);
         	}
			
			// Savint throw for blindness
			/*if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
			{
				// failed saving throw, uh oh! Blinded!
				effect eBlind = EffectBlindness();
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(1));
			}*/
			// If applicable adds any sneak damage to total to be inflicted and reports the damage.
			nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_COLD);
				
			
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL);
			// visual!!!!
			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		    //effect eLink = EffectLinkEffects(eFireDamage, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			
			
			
		 	
		 }
		 
	}
	
	}