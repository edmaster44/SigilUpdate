//::///////////////////////////////////////////////
//:: Corrosive Trap
//:: scod_s3_corrosivetrap.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that unleashes a burst of corrosive acid. Deals 10d10 acid damage reduces AC by 2.
	Enemies are paralyzed for five rounds unless they make a DC 30 fortitude save. Reflex save for half damage. Reflex with
	Evasion and Improved Evasion can avoid all effects.
	Damage and DC increased by craft trap (+1d10 damage per 2 Craft Trap ranks and +1 DC per 4 Craft Trap ranks)
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 9, 2021
//:://////////////////////////////////////////////

#include "scod_inc_trapfeats"

void main()
{

   //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_TRAPVIS, "scod_s3_corrosivetrap_onenter");
	object oCaster = OBJECT_SELF;
	int nSetDC = 27;
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = 5;
	// Roll Set Trap Check
	if (GetIsSkillSuccessful(oCaster, SKILL_SET_TRAP, nSetDC)) {
	    //Create an instance of the AOE Object using the Apply Effect function
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	}
}