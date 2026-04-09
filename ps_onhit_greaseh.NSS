//::///////////////////////////////////////////////
//:: Grease: Heartbeat
//:: NW_S0_GreaseC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

void main()
{


    //Declare major variables
    object oTarget;
    effect eFall = EffectKnockdown();
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	effect eLink = EffectLinkEffects(eFall, eHit);
    float fDelay;
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
	
    //Get first target in spell area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
       // if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
       if( (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
       {
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
                fDelay = GetRandomDelay(0.0, 2.0);
                if(!OnHitSavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 4.0));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> slows "+GetName(oTarget)+"</color>";
					DelayCommand(fDelay, SendMessageToPC(oCaster, sReport));
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}