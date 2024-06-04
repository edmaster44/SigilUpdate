//::///////////////////////////////////////////////
//:: Expeditious retreat
//:: x0_s0_exretreat.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Increases movement rate to the max, allowing
 the spell-caster to flee.
 Also gives + 2 AC bonus
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
// JLR - OEI 08/23/05 -- Metamagic changes
// Flatted Fifth June 4, 2024 - Changed duration from 6 seconds per level to 30 seconds + 5 seconds per level,
//					changed call from GetCasterLevel to PS_GetCasterLevel
#include "ps_inc_functions"
#include "nwn2_inc_spells"


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
	
	int CasterLevel = PS_GetCasterLevel(OBJECT_SELF);

    if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE)
    {
        return ; // does nothing if caster already has haste
    }
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_EXPEDITIOUS_RETREAT );	// NWN2 VFX
    effect eFast = EffectMovementSpeedIncrease(150);
    effect eLink = EffectLinkEffects(eFast, eDur);
    
    //float fDuration = RoundsToSeconds(PS_GetCasterLevel(OBJECT_SELF));// default duration
	float fDuration = 30 + (5 * PS_GetCasterLevel(OBJECT_SELF)); // FlattedFifth duration
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 455, FALSE));

	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}