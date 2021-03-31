#include "ps_inc_functions"
#include "ps_inc_treasuregeneration"

void main () {

	object oPC = GetLastUsedBy();
	object oFruit1 = GetObjectByTag("pl_gardenfruit_1");
	object oFruit2 = GetObjectByTag("pl_gardenfruit_2");
	int nLastFired = GetLocalInt(OBJECT_SELF, "last_fired");
	int nTime = PS_GetTime();
	
	int lastLooted = GetLocalInt(OBJECT_SELF, "lastlooted");
	if (lastLooted != 0 && nTime-lastLooted > 120) {
		DeleteLocalInt(oFruit1, "reward");
		DeleteLocalInt(oFruit2, "reward");
	}
		
	SetLocalObject(oFruit1, "TriggeredBy", oPC);
	
	int nHasReward = GetPCActionRecorded(oFruit1, "gardenboss", oPC);
	
	if (GetLocalInt(OBJECT_SELF, "reward") > 0 && !nHasReward) {
		SendMessageToPC(oPC, "<i>The vines whither away from your touch after the defeat of their guardian. . showing the remains of those who tried before you and failed. You find an item of interest.</i>");
		
		GenerateQuestRewardOnTarget(oPC, TREASURE_QUEST_MED, FALSE);
		RecordPCAction(oFruit1, "gardenboss", oPC);
		SetLocalInt(oPC, "gardenboss", 1);
		
		SetLocalInt(oFruit1, "lastlooted", nTime);
		SetLocalInt(oFruit2, "lastlooted", nTime);
		
		//remove possibility of reward after a minute
		DelayCommand(120.0f, DeleteLocalInt(oFruit1, "reward"));
		DelayCommand(120.0f, DeleteLocalInt(oFruit2, "reward"));
		DeleteLocalInt(oFruit1, "stage");
		return;
	} else if (nHasReward > 0) {
		SendMessageToPC(oPC, "<i>You find nothing further of interest.");
		DeleteLocalInt(oFruit1, "stage");
		return;
	} else if (nTime-nLastFired < 360) {
		SendMessageToPC(oPC, "<i>You find nothing further of interest.");
		DeleteLocalInt(oFruit1, "stage");
		return;
	}
		
	SetLocalInt(OBJECT_SELF, "last_fired", nTime);
	
	SetUseableFlag(oFruit1, FALSE);
	SetUseableFlag(oFruit2, FALSE);
	
	ExecuteScript("colothys_bossfight", oFruit1);

}