// include file for merging item appearance with properties from another source.

#include "x2_inc_itemprop"

const string CONTAINER_PROP = "contcloneprop";
const string CONTAINER_APP = "contcloneapp";
const string CONTAINER_NEW = "contclonenew";

// GetArmorRulesType doesn't push the return value on the stack if an object id
// that wasn't an item is supplied which will abort the script or cause errors.
int SafeGetArmorRulesType(object oItem)
{
	if (GetObjectType(oItem) != OBJECT_TYPE_ITEM)
		return 0;

	return GetArmorRulesType(oItem);
}

// find the container required
object GetCloneContainer(string sContainer)
{
	return GetObjectByTag(sContainer);
}

// returns the first item in the container
object GetCloneItem(object oContainer)
{
	return GetFirstItemInInventory(oContainer);
}

// the new container must be empty, or else could be problems with item merging
int CheckNewItemContainerIsEmpty()
{
	object oItem = GetCloneItem(GetCloneContainer(CONTAINER_NEW));
	
	if (GetIsObjectValid(oItem))
	{
		return FALSE;
	}
	else
	{
		return TRUE;
	}
}

/*
// returns false if first item in inventorty of target oContainer is not an armour, otherwise true.
int CheckItemValidForCloning(object oContainer)
{
	object oArmour = GetFirstItemInInventory(oContainer);
	int iReturn;
	
	if (GetIsObjectValid(oArmour))
	{
		if (GetBaseItemType(oArmour) == BASE_ITEM_ARMOR)
			iReturn = TRUE;
		else
			iReturn = FALSE;
	}
	else
	{
		iReturn = FALSE;
	}
	
	return iReturn;
}
*/



int CheckCloneItemIsValidType(object oItem) {

	if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR ||
	GetBaseItemType(oItem) == BASE_ITEM_BOOTS ||
	GetBaseItemType(oItem) == BASE_ITEM_GLOVES ||
	GetBaseItemType(oItem) == BASE_ITEM_HELMET)
	return TRUE;
	
	return FALSE;

}

int CheckCloneItemsAreEqualType()
{
	int iFirst;
	int iSecond;
	int iReturn;
	
	object oFirst = GetCloneItem(GetCloneContainer(CONTAINER_PROP));
	object oSecond = GetCloneItem(GetCloneContainer(CONTAINER_APP));
	
	iFirst = SafeGetArmorRulesType(oFirst);
	iSecond = SafeGetArmorRulesType(oSecond);
	
	if (!CheckCloneItemIsValidType(oFirst) || !CheckCloneItemIsValidType(oSecond))
	{
		iReturn = FALSE;
	}
	else if (iFirst == iSecond)
	{
		iReturn = TRUE;
	}
	else
	{
		iReturn = FALSE;
	}
	
	return iReturn;
}

void StripItemProps(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
		RemoveItemProperty(oItem, ip);

        ip = GetNextItemProperty(oItem);
    }
}

// does the cloning, destroys the originals, returns the new object, first parameter is the object with the properties, second is with the appearance.
void DoCloning(object oPropSource, object oAppSource)
{
	object oNewCont = GetCloneContainer(CONTAINER_NEW);
	
	object oNPC = GetLastSpeaker();
	PlayCustomAnimation(oNPC, "worship", FALSE);
	
	object oNew = CopyItem(oAppSource, oNewCont, FALSE); // variables false, as we want to copy those properties from the other one
	StripItemProps(oNew);
	SetItemBaseMaterialType(oNew, GetItemBaseMaterialType(oPropSource));
	SetTag(oNew, GetTag(oPropSource));
	SetFirstName(oNew, GetFirstName(oPropSource));
	SetDescription(oNew, GetDescription(oPropSource));
	
	int iCount;
	int iMaxCount = GetVariableCount(oPropSource) + 1; // just to make sure we catch all.
	
	string sName;
	int iType;
	
	for (iCount=0; iCount <= iMaxCount; iCount++)
	{
		sName = GetVariableName(oPropSource, iCount);
		iType = GetVariableType(oPropSource, iCount);
		
		if (sName != "")
		{
			switch (iType)
			{
				case VARIABLE_TYPE_INT: SetLocalInt(oNew, sName, GetLocalInt(oPropSource, sName)); break;
				case VARIABLE_TYPE_STRING: SetLocalString(oNew, sName, GetLocalString(oPropSource, sName)); break;
				case VARIABLE_TYPE_FLOAT: SetLocalFloat(oNew, sName, GetLocalFloat(oPropSource, sName)); break;
				case VARIABLE_TYPE_LOCATION: SetLocalLocation(oNew, sName, GetLocalLocation(oPropSource, sName)); break;
				default: SendMessageToPC(GetPCSpeaker(), "WARNING: Item failed to copy unknown datatype for variable '" + sName + "'"); break; // not sure whether GetPCSpeaker will work here
			}
		}
	}
	
	// now for item properties.
	IPCopyItemProperties(oPropSource, oNew, FALSE);
	
	// and now destroy
	DestroyObject(oPropSource);
	DestroyObject(oAppSource);
	
	// and some VFX on the placeables.
	effect eSource = EffectNWN2SpecialEffectFile("fx_magical_explosion");
	effect eDest = EffectNWN2SpecialEffectFile("fx_teleport");
	
	location lSource1 = GetLocation(GetCloneContainer(CONTAINER_PROP));
	location lSource2 = GetLocation(GetCloneContainer(CONTAINER_APP));
	location lDest = GetLocation(oNewCont);
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSource, lSource1);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSource, lSource2);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSource, lDest);
	
}