//::///////////////////////////////////////////////
//:: Shield of Faith
//:: x0_s0_ShieldFait.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*  16823447   16781929
 +2 deflection AC bonus, +1 every 6 levels (max +5)
 Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:


// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 

void main(){

    if (!X2PreSpellCastCode()) return;
    
    //Declare major variables
	int nId = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    
    int nValue = 3 + (nCasterLvl)/5;
    if (nValue > 6) nValue = 6; // * Max of 6
    
    effect eAC = EffectACIncrease(nValue, AC_DEFLECTION_BONUS);

    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_SHIELD_OF_FAITH);
    effect eLink = EffectLinkEffects(eAC, eDur);

    float fDuration = TurnsToSeconds(nCasterLvl); // * Duration 1 turn/level
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);

}