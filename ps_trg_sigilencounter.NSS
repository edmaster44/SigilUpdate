#include "ps_inc_advscript"
#include "ps_inc_dynamicencounters"
#include "ps_inc_functions"

//Spawn some berk
object SpawnSomeBerk(object oWP, object oPC);

//Randomize Berk appearance
void DetailBerk(object oBerk);

//Give a berk an outfit! And appropriate gear
void EquipBerk(object oBerk);

int ShouldTriggerDebtorQuest(object oPC, object oBerk) {

	string sDebtorQuest = "ps_quest_debtorspole";
	int nHasDebtorQuest = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sDebtorQuest);
	
	//Don't ALWAYS give us the right berk
	if (d100() < 50)
		return FALSE;
	
	if (nHasDebtorQuest <= 0)
		return FALSE;
	if (nHasDebtorQuest >= 5)
		return FALSE;
		
	int nDebtor = 0;
	if (GetLocalInt(oPC, "DEBTOR_1_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_1_LOCATION") || GetTag(GetArea(oPC)) == "ps_area_dmlair")) 
		nDebtor = 1;
	if (GetLocalInt(oPC, "DEBTOR_2_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_2_LOCATION") || GetTag(GetArea(oPC)) == "ps_area_dmlair")) 
		nDebtor = 2;
	if (GetLocalInt(oPC, "DEBTOR_3_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_3_LOCATION") || GetTag(GetArea(oPC)) == "ps_area_dmlair")) 
		nDebtor = 3;
		
	if (GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_GENDER") == GetLocalInt(oBerk, "GENDER")) {
		return nDebtor;
	} else {
		return FALSE;
	}

}

void main () {

	object oPC = GetEnteringObject();
	
	SendMessageToPC(oPC, "Crossing some berk trigger.");
	
	if (!GetIsPC(oPC))
		return;
	
	object myBerk = GetLocalObject(OBJECT_SELF, "BERK_SPAWNED");
	if (GetIsObjectValid(myBerk)) {
		return;
	}
	
	int lastDone = CheckTimeStamp();
	if (lastDone < 600) //happens once per 10 minutes
		return;
	TimeStamp();
	
	if (d100() < 75)
		return;
		
	SendMessageToPC(oPC, "Spawning some berk encounter. . .");
	
	object oWP = GetWaypointByTag("wp_"+GetTag(OBJECT_SELF));
	if (!GetIsObjectValid(oWP)) {
		SendMessageToPC(oPC, "Waypoint not valid: wp_"+GetTag(OBJECT_SELF));
		return;
	}
	
	object oBerk = SpawnSomeBerk(oWP, oPC);
	
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
	}
	
	SetLocalObject(OBJECT_SELF, "BERK_SPAWNED", oBerk);

}

object SpawnSomeBerk(object oWP, object oPC) {

	int iMAX = PS_GetMaxPartylevel(oPC);
	int nLevel = FloatToInt(PS_GetAvgPartylevel(oPC, iMAX));	
	
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
	if (!GetIsObjectValid(oBerk)) {
		return oBerk;
	}
	
	SetConversation(oBerk, "_someberkconvo_");

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

void DetailBerk(object oBerk) {

	string berkType = GetLocalString(oBerk, "Berk_Type");
	
	int nGender = Random(2);
	if (berkType == "Clueless_3")
		nGender = GENDER_MALE;
	SetLocalInt(oBerk, "GENDER", nGender);
		
	int nHead = Random(7);
	int nHair = Random(26);
	
	struct CreatureCoreAppearance currentAppearance = PS_GetCreatureCoreAppearance(oBerk);
	currentAppearance.Gender = nGender;
	currentAppearance.HeadVariation = nHead;
	currentAppearance.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oBerk, currentAppearance);
	
	string sName = "Some Berk";
	string sDescription = "A lost human - likely just fell through some portal. Cagestruck as they come.";
	int nRand = Random(10)+1;
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
		case 10: sName = "Addled Clueless"; break;
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
		DelayCommand(1.0f, AssignCommand(oBerk, ActionEquipMostDamagingMelee()));
	} else {
		assignProtectiveItems(oBerk, FALSE);
		assignWeaponToCreature(oBerk, FALSE);
	}
	
	makeInventoryUndroppable(oBerk);
}