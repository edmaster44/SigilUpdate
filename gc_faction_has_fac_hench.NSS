/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

// used to check to see if a henchman is a faction one and not from another source
int StartingConditional()
{
	object oPC = GetPCSpeaker();
	
	object oHench = GetHenchman(oPC, 1);
	
	if (oHench != OBJECT_INVALID)
	{
		string sHenchTagLeft = GetStringLeft(GetTag(oHench), 15);
	
		if (sHenchTagLeft == "ps_faction_npc_")
			return TRUE;
		else
			return FALSE;
	}
	else
		return FALSE;
}
	