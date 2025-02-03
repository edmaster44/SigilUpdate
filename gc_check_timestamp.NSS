#include "ps_inc_time"

//Checks the timestamp set by ga_timestamp
//returns true if it has been over secondsToCheck seconds
//saves on the module for universality
//stampName = the name of the timestamp variable
//secondsToCheck = the number of seconds it has been since the last timestamp

/*
Warning: ga_play_custom_animation.nss(34): Warning: NSC6010: Entry point function "main" has a default value for argument "bLoop", but the runtime will select default argument values from a hardcoded list of defaults for script entry point symbols.  Consider removing explicit default arguments from the function and handling the actual runtime default values (which are zero, OBJECT_INVALID, and an empty string, as appropriate).

*/
int StartingConditional(string stampName, int secondsToCheck) {
	
	if (stampName == "") stampName = "Timestamp";
	if (secondsToCheck == 0) secondsToCheck = 60;
	object oHolder = GetModule();
	
	if (GetLocalInt(oHolder, stampName) <= 0)
		return TRUE;
	
	if (PS_GetTimestamp_Age_Seconds(oHolder, stampName) >= secondsToCheck)
		return TRUE;
	
	return FALSE;

}