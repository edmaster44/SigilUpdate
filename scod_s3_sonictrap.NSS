//::///////////////////////////////////////////////
//:: Sonic Trap
//:: scod_s3_sonictrap.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that produces a sonic burst. Deals 10d8 sonic damage and stuns
	targets that fail a DC 25 will save. Damage and DC increased by craft trap (+1d8 damage and +1 DC 
	per 4 Craft Trap rank)
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 9, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_TRAPVIS, "scod_s3_sonictrap_onenter");
	object oCaster = OBJECT_SELF;
	int nSetDC = GetAdjustedSetDC(24, oCaster);
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = TRAP_DUR;
	// Roll Set Trap Check
	if (GetIsSkillSuccessful(oCaster, SKILL_SET_TRAP, nSetDC)) {
	    //Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
		ApplyTrapInvisibility(oCaster, nSetDC);
	}
}