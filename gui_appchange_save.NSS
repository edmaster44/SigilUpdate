void main(int nAppearanceID, int nGenderID, int nHeadID, int nTailID, int nWingsID, int nHairID, int nFacialHairID, string sAccessory, string sHairColor, string sHairHighlight, string sSkinColor, string sEyeColor, string sEyebrowColor, string nSlot, string sScaleX, string sScaleY, string sScaleZ)
{
	//object oObject = OBJECT_SELF;
	object oObject = GetItemPossessedBy(OBJECT_SELF, "ps_essence");
	SetLocalInt(oObject, "ChangeSelfAppearanceID" + nSlot, nAppearanceID);
	SetLocalInt(oObject, "ChangeSelfGenderID" + nSlot, nGenderID);
	SetLocalInt(oObject, "ChangeSelfHeadID" + nSlot, nHeadID);
	SetLocalInt(oObject, "ChangeSelfTailID" + nSlot, nTailID);
	SetLocalInt(oObject, "ChangeSelfWingsID" + nSlot, nWingsID);
	SetLocalInt(oObject, "ChangeSelfHairID" + nSlot, nHairID);
	SetLocalInt(oObject, "ChangeSelfFacialHairID" + nSlot, nFacialHairID);
	SetLocalString(oObject, "ChangeSelfAccessoryHex" + nSlot, sAccessory);
	SetLocalString(oObject, "ChangeSelfHairHex" + nSlot, sHairColor);
	SetLocalString(oObject, "ChangeSelfHairHighlightHex" + nSlot, sHairHighlight);
	SetLocalString(oObject, "ChangeSelfSkinHex" + nSlot, sSkinColor);
	SetLocalString(oObject, "ChangeSelfEyeHex" + nSlot, sEyeColor);
	SetLocalString(oObject, "ChangeSelfEyebrowHex" + nSlot, sEyebrowColor);
	SetLocalString(oObject, "ScaleX" + nSlot, sScaleX);
	SetLocalString(oObject, "ScaleY" + nSlot, sScaleY);
	SetLocalString(oObject, "ScaleZ" + nSlot, sScaleZ);
}