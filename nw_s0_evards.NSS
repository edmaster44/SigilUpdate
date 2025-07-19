//::///////////////////////////////////////////////
//:: Evards Black Tentacles
//:: NW_S0_Evards.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 tentacles.  Each has
    a chance to hit of 5 + 1d20. If it succeeds then
    it does 1d6 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001

#include "nw_s0_evards_inc"

void main()
{
    if (!X2PreSpellCastCode()) return;
    

    object oCaster = OBJECT_SELF;
    effect eAOE = EffectAreaOfEffect(AOE_PER_EVARDS_BLACK_TENTACLES);
    location lTarget = GetSpellTargetLocation();
	int PML = GetPureMageLevels(oCaster);
	
	int nDuration = PS_GetCasterLevel(oCaster);
    if (nDuration < 1) nDuration = 1;
	int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;
	
	int nDC = FF_GetSpellSaveDC(oCaster, GetSpellId(), GetLastSpellCastClass());
	
	SetLocalInt(oCaster, "EvardsCasterLevel", nDuration);
	SetLocalInt(oCaster, "EvardsSaveDC", nDC);
	SetLocalInt(oCaster, "EvardsMetaMagic", nMetaMagic);
	SetLocalInt(oCaster, "EvardsPML", PML);
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}