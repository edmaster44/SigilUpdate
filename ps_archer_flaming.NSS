#include "ff_safevar"

#include "ps_inc_onhit" 

void main() {

	object oCaster = OBJECT_SELF;
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	if (!GetIsObjectValid(oItem)) //reject if we don't have a weapon equipped
		oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
	if (!GetIsObjectValid(oItem)) {
		SendMessageToPC(oCaster, "You must have a weapon equipped to use this ability.");
		return;
	}
		
	int itemType = GetBaseItemType(oItem);
	if (itemType != BASE_ITEM_HEAVYCROSSBOW && //reject for not being a ranged weapon
		itemType != BASE_ITEM_LIGHTCROSSBOW &&
		itemType != BASE_ITEM_SLING &&
		itemType != BASE_ITEM_LONGBOW  &&
		itemType != BASE_ITEM_SHORTBOW) {
		SendMessageToPC(oCaster, "You must be holding a ranged weapon to activate this feat!");
		return;	
	}
	
	//Get ammunition. . .
	if (itemType == BASE_ITEM_HEAVYCROSSBOW || itemType == BASE_ITEM_LIGHTCROSSBOW)
		oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oCaster);
	else if (itemType == BASE_ITEM_LONGBOW || itemType == BASE_ITEM_SHORTBOW)
		oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCaster);
	else if (itemType == BASE_ITEM_SLING)
		oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oCaster);
		
	if(!GetIsObjectValid(oItem) ){ //must have ammunition equipped
		SendMessageToPC(oCaster, "You must have ammunition equipped to activate this feat!");
		return;	
	}
		
	if (GetItemHasPermanentProperties(oItem) &&
		!IsCraftedAmmunition(oItem)){ //cannot be magical ammunition
		SendMessageToPC(oCaster, "You may only use this on non-magical ammunition!");
		return;	
	}
	
	if (PS_GetLocalInt(oItem, "elemental") == 1 && GetItemHasTemporaryProperties(oItem)){ //cannot be magical ammunition
		SendMessageToPC(oCaster, "You may only have one type of damage active at a time!");
		return;	
	}
	
    SignalEvent(GetItemPossessor(oItem), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	float fDuration = 86400.0f;
		
	// AFW-OEI 06/27/2007: Add a "cast" effect.
	effect eCast = EffectNWN2SpecialEffectFile("sp_fire_cast");
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
	PS_SetLocalInt(oItem, "elemental", 1);
	
	SetPlotFlag(oItem, TRUE);
	SetItemCursedFlag(oItem, TRUE);
	
	object rangedWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	if (GetHasFeat(2762, oCaster, TRUE) && !GetItemHasItemProperty(rangedWeapon, ITEM_PROPERTY_MASSIVE_CRITICALS)) {
		IPSafeAddItemProperty(rangedWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d10),
					  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
		
	if (GetHasFeat(2765, oCaster, TRUE))
	{
   		IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6),
						  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}

}