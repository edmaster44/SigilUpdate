/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/
#include "ps_inc_faction"

int StartingConditional(int iFaction)
{
	object oPC = GetPCSpeaker();
	
	int iBadgeFaction = GetFaction(oPC);
	
	if (iBadgeFaction == iFaction)
		return TRUE;
	else
		return FALSE;
}