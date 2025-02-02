#include "ff_safevar"

#include "dmfi_inc_sendtex"

void main()
{

	object oPC = OBJECT_SELF;
	object oSpeaker = PS_GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_SPEAKER");
	object oTarget = PS_GetLocalObject(OBJECT_SELF, "DMFI_CUSTOM_TARGET");
	string sInput = PS_GetLocalString(OBJECT_SELF, "DMFI_CUSTOM_CMD");
	
	SendText(oSpeaker, "DEBUG: CMD 2");

}	
			