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
	
	//Does not do damage if you're dead!
	if (GetIsDead(oCaster)) {
		return;
	}
	
	//Does not do damage if you're invisible
	if (GetActionMode(oCaster, ACTION_MODE_STEALTH) ||
		GetHasSpellEffect(SPELL_I_WALK_UNSEEN, oCaster) ||
		GetHasSpellEffect(SPELL_I_RETRIBUTIVE_INVISIBILITY, oCaster) ||
		GetHasSpellEffect(SPELL_INVISIBILITY, oCaster) ||
		GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oCaster) ||
		GetHasSpellEffect(SPELL_GREATER_INVISIBILITY, oCaster)) {
		return;
	}
	
	effect eDamage;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	int nCha = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget)) {	
	
		//Should not do damage to friends
		if (GetIsEnemy(oTarget, oCaster) && oTarget != oCaster) {
			eDamage = EffectDamage(d6(2) + nCha, DAMAGE_TYPE_NEGATIVE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		
		}
		
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
		
	}
}