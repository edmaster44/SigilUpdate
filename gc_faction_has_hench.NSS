/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	
	object oHench = GetHenchman(oPC, 1);
	
	if (oHench != OBJECT_INVALID)
		return TRUE;
	else
		return FALSE;
}
	