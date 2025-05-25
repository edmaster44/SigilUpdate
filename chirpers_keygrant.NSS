

#include "ps_sigis_inc"

string TodaysDate() {
	return SigisDate(GetRealTime());
}

void main (int roomNum, string sType) {

	object oPC = GetPCSpeaker();
	object oSign = GetNearestObjectByTag("chirpers_sign_2");
	object oSign2 = GetNearestObjectByTag("chirpers_sign_3");

	if (sType == "upstairs")
	{
		TakeGoldFromCreature(50, oPC, TRUE, TRUE);
		object oItem = CreateItemOnObject("ps_key_chirpers", oPC, 1, "ps_chirpers_room_"+IntToString(roomNum), TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nRoom #"+IntToString(roomNum)+" \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		SetLocalInt(oSign, "room_"+IntToString(roomNum), 1);
		SetLocalString(oItem, "timestamp", TodaysDate());
	} else if (sType == "downstairs" && roomNum == 2) {
		TakeGoldFromCreature(250, oPC, TRUE, TRUE);
		object oItem = CreateItemOnObject("ps_key_chirpers", oPC, 1, "ps_chirpers_a"+IntToString(roomNum), TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nShipwreck Suite \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		SetLocalInt(oSign2, "appart_"+IntToString(roomNum), 1);
		SetLocalString(oItem, "timestamp", TodaysDate());
	} else {
		TakeGoldFromCreature(100, oPC, TRUE, TRUE);
		object oItem = CreateItemOnObject("ps_key_chirpers", oPC, 1, "ps_chirpers_a"+IntToString(roomNum), TRUE);
		string sDescrip = GetDescription(oItem)+"\n\nAppartment #"+IntToString(roomNum)+" \n\nGood for: "+TodaysDate();
		SetDescription(oItem, sDescrip);
		SetLocalInt(oSign2, "appart_"+IntToString(roomNum), 1);
		SetLocalString(oItem, "timestamp", TodaysDate());
	}
}