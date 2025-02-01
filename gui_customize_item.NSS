#include "ff_safevar"

#include "ps_inc_newcrafting"
//Allows name / description / icon customization
//called from the customization ui after crafting
void main(string sName, string sDescrip, string sIcon)
{

	//SendMessageToPC(OBJECT_SELF, "recieved: "+sName+", "+sDescrip+", "+sIcon);
	int nIcon = StringToInt(sIcon);
	string sCRLF = GetStringByStrRef(16777631);
	string newDescrip = "<color=indigo><i>***Custom Description***</i></color> " + sCRLF + sDescrip;
	
	object oItem = PS_GetLocalObject(OBJECT_SELF, "crafted_item");
	
	SetFirstName(oItem, sName);
	SetDescription(oItem, newDescrip);
	if (nIcon > 0)
		SetItemIcon(oItem, nIcon);
	
	PS_DeleteLocalObject(OBJECT_SELF, "crafted_item");
	CloseGUIScreen(OBJECT_SELF, sCustomizationScreen);
	SendMessageToPC(OBJECT_SELF, "Item updated. You may need to drop and retrieve the item, or transition to see any change in the icon.");
}