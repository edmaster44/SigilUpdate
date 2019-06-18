//An include file for quest functions
//created 6/17/19
//by MimiFearthegn
//For permanent quest functions
#include "nwnx_sql"

//database function
//Get the permanent int entry id by characer id and quest name
int GetPermanentEntry(string sID, string sQuestName) {

	int nResult = 0;
	string sQuery = "SELECT entry_id FROM characterquests WHERE character_id='"+sID+"' AND quest_name='"+sQuestName+"'";
	
	SpeakString(sQuery, TALKVOLUME_SHOUT);
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		nResult = StringToInt(SQLGetData(1));
	}
	
	return nResult;
	
}

//database function
//Get the character ID of this PC
void SetPermanentInt(string sID, string sQuestName, int nStatus) {

	string sQuery = "";
	int nEntry = GetPermanentEntry(sID, sQuestName);
	if (nEntry > 0) {
		sQuery = "UPDATE characterquests SET quest_status='"+IntToString(nStatus)+"' WHERE character_id='"+sID+"' AND quest_name='"+sQuestName+"'"; 
	} else {
		sQuery = "INSERT INTO characterquests SET quest_status='"+IntToString(nStatus)+"', character_id='"+sID+"', quest_name='"+sQuestName+"'"; 
	}
	SpeakString(sQuery, TALKVOLUME_SHOUT);
	SQLExecDirect(sQuery);

}

//database function
//Get the permanent int value by characer id and quest name
int GetPermanentInt(string sID, string sQuestName) {

	int nResult = 0;
	string sQuery = "SELECT quest_status FROM characterquests WHERE character_id='"+sID+"' AND quest_name='"+sQuestName+"'";
	
	SpeakString(sQuery, TALKVOLUME_SHOUT);
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		nResult = StringToInt(SQLGetData(1));
	}
	
	return nResult;

}