/*This Function was provided by Skywing in an attempt to Fix the crashing by conversation*/

void ActionStartConversationSafe(object oObjectToConverseWith, string sDialogResRef="", int bPrivateConversation=FALSE, int bPlayHello=TRUE, int bIgnoreStartDistance=FALSE, int bDisableCutsceneBars=FALSE)
{
    //
    // The server may crash if a DM possessed NPC attempts to use a dialog.
    // Block these dialogs to avoid the crash.
    //

    if (GetIsDMPossessed(OBJECT_SELF) != FALSE)
    {
        string DialogDesc = "object named (";
        DialogDesc += GetName(oObjectToConverseWith);
        DialogDesc += "), with tag (";
        DialogDesc += GetTag(oObjectToConverseWith);
        DialogDesc += ")";
        SendMessageToPC(OBJECT_SELF, "Can't interact with dialog for " + DialogDesc + ", dialog resref " + sDialogResRef + " while possessing an NPC as a DM.");
        return;
    }

    ActionStartConversation(oObjectToConverseWith, sDialogResRef, bPrivateConversation, bPlayHello, bIgnoreStartDistance, bDisableCutsceneBars);
}




void main()
{

	
    ActionStartConversationSafe(GetLastUsedBy(), "", TRUE);
}