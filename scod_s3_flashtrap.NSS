//::///////////////////////////////////////////////
//:: Flash Trap
//:: scod_s3_flashtrap.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that produces a bright explosion upon being triggered.
	Enemies in the area of effect must succeed in a fortitude save or be blinded for five rounds.
	The save and duration are increased by 1 per four ranks of craft trap.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 9, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_TRAPVIS, "scod_s3_flashtrap_onenter");
	object oCaster = OBJECT_SELF;
	int nSetDC = GetAdjustedSetDC(21, oCaster);
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = TRAP_DUR;
	// Roll Set Trap Check
	if (GetIsSkillSuccessful(oCaster, SKILL_SET_TRAP, nSetDC)) {
	    //Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
		ApplyTrapInvisibility(oCaster, nSetDC);
	}
}