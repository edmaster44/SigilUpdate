/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/


int StartingConditional()
{
	object oNPC = OBJECT_SELF; 
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oNPC);
	
	if (GetIsObjectValid(oItem) == TRUE)
		return TRUE;
	else
		return FALSE;
}
	