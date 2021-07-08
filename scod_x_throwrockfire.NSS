//::///////////////////////////////////////////////
//:: Rock Throwing
//:: NX2_S0_OrbAcid.nss
//:://////////////////////////////////////////////
/*
   This is a script allowing giants to hurl boulders, and catch them in turn.
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: 2014
//:://////////////////////////////////////////////
//:: RPGplayer1 12/22/2008: Added support for critical hits


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
	if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

		
	object oTarget = GetSpellTargetObject();
	int nSize = GetCreatureSize(OBJECT_SELF);
	int nStrength = ABILITY_STRENGTH;
	int nBonusDam = GetAbilityModifier(nStrength, OBJECT_SELF);
	int nDamage = d6(2)+ (nBonusDam);
	int nDamageFire = d10(1);
	
	if (nSize == CREATURE_SIZE_LARGE)
	{
		int nDamage = d6(2)+ (nBonusDam);
	}
	else if (nSize == CREATURE_SIZE_HUGE)
	{
		int nDamage = d8(2)+ (nBonusDam);
	}
	else return;
	// Calculate max damage.
	
		
	int nTouch = TouchAttackRanged(oTarget);
	if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDamage = nDamage *2;
	}

	// calculate base damage	
		
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ORB_OF_ACID));
		 //if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS)
		 if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		 {
		 	int nTargetRace = GetRacialType(oTarget);
		 	if (nTargetRace == RACIAL_TYPE_GIANT)
			{
				int nReflex = ReflexSave(oTarget, 15, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
				if (nReflex == SAVING_THROW_CHECK_SUCCEEDED)
					{
						SendMessageToPC(OBJECT_SELF, "Your thrown rock was caught!.");
					}
				else
					{
						effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
						effect eDam2 = EffectDamage(nDamageFire, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
						effect eLink = EffectLinkEffects(eDam, eDam2);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
					}	
			}
			else
			{
				effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
				effect eDam2 = EffectDamage(nDamageFire, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
				effect eLink = EffectLinkEffects(eDam, eDam2);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
		
			
			
			
		 	
		 }
		 
	}
	
	}