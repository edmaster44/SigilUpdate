/*This Function was provided by Skywing in an attempt to Fix the crashing by conversation*/

void ActionStartConversationSafe(object oObjectToConverseWith, string sDialogResRef="", int bPrivateConversation=FALSE, int bPlayHello=TRUE, int bIgnoreStartDistance=FALSE, int bDisableCutsceneBars=FALSE)
{
    string BlockReason = "";

    //
    // The server may crash if a DM possessed NPC attempts to use a dialog.
    // Block these dialogs to avoid the crash.
    //

    if (GetArea(OBJECT_SELF) == OBJECT_INVALID)
    {
        BlockReason = "Controlled creature object is in area transition";
    }
    else if (GetArea(GetOwnedCharacter(OBJECT_SELF)) == OBJECT_INVALID)
    {
        BlockReason = "Primary PC character object is in area transition";
    }

    if (BlockReason != "")
    {
        string DialogDesc = "object named (";
        DialogDesc += GetName(oObjectToConverseWith);
        DialogDesc += "), with tag (";
        DialogDesc += GetTag(oObjectToConverseWith);
        DialogDesc += ")";

        SendMessageToPC(OBJECT_SELF, "Can't interact with dialog for " + DialogDesc + ", dialog resref " + sDialogResRef + ": " + BlockReason);
        WriteTimestampedLogEntry("Can't interact with dialog for " + DialogDesc + ", dialog resref " + sDialogResRef + ": " + BlockReason);
        return;
    }
    else
    {
        string DialogDesc = "object named (";
        DialogDesc += GetName(oObjectToConverseWith);
        DialogDesc += "), with tag (";
        DialogDesc += GetTag(oObjectToConverseWith);
        DialogDesc += ")";

        SendMessageToPC(OBJECT_SELF, "DEBUG: Dialog not blocked for " + DialogDesc + ", dialog resref " + sDialogResRef);
        WriteTimestampedLogEntry("DEBUG: Dialog not blocked for " + DialogDesc + ", dialog resref " + sDialogResRef);
    }

    WriteTimestampedLogEntry("DEBUG: Dialog initation from: " + GetName(OBJECT_SELF) + ", area: " + GetName(GetArea(OBJECT_SELF)) + ", owned character: " + GetName(GetOwnedCharacter(OBJECT_SELF)) + ", owned character area: " + GetName(GetArea(GetOwnedCharacter(OBJECT_SELF))) + ", Limbo creature count: " + IntToString(GetLimboCreatureCount()));
    ActionStartConversation(oObjectToConverseWith, sDialogResRef, bPrivateConversation, bPlayHello, bIgnoreStartDistance, bDisableCutsceneBars);
}