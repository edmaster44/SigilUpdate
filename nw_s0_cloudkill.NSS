//::///////////////////////////////////////////////
//:: Cloudkill
//:: NW_S0_CloudKill.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "nw_s0_cloudkill_inc"

void main(){
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;
  
    //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGKILL);
    location lTarget = GetSpellTargetLocation();
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	StoreSpellDataForAoE("Cloudkill", GetSpellId(), nCL);
	
	
    int nDuration = nCL / 2;
    //effect eImpact = EffectVisualEffect(258);	// no longer using NWN1 VFX
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);	// no longer using NWN1 VFX
    if(nDuration < 1) nDuration = 1;
   

	if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDuration *= 2;
		
    //Apply the AOE object to the specified location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}