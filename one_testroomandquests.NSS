#include "ps_inc_achievements"
#include "ps_inc_faction"

int GetFaction(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}

void main () {

	object oPC = GetEnteringObject();
	object oModule = GetModule();
	
	//Fetching permanent quest statuses
	string sID = PS_GetCharID(oPC);
	
	if (GetLocalInt(oPC, "LAST_OOC_PORTAL") == 0) {
		PS_Timestamp_UNIX(oPC, "LAST_OOC_PORTAL");
	}
	
	int nAbyssQuest = GetPermanentInt(sID, "ps_quest_abyss_contracts");
	if (nAbyssQuest > 0)
		AddJournalQuestEntry("ps_quest_abyss_contracts", 1, oPC);
		
	int nBaatorQuest = GetPermanentInt(sID, "ps_quest_baator_contracts");
	if (nBaatorQuest > 0)
		AddJournalQuestEntry("ps_quest_baator_contracts", 1, oPC);
		
	int nGehennaQuest = GetPermanentInt(sID, "ps_quest_gehenna_contracts");
	if (nGehennaQuest > 0)
		AddJournalQuestEntry("ps_quest_gehenna_contracts", 1, oPC);
		
	//Update Achievements
	int nFaction = GetFaction(oPC);
	if (nFaction > 1 & nFaction < 17)  {
		DelayCommand(0.5f, AddAchievement(oPC, 2));
		
		if (GetIsFactotum(oPC)) {
			DelayCommand(0.6f, AddAchievement(oPC, 16));
		}
		if (GetIsFactor(oPC)) {
			DelayCommand(0.7f, AddAchievement(oPC, 17));
		}
	}
	
	//You've left or been kicked out of your faction
	if (nFaction == 255) {
		DelayCommand(0.8f, AddAchievement(oPC, 5));
	}
	
	if (GetHitDice(oPC) > 1) {
		DelayCommand(0.9f, AddAchievement(oPC, 1));
	}
	
	if (GetPermanentInt(sID, "Twin Cities")) {
		DelayCommand(1.0f, AddAchievement(oPC, 4));
		DeletePermanentInt(sID, "Twin Cities");
	}
	
	if (GetPermanentInt(sID, "beggar_charity") >= 100) {
		DelayCommand(1.1f, AddAchievement(oPC, 15));
		DeletePermanentInt(sID, "beggar_charity");
	}
	
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