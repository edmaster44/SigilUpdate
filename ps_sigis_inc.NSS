// SIGIS functions for SCoD - SIGIS News Submission and Reader - by Agony_Aunt/Loki
// All functions in beta version will write to local objects.  Functions to be modified by cryptc to hit the db for persistence.

#include "nwnx_sql"
#include "ps_inc_functions"
#include "ps_inc_time"

const string SIGIS_EDITOR = "npc_sigis_editor";
const string SIGIS_JOURNALIST = "npc_sigis_journalist";
const string SIGIS_JOURNALIST_OOC = "npc_sigis_journalist_ooc";
const int SIGIS_BACKDATE = 604800; // how far back in time should we go for fetching entries?

// Date function for newspaper
// iDetailed means return hours and mins.
string SigisDate(int iSQLTime, int iDetailed=FALSE)
{
	int SecondsInYear = 31557600; // 60*60*24*365.25
	int SecondsInDay = 86400; // 60*60*24
	
	int iBaseYear = iSQLTime / SecondsInYear;
	int iYear =  iBaseYear + 86;
	string sYear = IntToString(iYear) + "Ha"; // <-- Hashkar
	
	int iDayOfYear = ((iSQLTime - (iBaseYear * SecondsInYear))/SecondsInDay) + 1;
	int iMonth = iDayOfYear/28;
	int iDayOfMonth = iDayOfYear - (28*iMonth);
	iMonth++; // now finished calculating DayOfMonth, make first month = 1 not 0 for easier reading
	int iWeek = iDayOfMonth/7+1;
	
	string sFullDate;
	string sMonth;
	string sDay;	
	string sWeek;
	int iHour;
	int iMin;
	string sHour;
	string sMin;
	
	if (iDayOfYear == 365)
	{
		sFullDate = "Leagueheim, " + sYear;
	}
	else if (iDayOfYear == 366)
	{
		sFullDate = "Revolution, " + sYear;
	}
	else
	{
		switch (iMonth)
		{
			case 1: sMonth = "Regula"; break;
			case 2: sMonth = "Accordant"; break;
			case 3: sMonth = "Retributus"; break;
			case 4: sMonth = "Narciss"; break;
			case 5: sMonth = "Tithing"; break;
			case 6: sMonth = "Savorus"; break;
			case 7: sMonth = "The Pivot"; break;
			case 8: sMonth = "Catechism"; break;
			case 9: sMonth = "Sacrilegion"; break;
			case 10: sMonth = "Nihilum"; break;
			case 11: sMonth = "Mortis"; break;
			case 12: sMonth = "Decadre"; break;
			case 13: sMonth = "Capricious"; break;
			// no need for default (hopefully) as should already be caught if month=14
		}
		
		switch (iDayOfMonth)
		{
			case 1: case 8: case 15: case 22: sDay = "Lady"; break;
			case 2: case 9: case 16: case 23: sDay = "Market"; break;
			case 3: case 10: case 17: case 24: sDay = "Guild"; break;
			case 4: case 11: case 18: case 25: sDay = "Clerk"; break;
			case 5: case 12: case 19: case 26: sDay = "Hive"; break;
			case 6: case 13: case 20: case 27: sDay = "Low"; break;
			case 7: case 14: case 21: case 28: sDay = "Void"; break;
		}
		
		sWeek = IntToString(iWeek);
		switch (iWeek)
		{
			case 1: sWeek += "st"; break;
			case 2: sWeek += "nd"; break;
			case 3: sWeek += "rd"; break;
			case 4: sWeek += "th"; break;
		}
	
	// need to convert the individual strings into a combined one.
	sFullDate = sWeek + " " + sDay + " of " + sMonth + ", " + sYear;

	}
	
	if (iDetailed == TRUE)
	{
		string sHoursMins;
		
		iHour = GetTimeHour();
		iMin = GetTimeMinute();

		if (iHour == 0 && iMin == 0)
		{
			sHoursMins = "Anti-peak on ";
		}
		else if (iHour == 12 && iMin == 0)
		{
			sHoursMins = "Peak on ";
		}
		else if (iHour < 6)
		{
			sHoursMins = IntToString(iHour);
			
			if (iHour == 1)
				sHoursMins += " hour and ";
			else
				sHoursMins += " hours and ";
			
			sHoursMins += IntToString(iMin);
			
			if (iMin == 1)
				sHoursMins += " minute ";
			else
				sHoursMins += " minutes ";
			
			sHoursMins += "after anti-peak on ";
		}
		else if (iHour > 11 && iHour < 18)
		{
			iHour = iHour - 12;
			sHoursMins = IntToString(iHour);
			
			if (iHour == 1)
				sHoursMins += " hour and ";
			else
				sHoursMins += " hours and ";
			
			sHoursMins += IntToString(iMin);
			
			if (iMin == 1)
				sHoursMins += " minute ";
			else
				sHoursMins += " minutes ";
			
			sHoursMins += "after peak on ";
		}
		else if (iHour > 5 && iHour < 12)
		{
			// because dealing with "to" times, need to invert hours and mins, ie 6=5, 7=4 .. 11=0.
			// and with mins 1 = 59 and 59 = 1.
			iHour = abs(iHour - 11);
			iMin = abs(iMin - 60);
			
			sHoursMins = IntToString(iHour);
			
			if (iHour == 1)
				sHoursMins += " hour and ";
			else
				sHoursMins += " hours and ";
			
			sHoursMins += IntToString(iMin);
			
			if (iMin == 1)
				sHoursMins += " minute ";
			else
				sHoursMins += " minutes ";
			
			sHoursMins += "to peak on ";
		}
		else
		{
			// because dealing with "to" times, need to invert hours and mins, ie 18 = 5 .. 23 = 0.
			// and with mins 1 = 59 and 59 = 1.
			iHour = abs(iHour - 23);
			iMin = abs(iMin - 60);
			
			sHoursMins = IntToString(iHour);
			
			if (iHour == 1)
				sHoursMins += " hour and ";
			else
				sHoursMins += " hours and ";
			
			sHoursMins += IntToString(iMin);
			
			if (iMin == 1)
				sHoursMins += " minute ";
			else
				sHoursMins += " minutes ";
			
			sHoursMins += "to anti-peak on ";
		}
		
		sFullDate = sHoursMins + sFullDate;
	}
	
	return sFullDate;
}


void SIGISAddEntry(object oItem)
{
	string sHeadline = PS_GetLocalString(oItem, "SIGIS_HEADLINE"); 
	string sAuthor = PS_GetLocalString(oItem, "SIGIS_AUTHOR");
	string sText = PS_GetLocalString(oItem, "SIGIS_TEXT");
	int iDate = GetRealTime();
	string sPCID = PS_GetCharID(GetItemPossessor(oItem));
	
	SQLExecDirect("INSERT INTO sigis (creator,submissiondate,author,headline,articletext) VALUES ("+sPCID+",UNIX_TIMESTAMP(),'"+SQLEncodeSpecialChars(sAuthor)+"','"+SQLEncodeSpecialChars(sHeadline)+"','"+SQLEncodeSpecialChars(sText)+"')");
}

/* Used when player purchases a newspaper.  Retrieves all entries in the table and stores on the item (these variables are then taken by the gui script when a player reads the paper, this allows people to keep old editions of newspapers and we can keep the table in the DB under control by clearing out old entries).

Stores entries in sequentially numbered variables on the object. EDIT: SORT by SubmissionDate please! (newest to oldest)

Table column 'SubmissionDate' -> local int on oItem "SIGIS_DATE_[i]1[/i]"
Table column 'Headline' -> local string on oItem "SIGIS_HEADLINE_[i]1[/i]"
Table column 'Author' -> local string on oItem "SIGIS_AUTHOR_[i]1[/i]"
Table column 'ArticleText' -> local string on oItem "SIGIS_TEXT_[i]1[/i]"

As each row is added the local variable number (in italics) is incremented.
eg: int iCounter; [i]do while loop[/i] iCounter++; PS_SetLocalInt(oItem, "SIGIS_DATE_" + IntToString(iCounter), [i]timestamp[/i]);

int return value = TRUE if any entries were found, FALSE if no entries were found.  Therefore if no news entries, i can drop some random or default news in.
*/
int SIGISGetEntries(object oItem)
{
	int iLoop = 0;
	int iFound = TRUE;
	object oPC = GetItemPossessor(oItem);
	int iDate;
	string sAuthor;
	string sHeadline;
	string sArticleText;
	
	SQLExecDirect("SELECT submissiondate,author,headline,articletext FROM sigis WHERE submissiondate > UNIX_TIMESTAMP() - "+IntToString(SIGIS_BACKDATE)+" ORDER BY submissiondate");

	while (SQLFetch() != SQL_ERROR) 
	{ 
		iDate = StringToInt(SQLGetData(1));
		sAuthor = SQLGetData(2);
		sHeadline = SQLGetData(3);
		sArticleText = SQLGetData(4);
		
		iLoop++;
		PS_SetLocalInt(oItem, "SIGIS_DATE_" + IntToString(iLoop), iDate);
		PS_SetLocalString(oItem, "SIGIS_HEADLINE_" + IntToString(iLoop), sHeadline);	
		PS_SetLocalString(oItem, "SIGIS_AUTHOR_" + IntToString(iLoop), sAuthor);	
		PS_SetLocalString(oItem, "SIGIS_TEXT_" + IntToString(iLoop), sArticleText);		
	}
	
	// Stores the max number of pages
	PS_SetLocalInt(oItem, "SIGIS_PAGES", iLoop);
	
	if (iLoop == 0)
		iFound = FALSE;
	else
		iFound = TRUE;
		
	return iFound;
}

void SIGISReadChangePage(object oPC, object oItem, int iPage)
{
	string sPage = IntToString(iPage);

	//SendMessageToPC(oPC, "Displaying Page: " + sPage);
	
	SetGUIObjectText(oPC, "SIGIS_READ_SCENE", "SRLB_HEADLINE", -1, PS_GetLocalString(oItem, "SIGIS_HEADLINE_" + sPage));
	SetGUIObjectText(oPC, "SIGIS_READ_SCENE", "SRLB_AUTHOR", -1, "Submitted By: " + PS_GetLocalString(oItem, "SIGIS_AUTHOR_" + sPage));
	SetGUIObjectText(oPC, "SIGIS_READ_SCENE", "SRLB_DATE", -1, "Submit Date: " + SigisDate(PS_GetLocalInt(oItem, "SIGIS_DATE_" + sPage)));
	SetGUIObjectText(oPC, "SIGIS_READ_SCENE", "SRLB_TEXT", -1, PS_GetLocalString(oItem, "SIGIS_TEXT_" + sPage));
	
	PS_SetLocalInt(oItem, "CURRENT_PAGE", iPage);
	int iMaxPage = PS_GetLocalInt(oItem, "SIGIS_PAGES");
	string sPageText = IntToString(iPage) + " of " + IntToString(iMaxPage);
	
	if (iPage == 1)
		SetGUIObjectDisabled(oPC, "SIGIS_READ_SCENE", "SIGIS_WRITE_BUTTON_LEFT", TRUE);
	else
		SetGUIObjectDisabled(oPC, "SIGIS_READ_SCENE", "SIGIS_WRITE_BUTTON_LEFT", FALSE);
		
	if (iPage == iMaxPage)
		SetGUIObjectDisabled(oPC, "SIGIS_READ_SCENE", "SIGIS_WRITE_BUTTON_RIGHT", TRUE);
	else
		SetGUIObjectDisabled(oPC, "SIGIS_READ_SCENE", "SIGIS_WRITE_BUTTON_RIGHT", FALSE);
		
	SetGUIObjectText(oPC, "SIGIS_READ_SCENE", "PAGE_OF_PAGES", -1, sPageText);		
}