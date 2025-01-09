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


#include "nw_s2_light_inc"

void main(){

    if (!X2PreSpellCastCode()) return;
    
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	int nTargetType = GetObjectType(oTarget);
	effect eAOE = EffectAreaOfEffect(AOE_PER_LIGHT); // new aoe for light
	
	int nRounds = PS_GetCasterLevel(OBJECT_SELF);
 
	int bDivineLight = FALSE;
	int nRace = GetSubRace(oCaster);
	int nId = GetSpellId();
	if (nId == SPELL_RACIAL_LIGHT){
		nRounds = GetTotalLevels(oCaster, TRUE); 
		if (nRace == 13 || nRace == 203) bDivineLight = TRUE;
			
	}
	if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nRounds *= 2;
	float fDur = HoursToSeconds(nRounds);
	
    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && !CIGetIsCraftFeatBaseItem(oTarget)){
        // Do not allow casting on not equippable items
        if (IPGetIsItemEquipable(oTarget)){
			itemproperty ip = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE);
			if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT)) return;
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip,oTarget,fDur);
        }
        itemproperty ip = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE);

        if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
			IPRemoveMatchingItemProperties(oTarget,ITEM_PROPERTY_LIGHT,DURATION_TYPE_TEMPORARY);
			
        AddItemProperty(DURATION_TYPE_TEMPORARY,ip,oTarget, fDur);
    } else {
       if (nTargetType == OBJECT_TYPE_CREATURE || nTargetType == OBJECT_TYPE_DOOR ||
			nTargetType == OBJECT_TYPE_PLACEABLE || nTargetType == OBJECT_TYPE_ITEM){
		
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDur);
			ApplyLight(oCaster, oTarget, nId, fDur, bDivineLight);
		} else {
			location lLocation = GetSpellTargetLocation();
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, fDur);
		}
    }
}