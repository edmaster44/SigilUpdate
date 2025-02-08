#include "ff_safevar"

// SIGIS newspaper function  - SIGIS News Submission and Reader - by Agony_Aunt/Loki
// Called from convo when someone purchases a copy of SIGIS

#include "ps_sigis_inc"

void main()
{
	object oPC = GetPCSpeaker();
	
	object oItem = CreateItemOnObject("sigisedition", oPC);
	int iNewsExists = SIGISGetEntries(oItem);
	
	PS_SetLocalInt(oItem, "SIGIS_EDITION_DATE", GetRealTime());
	SetFirstName(oItem, "SIGIS Edition - " + SigisDate(GetRealTime()));
	
	if (iNewsExists == FALSE)
	{
		//SendMessageToPC(oPC, "No news, so setting quiet day");
		PS_SetLocalInt(oItem, "SIGIS_DATE_1", GetRealTime());
		PS_SetLocalString(oItem, "SIGIS_HEADLINE_1", "A Quiet Day in Sigil!");	
		PS_SetLocalString(oItem, "SIGIS_AUTHOR_1", "Editor-in-Chief");	
		PS_SetLocalString(oItem, "SIGIS_TEXT_1", "SIGIS journalists today failed to report anything newsworthy. A report of a Modron stuck up a tree turned out to be false.");
		PS_SetLocalInt(oItem, "SIGIS_PAGES", 1);
	}
}