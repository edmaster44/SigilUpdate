//::///////////////////////////////////////////////
//:: Invocation: Dark One's Own Luck
//:: NW_S0_IDrkOnLck.nss
//:://////////////////////////////////////////////
/*
    Gives a +(Charisma Modifier) bonus to all Saving
    Throws for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/24/05 -- Metamagic changes
#include "ps_inc_invocations"


void main(){
	DoSelfOnlyInvocation(SPELL_I_DARK_ONES_OWN_LUCK);
}


/*
void main()
{
    if (!X2PreSpellCastCode()) return;


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(24);
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);

	
	
	effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_DARKONESLUCK);
	effect eLink = EffectLinkEffects(eSave, eDur);
	 //Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
    RemoveEffectsFromSpell(oTarget, GetSpellId());

   
    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
*/