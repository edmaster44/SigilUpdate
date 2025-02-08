#include "ff_safevar"

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ginc_crafting"


void UserPlaceableCleanContainter(object oTarget)
{
	if (GetHasInventory(oTarget))
	{
		object oItem = GetFirstItemInInventory(oTarget);
		
		while (oItem != OBJECT_INVALID)
		{
			DestroyObject(oItem, 0.0);
			oItem = GetNextItemInInventory(oTarget);
		}
	}
}

void MovePlaceableToPlayer(object oPC, object oPlaceable)
{
	string oOwner = PS_GetLocalString(oPlaceable,"OWNER_NAME");
	location lPC = GetLocation(oPC);
	string sRef = GetResRef(oPlaceable);
	string sSignName = GetFirstName(oPlaceable);
	DestroyObject(oPlaceable, 0.01);
	
	object oNewSign = CreateObject(OBJECT_TYPE_PLACEABLE, sRef, lPC, FALSE);
	PS_SetLocalString(oNewSign, "OWNER_NAME", GetName(oPC));
	PS_SetLocalObject(oPC, "LASTSIGNTALK", oNewSign);
	SetFirstName(oNewSign, sSignName);
}

void MovePlaceableZAxis(object oPC, object oPlaceable, int iParam)
{
	string oOwner = PS_GetLocalString(oPlaceable,"OWNER_NAME");
	location lSign = GetLocation(oPlaceable);
	object oArea = GetAreaFromLocation(lSign);
	vector vVector = GetPositionFromLocation(lSign);
	float fParam = IntToFloat(iParam) / 100; // 100 needs to be 1 for 1 meter (roughly) - could be yards actually
	vVector.z = vVector.z + fParam;
	float fRotation = GetFacingFromLocation(lSign);
	
	string sRef = GetResRef(oPlaceable);
	string sSignName = GetFirstName(oPlaceable);

	DestroyObject(oPlaceable, 0.01);
	lSign = Location(oArea, vVector, fRotation);
	object oNewSign = CreateObject(OBJECT_TYPE_PLACEABLE, sRef, lSign, FALSE);
	PS_SetLocalString(oNewSign, "OWNER_NAME", GetName(oPC));
	PS_SetLocalObject(oPC, "LASTSIGNTALK", oNewSign);
	SetFirstName(oNewSign, sSignName);
}

void RotatePlaceableSign(object oPC, object oPlaceable, int iParam)
{
		string oOwner = PS_GetLocalString(oPlaceable,"OWNER_NAME");
		location lSign = GetLocation(oPlaceable);
		object oArea = GetAreaFromLocation(lSign);
		vector vVector = GetPositionFromLocation(lSign);
		float fRotation;
		float fParam = IntToFloat(iParam);
		string sRef = GetResRef(oPlaceable);
		string sSignName = GetFirstName(oPlaceable);
		
		(iParam == -1)?(fRotation = GetFacing(oPC)):(fRotation = IntToFloat(iParam));
		
		DestroyObject(oPlaceable, 0.01);
		lSign = Location(oArea, vVector, fRotation);
		object oNewSign = CreateObject(OBJECT_TYPE_PLACEABLE, sRef, lSign, FALSE);
		PS_SetLocalString(oNewSign, "OWNER_NAME", GetName(oPC));
		PS_SetLocalObject(oPC, "LASTSIGNTALK", oNewSign);
		SetFirstName(oNewSign, sSignName);
}

void DescSpawnableSign(object oPC, object oItem, int iNewAdd)
{
	int nMessageStrRef 		= 181743;
	
	string sMessage;
	
	if (iNewAdd == 1)
	{
		sMessage 		= "Give your placeable a description"; // "Please rename the item.";
	}
	else
	{
		sMessage 		= "Enter text to add to your description"; // "Please rename the item.";
	}
	
	string sOkCB			= "gui_ps_desc_placeable_sign";
	string sCancelCB		= "";
	int bShowCancel			= FALSE; 
	string sScreenName		= "";
	int nOkStrRef			= 181744;
	string sOkString		= "";
	int nCancelStrRef		= 181745;
	string sCancelString	= "";
	string sDefaultString 	= ""; //GetDescription(oItem);
	string sVariableString	= "";
	

	// the gui script will always run on the owned PC, regardless of who the player has possessed.
	object oObj = GetOwnedCharacter(oPC);
	PS_SetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT, oItem);
	PS_SetLocalInt(oObj, "DescriptionAdd", iNewAdd);
	
	DisplayInputBox( oPC, nMessageStrRef, sMessage, sOkCB, sCancelCB, bShowCancel, 
                     sScreenName, nOkStrRef, sOkString, nCancelStrRef, sCancelString,
                     sDefaultString, sVariableString);
}


void NameSpawnableSign(object oPC, object oItem)
{
	int nMessageStrRef 		= 181743;
	string sMessage 		= "Give your placeable a name"; // "Please rename the item.";
	string sOkCB			= "gui_ps_name_placeable_sign";
	string sCancelCB		= "";
	int bShowCancel			= FALSE; 
	string sScreenName		= "";
	int nOkStrRef			= 181744;
	string sOkString		= "";
	int nCancelStrRef		= 181745;
	string sCancelString	= "";
	string sDefaultString 	= GetFirstName(oItem);
	string sVariableString	= "";
	

	// the gui script will always run on the owned PC, regardless of who the player has possessed.
	object oObj = GetOwnedCharacter(oPC);
	PS_SetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT, oItem);

	DisplayInputBox( oPC, nMessageStrRef, sMessage, sOkCB, sCancelCB, bShowCancel, 
                     sScreenName, nOkStrRef, sOkString, nCancelStrRef, sCancelString,
                     sDefaultString, sVariableString);
}

// this function creates the actual sign
void CreateSignPlaceable(object oPC, object oItem, location lTarget)
{
	// may have to put in a check to find nearest safe location to place
	// perhaps in case of error the originating object shouldn't just be single use
	// but only be destroyed on sucessful creation.
	
	// Flat placeables (eg: arcane circles) present a difficulty moving after, so a bit of a hack
	// so that it will spawn above ground... hopefully.
	if (PS_GetLocalString(oItem, "TEMPLATE_RESREF") == "ps_usersign_acircle")
	{
		vector vVector = GetPositionFromLocation(lTarget);
		vVector.z += 0.1;
		lTarget = Location(GetAreaFromLocation(lTarget), vVector, GetFacingFromLocation(lTarget));
	}
	object oPlacedSign = CreateObject(OBJECT_TYPE_PLACEABLE, PS_GetLocalString(oItem, "TEMPLATE_RESREF"), lTarget);
	if (oPlacedSign != OBJECT_INVALID)
	{
		// going with PC name as only they should be able to manipulate their signs and should 
		// still work after client crash, which could result in different object ID.
		PS_SetLocalString(oPlacedSign, "OWNER_NAME", GetName(oPC));
		NameSpawnableSign(oPC, oPlacedSign);
	}
}