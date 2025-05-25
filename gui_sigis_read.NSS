

// SIGIS gui function called from sigisread.xml when page change buttons are clicked - SIGIS News Submission and Reader - by Agony_Aunt/Loki
// sFunction is expected to be either "+" or "-"

#include "ps_sigis_inc"

void main(string sFunction)
{
	object oPC = OBJECT_SELF; // hopefully
	object oItem = GetLocalObject(oPC, "SIGIS_EDITION");
		
	int iCurrentPage = GetLocalInt(oItem, "CURRENT_PAGE");
	int iMaxPage = GetLocalInt(oItem, "SIGIS_PAGES");
	
	if (sFunction == "BACK")
	{
		//SendMessageToPC(oPC, "Going back a page");
		SIGISReadChangePage(oPC, oItem, iCurrentPage - 1);
	}
	
	if (sFunction == "FORWARD")
	{
		//SendMessageToPC(oPC, "Going forward a page");
		SIGISReadChangePage(oPC, oItem, iCurrentPage + 1);
	}
}