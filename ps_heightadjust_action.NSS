

#include "ps_heightadjust_includes"

void main(int selection)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	ForceRest(oPC); 
	
	RemoveSizeEffects(oPC);
	
	if(selection == 99)
	{
		AdjustToOriginalHeight(oPC);
		ExportSingleCharacter(oPC);
		return;
	}
	
	if(selection == 98)
	{
		AdjustToAdjustedHeight(oPC);
		ExportSingleCharacter(oPC);
		return;
	}
	
	if(selection == 97)
	{
		AdjustWeight(oPC,1); //increase
		ExportSingleCharacter(oPC);
		return;
	}
	
	if(selection == 96)
	{
		AdjustWeight(oPC,0); //decrease
		ExportSingleCharacter(oPC);
		return;
	}
	
	SetLocalInt(oPC,"heightadjust",selection);

	string sMessage;
	//if(FirstTime(oPC))
	 sMessage = "Are you sure you want to adjust your height.";
//	else sMessage = "Are you sure you want to adjust your height? It will cost 10% xp.";
	
	DisplayMessageBox(oPC, -1, sMessage, "gui_ps_height_confirm", "", TRUE, "SCREEN_MESSAGEBOX_DEFAULT", -1, "Yes", -1, "No");
}
	
		