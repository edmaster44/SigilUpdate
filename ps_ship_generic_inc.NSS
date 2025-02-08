#include "ff_safevar"

int ShipTimeStamp()
{
	int iCurrentTime = GetCalendarYear()*812851200 + GetCalendarMonth()*2419200 + GetCalendarDay()*86400 + GetTimeHour()*3600 + GetTimeMinute()*60 + GetTimeSecond();
	
	return iCurrentTime;
}

int GetWithinTimeWindow(int destTime)
{
	int diff = ShipTimeStamp()-destTime;
	if (diff > 0 && diff < 120)
		return TRUE;
	return FALSE;
}

int GetDestinationIsInQueue(object ship, string dest)
{
	int nextInQueue = PS_GetLocalInt(ship, "ship_queue_pos");
	string nextDestination = PS_GetLocalString(ship, "ship_queue_"+IntToString(nextInQueue));
	while (nextDestination != "")
	{
		if (nextDestination == dest)
			return TRUE;
		nextInQueue++;
		nextDestination = PS_GetLocalString(ship, "ship_queue_"+IntToString(nextInQueue));
	}
	return FALSE;
}

void AddDestinationToQueue(object ship, string dest)
{
	if (GetDestinationIsInQueue(ship, dest))
		return;

	int nextInQueue = PS_GetLocalInt(ship, "ship_queue_pos");
	string nextDestination = PS_GetLocalString(ship, "ship_queue_"+IntToString(nextInQueue));
	while (nextDestination != "")
	{
		nextInQueue++;
		nextDestination = PS_GetLocalString(ship, "ship_queue_"+IntToString(nextInQueue));
	}
	PS_SetLocalString(ship, "ship_queue_"+IntToString(nextInQueue), dest);
	PS_SetLocalInt(ship, "ship_time_"+IntToString(nextInQueue), (ShipTimeStamp()+60));
}