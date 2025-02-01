#include "ff_safevar"

void main (string newname)
{
	newname = GetSubString(newname, 0, 20);

	string parchmentVarName = "parchmentObject";
	string parchmentWritingVarName = "writing";
	
	object oPC = OBJECT_SELF;
	object parchmentObject = PS_GetLocalObject(oPC, parchmentVarName);

	if (newname != "")
	{
		SetFirstName(parchmentObject, "Parchment: " + newname);
		PS_SetLocalString(parchmentObject, parchmentWritingVarName, "(no text)");
	}
	else
	{
		SetFirstName(parchmentObject, "Written parchment");
		PS_SetLocalString(parchmentObject, parchmentWritingVarName, "(no text)");
	}
	
	// get the actual message text
    int msgref = 0;
    string msg = "Enter the message (200 characters maximum):";
	DisplayInputBox (oPC, msgref, msg, "gui_ps_parchment_write");
}