/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/


int StartingConditional()
{
	object oNPC = GetLocalObject(OBJECT_SELF, "RCTag"); 
	
	if (oNPC == OBJECT_INVALID)
	{
		SendMessageToPC(OBJECT_SELF, "No valid NPC found");
		return FALSE;
	}
	else
	{
		object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC);
	
		if (oItem == OBJECT_INVALID)
			return FALSE;
		else
			return TRUE;
	}
}
	