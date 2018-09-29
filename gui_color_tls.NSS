//*/////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------ 
// gui_color_tls - Elechos - Script de GUI : Calcule une couleur RGB grace 
//								aux valeurs envoyé en TLS
// Scripteur:  Tyrnis
// Dernière Modification : 08 / 12 / 2007
//------------------------------------------------------------------------------
//*/////////////////////////////////////////////////////////////////////////////


#include "nwnx_craft_system"
#include "ps_inc_advscript"

void main (int iTeinte, int iLuminosite, int iSaturation)
{	
	//XPCraft_Debug(OBJECT_SELF,"TLS : \n T = " + IntToString(iTeinte) + "\n L = " + IntToString(iLuminosite) + "\n S = " + IntToString(iSaturation));
	object oPC = OBJECT_SELF;

	// Make sure that the item still exists so that the slot zero item isn't
	// destroyed when trying to change colors after backing out of the menu.
	if (GetLocalObject(oPC, "XC_ITEM_TO_CRAFT") == OBJECT_INVALID)
	{
		XPCraft_Debug(oPC, "No item selected for color change, aborted.");
		return;
	}
	
	struct strTint strMyTint = XPCraft_HLSToTintStruct(iTeinte, iLuminosite, iSaturation);
	int iNewColorValue =  XPCraft_strTintToInt(strMyTint);
	SetLocalObject(oPC, "XC_ITEM_TO_CRAFT", XPCraft_ActionChangeColor(oPC, iNewColorValue));
		
}