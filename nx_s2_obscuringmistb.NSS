//////////////////////////////////////////////
// On Exit script for Obscuring Mist AOE	//
// Ceremorph 4/26/16						//
//////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    object oTarget  = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
	effect eAOE = GetFirstEffect(oTarget);
    
	while (GetIsEffectValid(eAOE))
    {	
		if (GetEffectCreator(eAOE) == oCreator && GetEffectSpellId(eAOE) == 1248)
        {	
			RemoveEffect(oTarget, eAOE);
			eAOE = GetFirstEffect(oTarget);
        } else eAOE = GetNextEffect(oTarget);
    }
}