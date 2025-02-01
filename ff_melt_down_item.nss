#include "ff_safevar"

// This script destroys a selected craftable item and gives a metal ingot. It is called in the
// dialog confirm_meltdown_dialog, which is started from using the smithhammer on an item. See
// x2_mod_def_act

void ConfirmAndMelt(object oIngot, object oDestroy){
	if (GetIsObjectValid(oIngot)) DestroyObject(oDestroy, 0.3f);
}


void main(){
	object oPC = GetPCSpeaker();
 
	object oDestroy = PS_GetLocalObject(oPC, "melt_itemObject");
	string sIngot = PS_GetLocalString(oPC, "melt_ingotRes");
	
	object oIngot = CreateItemOnObject(sIngot, oPC);
	DelayCommand(0.5f, ConfirmAndMelt(oIngot, oDestroy));
}
