#include "ps_heightadjust_includes"

	int StartingConditional(int selection)
	{
	object oPC = GetPCSpeaker();
	
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