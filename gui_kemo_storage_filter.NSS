#include "ff_safevar"

void main (string sFilter)
{
	object oPC = OBJECT_SELF;
	
	if (sFilter != PS_GetLocalString(oPC,"StorageFilter"))
	{	PS_SetLocalString(oPC,"StorageFilter",sFilter);
		PS_SetLocalInt(oPC, "kemo_storage_page", 1);
	}
}