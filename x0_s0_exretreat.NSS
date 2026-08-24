//::///////////////////////////////////////////////
//:: Expeditious retreat and Longstrider
//:: x0_s0_exretreat.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Increases movement rate to the max, allowing
 the spell-caster to flee.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
// JLR - OEI 08/23/05 -- Metamagic changes
// Flatted Fifth June 4, 2024 - Changed duration from 6 seconds per level to 30 seconds + 5 seconds per level,
//					changed call from GetCasterLevel to PS_GetCasterLevel
//					fixed typo
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

    if (!X2PreSpellCastCode()) return;
   
	//Declare major variables
    object oTarget = GetSpellTargetObject();

    if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE){
		SendMessageToPC(OBJECT_SELF, "This spell does not stack with Haste effects");
        return ; // does nothing if caster already has haste
    }
	int nId = GetSpellId();
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	int nFast;
	float fDur;
	if (nId == 1959){ //Longstrider
		nFast = 30; // speed +30 for Longstrider
		fDur = HoursToSeconds(nCL); // duration 1 hour per CL for Longstrider
	} else {
		nFast = 50; // speed + 50 for exp retreat
		// duration 5 rounds + 1 round per level for exp retreat, max 30 rounds
		nCL += 5;
		if (nCL > 30) nCL = 30;
		fDur = RoundsToSeconds(nCL);
	}
	fDur = ApplyMetamagicDurationMods(fDur);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_EXPEDITIOUS_RETREAT);	// NWN2 VFX
    effect eFast = EffectMovementSpeedIncrease(nFast);
    effect eLink = EffectLinkEffects(eFast, eDur);
	eLink = SetEffectSpellId(eLink, nId); 
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
	//remove previous castings of Expeditious Retreat and Longstrider
	PS_RemoveEffects(oTarget, 456); // exp retreat
	PS_RemoveEffects(oTarget, 1959); // longstrider
	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDur);
}