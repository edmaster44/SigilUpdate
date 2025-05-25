

// Cleanup on area exit if there are no other PCs in the area

// Check if there are other PC's in the area.
// return TRUE if there are, FALSE otherwise.
int GetOtherPCs(object oPC, object oArea)
{
	object oObj = GetFirstObjectInArea(oArea);
	while (GetIsObjectValid(oObj)) {
		if (GetIsPC(oObj) && oPC != oObj)
			return TRUE;
			
		oObj = GetNextObjectInArea(oArea);
	}
	
	return FALSE;
}

void main()
{
	object oPC = GetExitingObject();
	if (!GetIsPC(oPC)) return;
	if (GetOtherPCs(oPC, OBJECT_SELF)) return;
	
	object oEntryDoor = GetObjectByTag("ps_chessboard_door_enter",0);
	object oExitDoor = GetObjectByTag("ps_chessboard_door_exit",0);
	AssignCommand(oEntryDoor, ActionCloseDoor(oEntryDoor));
	AssignCommand(oExitDoor, ActionCloseDoor(oExitDoor));
	SetLocked(oEntryDoor, TRUE);
	SetLocked(oExitDoor, TRUE);
	SetLocalInt(oEntryDoor, "GameStarted", FALSE);
	SetLocalInt(oEntryDoor, "FightStarted", FALSE);
	
	// bit of a clean up just in case some other player takes the quest before it cleans up.
	object oCurrentArea = GetArea(OBJECT_SELF);
	object oCurrentCreature = GetFirstObjectInArea(oCurrentArea);
		
	while (GetIsObjectValid(oCurrentCreature) == TRUE)
		{
		if 	(GetObjectType(oCurrentCreature) == OBJECT_TYPE_CREATURE)
			{
			if (GetStringRight(GetTag(oCurrentCreature), 4) == "ally")
				{
				DestroyObject(oCurrentCreature, 0.0, FALSE);
				}
				else if (GetStringRight(GetTag(oCurrentCreature), 5) == "enemy")
				{
				DestroyObject(oCurrentCreature, 0.0, FALSE);
				}
			}
		oCurrentCreature = GetNextObjectInArea(oCurrentArea);
	    }
		
	// Call normal cleaup script
	ExecuteScript("bar_onareaexit", oCurrentArea);
}