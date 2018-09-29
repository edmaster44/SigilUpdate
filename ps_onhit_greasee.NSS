#include "ps_inc_onhit" 
#include "x2_inc_spellhook" 
#include "NW_I0_SPELLS"

void main()
{


    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
	
    if(GetHasSpellEffect(SPELL_GREASE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == oCaster)
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by Grease then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_GREASE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}