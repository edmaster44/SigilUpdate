#include "ff_safevar"

#include "ps_ship_generic_inc"

int StartingConditional(string currentWp, string controllerTag)
{
	object ship_controller = GetObjectByTag(controllerTag);
	int currentPosInQueue = PS_GetLocalInt(ship_controller, "ship_queue_pos");
	string currentDestination = PS_GetLocalString(ship_controller, "ship_queue_"+IntToString(currentPosInQueue-1));
	return (currentDestination == currentWp);
}