//::///////////////////////////////////////////////
//:: Acid Fog
//:: NW_S0_AcidFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    or their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001


#include "x2_inc_spellhook" 

void main(){

    if (!X2PreSpellCastCode()) return;
    

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID);
	int nId = GetSpellId();
    location lTarget = GetSpellTargetLocation();
    int nCL = PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
	int nDuration = nCL;
    if (nDuration < 1) nDuration = 1;
 
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration += 2;	
    
	SetEffectSpellId(eAOE, nId);
	
	StoreSpellDataForAoE("AcidFog", nId, nCL);
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}