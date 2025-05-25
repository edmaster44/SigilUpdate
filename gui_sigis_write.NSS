

// SIGIS gui function called from sigiswrite.xml when text is accepted - SIGIS News Submission and Reader - by Agony_Aunt/Loki

void main(string sHeadline, string sAuthor, string sText)
{
	object oPC = OBJECT_SELF; // hopefully
	object oItem = GetLocalObject(oPC, "SIGIS_PARCHMENT");
	if (sHeadline != "")
	{
		SetFirstName(oItem, "SIGIS Parchment: " + sHeadline);
		SetLocalString(oItem, "SIGIS_HEADLINE", sHeadline);
	}
	if (sAuthor != "") SetLocalString(oItem, "SIGIS_AUTHOR", sAuthor);
	if (sText != "") 
	{
		SetLocalString(oItem, "SIGIS_TEXT", sText);
		SetDescription(oItem, sText);
	}
}