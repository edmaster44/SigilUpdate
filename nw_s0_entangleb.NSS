//::///////////////////////////////////////////////
//:: Entangle B: On Exit
//:: NW_S0_EntangleB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes the entangle effect after the AOE dies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 25, 2002
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"

void main()
{
	
	object oCaster = GetAreaOfEffectCreator();

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    effect eAOE;
    if(GetHasSpellEffect(SPELL_ENTANGLE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == oCaster && 
				GetEffectType(eAOE) == EFFECT_TYPE_ENTANGLE &&
				GetEffectSpellId(eAOE) == SPELL_ENTANGLE)
                {
                    RemoveEffect(oTarget, eAOE);
					 eAOE = GetFirstEffect(oTarget);
                } else eAOE = GetNextEffect(oTarget);
        }
    }
}

