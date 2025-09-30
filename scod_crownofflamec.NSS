//::///////////////////////////////////////////////

// FlattedFifth - June 17, 2024. Reworked logic to have no affect on allies, changed damage 
//			to do 1d8 vs good, 2d8 vs neutral, and 3d8 vs evil with an additional 1d8 vs
//			enemy outsiders, undead, and fey
// FlattedFifth - June 26, 2024. Updated to use spellIsTarget() function in nw_io_spells. That's
// 		 	a more thorough check than just GetReactionTypeHostile().

#include "scod_crownofflame_inc"


void main()
{
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){	
		DestroyObject(OBJECT_SELF);
        return;		
	}
	
	struct dSpellData data = GetSpellDataForAoE("CrownOfFlames", oCaster);
	
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {	
		ApplyCoF(oTarget, oCaster, data.nId, data.nCL);
		// get the next target in the AoE
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
	}
}