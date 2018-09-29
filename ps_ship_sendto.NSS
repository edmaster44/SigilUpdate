#include "ps_ship_generic_inc"
void main (string destWaypoint, string controllerTag)
{
	object ship_controller = GetObjectByTag(controllerTag);
	AddDestinationToQueue(ship_controller, destWaypoint);
}