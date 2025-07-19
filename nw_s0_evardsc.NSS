//::///////////////////////////////////////////////
//:: Evards Black Tentacles: Heartbeat
//:: NW_S0_EvardsB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 tentacles.  Each has
    a chance to hit of 5 + 1d20. If it succeeds then
    it does 2d6 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book
// 10/16/06 - BDF(OEI): fixed an issue with the AC being queried from an uninitialized object.
//	AC was also never being requeried during object iteration.  Good catch, xitooner!

#include "nw_s0_evards_inc"

void main(){

    object oTarget;
	object oAOE = OBJECT_SELF;
	object oCaster = GetAreaOfEffectCreator();
	
	//stores caster level as data.data.nCL, 
	// save dc as data.nDC
	// Metamagic as data.nMeta
	// and pure mage levels as data.ndata.nPML
	struct dEvardsData data = GetEvardsData(oAOE, oCaster);
	
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget)){
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
			DoEvardsDamage(oCaster, oTarget, data);
		}
	    oTarget = GetNextInPersistentObject();
    }
}