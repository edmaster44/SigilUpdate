//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 08/29/2008: Will ignore SR check, in case of Acid Bomb (won't work otherwise)
// Mymothersmeatloaf 6/21/2020 - Removed SR
#include "nw_s0_acidfog_inc"

void main(){

	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
		struct dSpellData data = GetSpellDataForAoE("AcidFog", oCaster);
	
		int nDamage = GetAcidFogDamage(oCaster, data.nCL);
		effect eDam;
		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
		effect eSlow = EffectMovementSpeedDecrease(50);
		eSlow = SetEffectSpellId(eSlow, data.nId);
		object oTarget = GetEnteringObject();
		float fDelay = GetRandomDelay(1.0, 2.2);
        
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_FOG));
      
		
		//Make a Fortitude Save to avoid the effects of the movement hit.
		if(!MySavingThrow(SAVING_THROW_FORT, oTarget, data.nDC, SAVING_THROW_TYPE_ACID, oCaster, fDelay)){
			//slowing effect
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
		} else {
			nDamage = nDamage / 2;
		}
			
		eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
		eDam = EffectLinkEffects(eVis, eDam);
		
		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}