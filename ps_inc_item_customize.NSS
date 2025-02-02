//::///////////////////////////////////////////////
//:: ps_inc_item_customize
//:: Include file for gui_ps_setitem*** scripts
//:: Created by Ceremorph 3/1/16
//:://////////////////////////////////////////////

#include "ginc_crafting"
#include "ps_inc_functions"

void PS_SetItemDescription(object oPC, object oItem)
{
	int nMessageStrRef 		= 181743;
	string sMessage			= "Enter the description for your item"; 
	
	string sOkCB			= "gui_ps_setitemdescription";
	string sCancelCB		= "";
	int bShowCancel			= TRUE; 
	string sScreenName		= "";
	int nOkStrRef			= 181744;
	string sOkString		= "";
	int nCancelStrRef		= 181745;
	string sCancelString	= "";
	string sDefaultString 	= GetDescription(oItem);
	string sVariableString	= "";
	

	// the gui script will always run on the owned PC, regardless of who the player has possessed.
	object oObj = GetOwnedCharacter(oPC);
	PS_SetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT, oItem);
	
	DisplayInputBox( oPC, nMessageStrRef, sMessage, sOkCB, sCancelCB, bShowCancel, 
                     sScreenName, nOkStrRef, sOkString, nCancelStrRef, sCancelString,
                     sDefaultString, sVariableString);
}


void PS_SetItemName(object oPC, object oItem)
{
	int nMessageStrRef 		= 181743;
	string sMessage 		= "Enter the name for your item"; // "Please rename the item.";
	string sOkCB			= "gui_ps_setitemname";
	string sCancelCB		= "";
	int bShowCancel			= TRUE; 
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

void PS_SetItemIcon(object oPC, object oItem)
{
	int nIconNumber			= GetItemIconSafe(oItem);
	string sIconNumber		= IntToString(nIconNumber);

	int nMessageStrRef 		= 181743;
	string sMessage 		= "Enter the icon number for your item"; // "Please rename the item.";
	string sOkCB			= "gui_ps_setitemicon";
	string sCancelCB		= "";
	int bShowCancel			= TRUE; 
	string sScreenName		= "";
	int nOkStrRef			= 181744;
	string sOkString		= "";
	int nCancelStrRef		= 181745;
	string sCancelString	= "";
	string sDefaultString 	= sIconNumber;
	string sVariableString	= "";
	

	// the gui script will always run on the owned PC, regardless of who the player has possessed.
	SendMessageToPC(oPC, "Current Icon: " + sIconNumber);
	object oObj = GetOwnedCharacter(oPC);
	PS_SetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT, oItem);

	DisplayInputBox( oPC, nMessageStrRef, sMessage, sOkCB, sCancelCB, bShowCancel, 
                     sScreenName, nOkStrRef, sOkString, nCancelStrRef, sCancelString,
                     sDefaultString, sVariableString);
}