#include "ff_safevar"

void main(string nSlot)
{
	//object oObject = OBJECT_SELF;
	object oObject = GetItemPossessedBy(OBJECT_SELF, "ps_essence");
	int nAppearanceID = PS_GetLocalInt(oObject, "ChangeSelfAppearanceID" + nSlot);
	int nGenderID = PS_GetLocalInt(oObject, "ChangeSelfGenderID" + nSlot);
	int nHeadID = PS_GetLocalInt(oObject, "ChangeSelfHeadID" + nSlot);
	int nTailID = PS_GetLocalInt(oObject, "ChangeSelfTailID" + nSlot);
	int nWingsID = PS_GetLocalInt(oObject, "ChangeSelfWingsID" + nSlot);
	int nHairID = PS_GetLocalInt(oObject, "ChangeSelfHairID" + nSlot);
	int nFacialHairID = PS_GetLocalInt(oObject, "ChangeSelfFacialHairID" + nSlot);
	
	string sAccessory = PS_GetLocalString(oObject, "ChangeSelfAccessoryHex" + nSlot);
	string sHairColor = PS_GetLocalString(oObject, "ChangeSelfHairHex" + nSlot);
	string sHairHighlight = PS_GetLocalString(oObject, "ChangeSelfHairHighlightHex" + nSlot);
	string sSkinColor = PS_GetLocalString(oObject, "ChangeSelfSkinHex" + nSlot);
	string sEyeColor = PS_GetLocalString(oObject, "ChangeSelfEyeHex" + nSlot);
	string sEyebrowColor = PS_GetLocalString(oObject, "ChangeSelfEyebrowHex" + nSlot);
	
	string sScaleX = PS_GetLocalString(oObject, "ScaleX" + nSlot);
	string sScaleY = PS_GetLocalString(oObject, "ScaleY" + nSlot);
	string sScaleZ = PS_GetLocalString(oObject, "ScaleZ" + nSlot);
	
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