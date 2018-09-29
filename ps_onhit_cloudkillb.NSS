//::///////////////////////////////////////////////
//:: Cloudkill: On Exit
//:: NW_S0_CloudKillB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
	
    if(GetHasSpellEffect(SPELL_CLOUDKILL, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == oCaster)
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    //If the effect was created by the spell then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_CLOUDKILL)
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