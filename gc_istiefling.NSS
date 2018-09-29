#include "ginc_misc"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	
	int nRacialType = GetSubRace(oPC);
	
//	SendMessageToPC(GetFirstPC(),IntToString(nRacialType));
	
	if (nRacialType == 14)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}