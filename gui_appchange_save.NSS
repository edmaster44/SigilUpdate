#include "ff_safevar"

void main(int nAppearanceID, int nGenderID, int nHeadID, int nTailID, int nWingsID, int nHairID, int nFacialHairID, string sAccessory, string sHairColor, string sHairHighlight, string sSkinColor, string sEyeColor, string sEyebrowColor, string nSlot, string sScaleX, string sScaleY, string sScaleZ)
{
	//object oObject = OBJECT_SELF;
	object oObject = GetItemPossessedBy(OBJECT_SELF, "ps_essence");
	PS_SetLocalInt(oObject, "ChangeSelfAppearanceID" + nSlot, nAppearanceID);
	PS_SetLocalInt(oObject, "ChangeSelfGenderID" + nSlot, nGenderID);
	PS_SetLocalInt(oObject, "ChangeSelfHeadID" + nSlot, nHeadID);
	PS_SetLocalInt(oObject, "ChangeSelfTailID" + nSlot, nTailID);
	PS_SetLocalInt(oObject, "ChangeSelfWingsID" + nSlot, nWingsID);
	PS_SetLocalInt(oObject, "ChangeSelfHairID" + nSlot, nHairID);
	PS_SetLocalInt(oObject, "ChangeSelfFacialHairID" + nSlot, nFacialHairID);
	PS_SetLocalString(oObject, "ChangeSelfAccessoryHex" + nSlot, sAccessory);
	PS_SetLocalString(oObject, "ChangeSelfHairHex" + nSlot, sHairColor);
	PS_SetLocalString(oObject, "ChangeSelfHairHighlightHex" + nSlot, sHairHighlight);
	PS_SetLocalString(oObject, "ChangeSelfSkinHex" + nSlot, sSkinColor);
	PS_SetLocalString(oObject, "ChangeSelfEyeHex" + nSlot, sEyeColor);
	PS_SetLocalString(oObject, "ChangeSelfEyebrowHex" + nSlot, sEyebrowColor);
	PS_SetLocalString(oObject, "ScaleX" + nSlot, sScaleX);
	PS_SetLocalString(oObject, "ScaleY" + nSlot, sScaleY);
	PS_SetLocalString(oObject, "ScaleZ" + nSlot, sScaleZ);
}