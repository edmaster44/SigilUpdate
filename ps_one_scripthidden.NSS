//Hide the npc when they cross the trigger. Or make them visible.
#include "ps_inc_time"
void main() {

	object oNPC = GetEnteringObject();
	
	if (GetIsPC(oNPC))
		return;

	int nHidden = GetLocalInt(OBJECT_SELF, "SCRIPT_HIDDEN"); //1 = hide, 0 = don't hide
	int nLerp = GetLocalInt(OBJECT_SELF, "SCRIPT_HIDDEN_DELAY"); //the time to wait before working again
	
	//Check if its been long enough
	if (nLerp > 0 && PS_GetTimestamp_Age_Seconds(oNPC, "LAST_HIDDEN") < nLerp)
		return;
		
	SetScriptHidden(oNPC, nHidden);
		
	PS_Timestamp_UNIX(oNPC, "LAST_HIDDEN");

}