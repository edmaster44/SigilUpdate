//::///////////////////////////////////////////////
//:: Dragon Fire Trap
//:: scod_s3_firetrap.nss
//:://////////////////////////////////////////////
/*
    When triggered, all hostiles in the area of effect receive 10d8 points of fire damage and are knockeddown for one
	round. A successful reflex save (DC 18) reduces the damage by half and negates the knockdown. The knockdown 
	duration is increased by one round per five levels of Arcane Trickster (for a maxium of 3 rounds). 
	The damage and DC of the trap are increased by the Craft Trap skill at a rate of +1d8 damage per 2 points 
	and +1 DC per 5 points. The DC is further increased by the users casting attribute modifier.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 15, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_ATTRAP, "scod_s3_firetrap_onenter");
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