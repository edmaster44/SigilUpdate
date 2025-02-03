/* Script Created by Agony_Aunt/Loki for SCoD PW. Waiter who can be summoned to provide refreshments for a party*/

#include "ps_waiter_inc"

void main(int iAction)
{
	object oWaiter = OBJECT_SELF;
	object oPC = GetPCSpeaker();
	
	AssignCommand(oWaiter, ClearAllActions(TRUE));
	
	switch (iAction)
	{
		case 1:
		{
			// Set Bar
			SetLocalLocation(oWaiter, "BarLocation", GetLocation(oWaiter));
			break;
		}
		case 2:
		{
			// Set Service Area
			SetLocalLocation(oWaiter, "SpawnLocation", GetLocation(oWaiter));
			break;
		}
		case 3:
		{
			// Stay
			SetLocalInt(oWaiter, "ServiceStatus", WAITER_INACTIVE);
			break;
		}
		case 4:
		{
			// Follow
			SetLocalInt(oWaiter, "ServiceStatus", WAITER_INACTIVE);
			AssignCommand(oWaiter, ActionForceFollowObject(oPC, 2.0));
			break;
		}
		case 5:
		{
			// Serve customers
			
			// just update the owner object since we are here anyway and the gc_ script has already confirmed via name that this is the right person
			if (GetLocalObject(oWaiter, "Owner") != oPC)
				SetLocalObject(oWaiter, "Owner", oPC);
			
			// check for valid areas and start locations for both, otherwise report to owner that there is a problem.
			object oServiceArea = GetAreaFromLocation(GetLocalLocation(oWaiter, "SpawnLocation"));
			object oBarArea = GetAreaFromLocation(GetLocalLocation(oWaiter, "BarLocation"));
			object oCurrentArea = GetAreaFromLocation(GetLocation(oWaiter));
			
			if (oServiceArea != oCurrentArea || oBarArea != oCurrentArea)
			{
				SendMessageToPC(oPC, "<COLOR=cyan>Your waiter's service and/or bar areas have not been set or are set for a different area. Give it instructions by talking to it so it knows where to work from.");
			}
			else
			{
				// everything is ok, start serving
				SetLocalInt(oWaiter, "ServiceStatus", WAITER_ACTIVE);
			}
			break;
		}
		case 6:
		{
			// Stop serving
			SetLocalInt(oWaiter, "ServiceStatus", WAITER_INACTIVE);
			WaiterMoveToBar(oWaiter);
			break;
		}
		case 7:
		{
			AssignCommand(oWaiter, ClearAllActions());
			AssignCommand(oWaiter,SetIsDestroyable(TRUE, FALSE, FALSE));
			DestroyObject(oWaiter, 1.0);
			break;
		}
		default:
		{
			// do nothing
			break;
		}
	}
}