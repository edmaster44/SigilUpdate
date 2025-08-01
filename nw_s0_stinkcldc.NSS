//::///////////////////////////////////////////////
//:: Stinking Cloud
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

#include "x2_inc_spellhook"

void main(){
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
    }


    //Declare major variables
	struct dSpellData data = GetSpellDataForAoE("StinkCloud", oCaster);
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
    while(GetIsObjectValid(oTarget)){
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STINKING_CLOUD));
            //Make a SR check
            if(!MyResistSpell(oCaster, oTarget)){
                //Make a Fort Save
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, data.nDC, SAVING_THROW_TYPE_POISON)){
                   fDelay = GetRandomDelay(0.75, 1.75);
                   //Apply the VFX impact and linked effects
				   // MySavingThrow now checks for immunity, so no need to do it here
                  //if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE){
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
                   //}
                } else {
                    //If the Fort save was successful remove the Dazed effect
					PS_RemoveEffects(oTarget, SPELL_STINKING_CLOUD, NULL, oCaster);
                    
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}