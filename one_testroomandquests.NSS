#include "ps_inc_achievements"
#include "ps_inc_faction"

int GetFaction(object oPC);

void CheckForAchievements(object oPC);

void main () {

	object oPC = GetEnteringObject();
	object oModule = GetModule();
	
	if (GetLocalInt(oPC, "LAST_OOC_PORTAL") == 0) {
		PS_Timestamp_UNIX(oPC, "LAST_OOC_PORTAL");
	}
	
	//check achievements
	DelayCommand(1.0f, CheckForAchievements(oPC));
	
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
				object oWP = GetWaypointByTag("wp_testing_portal_in_2"); //normal version
				//object oWP = GetWaypointByTag("wp_testing_portal_in"); //xmas version
				CreateObject(OBJECT_TYPE_PLACEABLE, "testing_portal_out", GetLocation(oWP));
			}
		}
	}

}

//check for achievments on delay
void CheckForAchievements(object oPC) {

	int nChecked = GetLocalInt(oPC, "ACHIEVEMENTS_CHECKED");
	string sID = PS_GetCharID(oPC);
	//SendMessageToPC(oPC, "Checking for achievements");
	
	if (nChecked == 0) {
	
		int nAbyssQuest = GetPermanentInt(sID, "ps_quest_abyss_contracts");
		if (nAbyssQuest > 0) {
			AddJournalQuestEntry("ps_quest_abyss_contracts", 1, oPC);
			AddAchievement(oPC, 27);
		}
			
	} else if (nChecked == 1) {
	
		int nBaatorQuest = GetPermanentInt(sID, "ps_quest_baator_contracts");
		if (nBaatorQuest > 0) {
			AddJournalQuestEntry("ps_quest_baator_contracts", 1, oPC);
			AddAchievement(oPC, 27);
		}
			
	} else if (nChecked == 2) {
	
		int nGehennaQuest = GetPermanentInt(sID, "ps_quest_gehenna_contracts");
		if (nGehennaQuest > 0) {
			AddJournalQuestEntry("ps_quest_gehenna_contracts", 1, oPC);
			AddAchievement(oPC, 27);
		}
		
	} else if (nChecked == 3) {
	
		int nFaction = GetFaction(oPC);
		if (nFaction > 1 & nFaction < 17)  {
			AddAchievement(oPC, 2);
		} else if (nFaction == 255) {
			AddAchievement(oPC, 5);
		}
		
	} else if (nChecked == 4) {
		
		if (GetIsFactotum(oPC)) {
			AddAchievement(oPC, 16);
		}
		
	} else if (nChecked == 5) {
	
		if (GetIsFactor(oPC)) {
			AddAchievement(oPC, 16);
			AddAchievement(oPC, 17);
		}
		
	} else if (nChecked == 6) {
	
		if (GetHitDice(oPC) > 1) {
			AddAchievement(oPC, 1);
		}
		
	} else if (nChecked == 7) {
	
		if (GetPermanentInt(sID, "Twin Cities") > 0) {
			AddAchievement(oPC, 4);
			DeletePermanentInt(sID, "Twin Cities");
		}
		
	} else if (nChecked == 8) {
	
		if (GetPermanentInt(sID, "beggar_charity") >= 50) {
			AddAchievement(oPC, 15);
			DeletePermanentInt(sID, "beggar_charity");
		}
		if (GetPermanentInt(sID, "beggar_kick") >= 50) {
			AddAchievement(oPC, 43);
			DeletePermanentInt(sID, "beggar_kick");
			DeletePermanentInt(sID, "Charity Drive");
		}
		
	} else if (nChecked == 9) {
	
		if (GetPermanentInt(sID, "bloodwar_kill") >= 1000) {
			AddAchievement(oPC, 8);
		}
		
	} else if (nChecked == 10) {
	
		if (GetPermanentInt(sID, "Peeled a Berk") > 0 &&
			GetPermanentInt(sID, "Helped a Berk") > 0) {
			DeletePermanentInt(sID, "Helped a Berk");
		}
		
	} else if (nChecked == 11) {
	
		if (GetPermanentInt(sID, "Bet Your Life - Victor") >= 10) {
			AddAchievement(oPC, 64);
		}
		
	} else if (nChecked == 12) {
	
		if (PS_GetLevel(oPC) >= 30) {
			AddAchievement(oPC, 29);
		}
		
	} else if (nChecked == 13) {
	
		int gamblingInt = GetPermanentInt(sID, "Gambled an Item");
		if (gamblingInt >= 10) {
			AddAchievement(oPC, 81);
		}
		if (gamblingInt >= 50) {
			AddAchievement(oPC, 82);
		}
		
	} else if (nChecked == 14) {
	
		int sigisInt = GetPermanentInt(sID, "Fit to Print");
		if (sigisInt >= 10) {
			AddAchievement(oPC, 41);
		}
		if (sigisInt >= 50) {
			AddAchievement(oPC, 40);
		}
		
	} else if (nChecked == 15) {
		
		if (GetPermanentInt(sID, "athar_1") > 0 &&
			GetPermanentInt(sID, "athar_2") > 0 &&
			GetPermanentInt(sID, "athar_3") > 0) {
			AddAchievement(oPC, 42);
		}
	
	} else if (nChecked == 16) {
	
		int sigisInt = GetPermanentInt(sID, "Sands of the Arena");
		if (sigisInt >= 10) {
			AddAchievement(oPC, 41);
		}
		if (sigisInt >= 50) {
			AddAchievement(oPC, 47);
		}
		
	} else if (nChecked == 17) {
	
		if (GetPermanentInt(sID, "FINISHED_LECTURE_1") > 0 &&
			GetPermanentInt(sID, "FINISHED_LECTURE_2") > 0) {
			AddAchievement(oPC, 56);
			DeletePermanentInt(sID, "FINISHED_LECTURE_1");
			DeletePermanentInt(sID, "FINISHED_LECTURE_2");
		}
		
	} else {
		return;
	}
	
	SetLocalInt(oPC, "ACHIEVEMENTS_CHECKED", nChecked+1);
	DelayCommand(0.5f, CheckForAchievements(oPC));

}

//Get faction
//Refactor this later
int GetFaction(object oPC) {

	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}