//Delete the visual effect on enter

#include "X0_I0_SPELLS"
#include "scod_inc_trapfeats"

void main() {

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
	
	int nDuration = 5;
	
	location lTarget = GetLocation(OBJECT_SELF);
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
	{
		effect eAOE = EffectAreaOfEffect(AOE_PER_TRAPINVIS, "scod_s3_beetrap_onenter");
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
		
		DestroyObject(OBJECT_SELF, 1.0);
	}
}