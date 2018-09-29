//::///////////////////////////////////////////////
//:: Stinking Cloud: Heartbeat
//:: NW_S0_StinkCldC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "ps_inc_onhit" 

void main()
{

	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);
    //eLink = EffectLinkEffects(eLink, eDur);

    //effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    //Get the first object in the persistant area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STINKING_CLOUD));
            //Make a SR check
            if(!OnHitResistSpell(oCaster, oTarget))
            {
                //Make a Fort Save
                if(!OnHitSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oCaster))
                {
                   fDelay = GetRandomDelay(0.75, 1.75);
                   //Apply the VFX impact and linked effects
                   if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
                   {
                     	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
						string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> dazes "+GetName(oTarget)+"</color>";
						DelayCommand(fDelay, SendMessageToPC(oCaster, sReport));
                   }
                }
                else
                {
                    //If the Fort save was successful remove the Dazed effect
                    eFind = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eFind))
                    {
                        if(eFind == EffectDazed())
                        {
                            oCreator = GetEffectCreator(eFind);
                            if(oCreator == oCaster)
                            {
                                RemoveEffect(oTarget, eFind);
                            }
                        }
                        eFind = GetNextEffect(oTarget);
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}