

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ginc_crafting"

// rename sign based on user input.
void main(string sName)
{
	object oObj = OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oItem = GetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
	//PrettyDebug("gui_name_enchanted_item: oObj=" + GetName(oObj) + "| oItem=" + GetName(oItem)+ "| sName=" + sName);
	
	if ((sName != "") && (GetIsObjectValid(oItem)))
	{
		SetFirstName(oItem, sName);
	}
	
	DeleteLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
}