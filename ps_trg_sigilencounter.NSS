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


object SpawnSomeBerk();

void main () {

	object oPC = GetLastUsedBy();
	
	string sWP = GetLocalString(OBJECT_SELF, "WAYPOINT_BASE");
	object oWP = GetWaypointByTag("monstertest_a");
	
	object oMonster = CreateObject(OBJECT_TYPE_CREATURE, "ps_faction_npc_12_rp2", GetLocation(oWP));
	SendMessageToPC(oPC, "Monster created; race is. . "+IntToString(GetSubRace(oMonster)));
	PS_SetSubRacialType(oMonster, RACIAL_SUBTYPE_UNDEAD);
	SendMessageToPC(oPC, "Monster race is now. . "+IntToString(GetSubRace(oMonster)));


}

/*object SpawnSomeBerk() {

	string toSpawn
	int nRand = Random(4)+1;
	switch(nRand) {
		case 1: 
	}

}*/