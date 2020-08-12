//::///////////////////////////////////////////////
//:: Hungry Darkness: On Exit
//:: scod_s_hgrydarkness_onex.nss
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness that provides concealment to friends
	and eats enemies
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: 8/11/2020
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "aaa_constants"
#include "x2_inc_spellhook"

void main()
{

    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
	// 

    int bValid = FALSE;
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE) && bValid == FALSE) {	
	
		if (GetEffectCreator(eAOE) == oCreator) {	
	
			int nID = GetEffectSpellId(eAOE);
            //If the effect was created by the spell then remove it
            if( nID == 821 ) {	
		   		RemoveEffect(oTarget, eAOE);
                bValid = TRUE;	
			}
			
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}