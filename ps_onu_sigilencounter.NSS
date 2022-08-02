#include "ps_inc_advscript"
#include "ps_inc_dynamicencounters"
#include "ps_inc_functions"
#include "x0_i0_position"

//Spawn some berk
object SpawnSomeBerk(object oWP, object oPC);
object SpawnRioter(location lLoc, object oPC);

//Randomize Berk appearance
void DetailBerk(object oBerk);
void DetailRioter(object oBerk);

//Give a berk an outfit! And appropriate gear
void EquipBerk(object oBerk);

//Debtor quest logic
int ShouldTriggerDebtorQuest(object oPC, object oBerk);


void main () {

	object oPC = GetLastUsedBy();
	
	object myBerk = GetLocalObject(OBJECT_SELF, "BERK_SPAWNED");
	if (GetIsObjectValid(myBerk)) {
		SpeakString("Already has a berk! But we'll create another one anyway", TALKVOLUME_SHOUT);
	}
	
	//string sWP = GetLocalString(OBJECT_SELF, "WAYPOINT_BASE");
	object oWP = GetWaypointByTag("monstertest_a");
	
	float fDistance = 5.0f;
	location lLoc1 = GetLocation(oWP);
	location lLoc2 = CalcSafeLocation(oPC, GetRandomLocation(GetArea(oPC), oWP, fDistance), fDistance, TRUE, FALSE);
	location lLoc3 = CalcSafeLocation(oPC, GetRandomLocation(GetArea(oPC), oWP, fDistance), fDistance, TRUE, FALSE);
	
	object oBerk1 = SpawnRioter(lLoc1, oPC);
	object oBerk2 = SpawnRioter(lLoc2, oPC);
	object oBerk3 = SpawnRioter(lLoc3, oPC);
	
	SetLocalObject(oBerk1, "FELLOW_RIOTER_1", oBerk1);
	SetLocalObject(oBerk1, "FELLOW_RIOTER_2", oBerk2);
	SetLocalObject(oBerk1, "FELLOW_RIOTER_3", oBerk3);
	SetLocalInt(oBerk1, "NUM_RIOTERS", 3);
	
	SetLocalObject(oBerk2, "FELLOW_RIOTER_1", oBerk1);
	SetLocalObject(oBerk2, "FELLOW_RIOTER_2", oBerk2);
	SetLocalObject(oBerk2, "FELLOW_RIOTER_3", oBerk3);
	SetLocalInt(oBerk2, "NUM_RIOTERS", 3);
	
	SetLocalObject(oBerk3, "FELLOW_RIOTER_1", oBerk1);
	SetLocalObject(oBerk3, "FELLOW_RIOTER_2", oBerk2);
	SetLocalObject(oBerk3, "FELLOW_RIOTER_3", oBerk3);
	SetLocalInt(oBerk3, "NUM_RIOTERS", 3);
	
	DetailBerk(oBerk1);
	DetailBerk(oBerk2);
	DetailBerk(oBerk3);
	EquipBerk(oBerk1);
	EquipBerk(oBerk2);
	EquipBerk(oBerk3);
	
	/*object oBerk = SpawnSomeBerk(oWP, oPC);
	
	if (GetIsObjectValid(oBerk)) {
		DetailBerk(oBerk);
		EquipBerk(oBerk);
		
		int debtorIndex = ShouldTriggerDebtorQuest(oPC, oBerk); //returns 1, 2, or 3 if this should trigger a debtor berk
		if (debtorIndex > 0) {
			SetLocalInt(oBerk, "IS_DEBTOR", 1);
			SetLocalInt(oBerk, "DEBTOR_INDEX", debtorIndex);
			SetLocalObject(oBerk, "DEBT_HOLDER", oPC);
			SetFirstName(oBerk, "Suspicious Berk");
			SetLastName(oBerk, "");
			SetConversation(oBerk, "_somedebtorconvo_");
		}
	}*/
	
	SetLocalObject(OBJECT_SELF, "BERK_SPAWNED", oBerk1);

}

object SpawnRioter(location lLoc, object oPC) {

	int iMAX = PS_GetMaxPartylevel(oPC);
	int nLevel = FloatToInt(PS_GetAvgPartylevel(oPC, iMAX));	
	
	SpeakString("PC level: "+IntToString(nLevel), TALKVOLUME_SHOUT);
	
	int nClass = CLASS_TYPE_FIGHTER;
	int nClassRoll = Random(4)+1;
	
	//Switch between class types
	switch(nClassRoll) {
		case 1: nClass = CLASS_TYPE_FIGHTER; break;
		case 2: nClass = CLASS_TYPE_BARBARIAN; break;
		case 3: nClass = CLASS_TYPE_ROGUE; break;
		case 4: nClass = CLASS_TYPE_MONK; break;
	}
	
	SpeakString("Class chosen: "+IntToString(nClass), TALKVOLUME_SHOUT);

	object oBerk = CreateScaledCreatureofClassLocation(lLoc, nLevel, nClass, STANDARD_FACTION_COMMONER);
	if (!GetIsObjectValid(oBerk)) {
		SpeakString("Creature not spawned.", TALKVOLUME_SHOUT);
		return oBerk;
	}
	
	SetConversation(oBerk, "_somerioterconvo_");
	
	SpeakString("berk is found: "+GetName(oBerk), TALKVOLUME_SHOUT);
	
	SetLocalString(oBerk, "Berk_Type", "Rioter");
	
	SetLocalInt(oBerk, "QUEST_CR", nLevel);
	
	return oBerk;

}

object SpawnSomeBerk(object oWP, object oPC) {

	int iMAX = PS_GetMaxPartylevel(oPC);
	int nLevel = FloatToInt(PS_GetAvgPartylevel(oPC, iMAX));	
	
	SpeakString("PC level: "+IntToString(nLevel), TALKVOLUME_SHOUT);
	
	int nClass = CLASS_TYPE_FIGHTER;
	int nClassRoll = Random(4)+1;
	
	//Switch between class types
	switch(nClassRoll) {
		case 1: nClass = CLASS_TYPE_FIGHTER; break;
		case 2: nClass = CLASS_TYPE_BARBARIAN; break;
		case 3: nClass = CLASS_TYPE_ROGUE; break;
		case 4: nClass = CLASS_TYPE_MONK; break;
	}
	
	SpeakString("Class chosen: "+IntToString(nClass), TALKVOLUME_SHOUT);

	object oBerk = CreateScaledCreatureofClass(oWP, nLevel, nClass, STANDARD_FACTION_COMMONER);
	if (!GetIsObjectValid(oBerk)) {
		SpeakString("Creature not spawned.", TALKVOLUME_SHOUT);
		return oBerk;
	}
	
	SetConversation(oBerk, "_someberkconvo_");
	
	SpeakString("berk is found: "+GetName(oBerk), TALKVOLUME_SHOUT);

	int nRand = Random(4)+1;
	switch(nRand) {
		case 1: SetLocalString(oBerk, "Berk_Type", "Clueless_1"); break;
		case 2: SetLocalString(oBerk, "Berk_Type", "Clueless_2"); break;
		case 3: SetLocalString(oBerk, "Berk_Type", "Clueless_3"); break;
		case 4: SetLocalString(oBerk, "Berk_Type", "Clueless_4"); break;
	}
	
	SetLocalInt(oBerk, "QUEST_CR", nLevel);
	
	return oBerk;

}

void DetailRioter(object oBerk) {

	int nGender = Random(2);
	SetLocalInt(oBerk, "GENDER", nGender);
		
	int nHead = Random(7);
	int nHair = Random(26);
	
	SpeakString("Detailing berk: Gender = "+IntToString(nGender)+", head = "+IntToString(nHead)+", hair = "+IntToString(nHair), TALKVOLUME_SHOUT);

	struct CreatureCoreAppearance currentAppearance = PS_GetCreatureCoreAppearance(oBerk);
	currentAppearance.Gender = nGender;
	currentAppearance.HeadVariation = nHead;
	currentAppearance.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oBerk, currentAppearance);
	
	SpeakString("Post berk detailing.", TALKVOLUME_SHOUT);
	
	string sName = "Rioter";
	string sDescription = "A berk with some greivances.";
	int nRand = Random(7)+1;
	switch(nRand) {
		case 1: sName = "Enraged Berk"; break;
		case 2: sName = "Clueless Rioter"; break;
		case 3: sName = "Angry Addle-cover"; break;
		case 4: sName = "Foaming Fellow"; break;
		case 5: sName = "Ful-Foamer"; break;
		case 6: sName = "Narky Cutter"; break;
		case 7: sName = "Rioter"; break;
	}
	
	SetFirstName(oBerk, sName);
	SetLastName(oBerk, "");
	SetDescription(oBerk, sDescription);
}

void DetailBerk(object oBerk) {

	string berkType = GetLocalString(oBerk, "Berk_Type");
	
	int nGender = Random(2);
	if (berkType == "Clueless_3")
		nGender = GENDER_MALE;
	SetLocalInt(oBerk, "GENDER", nGender);
		
	int nHead = Random(7);
	int nHair = Random(26);
	
	SpeakString("Detailing berk: Gender = "+IntToString(nGender)+", head = "+IntToString(nHead)+", hair = "+IntToString(nHair), TALKVOLUME_SHOUT);

	struct CreatureCoreAppearance currentAppearance = PS_GetCreatureCoreAppearance(oBerk);
	currentAppearance.Gender = nGender;
	currentAppearance.HeadVariation = nHead;
	currentAppearance.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oBerk, currentAppearance);
	
	SpeakString("Post berk detailing.", TALKVOLUME_SHOUT);
	
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

	string berkType = GetLocalString(oBerk, "Berk_Type");
	
	if (berkType == "Clueless_3") {
		assignProtectiveItems(oBerk, TRUE);
		assignWeaponToCreature(oBerk, TRUE);
	} else {
		assignProtectiveItems(oBerk, FALSE);
		assignWeaponToCreature(oBerk, FALSE);
	}
	
	makeInventoryUndroppable(oBerk);
}


int ShouldTriggerDebtorQuest(object oPC, object oBerk) {

	string sDebtorQuest = "ps_quest_debtorspole";
	int nHasDebtorQuest = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sDebtorQuest);
	
	SpeakString("Rolling for randomness. . ", TALKVOLUME_SHOUT);
	
	//Don't ALWAYS give us the right berk
	if (d100() < 25)
		return FALSE;
		
	SpeakString("Checking if we have the quest: Stage #"+IntToString(nHasDebtorQuest), TALKVOLUME_SHOUT);
	
	if (nHasDebtorQuest <= 0)
		return FALSE;
	if (nHasDebtorQuest >= 5)
		return FALSE;
		
	SpeakString("We have the quest! Getting Debtor index. Should be in location: "+GetLocalString(oPC, "DEBTOR_1_LOCATION")+", "+GetLocalString(oPC, "DEBTOR_2_LOCATION")+", or "+GetLocalString(oPC, "DEBTOR_3_LOCATION"), TALKVOLUME_SHOUT);
	SpeakString("Current area: "+GetTag(GetArea(oPC)), TALKVOLUME_SHOUT);
	SpeakString("Finished status: 1: "+IntToString(GetLocalInt(oPC, "DEBTOR_1_DONE"))+", 2: "+IntToString(GetLocalInt(oPC, "DEBTOR_2_DONE"))+", 3: "+IntToString(GetLocalInt(oPC, "DEBTOR_3_DONE")), TALKVOLUME_SHOUT);
		
	int nDebtor = 0;
	if (GetLocalInt(oPC, "DEBTOR_1_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_1_LOCATION") || GetTag(GetArea(oPC)) == "ps_area_dmlair")) 
		nDebtor = 1;
	if (GetLocalInt(oPC, "DEBTOR_2_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_2_LOCATION") || GetTag(GetArea(oPC)) == "ps_area_dmlair")) 
		nDebtor = 2;
	if (GetLocalInt(oPC, "DEBTOR_3_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_3_LOCATION") || GetTag(GetArea(oPC)) == "ps_area_dmlair")) 
		nDebtor = 3;
		
	SpeakString("Debtor index: "+IntToString(nDebtor), TALKVOLUME_SHOUT);
	SpeakString("Gender match? "+IntToString(GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_GENDER"))+" vs. "+IntToString(GetLocalInt(oBerk, "GENDER")), TALKVOLUME_SHOUT);
		
	if (GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_GENDER") == GetLocalInt(oBerk, "GENDER")) {
		SpeakString("Gender match!", TALKVOLUME_SHOUT);
		return nDebtor;
	} else {
		return nDebtor;
	}

}