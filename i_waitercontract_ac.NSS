#include "ff_safevar"

/* Script Created by Agony_Aunt/Loki for SCoD PW. Waiter who can be summoned to provide refreshments for a party*/

void main()
{
	object	oPC = GetItemActivator();
	location lTarget = GetItemActivatedTargetLocation();
	object oItem = GetItemActivated();
	//spawn appropriate waiter
	string sResRef = PS_GetLocalString(oItem, "RESREF");
	object oWaiter = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget, TRUE);
	//set up local var(s) on spawn
	PS_SetLocalString(oWaiter, "OwnerName", GetName(oPC));
	PS_SetLocalObject(oWaiter, "Owner", oPC);
	DestroyObject(oItem);
}