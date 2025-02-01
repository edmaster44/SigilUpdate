#include "ff_safevar"

void main(int increase)
{
	// Keeps the hacks away.
	if (increase != 1 && increase != -1)
		return;

   	object oPC = OBJECT_SELF;
	int page = PS_GetLocalInt(oPC, "kemo_storage_page") + increase;
	
	// No negative pages.
	if (page < 1)
		page = 1;

	// No infinite pages.
	int iListTotal = PS_GetLocalInt(oPC, "kemo_storage_list_size");
	if ((page - 1) * 25 >= iListTotal)
		page = ((iListTotal - 1) / 25) + 1;

	// Prevents unneeded reloads
	if (page == PS_GetLocalInt(oPC, "kemo_storage_page"))
		return;
	
	PS_SetLocalInt(oPC, "kemo_storage_page", page);
	
	if ( PS_GetLocalString(oPC, "kemo_storage_mode") == "retrieve" )
		ExecuteScript("gui_kemo_storage_list",OBJECT_SELF);
	else
		ExecuteScript("gui_kemo_storage_deposit",OBJECT_SELF);
}