#include "ff_safevar"

void main () {

	object oPC = GetPCSpeaker();
	
	string sFighter1 = PS_GetLocalString(OBJECT_SELF, "MONSTER1");
	string sFighter2 = PS_GetLocalString(OBJECT_SELF, "MONSTER2");
	string sWinner = PS_GetLocalString(OBJECT_SELF, "POTENTIAL_WINNER");
	
	int nRand = Random(100);
	string sCreature = "";
	if (GetIsSkillSuccessful(oPC, SKILL_APPRAISE, 25, FALSE)) {
		if (nRand >= 90)
			sCreature = sWinner;
		else if (nRand <= 45)
			sCreature = sFighter1;
		else
			sCreature = sFighter2;
	}
	else {
		if (nRand <= 50)
			sCreature = sFighter1;
		else
			sCreature = sFighter2;
	}
	
	SendMessageToPC(oPC, "Appraise Result: You think that the "+sCreature+" is most likely to win.");
}