#include "ff_safevar"

void main (string msgtext)
{
	msgtext = GetSubString(msgtext, 0, 200);

	string parchmentVarName = "parchmentObject";
	string parchmentWritingVarName = "writing";

	object oPC = OBJECT_SELF;
	object parchmentObject = PS_GetLocalObject(oPC, parchmentVarName);
	if(parchmentObject != OBJECT_INVALID)
	{
		if (msgtext != "")
		{
			PS_SetLocalString(parchmentObject, parchmentWritingVarName, msgtext);
		}
		else
		{
			PS_SetLocalString(parchmentObject, parchmentWritingVarName, "(no text)");
		}
	}
	
	// delete the item mark	
	PS_DeleteLocalObject(oPC, parchmentVarName);
}