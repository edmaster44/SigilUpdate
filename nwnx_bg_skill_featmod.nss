#include "nwnx_bg"


	// Called at the end of the usual feat mods by the engine.
	// Be careful not to send messages to the PC.  This function is
	// called frequently and flooding a PC with messages will not be
	// good.


void main()
{

	// Passed into the script from nwnx.  The row number
	// of the skill to check as written in skills.2da
	int nSkillId = nwnx_bg_skill_featmod_GetSkill();

	// Creature to check for requirements before applying
	// base skill bonus.
	// Not used by current script so commented out.
	
	// object oCreature = OBJECT_SELF;

	// Temporary variable used as our return value.
	int nSkillBonus = 0;


	switch(nSkillId)
	{
		case 32: //LoreDungeon
		nSkillBonus += GetHasFeat(3925)*3; //SkillFocusLoreDungeon
			break;
		case 33: //LoreReligion
		nSkillBonus += GetHasFeat(3931)*3; //SkillFocusLoreReligion
			break;
		case 34: //LoreNature
		nSkillBonus += GetHasFeat(3929)*3; //SkillFocusLoreNature
			break;
		case 35: //LoreNobility
		nSkillBonus += GetHasFeat(3930)*3; //SkillFocusLoreNobility
			break;
		case 36: //LoreLocal
		nSkillBonus += GetHasFeat(3928)*3; //SkillFocusLoreLocal
			break;
		case 39: //LoreHistory
		nSkillBonus += GetHasFeat(3927)*3; //SkillFocusLoreHistory
			break;
		case 40: //LoreGeography
		nSkillBonus += GetHasFeat(3926)*3; //SkillFocusLoreGeography
			break;
		case 41: //LoreThePlanes
		nSkillBonus += GetHasFeat(3932)*3; //SkillFocusLoreThePlanes
			break;
		case 42: //LoreArchEngineer
		nSkillBonus += GetHasFeat(3924)*3; //SkillFocusLoreArchEngineer
			break;
		case 43: //CraftTextile
		nSkillBonus += GetHasFeat(2950)*3; //SkillFocusCraftTextile
			break;
		case 44: //CraftSculpt
		nSkillBonus += GetHasFeat(2951)*3; //SkillFocusCraftSculpt
			break;
		case 45: //CraftFood
		nSkillBonus += GetHasFeat(2952)*3; //SkillFocusCraftFood
			break;
		case 46: //CraftScribe
		nSkillBonus += GetHasFeat(2953)*3; //SkillFocusCraftScribe
			break;
		case 47: //ProfessionFarm
		nSkillBonus += GetHasFeat(2954)*3; //SkillFocusProfessionFarm
			break;
		case 48: //ProfessionMine
		nSkillBonus += GetHasFeat(2955)*3; //SkillFocusProfessionMine
			break;
		case 49: //ProfessionHunt
		nSkillBonus += GetHasFeat(2956)*3; //SkillFocusProfessionHunt
			break;
		case 50: //ProfessionForest
		nSkillBonus += GetHasFeat(2957)*3; //SkillFocusProfessionForest
			break;
		case 51: //ProfessionOther
		nSkillBonus += GetHasFeat(2958)*3; //SkillFocusProfessionOther
			break;
		case 28: //Ride
		nSkillBonus += GetHasFeat(2959)*3; //SkillFocusRide
			break;
		case 52: //GatherInfo
		nSkillBonus += GetHasFeat(2960)*3; //SkillFocusGatherInfo
			break;
		case 38: //EscapeArtist
		nSkillBonus += GetHasFeat(3923)*3; //SkillFocusEscapeArt
			break;
		case 30: //SenseMotive
		nSkillBonus += GetHasFeat(3949)*3; //SkillFocusSenseMot
			break;
		case 31: //Linguistics
		nSkillBonus += GetHasFeat(2963)*3; //SkillFocusLinguistics
			break;
		case 37: //Disguise
		nSkillBonus += GetHasFeat(3922)*3; //SkillFocusDisguise
			break;
		case 54: //Athletics
		nSkillBonus += GetHasFeat(2965)*3; //SkillFocusAthletics
			break;
	}

	nwnx_bg_skill_featmod_set(nSkillBonus);

}