//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
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
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
	}
	
	struct dSpellData data = GetSpellDataForAoE("AcidFog", oCaster);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    object oTarget;
    float fDelay;
	
	int nDamage = GetAcidFogDamage(oCaster, data.nCL);
	
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget)){
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
            if(MySavingThrow(SAVING_THROW_FORT, oTarget, data.nDC, SAVING_THROW_TYPE_ACID, oCaster, fDelay))
                 nDamage = nDamage / 2;
   
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
			eDam = EffectLinkEffects(eVis, eDam);

			fDelay = GetRandomDelay(0.4, 1.2);
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

        }
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}