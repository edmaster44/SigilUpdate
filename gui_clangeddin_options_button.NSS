//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2015
//:://////////////////////////////////////////////

void main(string sBUTTON)
{
	object oPC = OBJECT_SELF;
	string sDATA = "Clangeddin_Interface";
	string sPLAYER = GetPCPlayerName(oPC);
	string sSTYLE = "S_" + sPLAYER;
	string sDIRECTION = "D_" + sPLAYER;
	if (sBUTTON == "OLD") SetCampaignInt(sDATA, sSTYLE, 1);
	else if (sBUTTON == "NEW") SetCampaignInt(sDATA, sSTYLE, 0);
	else if (sBUTTON == "LEFT") SetCampaignInt(sDATA, sDIRECTION, 1);
	else if (sBUTTON == "RIGHT") SetCampaignInt(sDATA, sDIRECTION, 0);
	DelayCommand(0.0f, ExecuteScript("gui_clangeddin_start_ui", oPC));
}