//::///////////////////////////////////////////////
//:: Blindsight
//:: NW_S0_Blindsght.nss
//:://////////////////////////////////////////////
/*
    Allows the mage to see invisible creatures &
    see in darkness.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 12, 2005
//:://////////////////////////////////////////////


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
#include "nwn2_inc_spells"
#include "ps_inc_functions"

#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLINDSIGHT );	// NWN2 VFX
    effect eSightInvis = EffectSeeInvisible();
    effect eSightDark = EffectUltravision();
    effect eLink = EffectLinkEffects(eVis, eSightInvis);
    eLink = EffectLinkEffects(eLink, eSightDark);
    eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDSIGHT, FALSE));

    float fDuration = TurnsToSeconds(PS_GetCasterLevel(OBJECT_SELF));

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    RemovePermanencySpells(oTarget);

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}