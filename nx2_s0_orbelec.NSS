//::///////////////////////////////////////////////
//:: Orb of Electricity.
//:: NX2_S0_OrbElec.nss
//:://////////////////////////////////////////////
/*
	 An orb of acid about 3 inches across
	shoots from your palm at its target,
	dealing 1d6 points of acid damage
	per caster level (maximum 15d6). You
	must succeed on a ranged touch attack
	to hit your target.
	A creature struck by the orb takes
	damage and becomes sickened by the
	acid�s noxious fumes for 1 round. A
	successful Fortitude save negates the
	sickened effect but does not reduce the
	damage.

*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: Sept 3, 2008
//:://////////////////////////////////////////////
//:: RPGplayer1 12/22/2008: Added support for critical hits
//:: RPGplayer1 12/22/2008: Fixed Maximized damage
//:: Mymothersmeatloaf 6/21/2020: Uncapped to 25d6

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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	int PML = GetPureMageLevels(OBJECT_SELF);
	int nDice = nCasterLevel + (PML/3);
	int nDamage = 0;
	
	// Calculate max damage.

		
	int nTouch = TouchAttackRanged(oTarget);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDice = nDice*2;
	}

	// calculate base damage	
	nDamage = d4(nDice);
	if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
	nDamage = d4(20) + d4(PML/3);
	} 	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ORB_OF_ELECTRICITY));
		 //if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS)
		 if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		 {
		 // Orb spells are not resisted!!
		 	int nMetaMagic = GetMetaMagicFeat();
			if (nMetaMagic == METAMAGIC_MAXIMIZE)
     	    {
      		   	// do MAXIMIZE 6 * nDice
				nDamage = nDamage + ((3*nDamage)/4);
       	 	}
         	if (nMetaMagic == METAMAGIC_EMPOWER)
         	{
            	// DO EMPOWER damage * 1.5
				nDamage = nDamage + (nDamage/2);
         	}
			
			// Savint throw for "entangled" effect
			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
			{
				// failed saving throw, uh oh! Entangled!!
				effect eEntangled = EffectEntangle();
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEntangled, oTarget, RoundsToSeconds(1));
			}
			
			// If applicable adds any sneak damage to total to be inflicted and reports the damage.
			nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_ELECTRICAL);
				
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_NORMAL);
			// visual!!!!
			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		    //effect eLink = EffectLinkEffects(eFireDamage, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			
			
			
		 	
		 }
		 
	}
	
	}