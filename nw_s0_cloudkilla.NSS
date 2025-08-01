//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d4 CON damage
    every round. Fortitude saves for half.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 09.18.06: Modified to make closer to the PHB rules
//:: RPGplayer1 14/04/2008:
//::  Will stack CON damage (by setting SpellId to -1)
//::  CON damage changed to Extraordinary (to prevent dispelling)

#include "nw_s0_cloudkill_inc"

void main(){
	
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
	}

	struct dSpellData data = GetSpellDataForAoE("Cloudkill", oCaster);
    //Declare major variables
    object oTarget = GetEnteringObject();
	
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		ApplyCloudKill(oTarget, oCaster, data.nId, data.nDC);
  
}