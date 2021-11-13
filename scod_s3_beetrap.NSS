//::///////////////////////////////////////////////
//:: Bee Trap
//:: scod_s3_beetrap.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that will deal 1d6 + 1d6 per four ranks of craft trap damage per round
	to effected enemies. They must also make a will save or become confused. Lasts 5 rounds by default.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 9, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
	//effect eAOE = EffectAreaOfEffect(AOE_PER_TRAPVIS, "scod_s3_beetrapvisual_onenter");
	effect eAOE = EffectAreaOfEffect(AOE_PER_TRAPVIS, "scod_s3_beetrapvisual_onenter");
	object oCaster = OBJECT_SELF;
	int nSetDC = GetAdjustedSetDC(18, oCaster);
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = TRAP_DUR;
	// Roll Set Trap Check
	if (GetIsSkillSuccessful(oCaster, SKILL_SET_TRAP, nSetDC)) {
	    //Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
		ApplyTrapInvisibility(oCaster, nSetDC);
	}
}