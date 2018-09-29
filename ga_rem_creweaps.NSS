void main()
{
	object oPC = GetPCSpeaker();
	object oCW1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
	object oCW2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
	object oCW3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
	
	string sName;
	
	if (GetIsObjectValid(oCW1))
	{
		AssignCommand(oPC, ActionUnequipItem(oCW1));
		sName = "";
		sName = GetName(oCW1);
		if (sName == "") sName = "creature weapon";
		SendMessageToPC(oPC, "<c=red>Removing and destroying " + sName);
		DestroyObject(oCW1);
	}

	if (GetIsObjectValid(oCW2))
	{
		AssignCommand(oPC, ActionUnequipItem(oCW2));
		sName = "";
		sName = GetName(oCW2);
		if (sName == "") sName = "creature weapon";
		SendMessageToPC(oPC, "<c=red>Removing and destroying " + sName);
		DestroyObject(oCW2);
	}

	if (GetIsObjectValid(oCW3))
	{
		AssignCommand(oPC, ActionUnequipItem(oCW3));
		sName = "";
		sName = GetName(oCW3);
		if (sName == "") sName = "creature weapon";
		SendMessageToPC(oPC, "<c=red>Removing and destroying " + sName);
		DestroyObject(oCW3);
	}
	
}