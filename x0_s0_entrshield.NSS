//::///////////////////////////////////////////////
//:: Entropic Shield
//:: x0_s0_entrshield.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    20% concealment to ranged attacks including
    ranged spell attacks

    Duration: 1 turn/level

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 18, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: ?


// FlattedFifth - June 3, 2024. Changed spell target from OBJECT_SELF to GetSpellTargetObject()
// Flatted Fifth June 4, 2024 - Changed call from GetCasterLevel to PS_GetCasterLevel
#include "ps_inc_functions"


// JLR - OEI 08/24/05 -- Metamagic changes
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
	
	// AFW-OEI 08/07/2007: If you're casting it as a Svirfneblin racial, use HD.
	int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	if (GetSpellId() == SPELLABILITY_ENTROPIC_SHIELD)
	{
		nDuration = GetTotalLevels(OBJECT_SELF, TRUE);
	}
	
    float fDuration = TurnsToSeconds(nDuration);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the four unique armor bonuses
    effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_ENTROPIC_SHIELD);

    effect eLink = EffectLinkEffects(eShield, eDur);
//    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}