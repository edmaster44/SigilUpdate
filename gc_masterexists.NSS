#include "ff_safevar"

int StartingConditional()
{
	object oMaster = PS_GetLocalObject(OBJECT_SELF, "MASTER");
	return GetIsObjectValid(oMaster);
	
}