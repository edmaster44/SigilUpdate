#include "ps_inc_functions"
#include "ps_inc_treasuregeneration"

void main () {

	object oPC = GetLastUsedBy();
	object oFruit1 = GetObjectByTag("pl_gardenfruit_1");
	object oFruit2 = GetObjectByTag("pl_gardenfruit_2");
	int nTime = GetLocalInt(OBJECT_SELF, "last_fired");
		
	SetLocalObject(oFruit1, "TriggeredBy", oPC);
	
	if (GetLocalInt(OBJECT_SELF, "reward") > 0) {
		SendMessageToPC(oPC, "<i>The vines whither away from your touch after the defeat of their guardian. . showing the remains of those who tried before you and failed. You find an item of interest.</i>");
		
		GenerateQuestRewardOnTarget(oPC, TREASURE_QUEST_HIGH, TRUE);
		SetLocalInt(oPC, "gardenboss", 1);
		
		//remove possibility of reward after a minute
		DelayCommand(60.0f, DeleteLocalInt(OBJECT_SELF, "reward"));
		return;
	} else if (GetLocalInt(oPC, "gardenboss") > 0) {
		SendMessageToPC(oPC, "<i>You find nothing further of interest.");
		return;
	} else if (GetTime()-nTime < 360) {
		SendMessageToPC(oPC, "<i>You find nothing further of interest.");
		return;
	}
		
	SetLocalInt(OBJECT_SELF, "last_fired", GetTime());
	
	SetUseableFlag(oFruit1, FALSE);
	SetUseableFlag(oFruit2, FALSE);
	
	ExecuteScript("colothys_bossfight", oFruit1);

}