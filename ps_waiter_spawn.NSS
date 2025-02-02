#include "ff_safevar"

/* Script Created by Agony_Aunt/Loki for SCoD PW. Waiter who can be summoned to provide refreshments for a party*/

#include "ps_waiter_inc"

void main()
{
	PS_SetLocalLocation(OBJECT_SELF, "SpawnLocation", GetLocation(OBJECT_SELF));
	PS_SetLocalLocation(OBJECT_SELF, "BarLocation", GetLocation(OBJECT_SELF));
	PS_SetLocalInt(OBJECT_SELF, "ServiceStatus", WAITER_INACTIVE);
	SetFirstName(OBJECT_SELF, RandomName());
}