//::///////////////////////////////////////////////
//:: Shield Other
//:: NW_S0_ShldOther.nss
//:://////////////////////////////////////////////
/*
    Target creature gains +1 Deflection bonus to
    AC, +1 resistance to saves, and takes 1/2
    damage.  Excess damage is applied to the
    caster of this spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 14, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"

#include "ps_inc_functions"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(nCasterLvl);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eAC = EffectACIncrease(1, AC_DEFLECTION_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
    effect eDmg = EffectShareDamage(OBJECT_SELF);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SHIELD );

	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    
    effect eLink = EffectLinkEffects(eAC, eSave);
    eLink = EffectLinkEffects(eLink, eDmg);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
}