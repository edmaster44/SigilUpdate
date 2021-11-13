//::///////////////////////////////////////////////
//:: Heavenly Thunder Trap
//:: scod_s3_electricaltrap.nss
//:://////////////////////////////////////////////
/*
    TODO
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 24, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_ATTRAP, "scod_s3_electricaltrap_onenter");
	object oCaster = OBJECT_SELF;
	int nSetDC = GetAdjustedSetDC(25, oCaster);
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = TRAP_DUR;
	// Roll Set Trap Check
	if (GetIsSkillSuccessful(oCaster, SKILL_SET_TRAP, nSetDC)) {
	    //Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
		ApplyTrapInvisibility(oCaster, nSetDC);
	}
}