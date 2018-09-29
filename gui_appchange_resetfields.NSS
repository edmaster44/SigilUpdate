void main(int nType)
{
	if (nType == 1)
	{
		SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "GenderTextField", -1, "Male");
		SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 1, "0");
	}
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "HeadTextField", -1, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 2, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 71, "0");
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "TailTextField", -1, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 3, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 72, "0");
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "WingsTextField", -1, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 4, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 73, "0");
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "HairTextField", -1, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 5, "0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 74, "0");
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "FacialHairTextField", -1, "No");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 6, "0");
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "ScaleXTextField", -1, "1.0");
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "ScaleYTextField", -1, "1.0");
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "ScaleZTextField", -1, "1.0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 14, "1.0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 15, "1.0");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 16, "1.0");
	
	SendMessageToPC(OBJECT_SELF, "Resetting fields...");
}