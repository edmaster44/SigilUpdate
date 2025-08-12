//::///////////////////////////////////////////////
//:: Blade Barrier, Wall : On Enter
//:: NW_S0_BladeBarWallA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 08.10.06 - Adapted to new functionality


#include "nw_s0_bladebarwall_inc"

void main(){


	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
        DestroyObject(OBJECT_SELF);
        return;
    }
	
	object oTarget = GetEnteringObject();
	struct dSpellData data = GetSpellDataForAoE("BladeBarrier", oCaster);
    effect eDam;
   
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
        
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLADE_BARRIER));
        
        int nDamage = GetBladeBarrierDamage(data.nCL);
     
        if (!MyResistSpell(oCaster, oTarget) ){
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, data.nDC, SAVING_THROW_TYPE_NONE, oCaster);

			if (nDamage > 0){
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
				
				SpawnBloodHit(oTarget, TRUE, OBJECT_INVALID);
				ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget);
			}
        }
    }
}