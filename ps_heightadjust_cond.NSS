

#include "ps_heightadjust_includes"

	

	int StartingConditional(int selection)
	{
	object oPC = GetPCSpeaker();
	//height adjust buggy for new efreet, and as i'm busy with more important things I will just disallow
	//efreet height adjust.
	if (GetSubRace(oPC) == 122){
		SendMessageToPC(oPC, "Height and weight adjustments for Efreet are not allowed at this time.");
		return FALSE;
	}
	
	if(selection == 99 || selection == 98)
	{
		if(FirstTime(oPC)) return FALSE;
		else return TRUE;	
	}
	
	if(selection == 98)
	{
		if(FirstTimeAdjust(oPC)) return TRUE;
		else return FALSE;	
	}
	
	int iMax = GetLocalInt(oPC,"heightmax");
	
	if (selection > iMax) return FALSE;
	else return TRUE;
	}