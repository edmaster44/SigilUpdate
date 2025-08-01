//::///////////////////////////////////////////////
//:: Cloudkill: Heartbeat
//:: NW_S0_CloudKillC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d4 CON damage per
	round.  Fortitude reduces damage by half.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 09.18.06: Updated to do CON damage.
//:: RPGplayer1 14/04/2008:
//::  Will stack CON damage (by setting SpellId to -1)
//::  CON damage changed to Extraordinary (to prevent dispelling)

#include "nw_s0_cloudkill_inc"

void main(){

	object oCaster = GetAreaOfEffectCreator();

	struct dSpellData data = GetSpellDataForAoE("Cloudkill", oCaster);


    //Get the first object in the persistant AOE
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget)){
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator()) ){
			ApplyCloudKill(oTarget, oCaster, data.nId, data.nDC);
        }
        //Get the next target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}