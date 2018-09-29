// restores creature weapons that may have been removed
// checks first they should have
// does not reapply higher level weapons until next threshold

void main()
{
	object oPC = GetPCSpeaker();
	
	object oCWB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
	object oCWL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
	object oCWR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
	int iCWB = GetIsObjectValid(oCWB);
	int iCWL = GetIsObjectValid(oCWL);
	int iCWR = GetIsObjectValid(oCWR);

	if (iCWB == TRUE || iCWL == TRUE || iCWR == TRUE)
	{
		SendMessageToPC(oPC, "<color=yellow>Sorry, but your already have sharp teeth and/or claws.");
	}
	else
	{
		int iSUB = GetSubRace(oPC);
		string sCW1 = Get2DAString("racialsubtypes", "CW1", iSUB);
		string sCW2 = Get2DAString("racialsubtypes", "CW2", iSUB);
		string sCW3 = Get2DAString("racialsubtypes", "CW3", iSUB);
		object oTemp;

		if (sCW1 != "" && sCW2 != "" && sCW2 != "")
		{
			SendMessageToPC(oPC, "<color=yellow>Sorry, but you're just not the sort of creature that can have sharp teeth and claws");
		}
		else
		{
			if (sCW1 != "")
			{
				oTemp = CreateItemOnObject(sCW1, oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				DelayCommand(2.0, AssignCommand(oPC, ActionEquipItem(oTemp, INVENTORY_SLOT_CWEAPON_L)));
			}
			if (sCW2 != "")
			{
				oTemp = CreateItemOnObject(sCW2, oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				DelayCommand(2.0, AssignCommand(oPC, ActionEquipItem(oTemp, INVENTORY_SLOT_CWEAPON_R)));
			}
			if (sCW3 != "")
			{
				oTemp = CreateItemOnObject(sCW3, oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				DelayCommand(2.0, AssignCommand(oPC, ActionEquipItem(oTemp, INVENTORY_SLOT_CWEAPON_B)));
			}
			
			SendMessageToPC(oPC, "<color=yellow>There you go, nice and pointy again. If your race gets improved weapons at higher levels you will need to level up to the next threshold before they will be granted.");
		}
	}
}