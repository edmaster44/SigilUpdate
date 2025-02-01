#include "ps_inc_functions"

void main()
{
	object oPC = GetExitingObject();
	if (GetIsPC(oPC))
	{	PS_SetLocalInt(oPC,"ExploitBlocker",0);
		PS_DeleteLocalInt(oPC,"DoorExploitPrevent");
		if (PS_GetLocalInt(oPC,"ClosenessStatus") == 1)
		{	PS_CollisionControl(oPC,0);		}
	}
}