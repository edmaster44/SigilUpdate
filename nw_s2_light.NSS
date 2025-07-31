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

    if (!X2PreSpellCastCode()) return;
    
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	int nTargetType = GetObjectType(oTarget);
	
	int nLevel;
	int nId = GetSpellId();
	int bDivineLight = FALSE;
	if (nId == SPELL_RACIAL_LIGHT){
		nLevel = GetHitDice(oCaster);
		int nRace = GetSubRace(oCaster);
		if (nRace == 13 || nRace == 203) bDivineLight = TRUE;
	} else nLevel = PS_GetCasterLevel(oCaster);
	if (nLevel < 1) nLevel = 1;
	int nDur = nLevel;
	
	int nMeta = GetMetaMagicFeat();
	if (nMeta == METAMAGIC_EXTEND || bDivineLight == 1) nDur *= 2;
	float fDur = HoursToSeconds(nDur);
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_LIGHT); // new aoe for light
	SetEffectSpellId(eAOE, nId); 
	
    // Handle spell cast on item....
    if (nTargetType == OBJECT_TYPE_ITEM && !CIGetIsCraftFeatBaseItem(oTarget)){
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
		// store spell info on caster for aoe to read because 
		// GetSpellId(), GetCasterLevel(), and numerous other functions do not 
		// work reliably from within the aoe scripts
		StoreSpellDataForAoE("Light", nId, nLevel);
		if (nTargetType == OBJECT_TYPE_CREATURE || nTargetType == OBJECT_TYPE_DOOR ||
			nTargetType == OBJECT_TYPE_PLACEABLE || nTargetType == OBJECT_TYPE_ITEM){
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDur);
		} else {
			location lLocation = GetSpellTargetLocation();
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, fDur);
		}
    }
}