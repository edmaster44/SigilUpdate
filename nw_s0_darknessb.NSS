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

#include "x2_inc_spellhook"

void main()
{
	object oAOE = OBJECT_SELF;
	object oCaster = GetAreaOfEffectCreator();
	
	int nId = GetLocalInt(oAOE, "DarknessSpellId");
	if (nId == FALSE){
		nId = GetLocalInt(oCaster, "DarknessSpellId");
		// if we still don't have a spell id, just assume normal spell id for darkness
		if (nId == FALSE) nId = SPELL_DARKNESS;
		SetLocalInt(oAOE, "DarknessSpellId", nId);
	}
		
	PS_RemoveEffects(GetExitingObject(), nId, NULL, oCaster);
}




/* original code now handled by new function in spellhook
    int bValid = FALSE;
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE) && bValid == FALSE)
    {	if (GetEffectCreator(eAOE) == oCreator)
        {	int nID = GetEffectSpellId(eAOE);
            //If the effect was created by the spell then remove it
           if( nID == SPELL_DARKNESS || nID == SPELLABILITY_AS_DARKNESS  || nID == SPELL_SHADOW_CONJURATION_DARKNESS || nID == 688 || nID == 810 || nID == 941 || nID == 1687 || nID == 2636 )
		   {	RemoveEffect(oTarget, eAOE);
                bValid = TRUE;	}
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}
*/