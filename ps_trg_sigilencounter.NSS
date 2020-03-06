//AC metrics
//Levels 1-5 standard armor
//Levels 5-10 armor +1-5
//Levels 10-15 amulet of nat armor +1-5
//Levels 15-20 boots of dodge +1-5
//Levels 20-25 ring +1-5
//Levels 25-30 armor +6-10

//Weapon metrics
//Levels 1-5 standard weapons (sometimes silver or cold iron)
//Levels 5-10 weapons 1-3 points
//Levels 10-15 weapons 3-6 points
//Levels 15-20 weapons 6-9 points
//Levels 20+ weapons 9-10 points

//Add DR at level 10+ (if necessary for concept)
#include "ps_inc_advscript"
#include "ps_inc_dynamicencounters"

object SpawnSomeBerk(object oWP, object oPC);

void main () {

	object oPC = GetLastUsedBy();
	
	//string sWP = GetLocalString(OBJECT_SELF, "WAYPOINT_BASE");
	object oWP = GetWaypointByTag("monstertest_a");
	object oBerk = SpawnSomeBerk(oWP, oPC);
	

}

object SpawnSomeBerk(object oWP, object oPC) {

	int nLevel = GetHitDice(oPC);

	object oBerk = CreateScaledCreatureofClass(oWP, nLevel, CLASS_TYPE_FIGHTER, STANDARD_FACTION_COMMONER);
	SetConversation(oBerk, "_someberkconvo_");

	int nRand = Random(4)+1;
	switch(nRand) {
		case 1: SetLocalString(oBerk, "Berk_Type", "Clueless_1"); break;
		case 2: SetLocalString(oBerk, "Berk_Type", "Clueless_2"); break;
		case 3: SetLocalString(oBerk, "Berk_Type", "Clueless_3"); break;
		case 4: SetLocalString(oBerk, "Berk_Type", "Clueless_4"); break;
	}
	
	return oBerk;

}