#include "ff_safevar"

/* Script Created by Agony_Aunt/Loki for SCoD PW. Waiter who can be summoned to provide refreshments for a party*/

// used to delay an active waiter from doing anything for a round due to heartbeat when a convo is started
#include "ps_waiter_inc"

void main()
{
	object oWaiter = OBJECT_SELF;
	PS_SetLocalInt(oWaiter, "LastAction", WAITER_IN_CONVO);
}