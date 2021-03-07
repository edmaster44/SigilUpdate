#include "ps_inc_quests"
#include "ps_inc_functions"
//Include file for the achievements system
const string sAchievementWindow = "SCOD_ACHIEVEMENTS";

//List the achievements of a given PC
//In the achievements UI
void ListAchievements(object oPC);

//Display the achievement text and description
//in the achievement window
void DisplayAchievement(object oPC, int nIndex);

//Add the achievement specified by
//2da row #
//checks if you have the achievement first
void AddAchievement(object oPC, int nIndex);

//Check if the PC already has the achievement
//specified by 2da row #
int GetHasAchievement(object oPC, int nIndex);

//Increment the quest status of the achievement
//Useful for counting number of times something has happened
void IncrementAchievement(object oPC, int nIndex);

void ListAchievements(object oPC) {

	string sID = PS_GetCharID(oPC);
	string sQuery = "SELECT entry_id, quest_name, quest_icon, quest_description, quest_status FROM characterquests WHERE character_id="+sID+" AND isAchievement=1";
	//SendMessageToPC(oPC, sQuery);
	
	int nCount = 0;
	SQLExecDirect(sQuery);
	while (SQLFetch() != SQL_ERROR) {
	
		nCount++;
		
		int entry_id = StringToInt(SQLGetData(1));
		string quest_name = SQLGetData(2);
		int quest_icon = StringToInt(SQLGetData(3));
		string quest_description = SQLGetData(4);
		int quest_status = StringToInt(SQLGetData(5));
		
		//SendMessageToPC(oPC, "Found achievement: "+quest_name);
			
		AddListBoxRow(oPC, sAchievementWindow, "SCOD_ACHIEVEMENT_LIST", "ACHIEVEMENTROW_"+IntToString(nCount), "AchievementEntryName="+quest_name+";", "", "5="+IntToString(nCount), "");
		
		SetLocalInt(oPC, "ACHIEVEMENT_"+IntToString(nCount)+"_ID", entry_id);
		SetLocalString(oPC, "ACHIEVEMENT_"+IntToString(nCount)+"_NAME", quest_name);
		SetLocalInt(oPC, "ACHIEVEMENT_"+IntToString(nCount)+"_ICON", quest_icon);
		SetLocalString(oPC, "ACHIEVEMENT_"+IntToString(nCount)+"_DESCRIPTION", quest_description);
		SetLocalInt(oPC, "ACHIEVEMENT_"+IntToString(nCount)+"_STATUS", quest_status);	
		
	}
	
	SetLocalInt(oPC, "ACHIEVEMENT_COUNT", nCount);

}


void DisplayAchievement(object oPC, int nIndex) {

	//SendMessageToPC(oPC, "Displaying achievement #"+IntToString(nIndex));
		
	int entry_id = GetLocalInt(oPC, "ACHIEVEMENT_"+IntToString(nIndex)+"_ID");
	string quest_name = GetLocalString(oPC, "ACHIEVEMENT_"+IntToString(nIndex)+"_NAME");
	int quest_icon = GetLocalInt(oPC, "ACHIEVEMENT_"+IntToString(nIndex)+"_ICON");
	string quest_description = GetLocalString(oPC, "ACHIEVEMENT_"+IntToString(nIndex)+"_DESCRIPTION");
	int quest_status = GetLocalInt(oPC, "ACHIEVEMENT_"+IntToString(nIndex)+"_STATUS");
	
	SetGUIObjectText(oPC, sAchievementWindow, "Achievement_Title", -1, quest_name);
	SetGUIObjectText(oPC, sAchievementWindow, "Achievement_Description", -1, quest_description);
}

void AddAchievement(object oPC, int nIndex) {

	if (nIndex == 0)
		return;

	if (GetHasAchievement(oPC, nIndex)) {
		SendMessageToPC(oPC, "you already have this achievement: "+IntToString(nIndex));
		return;
	}
	
	string sID = PS_GetCharID(oPC);
	string quest_name = Get2DAString("achievements", "Name", nIndex);
	string quest_description = Get2DAString("achievements", "Description", nIndex);
	int quest_icon = StringToInt(Get2DAString("achievements", "Icon", nIndex));
	string sIcon = "0";
	if (quest_icon > 0) {
		sIcon = IntToString(quest_icon);
	}
	
	string sQuery = "INSERT INTO characterquests SET character_id="+sID+", quest_name='"+quest_name+"', quest_icon="+sIcon+", quest_description='"+quest_description+"', isAchievement = 1, quest_status=1"; 
	SQLExecDirect(sQuery);
	
	SendMessageToPC(oPC, "Achievement gained: "+quest_name);
	PlaySound("gui_critical1", TRUE);
	
}

void IncrementAchievement(object oPC, int nIndex) {

	if (nIndex == 0)
		return;

	if (!GetHasAchievement(oPC, nIndex)) {
		//SendMessageToPC(oPC, "you don't already have this achievement");
		AddAchievement(oPC, nIndex);
		return;
	}
	
	string sID = PS_GetCharID(oPC);
	string quest_name = Get2DAString("achievements", "Name", nIndex);
	int nStatus = GetPermanentInt(sID, quest_name);
	
	SetPermanentInt(sID, quest_name, nStatus+1);
}

int GetHasAchievement(object oPC, int nIndex) {

	if (nIndex == 0)
		return FALSE;
	
	string sID = PS_GetCharID(oPC);
	string quest_name = Get2DAString("achievements", "Name", nIndex);
	
	int nEntry = GetPermanentEntry(sID, quest_name);
	
	return (nEntry > 0);

}