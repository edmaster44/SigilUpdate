//::///////////////////////////////////////////////
//:: Acid Fog: On Exit
//:: NW_S0_AcidFogB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001
//:: RPGplayer1 08/29/2008: Added support for Acid Bomb (SpellID: 745)
#include "nw_s0_acidfog_inc"

void main(){

	object oCaster = GetAreaOfEffectCreator();
	struct dSpellData data = GetSpellDataForAoE("AcidFog", oCaster);
	
	PS_RemoveEffects(GetExitingObject(), data.nId, NULL, oCaster);
	
   
}