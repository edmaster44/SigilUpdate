//*******************************************
//ps_inc_dynamicencounters
//Mimi Fearthegn
//Started 3-5-20
//*******************************************
//Include script for creating creatures
//suitable for encounters (fighting or flavor)
//of any level
//*******************************************
#include "ps_inc_advscript"

//creates a creature/npc at the given waypoint
//of decent challenge to nLevel
//and of the given class type
//can be set to a standard faction with faction = STANDARD_FACTION_*
//(if there is no blueprint of the given class type, defaults to fighter)
//Supported class types:
//CLASS_TYPE_BARBARIAN
//CLASS_TYPE_BARD
//CLASS_TYPE_CLERIC
//CLASS_TYPE_DRUID
//CLASS_TYPE_SPIRIT_SHAMAN (defaults to druid for now)
//CLASS_TYPE_FIGHTER
//CLASS_TYPE_MONK
//CLASS_TYPE_PALADIN
//CLASS_TYPE_RANGER
//CLASS_TYPE_ARCANE_ARCHER (actually just gives ranger archer)
//CLASS_TYPE_ROGUE
//CLASS_TYPE_WARLOCK
//CLASS_TYPE_WIZARD
object CreateScaledCreatureofClass(object oWP, int nLevel, int classType, int isHostile = TRUE);

//Gets the blueprint string from the class INT
//(if there is no blueprint of the given class type, defaults to fighter)
string GetBlueprintStringFromClass(int classType);

//Gets the nearest blueprint available
//classType currently does nothing; putting it in for later
int GetNearestCreatureLevelAvailable(int nLevel, int classType);

//Sets the creature's conversation
void SetConversation(object oCreature, string sConversation);

//Gets the resref of a suitable set of clothing
string GetClothing(object oCreature);

//Gets the resref of a suitable set of armor
string GetArmor(object oCreature);

//*******************************************
//ACTUAL CODE
//*******************************************
object CreateScaledCreatureofClass(object oWP, int nLevel, int classType, int faction = STANDARD_FACTION_HOSTILE) {

	int blueprintID = GetNearestCreatureLevelAvailable(nLevel, classType);
	string sBlueprint = GetBlueprintStringFromClass(classType)+IntToString(blueprintID);
	
	//make sure we have a waypoint
	if (!GetIsObjectValid(oWP))
		return oWP;
		
	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sBlueprint, GetLocation(oWP));
	ChangeToStandardFaction(oCreature, faction);
	
	return oCreature;
}

string GetBlueprintStringFromClass(int classType) {

	switch (classType) {
		case CLASS_TYPE_BARBARIAN: return "de_barbarian_";
		case CLASS_TYPE_BARD: return "de_bard_";
		case CLASS_TYPE_CLERIC: return "de_cleric_";
		case CLASS_TYPE_DRUID: return "de_druid_";
		case CLASS_TYPE_SPIRIT_SHAMAN: return "de_druid_";
		case CLASS_TYPE_FIGHTER: return "de_fighter_";
		case CLASS_TYPE_MONK: return "de_monk_";
		case CLASS_TYPE_PALADIN: return "de_paladin_";
		case CLASS_TYPE_RANGER: return "de_ranger_";
		case CLASS_TYPE_ARCANE_ARCHER: return "de_archer_";
		case CLASS_TYPE_ROGUE: return "de_rogue_";
		case CLASS_TYPE_WARLOCK: return "de_warlock_";
		case CLASS_TYPE_WIZARD: return "de_wizard_";
		default: return "de_fighter_";
	}
	
	return "de_fighter_";

}

int GetNearestCreatureLevelAvailable(int nLevel, int classType = CLASS_TYPE_FIGHTER) {

	if (nLevel <= 2)
		return 1;
	else if (nLevel <= 5) 
		return 2;
	else if (nLevel <= 8) 
		return 3;
	else if (nLevel <= 11) 
		return 4;
	else if (nLevel <= 14) 
		return 5;
	else if (nLevel <= 17) 
		return 6;
	else if (nLevel <= 20) 
		return 7;
	else if (nLevel <= 23) 
		return 8;
	else if (nLevel <= 27) 
		return 9;
	else
		return 10;

}

void SetConversation(object oCreature, string sConversation) {

	SetLocalString(oCreature, "DEFAULT_CONVERSATION", sConversation);

}

string GetClothing(object oCreature) {

	int nRand = Random(4)+1;
	switch(nRand) {
		case 1: return "";
	}

}