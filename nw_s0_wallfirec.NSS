//::///////////////////////////////////////////////
//:: Wall of Fire: Heartbeat
//:: NW_S0_WallFireA.nss
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

// (Update JLR - OEI 07/19/05) -- Changed Dmg to 2d6 + lvl (max 20), double dmg to Undead


#include "nw_s0_wallfire_inc"

void main(){

	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
	}
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	struct dSpellData data = GetSpellDataForAoE("Walloffire", oCaster);
	int PML = GetPureMageLevels(oCaster);
	int nMetaMagic = GetMetaMagicFeat();
   

    int nDamage;
    effect eDam;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
   
    while(GetIsObjectValid(oTarget)){
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));
            //Make SR check, and appropriate saving throw(s).
            if(!MyResistSpell(oCaster, oTarget)){
                nDamage = GetWallOfFireDamage(oCaster, oTarget, data, PML, nMetaMagic);

                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, data.nDC, SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0){
                    // Apply effects to the currently selected target.
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}