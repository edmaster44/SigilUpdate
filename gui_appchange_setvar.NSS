void main(int nVar, string sValue)
{
	SendMessageToPC(OBJECT_SELF, "Setting VarIndex "+IntToString(nVar)+" to "+sValue);
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", nVar, sValue);
	if (nVar == 1)
	{
		SetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIGenderID", StringToInt(sValue));
		AddScriptParameterInt(0);
		ExecuteScriptEnhanced("gui_appchange_resetfields", OBJECT_SELF);
		ClearScriptParams();
		if (StringToInt(sValue) == 0) SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "GenderTextField", -1, "Male");
		else SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "GenderTextField", -1, "Female");
	}
			
	if (nVar == 6)
	{
		if (StringToInt(sValue) == 0) SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "FacialHairTextField", -1, "No");
		else SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "FacialHairTextField", -1, "Yes");
	}	
}