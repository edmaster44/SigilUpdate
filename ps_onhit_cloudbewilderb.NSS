//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewldC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of noxious air goes forth from the caster.
    Enemies in the area of effect are stunned and blinded
    1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////
//:: RPGplayer1 04/16/2008: Will work with Empower or Maximize metamagic

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    int nRounds;
    effect eStun = EffectStunned();
    effect eBlind = EffectNewBlindness();
	effect eDur = EffectVisualEffect( VFX_DUR_STUN );
    eStun = EffectLinkEffects(eBlind,eStun);
    eStun = EffectLinkEffects(eStun,eDur);
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());

    effect eVis = EffectVisualEffect(VFX_DUR_BLIND);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Get the first object in the persistant area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CLOUD_OF_BEWILDERMENT));
            if (!GetHasSpellEffect(SPELL_CLOUD_OF_BEWILDERMENT,oTarget))
            {
                //Make a SR check
                if(!OnHitResistSpell(oCaster, oTarget))
                {
                    //Make a Fort Save
                    if(!OnHitSavingThrow(SAVING_THROW_FORT, oTarget, GetOnHitAbilityDC(oCaster), SAVING_THROW_TYPE_POISON, oCaster))
                    {
                       if (!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                       {
                       	nRounds = ApplyMetamagicVariableMods(d6(1), 6);
                       	fDelay = GetRandomDelay(0.75, 1.75);
                       	//Apply the VFX impact and linked effects
                       	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                       	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nRounds)));
						string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> stuns "+GetName(oTarget)+"</color>";
						SendMessageToPC(oCaster, report);
                       }
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}