//Weapon Salve script for adding ruin feats to weapons
void main () {

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	
	if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM ||
		GetWeaponType(oTarget) != WEAPON_TYPE_NONE) {
		SendMessageToPC(oPC, "Target must be a weapon.");
	}
	
	

}