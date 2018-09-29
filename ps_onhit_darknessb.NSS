//::///////////////////////////////////////////////
//:: Darkness: On Exit
//:: NW_S0_DarknessB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "ps_inc_onhit" 
#include "x2_inc_spellhook"

void main()
{

    object oTarget = GetExitingObject();
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
	// 

    int bValid = FALSE;
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE) && bValid == FALSE)
    {
        if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
        {
            int nID = GetEffectSpellId(eAOE);
            //If the effect was created by the spell then remove it
           if( nID == SPELL_DARKNESS)
           {
                RemoveEffect(oTarget, eAOE);
                bValid = TRUE;
           }
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }



}