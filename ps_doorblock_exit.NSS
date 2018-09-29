#include "ps_inc_functions"

void main()
{
	object oPC = GetExitingObject();
	if (GetIsPC(oPC))
	{	SetLocalInt(oPC,"ExploitBlocker",0);
		DeleteLocalInt(oPC,"DoorExploitPrevent");
		if (GetLocalInt(oPC,"ClosenessStatus") == 1)
		{	PS_CollisionControl(oPC,0);		}
	}
}