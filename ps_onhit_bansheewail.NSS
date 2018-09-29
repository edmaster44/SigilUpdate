//::///////////////////////////////////////////////
//:: Wail of the Banshee
//:: NW_S0_WailBansh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  You emit a terrible scream that kills enemy creatures who hear it
  The spell affects up to one creature per caster level. Creatures
  closest to the point of origin are affected first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: 6/21/06 - BDF-OEI: updated to use NWN2 VFX
//:: 7.08.06 - PKM-OEI: updated VFX again to make it hot & spicy (changed darkness hit to necro hit)
//:: 8.31.08 - RPGplayer1: Will not count creatures that do not pass spellsIsTarget() check

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLevel = GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
    int nToAffect = nCasterLevel;
    object oTarget;
    float fTargetDistance;
    float fDelay;
	effect eVis = EffectVisualEffect (VFX_HIT_SPELL_NECROMANCY);//looks cooler
    effect eWail = EffectVisualEffect( VFX_HIT_SPELL_WAIL_OF_THE_BANSHEE );	// makes use of NWN2 VFX
	int nCnt = 0;
    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWail, lTarget);
    oTarget = OBJECT_SELF; // direct target
    if (!GetIsObjectValid(oTarget))
    {
      nCnt++;
      oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
    while (nCnt < nToAffect)
    {
        lTarget = GetLocation(oTarget);
        //Get the distance of the target from the center of the effect
        fDelay = GetRandomDelay(1.0, 2.0);//FIX: original delay was too long (3-4s)
        fTargetDistance = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
        //Check that the current target is valid and closer than 10.0m
        if(GetIsObjectValid(oTarget) && fTargetDistance <= 10.0)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WAIL_OF_THE_BANSHEE));
                //Make SR check
                if(!OnHitResistSpell(oCaster, oTarget)) //, 0.1))
                {
                    //Make a fortitude save to avoid death
                    if(!OnHitSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH, oCaster)) //, OBJECT_SELF, 3.0))
                    {
                        //Apply the delay VFX impact and death effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        effect eDeath = EffectDeath();
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // no delay
						string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> kills "+GetName(oTarget)+"</color>";
						SendMessageToPC(oCaster, report);
                    } 
                }
            }
            else nToAffect++; //FIX: do not count allies
        }
        else
        {
            //Kick out of the loop
            nCnt = nToAffect;
        }
        //Increment the count of creatures targeted
        nCnt++;
        //Get the next closest target in the spell target location.
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
	DelayCommand(0.5f, ClearOnHitInfo(OBJECT_SELF));
}