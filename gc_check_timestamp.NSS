#include "ps_inc_time"

//Checks the timestamp set by ga_timestamp
//returns true if it has been over secondsToCheck seconds
//saves on the module for universality
//stampName = the name of the timestamp variable
//secondsToCheck = the number of seconds it has been since the last timestamp
int StartingConditional(string stampName = "Timestamp", int secondsToCheck = 60) {

	object oHolder = GetModule();
	
	if (GetLocalInt(oHolder, stampName) <= 0)
		return TRUE;
	
	if (PS_GetTimestamp_Age_Seconds(oHolder, stampName) >= secondsToCheck)
		return TRUE;
	
	return FALSE;

}