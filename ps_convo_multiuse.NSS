/*
ps_convo_multiuse
by Dedic8ed 2/26/2011

Script designed for to allow non-hostile NPCs to speak a quick response rather than initiate 
conversation when clicked on if they don't have a conversation attached If they do have a
conversation attached, do not use this script.

The randomizer and variables allow for multiple responses to be given if desired, up to a
maximum of five different responses.
*/

void main() {

    object oSpeaker  = GetLastSpeaker();
	if (!GetIsPC(oSpeaker))
		return;

	//	Determine how many responses will be available to this NPC.
	int iResponses	= GetLocalInt(OBJECT_SELF, "responses");
	string sSay1	= GetLocalString(OBJECT_SELF, "say1");
	string sSay2	= GetLocalString(OBJECT_SELF, "say2");
	string sSay3	= GetLocalString(OBJECT_SELF, "say3");
	string sSay4	= GetLocalString(OBJECT_SELF, "say4");
	string sSay5	= GetLocalString(OBJECT_SELF, "say5");

	switch (Random(iResponses)) {
	
		case 0:
			DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionSpeakString(sSay1)));
			break;
				
		case 1:
			DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionSpeakString(sSay2)));
			break;
			
		case 2: 
			DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionSpeakString(sSay3)));
			break;
			
		case 3:
			DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionSpeakString(sSay4)));
			break;
		
		case 4:
			DelayCommand(0.3, AssignCommand(OBJECT_SELF, ActionSpeakString(sSay5)));
			break;
						
	}

}