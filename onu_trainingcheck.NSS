#include "ps_inc_training"
void main () {

	object oPC = GetLastUsedBy();
	
	int nSkill = SKILL_BLUFF;
	SpeakString("Checking for Bluff. . . ", TALKVOLUME_SHOUT);
	int nXP = GetXPForSkillTrainingQuest(oPC, nSkill, TRAINING_DIFFICULTY_NORMAL);
	SpeakString("xp to grant: "+IntToString(nXP), TALKVOLUME_SHOUT);
	
	int nAbility = ABILITY_STRENGTH;
	SpeakString("Checking for Strength. . . ", TALKVOLUME_SHOUT);
	nXP = GetXPForAbilityTrainingQuest(oPC, nAbility, TRAINING_DIFFICULTY_NORMAL);
	SpeakString("xp to grant: "+IntToString(nXP), TALKVOLUME_SHOUT);

}