//::///////////////////////////////////////////////
//:: Mind Fog
//:: NW_S0_MindFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main(){

	if (!X2PreSpellCastCode()) return;
  
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGMIND);
    location lTarget = GetSpellTargetLocation();
	
	StoreSpellDataForAoE("Mindfog");
	
    int nDuration = 2 + GetCasterLevel(OBJECT_SELF) / 2;
    int nMetaMagic = GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;


    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}
