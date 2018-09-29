void main(string nSlot)
{
	//object oObject = OBJECT_SELF;
	object oObject = GetItemPossessedBy(OBJECT_SELF, "ps_essence");
	int nAppearanceID = GetLocalInt(oObject, "ChangeSelfAppearanceID" + nSlot);
	int nGenderID = GetLocalInt(oObject, "ChangeSelfGenderID" + nSlot);
	int nHeadID = GetLocalInt(oObject, "ChangeSelfHeadID" + nSlot);
	int nTailID = GetLocalInt(oObject, "ChangeSelfTailID" + nSlot);
	int nWingsID = GetLocalInt(oObject, "ChangeSelfWingsID" + nSlot);
	int nHairID = GetLocalInt(oObject, "ChangeSelfHairID" + nSlot);
	int nFacialHairID = GetLocalInt(oObject, "ChangeSelfFacialHairID" + nSlot);
	
	string sAccessory = GetLocalString(oObject, "ChangeSelfAccessoryHex" + nSlot);
	string sHairColor = GetLocalString(oObject, "ChangeSelfHairHex" + nSlot);
	string sHairHighlight = GetLocalString(oObject, "ChangeSelfHairHighlightHex" + nSlot);
	string sSkinColor = GetLocalString(oObject, "ChangeSelfSkinHex" + nSlot);
	string sEyeColor = GetLocalString(oObject, "ChangeSelfEyeHex" + nSlot);
	string sEyebrowColor = GetLocalString(oObject, "ChangeSelfEyebrowHex" + nSlot);
	
	string sScaleX = GetLocalString(oObject, "ScaleX" + nSlot);
	string sScaleY = GetLocalString(oObject, "ScaleY" + nSlot);
	string sScaleZ = GetLocalString(oObject, "ScaleZ" + nSlot);
	
	AddScriptParameterInt(-1);
	AddScriptParameterInt(70);
	AddScriptParameterString(IntToString(nAppearanceID));
	AddScriptParameterString("AppearanceTextField");
	
	ExecuteScriptEnhanced("gui_appchange_incdecvar", OBJECT_SELF);
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 6, IntToString(nFacialHairID));
	if (nFacialHairID == 0) SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "FacialHairTextField", -1, "No");
	else SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "FacialHairTextField", -1, "Yes");
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "HeadTextField", -1, IntToString(nHeadID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 2, IntToString(nHeadID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 71, IntToString(nHeadID));
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "TailTextField", -1, IntToString(nTailID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 3, IntToString(nTailID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 72, IntToString(nTailID));
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "WingsTextField", -1, IntToString(nWingsID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 4, IntToString(nWingsID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 73, IntToString(nWingsID));
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "HairTextField", -1, IntToString(nHairID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 5, IntToString(nHairID));
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 74, IntToString(nHairID));
	
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 1, IntToString(nGenderID));
	if (nGenderID == 0) SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "GenderTextField", -1, "Male");
	else SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "GenderTextField", -1, "Female");
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 81, IntToString(nGenderID));
	
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "HairAccessoryColorTextField", -1, sAccessory);
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "HairColorTextField", -1, sHairColor);
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "HairHighlightColorTextField", -1, sHairHighlight);
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "SkinColorTextField", -1, sSkinColor);
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "EyeColorTextField", -1, sEyeColor);
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "EyeBrowColorTextField", -1, sEyebrowColor);
	
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "ScaleXTextField", -1, sScaleX);
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "ScaleYTextField", -1, sScaleY);
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", "ScaleZTextField", -1, sScaleZ);
	
}