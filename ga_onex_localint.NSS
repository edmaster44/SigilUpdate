#include "ff_safevar"

void main() {

	object oPC = GetExitingObject();
	
	string sName = PS_GetLocalString(OBJECT_SELF, "INT_ONEX_NAME");
	int nValue = PS_GetLocalInt(OBJECT_SELF, "INT_ONEX_VALUE");
	
	PS_SetLocalInt(oPC, sName, nValue);

}