#include "ff_safevar"

#include "ps_sigis_inc"

string TodaysDate() {
	return SigisDate(GetRealTime());
}

void main (int roomNum) {

	object oPC = GetPCSpeaker();
	

	if (roomNum == 1)
	{
		TakeGoldFromCreature(500, oPC, TRUE, TRUE);
		object oItem = CreateItemOnObject("ps_gb_key", oPC, 1, "ps_gb_key_1", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nAzure Room \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		PS_SetLocalInt(OBJECT_SELF, "room_1", 1);
		PS_SetLocalString(oItem, "timestamp", TodaysDate());
	}
	else if (roomNum == 2)
	{
		TakeGoldFromCreature(750, oPC, TRUE, TRUE);
		object oItem = CreateItemOnObject("ps_gb_key", oPC, 1, "ps_gb_key_2", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nGreen Room \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		PS_SetLocalInt(OBJECT_SELF, "room_2", 1);
		PS_SetLocalString(oItem, "timestamp", TodaysDate());
	}
	else if (roomNum == 3)
	{
		TakeGoldFromCreature(1000, oPC, TRUE, TRUE);
		object oItem = CreateItemOnObject("ps_gb_key", oPC, 1, "ps_gb_key_3", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nGolden Room \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		PS_SetLocalInt(OBJECT_SELF, "room_3", 1);
		PS_SetLocalString(oItem, "timestamp", TodaysDate());
	}
}