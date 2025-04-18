//::///////////////////////////////////////////////
//:: Spike Trap
//:: scod_s3_spiketrap.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that will deal 5d6 + 1d6 per two ranks of craft trap damage to 
	effected enemies when triggered.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: August 22, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_TRAPVIS, "scod_s3_spiketrap_onenter");
	object oCaster = OBJECT_SELF;
	int nSetDC = GetAdjustedSetDC(15, oCaster);
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = TRAP_DUR;
	// Roll Set Trap Check
	if (GetIsSkillSuccessful(oCaster, SKILL_SET_TRAP, nSetDC)) {
	    //Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
		ApplyTrapInvisibility(oCaster, nSetDC);
	}
}