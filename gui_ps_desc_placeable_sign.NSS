/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ginc_crafting"
#include "ps_inc_functions"

// rename sign based on user input.
void main(string sDesc)
{
	object oObj = OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oItem = PS_GetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
	//PrettyDebug("gui_name_enchanted_item: oObj=" + GetName(oObj) + "| oItem=" + GetName(oItem)+ "| sName=" + sName);
	int iNewAdd = GetLocalInt (oObj, "DescriptionAdd");
	
	if ((sDesc != "") && (GetIsObjectValid(oItem)))
	{
		sDesc = ParseTellDescription(sDesc);
	
		if (iNewAdd == 1)
		{
			SetDescription(oItem, GetDescription(oItem) + sDesc);
		}
		else
		{
			SetDescription(oItem, sDesc);
		}
	}
	
	PS_DeleteLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
}