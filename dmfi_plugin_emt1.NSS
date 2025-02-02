#include "ff_safevar"

#include "dmfi_inc_sendtex"

void main()
{

	object oPC = OBJECT_SELF;
	object oSpeaker = PS_GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER");
	object oTarget = PS_GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET");
	string sInput = PS_GetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD");
	
	
	
	if (FindSubString(sInput, "wave")!=-1)
	{
		SendText(oSpeaker, "DEBUG: EMT 1");
		SendText(oSpeaker, "DEBUG: sInput: " + sInput);
		SendText(oSpeaker, "DEBUG: oPlayer: " + GetName(oPC));
		SendText(oSpeaker, "DEBUG: oSpeaker: " + GetName(oSpeaker));
		SendText(oSpeaker, "DEBUG: oTarget: " + GetName(oTarget));	
		
		DelayCommand(3.0, AssignCommand(oTarget, SpeakString("Greetings Lad!! (added via plugin)")));
	}		 

}	
			