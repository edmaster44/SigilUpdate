//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2015
//:://////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	string sDATA = "Clangeddin_Interface";
	string sPLAYER = GetPCPlayerName(oPC);
	string sSTYLE = "S_" + sPLAYER;
	string sDIRECTION = "D_" + sPLAYER;
	int nTYPE = GetCampaignInt(sDATA, sSTYLE);
	int nDIRECTION = GetCampaignInt(sDATA, sDIRECTION);
	if (nTYPE==1) AddScriptParameterString("OLD");
	else AddScriptParameterString("NEW");
	if (nDIRECTION==1) AddScriptParameterString("LEFT");
	else AddScriptParameterString("RIGHT");
	ExecuteScriptEnhanced("gui_clangeddin_switch_ui", oPC);
	DelayCommand(0.0f, CloseGUIScreen(oPC, "SCREEN_PARTY_BAR"));
}