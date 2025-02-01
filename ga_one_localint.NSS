#include "ff_safevar"

void main() {

	object oPC = GetEnteringObject();
	
	string sName = PS_GetLocalString(OBJECT_SELF, "INT_ONE_NAME");
	int nValue = PS_GetLocalInt(OBJECT_SELF, "INT_ONE_VALUE");
	
	PS_SetLocalInt(oPC, sName, nValue);

}