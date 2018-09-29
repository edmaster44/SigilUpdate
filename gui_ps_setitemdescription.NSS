//::///////////////////////////////////////////////
//:: gui_ps_setitemdescription
//:: Created by Ceremorph 3/1/16
//:://////////////////////////////////////////////

#include "ginc_crafting"
#include "ps_inc_functions"

// change description of item based on user input.
void main(string sDesc)
{
	object oObj = OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oItem = GetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
	string sCRLF = GetStringByStrRef(16777631);
	
	if ((sDesc != "") && (GetIsObjectValid(oItem)))
	{
		sDesc = ParseTellDescription(sDesc);
		SetDescription(oItem, "<color=indigo><i>***Custom Description***</i></color> " + sCRLF + sDesc);
	}
	
	DeleteLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
}