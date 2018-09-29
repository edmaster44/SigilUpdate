void main()
{
	object oPC = GetLastUsedBy();
	DisplayGuiScreen(oPC, "SCREEN_LIBRARY", FALSE, "library.xml", TRUE);
	SetLocalGUIVariable(oPC, "SCREEN_LIBRARY", 20, GetTag(OBJECT_SELF));
}