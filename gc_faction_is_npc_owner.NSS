/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/


//#include "ginc_param_const"

// Used for conversation tied to Faction NPC summons.
// If is the PC owner then use that part of the convo tree.

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oNPC = OBJECT_SELF; //TARGET_OWNER; //OBJECT_SELF;
	
	if (GetMaster(oNPC) == oPC)
		return TRUE;
	else
		return FALSE;
}
	