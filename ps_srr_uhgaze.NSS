//::///////////////////////////////////////////////
//:: Gaze: Confusion
//:: NW_S1_GazeConfu
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cone shape that affects all within the AoE if they
    fail a Will Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"

void main()
{

    if( GZCanNotUseGazeAttackCheck(OBJECT_SELF))
    {
        return;
    }

    //Declare major variables
    int nHD = GetHitDice(OBJECT_SELF);
    int nDuration = 1 + (nHD / 3);
    int nDC = 10 + (nHD/2) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eGaze = EffectConfused();
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVisDur = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );

    effect eLink = EffectLinkEffects(eDur, eVisDur);
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_SONIC);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eCone, lTargetLocation, 2.0);
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            if(oTarget != OBJECT_SELF)
            {
                nDuration = GetScaledDuration(nDuration , oTarget);
                //Determine effect delay
                float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_CONFUSION));
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    eGaze = GetScaledEffect(eGaze, oTarget);
                    eLink = EffectLinkEffects(eLink, eGaze);

                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}