//::///////////////////////////////////////////////
//:: gui_ps_setitemname
//:: Created by Ceremorph 3/1/16
//:://////////////////////////////////////////////

#include "ginc_crafting"
#include "ps_inc_functions"

// rename item based on user input.
void main(string sName)
{
	object oObj = OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oItem = GetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
	
	if ((sName != "") && (GetIsObjectValid(oItem)))
	{
		sName = ParseTellDescription(sName);
				SetFirstName(oItem, sName);
	}
	
	DeleteLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
}