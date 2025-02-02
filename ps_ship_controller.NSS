#include "ps_ship_generic_inc"
void main ()
{
	//slow down heartbeat to once a minute
	if (GetCustomHeartbeat(OBJECT_SELF) < 60000)
		SetCustomHeartbeat(OBJECT_SELF, 60000);
		
	int currentPosInQueue = GetLocalInt(OBJECT_SELF, "ship_queue_pos");
	string nextDestination = GetLocalString(OBJECT_SELF, "ship_queue_"+IntToString(currentPosInQueue));
	int nextDestinationTime = GetLocalInt(OBJECT_SELF, "ship_time_"+IntToString(currentPosInQueue));
	string boardShipPrefab = GetLocalString(OBJECT_SELF, "ship_board_prefab");
	string shipPrefab = GetLocalString(OBJECT_SELF, "ship_prefab");
	object ship_plank = GetObjectByTag(GetLocalString(OBJECT_SELF, "ship_plank"));
	
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
		SetLocalInt(OBJECT_SELF, "ship_queue_pos", currentPosInQueue+1);
		SetLocalString(ship_plank, "ship_dock", nextDestination);
		AssignCommand(OBJECT_SELF, ActionSpeakString("The ship has arrived at its destination. You may disembark."));
	}
	else if (GetIsObjectValid(GetObjectByTag(boardShipPrefab)))
	{
		DestroyObject(GetObjectByTag(boardShipPrefab));
		DestroyObject(GetObjectByTag(shipPrefab));
		SetLocalString(ship_plank, "ship_dock", "");
		AssignCommand(OBJECT_SELF, ActionSpeakString("The ship is departing. Please do not disembark."));
	}
}