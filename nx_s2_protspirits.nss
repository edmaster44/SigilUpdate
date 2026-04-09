//::///////////////////////////////////////////////
//:: Protection from Spirits
//:: nx_s2_protspirits.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    The spirit shaman gains a permanent +2
    deflection bonus to AC and a +2 resistance
    bonus on saves against attacks and effects
    made by spirits. This is essentially a
    permanent Protection From Evil, except it
    protects against spirits and lasts until it
    is dismissed or dispelled.  If this ability
    is dispelled, the spirit shaman can recreate
    it simply by taking a standard action to do so.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/13/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;
    
    //Declare major variables
    object oTarget = GetSpellTargetObject();
	int nId = GetSpellId();

	effect eAC = EffectACIncrease(2, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);

	effect eLink = EffectLinkEffects(eAC, eSave);
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, nId);
	PS_RemoveEffects(oTarget, nId);
	PS_RemoveEffects(oTarget, 1101); // Warding of the Spirits non-persistent group effect
    
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));

	//Apply the effects
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
}