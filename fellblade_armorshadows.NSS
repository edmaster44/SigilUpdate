//::///////////////////////////////////////////////
//:: Armor of Shadows
//:: fellblade_armorshadows
//:: 5/20/21 - Mimi Fearthegn
//:://////////////////////////////////////////////
/*
    +6 AC, enchantment. As Improved Mage Armor
*/
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void main() {

    if (!X2PreSpellCastCode()) {
        return;
    }

    //Declare major variables
    object oTarget = OBJECT_SELF;
    float fDuration = HoursToSeconds(24);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Set the unique armor bonus
    effect eAC = EffectACIncrease(6, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eDur = EffectNWN2SpecialEffectFile( "sp_armor_of_shadows" );
    effect eLink = EffectLinkEffects(eAC, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveEffectsFromSpell(oTarget, SPELL_IMPROVED_MAGE_ARMOR);
    RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);	// 10/16/06 - BDF

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}