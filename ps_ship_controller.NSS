#include "ff_safevar"

#include "ps_ship_generic_inc"
void main ()
{
	//slow down heartbeat to once a minute
	if (GetCustomHeartbeat(OBJECT_SELF) < 60000)
		SetCustomHeartbeat(OBJECT_SELF, 60000);
		
	int currentPosInQueue = PS_GetLocalInt(OBJECT_SELF, "ship_queue_pos");
	string nextDestination = PS_GetLocalString(OBJECT_SELF, "ship_queue_"+IntToString(currentPosInQueue));
	int nextDestinationTime = PS_GetLocalInt(OBJECT_SELF, "ship_time_"+IntToString(currentPosInQueue));
	string boardShipPrefab = PS_GetLocalString(OBJECT_SELF, "ship_board_prefab");
	string shipPrefab = PS_GetLocalString(OBJECT_SELF, "ship_prefab");
	object ship_plank = GetObjectByTag(PS_GetLocalString(OBJECT_SELF, "ship_plank"));
	
	int time = (nextDestinationTime-ShipTimeStamp())+30;
	object destination = GetWaypointByTag(nextDestination);
	if (GetIsObjectValid(destination))
	{
		if (time < 30)
			AssignCommand(OBJECT_SELF, ActionSpeakString("The ship will arrive at its next destination in a few seconds."));
		else if (time < 60)
			AssignCommand(OBJECT_SELF, ActionSpeakString("The ship will arrive at its next destination in approximately one minute."));
		else
			AssignCommand(OBJECT_SELF, ActionSpeakString("The ship will arrive at its next destination in a few minutes."));
	}
	
	if (GetWithinTimeWindow(nextDestinationTime) && !GetIsObjectValid(GetObjectByTag(boardShipPrefab)))
	{
		location lLoc = GetLocation(GetWaypointByTag(nextDestination));
		CreateObject(OBJECT_TYPE_PLACEABLE, boardShipPrefab, lLoc);
		lLoc = GetLocation(GetWaypointByTag(nextDestination+"_ship"));
		CreateObject(OBJECT_TYPE_PLACEABLE, shipPrefab, lLoc);
		PS_SetLocalInt(OBJECT_SELF, "ship_queue_pos", currentPosInQueue+1);
		PS_SetLocalString(ship_plank, "ship_dock", nextDestination);
		AssignCommand(OBJECT_SELF, ActionSpeakString("The ship has arrived at its destination. You may disembark."));
	}
	else if (GetIsObjectValid(GetObjectByTag(boardShipPrefab)))
	{
		DestroyObject(GetObjectByTag(boardShipPrefab));
		DestroyObject(GetObjectByTag(shipPrefab));
		PS_SetLocalString(ship_plank, "ship_dock", "");
		AssignCommand(OBJECT_SELF, ActionSpeakString("The ship is departing. Please do not disembark."));
	}
}