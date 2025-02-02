#include "ff_safevar"

void main()
{
	string parchmentVarName = "parchmentObject";
	string parchmentWritingVarName = "writing";

	object oPC = GetPCSpeaker();
	object parchmentObject = PS_GetLocalObject(oPC, parchmentVarName);
	
	if(parchmentObject != OBJECT_INVALID)
	{
		string writtenText = PS_GetLocalString(parchmentObject, parchmentWritingVarName);
		if (writtenText != "")
		{
			AssignCommand(oPC, ClearAllActions());
			AssignCommand(oPC, ActionSpeakString(writtenText));
		}
		else
		{
			SendMessageToPC(oPC, "This piece of parchment is empty.");
		}
	}
	else
	{
		SendMessageToPC(oPC, "This piece of parchment is empty.");
	}
	
	// delete the item mark	
	PS_DeleteLocalObject(oPC, parchmentVarName);
}