void main(string sAction)
{
	if (sAction == "Show")
	{
		SendMessageToPC(OBJECT_SELF, "<color=red>Please select your target before using a quick cast panel. If you have no target selected, character will attempt to cast a spell on self. You will perform no action if the spell is hostile while you are targeting yourself or having no target selected.");
		DisplayGuiScreen(OBJECT_SELF, "SCREEN_SPELLS_QUICK_PSION", 0, "quickspell_psi.xml");
		DelayCommand(0.4f, SetLocalInt(OBJECT_SELF, "PsionQuickCastUpdated", 1)); //Laggs if updates even every 0.5sec
	}
	if (sAction == "Hide")
	{
		CloseGUIScreen(OBJECT_SELF, "SCREEN_SPELLS_QUICK_PSION");
		SetLocalInt(OBJECT_SELF, "PsionQuickCastUpdated", 0);
	}
}