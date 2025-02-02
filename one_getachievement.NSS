#include "ps_inc_achievements"
void main() {

	object oPC = GetEnteringObject();
	
	
	if (!GetIsPC(oPC))
		return;
		
	string sPQuest = GetLocalString(OBJECT_SELF, "PQUEST_NAME");
	if (sPQuest != "") {
		string sID = PS_GetCharID(oPC);
		IncrementPermanentInt(sID, sPQuest, 1);
	}
	
	int nAchieve = GetLocalInt(OBJECT_SELF, "ACHIEVEMENT_INDEX");
	if (nAchieve > 0) {
		AddAchievement(oPC, nAchieve);
	}

}