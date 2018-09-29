//::///////////////////////////////////////////////
//:: Silence: On Exit
//:: NW_S0_SilenceB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    location lTarget = GetLocation(GetAreaOfEffectCreator());
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    int nCasterLevel = GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(GetAreaOfEffectCreator());
	int nID = GetOnHitAbilityID(GetAreaOfEffectCreator());
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;

    if ( GetHasSpellEffect(SPELL_SILENCE, oTarget) )
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect( oTarget );
        while ( GetIsEffectValid(eAOE) && bValid == FALSE )
        {
            if ( GetEffectCreator(eAOE) == oCaster)
            {
            	if ( GetEffectSpellId(eAOE) == SPELL_SILENCE )
                {
                   //AssignAOEDebugString("Removing Effects");
                   RemoveEffect( oTarget, eAOE );
                   bValid = TRUE;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect( oTarget );
        }
    }
}