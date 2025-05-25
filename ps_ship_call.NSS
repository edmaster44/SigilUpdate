

#include "ps_ship_generic_inc"
void main ()
{
	object ship_controller = GetObjectByTag(GetLocalString(OBJECT_SELF, "ship_controller_tag"));
	PlaySound("as_cv_gongring2", TRUE);
	if (GetDestinationIsInQueue(ship_controller, GetLocalString(OBJECT_SELF, "ship_this_location")))
	{
		int currentPosInQueue = GetLocalInt(ship_controller, "ship_queue_pos");
		int nextDestinationTime = GetLocalInt(ship_controller, "ship_time_"+IntToString(currentPosInQueue));
		int diff = nextDestinationTime-ShipTimeStamp();
		diff += 30;
		if (diff < 30)
			SpeakString("You see the ship pulling into the dock; it will be ready to board in approximately a minute.");
		else if (diff < 60)
			SpeakString("You see the ship on the horizon; it will be at the dock in a few minutes.");
		else
			SpeakString("The ship has been called.");		
		return;
	}
	else
		AddDestinationToQueue(ship_controller, GetLocalString(OBJECT_SELF, "ship_this_location"));
	SpeakString(GetLocalString(OBJECT_SELF, "ship_call_message"));
}