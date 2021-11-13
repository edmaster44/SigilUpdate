//::///////////////////////////////////////////////
//:: Heavenly Thunder Trap
//:: scod_s3_electricaltrap.nss
//:://////////////////////////////////////////////
/*
    When triggered, all hostiles in the area of effect receive 10d8 points of lightning
	damage and an additional 1d8 points of divine damage per level of Arcane Trickster (10d8 max). 
	A successful Reflex save (DC 18) halves the damage. The damage and DC of the trap are increased by the 
	Craft Trap skill at a rate of +1d8 electrical damage per 
	2 points and +1 DC per 5 points. The DC is further increased by the users casting attribute modifier.
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