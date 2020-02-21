#include "ps_inc_faction"
#include "ps_inc_randomitems"
#include "ps_inc_training"
/**********************************************************
* Summons a Harmonium to pursue the PC					  *
* sCause should be the reason why the guard was summoned  *
* Guard can be evaded with stealth                        *
**********************************************************/
//Valid sCause values
//sCause = Pickpocket
/*********************************************************/

string GetRandomGuardSpeak(object oPC, object oGuard) {

	string sPronoun = (GetGender(oPC) == GENDER_MALE) ? "he" : "she";

	int nRand = Random(3)+1;
	
	if (nRand == 1) {
		if (GetLocalString(oGuard, "CRIME") == "Pickpocket")
			return "Now then. . where's that pickpocket got to. .";
		else
			return "Now then. . which way did "+sPronoun+" go?";
	} else if (nRand == 2) {
		return "Show yourself, miscreant!";
	} else {
		return "Which way did "+sPronoun+" go?";
	}
	
	return "Which way did "+sPronoun+" go?";

}

void ApprehendPC(object oPC, object oGuard) {

	//If we've already apprehended the pc, skip this
	if (GetLocalInt(oGuard, "HAS_APPREHENDED") > 0)
		return;
		
	int nCR = GetChallengeRatingOfTarget(oGuard);
	int nDC = nCR+10+(d10());

	object oPC = GetPCSpeaker();
	int nMod = GetSkillRank(SKILL_HIDE, oPC, TRUE);
	int nDifficulty = GetDifficultyOfCheck(nDC, nMod);
	int noExp = FALSE;
	if (nDifficulty < 0) {
		noExp = TRUE;
		nDifficulty = TRAINING_DIFFICULTY_VERY_EASY;
	}
	
	int maxExp = 150; 
	int nExp = GetXPForSkillTrainingQuest(oPC, SKILL_HIDE, nDifficulty);
	if (nExp > maxExp)
		nExp = maxExp;
		
	if (GetActionMode(oPC, ACTION_MODE_STEALTH)) { //we are in stealth!
	
		if (GetIsSkillSuccessful(oPC, SKILL_HIDE, nDC, TRUE)) {
	 		if (!noExp)
				GiveXPToCreature(oPC, nExp);
				
			string sMessage = GetRandomGuardSpeak(oPC, oGuard);
			AssignCommand(oGuard, ActionSpeakString(sMessage));
			return;
		}
		
	} 
	
	if (GetDistanceBetween(oPC, oGuard) > 4.0f) { //PC is too far away
	
		AssignCommand(oGuard, ActionMoveToLocation(GetLocation(oPC), TRUE));
		AssignCommand(oGuard, ActionSpeakString("Stop! In the name of the law!"));
		DelayCommand(1.0f, ApprehendPC(oPC, oGuard));
		return;
		
	} else {
	
		SetLocalInt(oGuard, "HAS_APPREHENDED", 1);
		AssignCommand(oGuard, ActionStartConversation(oPC, "conv_harmoniumarrest", TRUE, FALSE, TRUE));
	
	}

}

void GuardExit(object oNPC, object oGuard) {
	
	SetLocalInt(oGuard, "HAS_APPREHENDED", 1);

	if (IsInConversation(oGuard)) {
		DelayCommand(6.0f, GuardExit(oNPC, oGuard));
		return;
	}

	AssignCommand(oGuard, ActionMoveAwayFromObject(oNPC, FALSE, 30.0f));
	DestroyObject(oGuard, 6.0f);
	
}

void main(string sCause) {

	object oPC = GetPCSpeaker();
	
	//The CR of this "encounter"
	int nCR = GetChallengeRatingOfTarget(OBJECT_SELF);

	//Summon the Harmonium
	object oGuard = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard", FindHenchSpawnPoint(oPC));

	//Set the appropriate variables
	SetLocalObject(oGuard, "CRIMINAL", oPC);
	SetLocalString(oGuard, "CRIME", sCause);
	SetLocalInt(oGuard, "QUEST_CR", nCR); //pass CR to guard npc
	SetLocalInt(oGuard, "HAS_APPREHENDED", 0);
	
	//Move to the PC
	DelayCommand(0.1f, SetImmortal(oGuard, TRUE));
	DelayCommand(0.2f, AssignCommand(oGuard, ActionMoveToLocation(GetLocation(oPC), TRUE)));
	
	//Now apprehending!
	DelayCommand(1.0f, ApprehendPC(oPC, oGuard));
	DelayCommand(13.0f, ApprehendPC(oPC, oGuard));
	DelayCommand(25.0f, ApprehendPC(oPC, oGuard));
	DelayCommand(37.0f, GuardExit(OBJECT_SELF, oGuard));
	
}