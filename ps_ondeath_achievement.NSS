#include "ff_safevar"

#include "ps_inc_achievements"
void main() {
    
	object oPC = GetLastKiller();
	while (GetIsObjectValid(GetMaster(oPC))) {
   		oPC=GetMaster(oPC);
   	}
	
	if (!GetIsPC(oPC))
		return;
		
	string sPQuest = PS_GetLocalString(OBJECT_SELF, "PQUEST_NAME");
	if (sPQuest != "") {
		string sID = PS_GetCharID(oPC);
		IncrementPermanentInt(sID, sPQuest, 1);
	}
	
	int nAchieve = PS_GetLocalInt(OBJECT_SELF, "ACHIEVEMENT_INDEX");
	if (nAchieve > 0) {
		AddAchievement(oPC, nAchieve);
	}
	

}