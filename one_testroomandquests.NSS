#include "ps_inc_quests"
#include "ps_inc_functions"

void main () {

	object oPC = GetEnteringObject();
	object oModule = GetModule();
	
	//Fetching permanent quest statuses
	string sID = PS_GetCharID(oPC);
	
	int nAbyssQuest = GetPermanentInt(sID, "ps_quest_abyss_contracts");
	if (nAbyssQuest > 0)
		AddJournalQuestEntry("ps_quest_abyss_contracts", 1, oPC);
		
	int nBaatorQuest = GetPermanentInt(sID, "ps_quest_baator_contracts");
	if (nBaatorQuest > 0)
		AddJournalQuestEntry("ps_quest_baator_contracts", 1, oPC);
		
	int nGehennaQuest = GetPermanentInt(sID, "ps_quest_gehenna_contracts");
	if (nGehennaQuest > 0)
		AddJournalQuestEntry("ps_quest_gehenna_contracts", 1, oPC);
	
	//Test server vs. production switch
	string sVersion = GetLocalString(oModule, "serverVersion");
	if (sVersion != "")
		return;

	string sQuery = "SELECT version FROM server_version WHERE row_id = 1";
	
	SQLExecDirect(sQuery);
	
	if (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		string version = SQLGetData(1);
		SetLocalString(oModule, "serverVersion", version);
		
		//Test server! open the testing room
		if (version == "Testing") {
			if (GetObjectByTag("testing_portal_out") == OBJECT_INVALID) {
				object oWP = GetWaypointByTag("wp_testing_portal_in_2");
				CreateObject(OBJECT_TYPE_PLACEABLE, "testing_portal_out", GetLocation(oWP));
			}
		}
	}

}