#include "ff_safevar"

/*
ga_creatureweapon_upgrade by Ceremorph for the Sigil: City of Doors PW
	For use with "equippable" creature weapons	
		Determines upgraded version of current weapon in right hand slot
		Removes current weapon
		Generates and equips upgraded weapon
*/

void main()
{
	object oPC = GetPCSpeaker();
	object oItem = GetItemInSlot(4, oPC);
	string sUpgrade = PS_GetLocalString(oItem, "NextTag");

	
	DestroyObject(oItem,0.0, TRUE);
	
	object oUpgrade;
	
	oUpgrade = CreateItemOnObject(sUpgrade,oPC,1,sUpgrade,1);
		SetIdentified(oUpgrade, TRUE);
//		DelayCommand(3.0, AssignCommand(oPC, ActionEquipItem(oUpgrade, INVENTORY_SLOT_CWEAPON_R)));
		
		string sUpgradeName = GetName(oUpgrade);
		
		SendMessageToPC(oPC, "<color=yellow>Upgraded " + sUpgradeName + " has been created in your inventory</color>");

}