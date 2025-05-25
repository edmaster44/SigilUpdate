

#include "ps_sigis_inc"
#include "ps_inc_faction"
#include "nw_i0_plot"

string TodaysDate() {
	return SigisDate(GetRealTime());
}

void TakeAppropriatePayment(object oPC);

void main (int roomNum) {

	object oPC = GetPCSpeaker();
	

	if (roomNum == 1)
	{
		TakeAppropriatePayment(oPC);
		object oItem = CreateItemOnObject("ps_3dragons_key", oPC, 1, "ps_3dragons_key_1", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nRoom 1 \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		SetLocalInt(OBJECT_SELF, "room_1", 1);
		SetLocalString(oItem, "timestamp", TodaysDate());
	}
	else if (roomNum == 2)
	{
		TakeAppropriatePayment(oPC);
		object oItem = CreateItemOnObject("ps_3dragons_key", oPC, 1, "ps_3dragons_key_2", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nRoom 2 \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		SetLocalInt(OBJECT_SELF, "room_2", 1);
		SetLocalString(oItem, "timestamp", TodaysDate());
	}
	else if (roomNum == 3)
	{
		TakeAppropriatePayment(oPC);
		object oItem = CreateItemOnObject("ps_3dragons_key", oPC, 1, "ps_3dragons_key_3", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nRoom 3 \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		SetLocalInt(OBJECT_SELF, "room_3", 1);
		SetLocalString(oItem, "timestamp", TodaysDate());
	}
	else if (roomNum == 4)
	{
		TakeAppropriatePayment(oPC);
		object oItem = CreateItemOnObject("ps_3dragons_key", oPC, 1, "ps_3dragons_key_4", TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nRoom 4 \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		SetLocalInt(OBJECT_SELF, "room_4", 1);
		SetLocalString(oItem, "timestamp", TodaysDate());
	}
}

void TakeAppropriatePayment(object oPC) {

	if (GetFaction(oPC) == 14 && GetGold(oPC) >= 800) {
		TakeGoldFromCreature(800, oPC, TRUE, TRUE);
	} else if (GetItemPossessedBy(oPC, "ps_miscstack_coinage-pcogcoin") != OBJECT_INVALID) {
		TakeNumItems( oPC, "ps_miscstack_coinage-pcogcoin", 1 );
	} else {
		TakeGoldFromCreature(1200, oPC, TRUE, TRUE);
	}

}