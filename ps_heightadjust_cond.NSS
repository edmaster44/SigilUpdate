

#include "ps_heightadjust_includes"

	

	int StartingConditional(int selection)
	{
	object oPC = GetPCSpeaker();
	
	if (GetLocalInt(oPC, "DisableHeightAdjust")){
		if (!GetLocalInt(oPC, "HeightAdjustWarn")){
			SendMessageToPC(oPC, "Height adjustment is disabled for this race due to a bug");
			SetLocalInt(oPC, "HeightAdjustWarn", TRUE);
		}
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