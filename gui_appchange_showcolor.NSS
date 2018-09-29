void main(int nFieldID)
{
	object oPlayer = OBJECT_SELF;
	DisplayGuiScreen(oPlayer, "CharacterAppearanceColorGUI", 0, "CharacterAppearanceColorGUI.xml");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceColorGUI", 60, IntToString(nFieldID));
}