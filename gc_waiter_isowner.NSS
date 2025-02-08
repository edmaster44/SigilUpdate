#include "ff_safevar"

/* Script Created by Agony_Aunt/Loki for SCoD PW. Waiter who can be summoned to provide refreshments for a party*/

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oNPC = OBJECT_SELF;
	
	if (PS_GetLocalString(oNPC, "OwnerName") == GetName(oPC)) return 1;
	else return 0;	
}