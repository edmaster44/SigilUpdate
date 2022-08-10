//An include file for quest functions
//created 6/17/19
//by MimiFearthegn
//For permanent quest functions
#include "nwnx_sql"
#include "ps_inc_faction"

//database function
//Get the permanent int entry id by characer id and quest name
int GetPermanentEntry(string sID, string sQuestName) {

	int nResult = 0;
	string sQuery = "SELECT entry_id FROM characterquests WHERE character_id='"+sID+"' AND quest_name='"+sQuestName+"'";
	
	//SpeakString(sQuery, TALKVOLUME_SHOUT);
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
	//SpeakString(sQuery, TALKVOLUME_SHOUT);
	SQLExecDirect(sQuery);

}

//database function
//Get the permanent int value by characer id and quest name
int GetPermanentInt(string sID, string sQuestName) {

	int nResult = 0;
	string sQuery = "SELECT quest_status FROM characterquests WHERE character_id='"+sID+"' AND quest_name='"+sQuestName+"'";
	
	//SpeakString(sQuery, TALKVOLUME_SHOUT);
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		nResult = StringToInt(SQLGetData(1));
	}
	
	return nResult;

}

//Remove the entry from the database
void DeletePermanentInt(string sID, string sQuestName) {

	string sQuery = "DELETE FROM characterquests WHERE character_id='"+sID+"' AND quest_name='"+sQuestName+"'";
	SQLExecDirect(sQuery);
	
}

//Increment a permenent integer by numberOfPoints
void IncrementPermanentInt(string sID, string sQuestName, int numberOfPoints) {

	if (numberOfPoints == 0)
		numberOfPoints = 1;

	//SendMessageToPC(oPC, "<i>You have spread your faction's influence in the city.</i>");

	int currentValue = GetPermanentInt(sID, sQuestName);
	int newValue = currentValue+numberOfPoints;
	if (newValue < 0)
		newValue = 0;
		
	SetPermanentInt(sID, sQuestName, newValue);
}

//checks if the given faction id (as in, sigil faction id) exists
int GetModuleFactionQuestExists(int nFaction) {

	string sQuery = "SELECT quest_name FROM serverquests WHERE sigil_faction_id = '"+IntToString(nFaction)+"'";
	
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		string sName = SQLGetData(1);
		if (sName == "")
			return FALSE;
	} else {
		return FALSE;
	}
	
	return TRUE;
	
}

//get the module counter for faction actions (as in, sigil factions like Athar, not other planar interests)
//If there isn't an entry for this faction yet, add one
int GetModuleFactionQuestStatus(int nFaction) {
	
	int factionExists = GetModuleFactionQuestExists(nFaction);
	
	//No entry? Make one!
	//But if we made one, we know the status is 0
	if (!factionExists) {
		string sName = FactionIdToName(nFaction);
		string sQuery = "INSERT INTO serverquests SET quest_name='"+sName+"', sigil_faction_id = '"+IntToString(nFaction)+"', current_value = 0";
		SQLExecDirect(sQuery);
		return 0;
	}
	
	string sQuery = "SELECT current_value FROM serverquests WHERE sigil_faction_id = '"+IntToString(nFaction)+"'";
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		int nValue = StringToInt(SQLGetData(1));
		return nValue;
	}
	
	return 0;

}

//increments the module counter for faction actions
//please note this applies to sigil factions (i.e. Athar, Godsmen, Bleakers, etc.)
//for non-faction interests that follow the same system
//make a different function (but use the same table!)
void IncrementModuleFactionQuest(object oPC, int nFaction, int numberOfPoints = 1) {

	if (numberOfPoints == 0)
		numberOfPoints = 1;

	//SendMessageToPC(oPC, "<i>You have spread your faction's influence in the city.</i>");

	int currentValue = GetModuleFactionQuestStatus(nFaction);
	int newValue = currentValue+numberOfPoints;
	if (newValue < 0)
		newValue = 0;
	
	string sQuery = "UPDATE serverquests SET current_value = '"+IntToString(newValue)+"' WHERE sigil_faction_id = '"+IntToString(nFaction)+"'";
	//SendMessageToPC(oPC, sQuery);
	SQLExecDirect(sQuery);
}

//checks if the given faction id (as in, sigil faction id) exists
int GetModuleQuestExists(string sName) {

	string sQuery = "SELECT quest_name FROM serverquests WHERE quest_name = '"+sName+"'";
	
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		string sName = SQLGetData(1);
		if (sName == "")
			return FALSE;
	} else {
		return FALSE;
	}
	
	return TRUE;
	
}

//get the module counter for faction actions (as in, sigil factions like Athar, not other planar interests)
//If there isn't an entry for this faction yet, add one
int GetModuleQuestStatus(string sName) {
	
	int questExists = GetModuleQuestExists(sName);
	
	//No entry? Make one!
	//But if we made one, we know the status is 0
	if (!questExists) {
		string sName = FactionIdToName(nFaction);
		string sQuery = "INSERT INTO serverquests SET quest_name='"+sName+"', current_value = 0";
		SQLExecDirect(sQuery);
		return 0;
	}
	
	string sQuery = "SELECT current_value FROM serverquests WHERE quest_name = '"+sName+"'";
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		int nValue = StringToInt(SQLGetData(1));
		return nValue;
	}
	
	return 0;

}

//increments the module counter for faction actions
//please note this applies to sigil factions (i.e. Athar, Godsmen, Bleakers, etc.)
//for non-faction interests that follow the same system
//make a different function (but use the same table!)
void IncrementModuleQuest(object oPC, string sName, int numberOfPoints = 1) {

	if (numberOfPoints == 0)
		numberOfPoints = 1;

	int currentValue = GetModuleQuestStatus(sName);
	int newValue = currentValue+numberOfPoints;
	if (newValue < 0)
		newValue = 0;
	
	string sQuery = "UPDATE serverquests SET current_value = '"+IntToString(newValue)+"' WHERE quest_name = '"+sName+"'";
	//SendMessageToPC(oPC, sQuery);
	SQLExecDirect(sQuery);
}