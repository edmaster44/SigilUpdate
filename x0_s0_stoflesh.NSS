//::///////////////////////////////////////////////
//:: Stone To Flesh
//:: x0_s0_stoflesh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is freed of any petrify effect
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: Oct 16 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//UPDATE - Do a check to make sure that the creature being cast on
//          has not been set up to be a permanent statue.

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();

    //Check to make sure the creature has not been set up to be a statue.
    if (GetLocalInt(oTarget, "NW_STATUE") != 1)
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 486, FALSE));
		
		
        //Search for and remove the above negative effects
        effect eLook = GetFirstEffect(oTarget);
		
		int bPetrifyFound = FALSE;
        while(GetIsEffectValid(eLook))
        {
            if(GetEffectType(eLook) == EFFECT_TYPE_PETRIFY)
            {
				bPetrifyFound = TRUE;
                SetCommandable(TRUE, oTarget);
                RemoveEffect(oTarget, eLook);
            }
            eLook = GetNextEffect(oTarget);
        }
		
		if (!bPetrifyFound){
			int nDuration = PS_GetCasterLevel(OBJECT_SELF) * 600; // 10 mins per level
			effect eImmune =  EffectSpellImmunity(EFFECT_TYPE_PETRIFY);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmune, oTarget, IntToFloat(nDuration));
		
		}

        //Apply Linked Effect
		effect eHit = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
    }
}

