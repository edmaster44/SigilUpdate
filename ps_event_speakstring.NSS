void main() {

	string sNPC = GetLocalString(OBJECT_SELF, "SPEAKSTRING_NPC");
	string sString = GetLocalString(OBJECT_SELF, "SPEAKSTRING_STRING");
	
	object oNPC = GetNearestObjectByTag(sNPC);
	
	if (GetIsObjectValid(oNPC)) {
	
		AssignCommand(oNPC, ActionSpeakString(sString));
	
	}

}