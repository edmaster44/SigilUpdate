#include "dmfi_inc_langexe"

void main() {

	object oPC = GetClickingObject();
	
	string sFail = GetLocalString(OBJECT_SELF, "FAILMESSAGE");
	string sLang = GetLocalString(OBJECT_SELF, "LANGUAGE");
	string sSuccess = GetLocalString(OBJECT_SELF, "SUCCESSMESSAGE");
	
	if (DMFI_IsLanguageKnown(oPC, sLang)) {
		SendMessageToPC(oPC, sSuccess);
	} else {
		SendMessageToPC(oPC, sFail);
	}

}