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

//Spawn some berk
object SpawnSomeBerk(object oWP, object oPC);

//Randomize Berk appearance
void DetailBerk(object oBerk);

//Give berk an outfit! And appropriate gear
void EquipBerk(object oBerk);

void main () {

	object oPC = GetLastUsedBy();
	
	//string sWP = GetLocalString(OBJECT_SELF, "WAYPOINT_BASE");
	object oWP = GetWaypointByTag("monstertest_a");
	object oBerk = SpawnSomeBerk(oWP, oPC);
	DetailBerk(oBerk);
	EquipBerk(oBerk);

}

object SpawnSomeBerk(object oWP, object oPC) {

	int nLevel = GetHitDice(oPC);
	
	int nClass = CLASS_TYPE_FIGHTER;
	int nClassRoll = Random(4)+1;
	
	//Switch between class types
	switch(nClassRoll) {
		case 1: nClass = CLASS_TYPE_FIGHTER; break;
		case 2: nClass = CLASS_TYPE_BARBARIAN; break;
		case 3: nClass = CLASS_TYPE_ROGUE; break;
		case 4: nClass = CLASS_TYPE_MONK; break;
	}

	object oBerk = CreateScaledCreatureofClass(oWP, nLevel, nClass, STANDARD_FACTION_COMMONER);
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

void DetailBerk(object oBerk) {

	string berkType = GetLocalString(oBerk, "Berk_Type");
	
	int nGender = Random(2);
	if (berkType == "Clueless_3")
		nGender = GENDER_MALE;
		
	int nHead = Random(7);
	int nHair = Random(26);

	struct CreatureCoreAppearance currentAppearance = PS_GetCreatureCoreAppearance(oBerk);
	currentAppearance.Gender = nGender;
	currentAppearance.HeadVariation = nHead;
	currentAppearance.HairVariation = nHair;
	if (d100() < 25)
		currentAppearance.SkinColor -= 10;
	else if (d100() < 50)
		currentAppearance.SkinColor += 10;
	PS_SetCreatureCoreAppearance(oBerk, currentAppearance);
	
	string sName = "Some Berk";
	string sDescription = "A lost human - likely just fell through some portal. Cagestruck as they come.";
	int nRand = Random(9)+1;
	switch(nRand) {
		case 1: sName = "Lost Clueless"; break;
		case 2: sName = "Cagestruck Cutter"; break;
		case 3: sName = "Clueless Berk"; break;
		case 4: sName = "Addled Primer"; break;
		case 5: sName = "A Right Outsider"; break;
		case 6: sName = "Unhende Berk"; break;
		case 7: sName = "Some Primer"; break;
		case 8: sName = "Clueless Cony"; break;
		case 9: sName = "Some Berk"; break;
	}
	
	SetFirstName(oBerk, sName);
	SetLastName(oBerk, "");
	SetDescription(oBerk, sDescription);
}

void EquipBerk(object oBerk) {

}