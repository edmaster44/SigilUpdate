#include "ff_safevar"

//requires ps_inc_functions, included in ps_inc_training
#include "ps_inc_training"


void ResetBottle(location lLoc) {

	CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plc_carnbottle", lLoc);

}

void main () {

	string sTag = GetTag(OBJECT_SELF);
	object oDamager = GetLastDamager();
	int hasPlayed = PS_GetLocalInt(oDamager, "cipher_game_played");
	int score = PS_GetLocalInt(oDamager, "cipher_game");
	int shots = PS_GetLocalInt(oDamager, "cipher_hits");
	object oCipher = GetNearestObjectByTag("ps_npc_carncipher");
	if (hasPlayed) {
		AssignCommand(oCipher, ActionSpeakString("I'm sorry, you've already had your shot. Come back again tomorrow!", TALKVOLUME_TALK));
		return;
	}
	
	int damage = GetTotalDamageDealt();
	
	int nMod = GetAbilityModifier(ABILITY_DEXTERITY, oDamager);
	int nRoll = d20();
	string sText = "Ranged Attack: "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nRoll+nMod);
	string sBottle = "";
	
	if (nMod+nRoll >= 15) {
		sText += " - Success!";
		if (nMod+nRoll > 20) {
			sBottle = "*the bottle is knocked off the crates*";
			score += 3;
		} else {
			sBottle = "*the bottle shatters!*";
			score += 1;
		}
	} else {
		sBottle = "*the bottle rocks as your missile whips past it and bounces off the wall*";
		score -= 2;
		sText += " - Failure.";
	}
	shots++;
	
	PS_SetLocalInt(oDamager, "cipher_game", score);
	PS_SetLocalInt(oDamager, "cipher_hits", shots);
	
	SendMessageToPC(oDamager, sText);
	AssignCommand(OBJECT_SELF, ActionSpeakString(sBottle, TALKVOLUME_TALK));
	
	int nExp = 0;
	int nGold = 0;
	if (shots == 4)
		AssignCommand(oCipher, ActionSpeakString("Four shots left!", TALKVOLUME_TALK));
	else if (shots == 6)
		AssignCommand(oCipher, ActionSpeakString("Two shots left!", TALKVOLUME_TALK));
	else if (shots >= 8) {
		AssignCommand(oCipher, ActionSpeakString("And that's eight!", TALKVOLUME_TALK));
		if (score >= 18) {
			DelayCommand(2.0f, 	AssignCommand(oCipher, ActionSpeakString("*claps* Very good! An expert! You get a special prize.", TALKVOLUME_TALK)));
			nExp = GetXPForAbilityTrainingQuest(oDamager, 1, TRAINING_DIFFICULTY_HARD);
			nGold = 500;
		} else if (score >= 12) {
			DelayCommand(2.0f, 	AssignCommand(oCipher, ActionSpeakString("Imperfect. But not bad! You get a prize!", TALKVOLUME_TALK)));
			nExp = GetXPForAbilityTrainingQuest(oDamager, 1, TRAINING_DIFFICULTY_NORMAL);
			nGold = 250;
		} else if (score >= 6) {
			DelayCommand(2.0f, 	AssignCommand(oCipher, ActionSpeakString("Hm, needs work. But not without promise. You get a prize.", TALKVOLUME_TALK)));
			nExp = GetXPForAbilityTrainingQuest(oDamager, 1, TRAINING_DIFFICULTY_EASY);
			nGold = 100;
		} else {
			DelayCommand(2.0f, 	AssignCommand(oCipher, ActionSpeakString("Oh my, you do need to work on your aim. I'm afraid you've lost the game.", TALKVOLUME_TALK)));
		}
		
		if (nExp > 200)
			nExp = 200;
		if (nExp > 0)
			DelayCommand(2.5f, PS_GiveXPRewardNoReturn(oDamager, nExp));
		if (nGold > 0)
			DelayCommand(2.5f, GiveGoldToCreature(oDamager, nGold));
		PS_SetLocalInt(oDamager, "cipher_game_played", 1);
	}
	
	DelayCommand(30.0f, ResetBottle(GetLocation(OBJECT_SELF)));
	if (nMod+nRoll < 15)
		DestroyObject(OBJECT_SELF, 0.2f);

}