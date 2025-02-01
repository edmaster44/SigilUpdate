#include "ff_safevar"

#include "ps_sigis_inc"

string TodaysDate() {
	return SigisDate(GetRealTime());
}

void main (int roomNum) {

	object oPC = GetPCSpeaker();
	
	if (roomNum == 3)
	{
		TakeGoldFromCreature(1000, oPC, TRUE, TRUE);
		object oItem = CreateItemOnObject("ps_fire_birdkey", oPC, 1, "ps_fire_birdkey_3", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nRoom#3 \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		PS_SetLocalInt(OBJECT_SELF, "room_3", 1);
		PS_SetLocalString(oItem, "timestamp", TodaysDate());
	}
	else
	{
		int room1 = PS_GetLocalInt(OBJECT_SELF, "room_1");
		int room2 = PS_GetLocalInt(OBJECT_SELF, "room_2");
		if (!room1)
		{
			TakeGoldFromCreature(500, oPC, TRUE, TRUE);
			object oItem = CreateItemOnObject("ps_fire_birdkey", oPC, 1, "ps_fire_birdkey_1", TRUE);
			string sDescrip = GetDescription(oItem)+"\n\nRoom#1 \n\nGood for: "+TodaysDate();
			SetDescription(oItem, sDescrip);
			PS_SetLocalInt(OBJECT_SELF, "room_1", 1);
			PS_SetLocalString(oItem, "timestamp", TodaysDate());
		}
		else if (!room2)
		{
			TakeGoldFromCreature(500, oPC, TRUE, TRUE);
			object oItem = CreateItemOnObject("ps_fire_birdkey", oPC, 1, "ps_fire_birdkey_2", TRUE);
			string sDescrip = GetDescription(oItem)+"\n\nRoom#2 \n\nGood for: "+TodaysDate();
			SetDescription(oItem, sDescrip);
			PS_SetLocalInt(OBJECT_SELF, "room_2", 1);
			PS_SetLocalString(oItem, "timestamp", TodaysDate());
		}
	}
}