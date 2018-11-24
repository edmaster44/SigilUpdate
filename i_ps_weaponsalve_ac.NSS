#include "x2_inc_itemprop"

//You only get one at a time
void EnforceOneRuinFeat(object oPC, int RuinFeat, object oTarget) {

	itemproperty ip = GetFirstItemProperty(oTarget);
	while (GetIsItemPropertyValid(ip)) {
	
		//If the item property is another temp ruin feat, remove
		if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT &&
		GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY &&
		GetItemPropertySubType(ip) != RuinFeat) {
			if (GetItemPropertySubType(ip) >= 393 &&
			GetItemPropertySubType(ip) <= 397) {
				SendMessageToPC(oPC, "Only one Ruin Feat salve may be applied at a time.");
				RemoveItemProperty(oTarget, ip);
			}
		}
		ip = GetNextItemProperty(oTarget);
	}
}

//Weapon Salve script for adding ruin feats to weapons
void main () {

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	
	if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM ||
		GetWeaponType(oTarget) == WEAPON_TYPE_NONE) {
		SendMessageToPC(oPC, "Target must be a weapon.");
		return;
	}
	
	int RuinFeat = GetLocalInt(oItem, "ruin_feat_id");
	float Duration = GetLocalFloat(oItem, "ruin_feat_duration");
	itemproperty ip = ItemPropertyBonusFeat(RuinFeat);
	
	EnforceOneRuinFeat(oPC, RuinFeat, oTarget);

	IPSafeAddItemProperty(oTarget, ip, Duration);
}