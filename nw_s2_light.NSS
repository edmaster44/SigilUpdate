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
	
	int nRounds;
	int nId = GetSpellId();
	if (nId == SPELL_RACIAL_LIGHT){
		nRounds = GetTotalLevels(oCaster, TRUE); 
	} else nRounds = PS_GetCasterLevel(oCaster);
	int nMeta = GetMetaMagicFeat();
	if (nRounds < 5) nRounds = 5;
	if (nMeta == METAMAGIC_EXTEND) nRounds *= 2;
	float fDur = HoursToSeconds(nRounds);
	
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
		// store spell id and metamagic feat on caster for aoe to read because 
		// GetSpellId() and GetMetaMagicFeat() do not work from within the aoe script
		SetLocalInt(oCaster, "LightSpellId", nId);
		SetLocalInt(oCaster, "LightMetaMagic", nMeta);
		if (nTargetType == OBJECT_TYPE_CREATURE || nTargetType == OBJECT_TYPE_DOOR ||
			nTargetType == OBJECT_TYPE_PLACEABLE || nTargetType == OBJECT_TYPE_ITEM){
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDur);
		} else {
			location lLocation = GetSpellTargetLocation();
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLocation, fDur);
		}
    }
}