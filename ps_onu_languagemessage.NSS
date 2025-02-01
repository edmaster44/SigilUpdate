#include "ff_safevar"

#include "dmfi_inc_langexe"

void main() {

	object oPC = GetLastUsedBy();
	
	string sFail = PS_GetLocalString(OBJECT_SELF, "FAILMESSAGE");
	string sLang = PS_GetLocalString(OBJECT_SELF, "LANGUAGE");
	string sSuccess = PS_GetLocalString(OBJECT_SELF, "SUCCESSMESSAGE");
	
	if (DMFI_IsLanguageKnown(oPC, sLang)) {
		SendMessageToPC(oPC, sSuccess);
	} else {
		SendMessageToPC(oPC, sFail);
	}

}