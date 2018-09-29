#include "ps_inc_onhit" 
#include "x2_inc_spellhook" 

void main() {

	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	
	if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_GREASE, "ps_onhit_greasea", "ps_onhit_greaseh", "ps_onhit_greasee");
    location lTarget = GetLocation(OBJECT_SELF);
	int nDuration = GetCasterLevel(oCaster);	// AFW-OEI 04/16/2007: Change duration to 1 round/level.
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}