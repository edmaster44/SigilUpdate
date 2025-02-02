#include "ff_safevar"

//version 1.00

void main(int nECL)
{
//SendMessageToPC(GetFirstPC(), "specracetemplate ecl startX");
   object oPC = OBJECT_SELF;
	
   object oItem = GetItemPossessedBy(oPC,"ps_specracetemplate");
   
   if(GetIsObjectValid(oItem))
   {
//SendMessageToPC(GetFirstPC(), IntToString(nECL));
		PS_SetLocalString(oItem,"ECL",IntToString(nECL));
		return;
	}

}