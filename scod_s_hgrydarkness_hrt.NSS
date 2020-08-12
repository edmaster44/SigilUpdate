//::///////////////////////////////////////////////
//:: Hungry Darkness: Heartbeat
//:: scod_s_hgrydarkness_hrt.nss
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness that provides concealment to friends
	and eats enemies
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: 8/11/2020
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "aaa_constants"
#include "x2_inc_spellhook"

void main() {

    object oCaster = GetAreaOfEffectCreator();
	
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget)) {	
	
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {
		
			effect eDamage = EffectDamage(d6(2));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		
		}
		
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
		
	}
}