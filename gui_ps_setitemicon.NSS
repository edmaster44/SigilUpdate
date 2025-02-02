//::///////////////////////////////////////////////
//:: gui_ps_setitemicon
//:: Created by Ceremorph 3/1/16
//:://////////////////////////////////////////////

#include "ginc_crafting"
#include "ps_inc_functions"

void main(string sIcon)
{
	object oObj		= OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oItem	= PS_GetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
		sIcon		= ParseTellDescription(sIcon);
	int nIcon		= StringToInt(sIcon);
	
	object oPC		= GetOwnedCharacter(oObj);
		
	if ((nIcon != 0) && (GetIsObjectValid(oItem)))
	{
		SetItemIcon(oItem, nIcon);
		SendMessageToPC(oPC, "Icon changed. You will need to either drop and retrieve the item or transition to see the new icon.");
	}
	
	PS_DeleteLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
}