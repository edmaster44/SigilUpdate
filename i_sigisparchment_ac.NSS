// SIGIS parchment item function when used - SIGIS News Submission and Reader - by Agony_Aunt/Loki
// If target is self, then it brings up the write screen, if target is the "editor" then it will be submitted (this all needs testing, maybe best all handled via convo really)

#include "ps_sigis_inc"
#include "ps_inc_achievements"

void main()
{
	object	oPC     = GetItemActivator();
    object	oItem   = GetItemActivated();
    object	oTarget = GetItemActivatedTarget();
	
	SetLocalObject(oPC, "SIGIS_PARCHMENT", oItem); // store the item on PC for later use... depends if gui_sigis_write needs this for the item.
	
	string sText = GetLocalString(oItem, "SIGIS_TEXT");
	string sHeadline = GetLocalString(oItem, "SIGIS_HEADLINE");
	string sAuthor = GetLocalString(oItem, "SIGIS_AUTHOR");
		
	if (oPC == oTarget)
	{
		DisplayGuiScreen(oPC, "SIGIS_WRITE_SCENE", FALSE, "sigiswrite.xml");
		
		if (sHeadline != "")
		{
			SetGUIObjectText(oPC, "SIGIS_WRITE_SCENE", "SIGIS_WRITE_TEXT_HEADLINE", -1, sHeadline);
		}
		
		if (sAuthor != "")
		{
			SetGUIObjectText(oPC, "SIGIS_WRITE_SCENE", "SIGIS_WRITE_TEXT_SUBMITTER", -1, sAuthor);
		}
		else
		{
			sAuthor = GetFirstName(oPC) + " " + GetLastName(oPC);
			SetLocalString(oItem, "SIGIS_TEXT", sAuthor); // since no guarantee this will be edited, the onlostfocus call will never be made, so store it by default on first use
			SetGUIObjectText(oPC, "SIGIS_WRITE_SCENE", "SIGIS_WRITE_TEXT_SUBMITTER", -1, sAuthor);
		}
		
		if (sText != "")
		{
			SetGUIObjectText(oPC, "SIGIS_WRITE_SCENE", "SIGIS_WRITE_TEXT_ARTICLE", -1, sText);
		} 
	}
	else if (GetTag(oTarget) == SIGIS_EDITOR || GetTag(oTarget) == SIGIS_JOURNALIST || GetTag(oTarget) == SIGIS_JOURNALIST_OOC)
	{
		if ((sHeadline != "") 
			&& (sAuthor != "") 
			&& (sText != ""))
		{
			SIGISAddEntry(oItem);
			DestroyObject(oItem);
			AssignCommand(oTarget, SpeakString("Cheers cutter, ill get this right to print.", TALKVOLUME_TALK));
			SetGlobalString("LATEST_NEWS", sHeadline);
			IncrementAchievement(oPC, 22);
		}
		else
		{
			SendMessageToPC(oPC, "Article to be submitted must contain a headline, a name, and some text. Check all are present. SIGIS prides itself on the quality of its news!");
		}
	}
	else
	{
		SendMessageToPC(oPC, "Parchment must be used on self to write news or the SIGIS Editor NPC to submit news.");
	}
}