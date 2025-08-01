//::///////////////////////////////////////////////
//:: Stinking Cloud On Enter
//:: NW_S0_StinkCldA.nss
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

void main(){
	
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
    }

	struct dSpellData data = GetSpellDataForAoE("StinkCloud", oCaster);
    //Declare major variables
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);
    //eLink = EffectLinkEffects(eLink, eDur);

    //effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    object oTarget;
    float fDelay;
    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STINKING_CLOUD));
        //Make a SR check
        if(!MyResistSpell(oCaster, oTarget)){
            //Make a Fort Save
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, data.nDC, SAVING_THROW_TYPE_POISON)){
               fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
			   //MySavingThrow now automatically succeeds if immune, so no need to check immunity
               //if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE){
                   //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
               //}
            }
        }
    }
}