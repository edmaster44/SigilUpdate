//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: March 2003: Removed movement speed penalty
#include "nw_s0_inccloud_inc"

void main()
{

    //Declare major variables
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
    }
	object oTarget = GetEnteringObject();
	struct dSpellData data = GetSpellDataForAoE("IncCloud", oCaster);
    int nDamage = GetIncCloudDamage(oCaster, data.nCL);
    effect eDam;

    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    float fDelay;
    
    //Declare the spell shape, size and the location.
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator())){
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD));
      
		fDelay = GetRandomDelay(0.5, 2.0);
		
		//Adjust damage for Reflex Save, Evasion and Improved Evasion
		if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, data.nDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay))
			 nDamage = nDamage/2;
			
		// Apply effects to the currently selected target.
		eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
		if(nDamage > 0)
		{
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
    }
}