//::///////////////////////////////////////////////
//:: Light (Drow/Aasimar Racial Ability)
//:: NW_S2_Light.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies a light source to the target for
    1 hour per level

    XP2
    If cast on an item, item will get temporary
    property "light" for the duration of the spell
    Brightness on an item is lower than on the
    continual light version.

*/

// JLR-OEI 03/16/06: For GDD Update
#include "x2_inc_spellhook"

void main(){
	object oCaster = GetAreaOfEffectCreator();
	
	struct dSpellData data = GetSpellDataForAoE("Light", oCaster);
	
    PS_RemoveEffects(GetExitingObject(), data.nId, NULL, oCaster);
}