

#include "ps_sigis_inc"

string TodaysDate() {
	return SigisDate(GetRealTime());
}

void main ()
{
	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
		
	object oKey = GetItemPossessedBy(oPC, "ps_fire_birdkey_1");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_fire_birdkey_2");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_fire_birdkey_3");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_gb_key_1");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_gb_key_2");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_gb_key_3");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_room_1");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_room_2");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_room_3");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_room_4");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_room_5");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_a1");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_a2");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_a3");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_a4");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
	oKey = GetItemPossessedBy(oPC, "ps_chirpers_a5");
	if (GetIsObjectValid(oKey) && GetLocalString(oKey, "timestamp") != TodaysDate())
	 	DestroyObject(oKey);
		
}