#include "ps_inc_time"

//Sets a timestamp variable on the module
//stampName = the name of the timestamp variable
void main(string stampName = "Timestamp") {

	object oHolder = GetModule();
	PS_Timestamp_UNIX(oHolder, stampName);

}