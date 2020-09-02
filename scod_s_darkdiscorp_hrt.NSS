//::///////////////////////////////////////////////
//:: Dark Discorporation: Heartbeat
//:: scod_s_darkdiscorp_hrt.nss
//:://////////////////////////////////////////////
/*
    Does the 1d6 magic damage every round
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
	
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster) {
		
			effect eDamage = EffectDamage(d6(2)+GetAbilityModifier(ABILITY_CHARISMA, oCaster));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		
		}
		
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
		
	}
}