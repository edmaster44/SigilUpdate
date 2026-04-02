#include "ff_applyeffect" 


int StartingConditional()
{
	object oMaster = GetLocalObject(OBJECT_SELF, "MASTER");
	return GetIsObjectValid(oMaster);
	
}