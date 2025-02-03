#include "ps_inc_faction"
#include "ps_inc_randomitems"
//requires ps_inc_functions, included in ps_inc_training
#include "ps_inc_training"
/**********************************************************
* Handles the actual Harmonium pursuit code, because that *
* could not be run with the conversation script           *
**********************************************************/

string GetRandomGuardSpeak(object oPC, object oGuard);
void ApprehendPC(object oPC, object oGuard);
void GuardExit(object oPC, object oGuard);

void main() {

	object oPC = OBJECT_SELF;
	object oGuard = GetLocalObject(oPC, "HARMONIUM");
	
	int nStage = GetLocalInt(oPC, "HARMONIUM_PURSUIT");
	SetLocalInt(oPC, "HARMONIUM_PURSUIT", nStage+1); 
	
	ApprehendPC(oPC, oGuard);
	
	if (nStage <= 3)
		DelayCommand(6.0f, ExecuteScript("ps_harmonium_apprehend", oPC));
	else
		DelayCommand(6.0f, GuardExit(oPC, oGuard));

}

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
		
	AssignCommand(oGuard, ActionSpeakString("Apprehending PC", TALKVOLUME_SHOUT));
		
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
	
		AssignCommand(oGuard, ActionSpeakString("PC is hiding", TALKVOLUME_SHOUT));
	
		if (GetIsSkillSuccessful(oPC, SKILL_HIDE, nDC, TRUE)) {
	 		if (!noExp)
				PS_GiveXPReward(oPC, nExp);
				
			string sMessage = GetRandomGuardSpeak(oPC, oGuard);
			AssignCommand(oGuard, ActionSpeakString(sMessage));
			return;
		}
		
	} 
	
	if (GetDistanceBetween(oPC, oGuard) > 4.0f) { //PC is too far away
	
		AssignCommand(oGuard, ActionSpeakString("PC is too far away", TALKVOLUME_SHOUT));
	
		AssignCommand(oGuard, ActionMoveToLocation(GetLocation(oPC), TRUE));
		AssignCommand(oGuard, ActionSpeakString("Stop! In the name of the law!"));
		DelayCommand(1.0f, ApprehendPC(oPC, oGuard));
		return;
		
	} else {
		AssignCommand(oGuard, ActionSpeakString("Apprehended! Should start conversation. . ", TALKVOLUME_SHOUT));
	
		if (!IsInConversation(oPC)) {
			ActionStartConversation(oGuard, "conv_harmoniumarrest", TRUE, FALSE, TRUE);
		} else {
			ClearAllActions();
			BeginConversation("conv_harmoniumarrest", oGuard);
		}
	
	}

}

void GuardExit(object oPC, object oGuard) {

	if (GetLocalInt(oGuard, "HAS_APPREHENDED") == 0 && IsInConversation(oPC)) {
		//you're probably cheating to avoid being fined, so just fine you anyway
		SendMessageToPC(oPC, "The Harmonium fine you 100 jink for pickpocketing.");
		TakeGoldFromCreature(100, oPC, TRUE);
	}

	AssignCommand(oGuard, ActionSpeakString("Guard leaving", TALKVOLUME_SHOUT));
	
	SetLocalInt(oGuard, "HAS_APPREHENDED", 1);

	if (IsInConversation(oGuard)) {
		DelayCommand(6.0f, GuardExit(oPC, oGuard));
		return;
	}

	AssignCommand(oGuard, ActionMoveAwayFromObject(oPC, FALSE, 30.0f));
	DestroyObject(oGuard, 6.0f);
	DestroyObject(OBJECT_SELF, 6.0f);
	
}