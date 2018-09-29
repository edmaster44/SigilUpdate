#include "ps_inc_functions"

void main()
{
	object oPC = GetEnteringObject();
	if (GetIsPC(oPC))
	{	if(GetCollision(oPC) == 0)
		{	PS_CollisionControl(oPC,1);
			SendMessageToPC(oPC, "You have been made OOC unwalkable.");
		}	
		SetLocalInt(oPC,"ExploitBlocker",1);
		SetLocalInt(oPC,"DoorExploitPrevent",1);
	}
}