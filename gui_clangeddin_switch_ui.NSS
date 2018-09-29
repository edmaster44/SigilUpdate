//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2015
//:://////////////////////////////////////////////

void main(string sTYPE, string sDIRECTION)
{
	object oPC = OBJECT_SELF;
	CloseGUIScreen(oPC, "SCREEN_PARTYBAR_NEW");
	CloseGUIScreen(oPC, "SCREEN_PARTYBAR_DEFAULT");
	CloseGUIScreen(oPC, "SCREEN_PARTYBAR_NEW_LEFT");
	CloseGUIScreen(oPC, "SCREEN_PARTYBAR_DEFAULT_LEFT");
	SetGUIObjectHidden(oPC, "SCREEN_TARGETED_OBJECT", "TARGET_STYLE_NEW", TRUE);
	SetGUIObjectHidden(oPC, "SCREEN_TARGETED_ENEMY", "TARGET_STYLE_NEW", TRUE);
	SetGUIObjectHidden(oPC, "SCREEN_TARGETED_OBJECT", "TARGET_STYLE_OLD", TRUE);
	SetGUIObjectHidden(oPC, "SCREEN_TARGETED_ENEMY", "TARGET_STYLE_OLD", TRUE);
	if(sTYPE=="OLD")
	{
		SetGUIObjectHidden(oPC, "SCREEN_TARGETED_OBJECT", "TARGET_STYLE_OLD", FALSE);
		SetGUIObjectHidden(oPC, "SCREEN_TARGETED_ENEMY", "TARGET_STYLE_OLD", FALSE);
		if (sDIRECTION=="LEFT")	DelayCommand(0.0f, DisplayGuiScreen(oPC, "SCREEN_PARTYBAR_DEFAULT_LEFT", FALSE, "party_bar_default_left.xml"));
		else DelayCommand(0.0f, DisplayGuiScreen(oPC, "SCREEN_PARTYBAR_DEFAULT", FALSE, "party_bar_default.xml"));
	}
	else
	{
		SetGUIObjectHidden(oPC, "SCREEN_TARGETED_OBJECT", "TARGET_STYLE_NEW", FALSE);
		SetGUIObjectHidden(oPC, "SCREEN_TARGETED_ENEMY", "TARGET_STYLE_NEW", FALSE);
		if (sDIRECTION=="LEFT") DelayCommand(0.0f, DisplayGuiScreen(oPC, "SCREEN_PARTYBAR_NEW_LEFT", FALSE, "party_bar_new_left.xml"));
		else DelayCommand(0.0f, DisplayGuiScreen(oPC, "SCREEN_PARTYBAR_NEW", FALSE, "party_bar_new.xml"));
	}	
}