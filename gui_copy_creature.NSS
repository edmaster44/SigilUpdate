//#include "nwnx_craft"
//#include "nwnx_craft_system"
#include "gui_appchange_inc"
#include "aaa_changeself_inc"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "ginc_math"

void main ()
{
	int nPCAllowed = 1;
//	XPCraft_CleanLocals(OBJECT_SELF, TRUE);
//	XPCraft_InitArmorVisualTypeValues(OBJECT_SELF);
	object oTarget = GetPlayerCurrentTarget(OBJECT_SELF);
	
	if (oTarget == OBJECT_SELF)
	{
		SendMessageToPC(OBJECT_SELF, "You can not copy youself.");
		return;
	}
	if (GetCurrentHitPoints(OBJECT_SELF) <= 0)
	{
		SendMessageToPC(OBJECT_SELF, "You cant not use the ability while you are dead.");
		return;
	}
	
	if (GetAppearanceType(oTarget) != 0 &
	GetAppearanceType(oTarget) != 1 &
	GetAppearanceType(oTarget) != 2 &
	GetAppearanceType(oTarget) != 3 &
	GetAppearanceType(oTarget) != 4 &
	GetAppearanceType(oTarget) != 5 &
	GetAppearanceType(oTarget) != 6 &
	GetAppearanceType(oTarget) != 38 &
	GetAppearanceType(oTarget) != 40 &
	GetAppearanceType(oTarget) != 45 &
	GetAppearanceType(oTarget) != 59 &
	GetAppearanceType(oTarget) != 70 &
	GetAppearanceType(oTarget) != 71 &
	GetAppearanceType(oTarget) != 300 &
	GetAppearanceType(oTarget) != 483 &
	GetAppearanceType(oTarget) != 534 &
	GetAppearanceType(oTarget) != 535 &
	GetAppearanceType(oTarget) != 536 &
	GetAppearanceType(oTarget) != 543 &
	GetAppearanceType(oTarget) != 563 &
	GetAppearanceType(oTarget) != 564 &
	GetAppearanceType(oTarget) != 565 &
	GetAppearanceType(oTarget) != 566 &
	GetAppearanceType(oTarget) != 567 &
	GetAppearanceType(oTarget) != 568 &
	GetAppearanceType(oTarget) != 569 &
	GetAppearanceType(oTarget) != 570 &
	GetAppearanceType(oTarget) != 571 &
	GetAppearanceType(oTarget) != 573 &
	GetAppearanceType(oTarget) != 574 &
	GetAppearanceType(oTarget) != 575 &
	GetAppearanceType(oTarget) != 576 &
	GetAppearanceType(oTarget) != 577 &
	GetAppearanceType(oTarget) != 578 &
	GetAppearanceType(oTarget) != 1017 &
	GetAppearanceType(oTarget) != 1036 &
	GetAppearanceType(oTarget) != 1037 &
	GetAppearanceType(oTarget) != 1038 &
	GetAppearanceType(oTarget) != 1039 &
	GetAppearanceType(oTarget) != 1040 &
	GetAppearanceType(oTarget) != 1041 &
	GetAppearanceType(oTarget) != 1087 &
	GetAppearanceType(oTarget) != 1102 &
	GetAppearanceType(oTarget) != 1509)
	{
		SendMessageToPC(OBJECT_SELF, "You must target a humanoid creature.");
		return;
	}
	/*
	if (GetIsPC(oTarget) == 1 & nPCAllowed == 1)
	{
		CopyItemDoppelganger(oTarget, 0); //helm
		CopyItemDoppelganger(oTarget, 1); //armor
		CopyItemDoppelganger(oTarget, 2); //boots
		CopyItemDoppelganger(oTarget, 3); //gloves
		CopyItemDoppelganger(oTarget, 6); //cloak
	}
	else if (GetIsPC(oTarget) == 0)
	{
		CopyItemDoppelganger(oTarget, 0); //helm
		CopyItemDoppelganger(oTarget, 1); //armor
		CopyItemDoppelganger(oTarget, 2); //boots
		CopyItemDoppelganger(oTarget, 3); //gloves
		CopyItemDoppelganger(oTarget, 6); //cloak
	}
	*/
	if (GetIsPC(oTarget) == 0)
	{
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oTarget);
	int nAppearanceID = app.AppearanceType;
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
	string sScaleX = FloatToString(GetScale(oTarget, SCALE_X));
	string sScaleY = FloatToString(GetScale(oTarget, SCALE_Y));
	string sScaleZ = FloatToString(GetScale(oTarget, SCALE_Z));
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
	
	AddScriptParameterInt(nAppearanceID);
	AddScriptParameterInt(nGenderID);
	AddScriptParameterInt(nHeadID);
	AddScriptParameterInt(nTailID);
	AddScriptParameterInt(nWingsID);
	AddScriptParameterInt(nHairID);
	AddScriptParameterInt(nFacialHairID);	
	AddScriptParameterString(sAccessory);
	AddScriptParameterString(sHairColor);
	AddScriptParameterString(sHairHighlight);
	AddScriptParameterString(sSkinColor);
	AddScriptParameterString(sEyeColor);
	AddScriptParameterString(sEyebrowColor);
	AddScriptParameterString(sScaleX);
	AddScriptParameterString(sScaleY);
	AddScriptParameterString(sScaleZ);
	
	ExecuteScriptEnhanced("gui_appchange_action", OBJECT_SELF);
	}
	else
	{	SendMessageToPC(OBJECT_SELF, "This ability may not be used on PCs");	}
}