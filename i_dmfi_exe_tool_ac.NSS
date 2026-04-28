

////////////////////////////////////////////////////////////////////////////////
// dmfi_exe_tool - DM Friendly Initiative - Script for DMFI Tool Activation
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/5/7
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "dmfi_inc_initial"
#include "dmfi_inc_inc_com"

void main()
{
    object oPC = GetItemActivator();
    object oItem = GetItemActivatedTarget();
    object oTool = GetItemActivated();
    string sResRef = GetResRef(oTool);
	
	if (GetBaseItemType(oItem) == BASE_ITEM_POTIONS){
		SendMessageToPC(oPC, "Due to numerous exploits and bugs, potions can no longer be edited by users");
		return;
	}
	string sRef = GetResRef(oItem);
	string sTag = GetTag(oItem);
	if (GetStringLeft(sRef, 10) == "ps_itemset" || GetStringLeft(sTag, 10) == "ps_itemset"){
		SendMessageToPC(oPC, "You cannot edit set items.");
		return;
	}
	
	if ((!DMFI_GetIsDM(oPC)) && (sResRef==DMFI_TOOL_RESREF))
	{  // Make sure Players can't use a DM Tool
		SetPlotFlag(oTool, FALSE);
		DestroyObject(oTool);
		return;
	}		

	//if (DMFI_GetIsDM(oPC))
	//{
		SetLocalObject(oTool, DMFI_TARGET, oItem);
		DMFI_RenameObject(oPC, oItem);
	//}
}