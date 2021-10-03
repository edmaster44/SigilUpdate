//::///////////////////////////////////////////////
//:: Spike Trap
//:: scod_s3_spiketrap.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that will deal 5d6 + 1d6 per two ranks of craft trap damage to 
	an enemy when triggered.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: August 22, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_SPIKETRAP, "scod_s3_spiketrap_onenter");
	object oCaster = OBJECT_SELF;
	int nSetDC = 15;
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = 5;
	// Roll Set Trap Check
	if (GetIsSkillSuccessful(oCaster, SKILL_SET_TRAP, nSetDC)) {
	    //Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	}
}