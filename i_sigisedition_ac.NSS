#include "ff_safevar"

// SIGIS newspaper function when used - SIGIS News Submission and Reader - by Agony_Aunt/Loki
// use to read the news contained in the edition.

#include "ps_sigis_inc"

void main()
{
	object	oPC     = GetItemActivator();
    object	oItem   = GetItemActivated();
	
	PS_SetLocalObject(oPC, "SIGIS_EDITION", oItem); // store the item on PC for later use. used by gui_sigis_read to get object info
	
	int iLoop = 0;
	int iFound = TRUE;
	
	DisplayGuiScreen(oPC, "SIGIS_READ_SCENE", FALSE, "sigisread.xml");
	
	string sTodayDate = SigisDate(PS_GetLocalInt(oItem, "SIGIS_EDITION_DATE"));
	SetGUIObjectText(oPC, "SIGIS_READ_SCENE", "SIGIS_READ_EDITION_DATE", -1, sTodayDate);
	
	// We populate from 1 which is safe as there is always the default no news page
	SIGISReadChangePage(oPC, oItem, 1);
}