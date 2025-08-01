//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloudC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Objects within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Updated By: GeorgZ 2003-08-21: Now affects doors and placeables as well
#include "nw_s0_inccloud_inc"

void main()
{

    //Declare major variables
	object oCaster = GetAreaOfEffectCreator();
	
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
    }
	
	object oTarget;
	struct dSpellData data = GetSpellDataForAoE("IncCloud", oCaster);
    int nDamage = GetIncCloudDamage(oCaster, data.nCL);
    effect eDam;

    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    float fDelay;
   
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget)){
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
            fDelay = GetRandomDelay(0.5, 2.0);
          
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INCENDIARY_CLOUD));
			
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
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}