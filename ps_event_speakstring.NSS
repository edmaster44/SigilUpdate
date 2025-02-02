#include "ff_safevar"

void main() {

	string sNPC = PS_GetLocalString(OBJECT_SELF, "SPEAKSTRING_NPC");
	string sString = PS_GetLocalString(OBJECT_SELF, "SPEAKSTRING_STRING");
	
	object oNPC = GetNearestObjectByTag(sNPC);
	
	if (GetIsObjectValid(oNPC)) {
	
		AssignCommand(oNPC, ActionSpeakString(sString));
	
	}

}