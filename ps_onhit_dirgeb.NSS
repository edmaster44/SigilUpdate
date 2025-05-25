//::///////////////////////////////////////////////
//:: Dirge: On Exit
//:: x0_s0_dirgeET.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    MARCH 2003
    Remove the negative effects of the dirge.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
//:: Update Pass By:

#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{
    object oTarget = GetExitingObject();
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
	int nID = GetOnHitAbilityID(GetAreaOfEffectCreator());
    effect eAOE;
 //   SpawnScriptDebugger();
    if(GetHasSpellEffect(SPELL_DIRGE, oTarget))
    {
        DeleteLocalInt(oTarget, "X0_L_LASTPENALTY");

        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);

        while (GetIsEffectValid(eAOE) )
        {
            if (GetEffectCreator(eAOE) == oCaster)
            {
                //If the effect was created by the Dirge spell then remove it
                if(nID == SPELL_DIRGE)
                {
                    RemoveEffect(oTarget, eAOE);
                    //bValid = TRUE;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}
