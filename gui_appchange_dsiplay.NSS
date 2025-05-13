//#include "nwnx_craft"
//#include "nwnx_craft_system"

// This is the GUI for setting alternate form for the first time
#include "gui_appchange_inc"
#include "aaa_changeself_inc"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "ginc_math"

void TryPreset(object oPlayer)
{
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPlayer);
	int nAppearanceID = app.AppearanceType;
	if (GetAppearanceType(oPlayer) == 0 |
	GetAppearanceType(oPlayer) == 1 |
	GetAppearanceType(oPlayer) == 2 |
	GetAppearanceType(oPlayer) == 3 |
	GetAppearanceType(oPlayer) == 4 |
	GetAppearanceType(oPlayer) == 5 |
	GetAppearanceType(oPlayer) == 6 |
	GetAppearanceType(oPlayer) == 38 |
	GetAppearanceType(oPlayer) == 40 |
	GetAppearanceType(oPlayer) == 45 |
	GetAppearanceType(oPlayer) == 59 |
	GetAppearanceType(oPlayer) == 70 |
	GetAppearanceType(oPlayer) == 71 |
	GetAppearanceType(oPlayer) == 300 |
	GetAppearanceType(oPlayer) == 483 |
	GetAppearanceType(oPlayer) == 534 |
	GetAppearanceType(oPlayer) == 535 |
	GetAppearanceType(oPlayer) == 536 |
	GetAppearanceType(oPlayer) == 543 |
	GetAppearanceType(oPlayer) == 563 |
	GetAppearanceType(oPlayer) == 564 |
	GetAppearanceType(oPlayer) == 565 |
	GetAppearanceType(oPlayer) == 566 |
	GetAppearanceType(oPlayer) == 567 |
	GetAppearanceType(oPlayer) == 568 |
	GetAppearanceType(oPlayer) == 569 |
	GetAppearanceType(oPlayer) == 570 |
	GetAppearanceType(oPlayer) == 571 |
	GetAppearanceType(oPlayer) == 573 |
	GetAppearanceType(oPlayer) == 574 |
	GetAppearanceType(oPlayer) == 575 |
	GetAppearanceType(oPlayer) == 576 |
	GetAppearanceType(oPlayer) == 577 |
	GetAppearanceType(oPlayer) == 578 |
	GetAppearanceType(oPlayer) == 1017 |
	GetAppearanceType(oPlayer) == 1036 |
	GetAppearanceType(oPlayer) == 1037 |
	GetAppearanceType(oPlayer) == 1038 |
	GetAppearanceType(oPlayer) == 1039 |
	GetAppearanceType(oPlayer) == 1040 |
	GetAppearanceType(oPlayer) == 1041 |
	GetAppearanceType(oPlayer) == 1087 |
	GetAppearanceType(oPlayer) == 1102 |
	GetAppearanceType(oPlayer) == 1509)
	{
		int nGenderID = app.Gender;
		int nHeadID = app.HeadVariation;
		int nTailID = app.TailVariation;
		int nWingsID = app.WingVariation;
		int nHairID = app.HairVariation;
		int nFacialHairID = app.FacialHairVariation;
		string sAccessory = IntToHexString(app.HairTint_Color0);
		sAccessory = "0x"+GetSubString(sAccessory, 2, 6);
		string sHairColor = IntToHexString(app.HairTint_Color1);
		sHairColor = "0x"+GetSubString(sHairColor, 2, 6);
		string sHairHighlight = IntToHexString(app.HairTint_Color2);
		sHairHighlight = "0x"+GetSubString(sHairHighlight, 2, 6);
		string sSkinColor = IntToHexString(app.HeadTint_Color0);
		sSkinColor = "0x"+GetSubString(sSkinColor, 2, 6);
		string sEyeColor = IntToHexString(app.HeadTint_Color1);
		sEyeColor = "0x"+GetSubString(sEyeColor, 2, 6);
		string sEyebrowColor = IntToHexString(app.HeadTint_Color2);
		sEyebrowColor = "0x"+GetSubString(sEyebrowColor, 2, 6);
		string sScaleX = FloatToString(GetScale(oPlayer, SCALE_X));
		string sScaleY = FloatToString(GetScale(oPlayer, SCALE_Y));
		string sScaleZ = FloatToString(GetScale(oPlayer, SCALE_Z));
	
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 6, IntToString(nFacialHairID));
		if (nFacialHairID == 0) SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "FacialHairTextField", -1, "No");
		else SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "FacialHairTextField", -1, "Yes");
	
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "HeadTextField", -1, IntToString(nHeadID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 2, IntToString(nHeadID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 71, IntToString(nHeadID));
	
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "TailTextField", -1, IntToString(nTailID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 3, IntToString(nTailID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 72, IntToString(nTailID));
	
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "WingsTextField", -1, IntToString(nWingsID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 4, IntToString(nWingsID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 73, IntToString(nWingsID));
	
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "HairTextField", -1, IntToString(nHairID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 5, IntToString(nHairID));
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 74, IntToString(nHairID));
	
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 1, IntToString(nGenderID));
		if (nGenderID == 0) SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "GenderTextField", -1, "Male");
		else SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "GenderTextField", -1, "Female");
		SetLocalGUIVariable(oPlayer, "CharacterAppearanceChangeGUI", 81, IntToString(nGenderID));
	
	
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "HairAccessoryColorTextField", -1, sAccessory);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "HairColorTextField", -1, sHairColor);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "HairHighlightColorTextField", -1, sHairHighlight);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "SkinColorTextField", -1, sSkinColor);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "EyeColorTextField", -1, sEyeColor);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "EyeBrowColorTextField", -1, sEyebrowColor);
	
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "ScaleXTextField", -1, sScaleX);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "ScaleYTextField", -1, sScaleY);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "ScaleZTextField", -1, sScaleZ);
		//DISPLAY PRESET
	}
}

void main(int nType)
{
	//object oPlayer = GetEnteringObject();
	object oPlayer = GetPCSpeaker();
	SendMessageToPC(oPlayer, "Loading...");
	CloseGUIScreen(oPlayer, "CharacterAppearanceChangeGUI");
	DisplayGuiScreen(oPlayer, "CharacterAppearanceChangeGUI", 0, "CharacterAppearanceChangeGUI.xml");
	
	AddScriptParameterInt(0);
	AddScriptParameterInt(70);
	AddScriptParameterString("");
	AddScriptParameterString("AppearanceTextField");
	
	ExecuteScriptEnhanced("gui_appchange_incdecvar", oPlayer);
	ClearScriptParams();
	
	AddScriptParameterInt(1);
	ExecuteScriptEnhanced("gui_appchange_resetfields", oPlayer);
	ClearScriptParams();
	
	TryPreset(oPlayer);
	
	if (nType == 0)
	{
		SetLocalInt(oPlayer, "CharacterAppearanceChangeGUIType", 0);
		if (GetSubRace(oPlayer) != 233) //DOPPELGANGER 233
		{
			SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "STORESAVE", TRUE);
			SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleX_Container", TRUE);
			SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleY_Container", TRUE);
			SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleZ_Container", TRUE);
		}
		if (GetSubRace(oPlayer) == 233)
				SendMessageToPC(oPlayer, "<color=red>Store Appearance button will copy all the field values from the targeted creature, paste them in to the GUI and apply new appearance. Also it will copy creature's armor (visual only for helm, chest, boots, gloves and cloak) including item icons and descriptions. ACTION IS NOT REVERTIBLE! If you do not wish to copy a certain armor piece - unequip that item before you press the button. Also such an action may be considered a hostile action, so be ready to roleplay consequences.</color>");
	}
	
	else if (nType == 1)
	{
		SetLocalInt(oPlayer, "CharacterAppearanceChangeGUIAppearanceID", GetAppearanceType(oPlayer));
		SetLocalInt(oPlayer, "CharacterAppearanceChangeGUIGenderID", GetGender(oPlayer));
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "SlotID_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "AppearanceID_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "GenderID_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "HeadID_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "TailID_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "WingsID_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "SkinColor_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "EyeColor_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "STORESAVE", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleX_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleY_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleZ_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "SAVE", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "LOAD", TRUE);
		SetLocalInt(oPlayer, "CharacterAppearanceChangeGUIType", 1);
	}
	
	else if (nType == 2)
	{
		SetLocalInt(oPlayer, "CharacterAppearanceChangeGUIType", 2);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "STORESAVE", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "SAVE", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "LOAD", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "SlotID_Container", TRUE);
		SetGUIObjectText(oPlayer, "CharacterAppearanceChangeGUI", "SlotTextField", -1, "AltForm");
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleX_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleY_Container", TRUE);
		SetGUIObjectHidden(oPlayer, "CharacterAppearanceChangeGUI", "ScaleZ_Container", TRUE);
		
	}
}