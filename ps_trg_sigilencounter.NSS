#include "ps_inc_advscript"
#include "ps_inc_dynamicencounters"
#include "ps_inc_functions"
#include "x0_i0_position"
#include "ps_inc_quests"

const float 	MAX_BERK_DISTANCE = 3.0f; //the distance at which groups of berks should be from each other
const int 		MAX_BERKS = 5; //the max number of npcs to spawn at a given time (for group events)
const int		EVENT_CHANCE = 50; //the chance to do an event instead of a single berk
const int		MERCHANT_CHANCE = 2; //the chance to spawn a merchant instead of a berk

//Spawn some berk
object SpawnSomeBerk(object oWP, object oPC);

//Randomize Berk appearance
void DetailBerk(object oBerk);

//Give a berk an outfit! And appropriate gear
void EquipBerk(object oBerk);

//Should we get a debtor? Returns 1, 2, or 3 if true
int ShouldTriggerDebtorQuest(object oPC, object oBerk);

//spawn eventer
object SpawnEventer(location lLoc, int nEvent, object oPC);

//detail the rioter
void DetailRioter(object oBerk);

//Get whether there's an active event of event type; returns the id of the event if so
int GetActiveEvent(int event_type);

void main () {

	object oPC = GetEnteringObject();
	
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
	
	//Skip spawning a berk 10% of the time
	if (d100() < 10)
		return;
	
	object oWP = GetWaypointByTag("wp_"+GetTag(OBJECT_SELF));
	if (!GetIsObjectValid(oWP)) {
		SendMessageToPC(oPC, "Waypoint not valid: wp_"+GetTag(OBJECT_SELF));
		return;
	}
	
	
	//Random merchant appearance
	if (d100() < MERCHANT_CHANCE) {
		if (GetObjectByTag("ps_random_carddealer") != OBJECT_INVALID) {
			WriteTimestampedLogEntry("Creating the card dealer.");
			object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "ps_random_carddealer", GetLocation(oWP));
			return;
		}
	}
	
	//Get whether there's an active riot and we should spawn it
	int activeEvent = GetActiveEvent(NPC_EVENT_RIOT);
	SendMessageToPC(oPC, "event found: "+IntToString(activeEvent));
	if (d100() < EVENT_CHANCE && activeEvent > 0) {
		int nBerkNum = Random(MAX_BERKS)+1;
		string sQuery = "SELECT * FROM ps_npc_events WHERE event_id = '"+IntToString(activeEvent)+"'";
		SQLExecDirect(sQuery);
		if (SQLFetch() != SQL_ERROR) { 
			int event_id = StringToInt(SQLGetData(1));
			int event_type = StringToInt(SQLGetData(2));
			string conversation_file = SQLGetData(3);
			string slogan_1 = SQLGetData(4);
			string slogan_2 = SQLGetData(5);
			string slogan_3 = SQLGetData(6);
			string explanation = SQLGetData(7);
			
			int n;
			for (n = 1; n <= nBerkNum; n++) {
				location lLoc;
				if (n == 1) //first berk generates on the waypoint
					lLoc = GetLocation(oWP);
				else //subsequent berks generate in random locations
					lLoc = CalcSafeLocation(oPC, GetRandomLocation(GetArea(oPC), oWP, MAX_BERK_DISTANCE), MAX_BERK_DISTANCE, TRUE, FALSE);
				object oBerk = SpawnEventer(lLoc, event_id, oPC);
				
				SetLocalObject(OBJECT_SELF, "FELLOW_RIOTER_"+IntToString(n), oBerk);
				DetailRioter(oBerk);
				EquipBerk(oBerk);
				
				SetLocalObject(OBJECT_SELF, "BERK_SPAWNED", oBerk);
				
				SetConversation(oBerk, conversation_file);
				SetLocalString(oBerk, "Slogan_1", slogan_1);
				SetLocalString(oBerk, "Slogan_2", slogan_2);
				SetLocalString(oBerk, "Slogan_3", slogan_3);
				SetLocalString(oBerk, "Explanation", explanation);
				SetLocalInt(oBerk, "NUM_RIOTERS", nBerkNum);
				
				if (n > 1) {
					DelayCommand(2.0f, TurnToFaceObject(GetLocalObject(OBJECT_SELF, "FELLOW_RIOTER_1"), oBerk));
				}
			}
				
			for (n = 1; n <= nBerkNum; n++) {
				object oBerk = GetLocalObject(OBJECT_SELF, "FELLOW_RIOTER_"+IntToString(n));
				int k;
				for (k = 1; k <= nBerkNum; k++) {
					object oFellow = GetLocalObject(OBJECT_SELF, "FELLOW_RIOTER_"+IntToString(k));
					SetLocalObject(oBerk, "FELLOW_RIOTER_"+IntToString(k), oFellow);
				}
			}
			
			SetCustomToken(6010, slogan_1);
			SetCustomToken(6011, slogan_2);
			SetCustomToken(6012, slogan_3);
			SetCustomToken(6013, explanation);
		}
	} 
	//Standard berk handling
	else {
		WriteTimestampedLogEntry("Creating some berk in "+GetTag(GetArea(oPC)));
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

object SpawnEventer(location lLoc, int nEvent, object oPC) {

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

	object oBerk = CreateScaledCreatureofClassLocation(lLoc, nLevel, nClass, STANDARD_FACTION_COMMONER);
	if (!GetIsObjectValid(oBerk)) {
		SpeakString("Creature not spawned.", TALKVOLUME_SHOUT);
		return oBerk;
	}
	
	DelayCommand(3.0f, SetCreatureScriptsToSet(oBerk, 12));
	
	int nAnim = Random(6)+1;
	switch(nAnim) {
		case 1: SetLocalString(oBerk, "ANIMATION", "talkforce01"); break;
		case 2: SetLocalString(oBerk, "ANIMATION", "talkcheer"); break;
		case 3: SetLocalString(oBerk, "ANIMATION", "talkforce"); break;
		case 4: SetLocalString(oBerk, "ANIMATION", "torchidle"); break;
		case 5: SetLocalString(oBerk, "ANIMATION", "talkforce02"); break;
		case 6: SetLocalString(oBerk, "ANIMATION", "talkforce03"); break;
	}
	
	int nSound = Random(7)+1;
	switch (nSound) {
		case 1: SetLocalString(oBerk, "SOUND", "as_pl_tauntingf1"); break;
		case 2: SetLocalString(oBerk, "SOUND", "as_pl_tauntingf2"); break;
		case 3: SetLocalString(oBerk, "SOUND", "as_pl_tauntingf3"); break;
		case 4: SetLocalString(oBerk, "SOUND", "as_pl_prisinmob1"); break;
		case 5: SetLocalString(oBerk, "SOUND", "as_pl_prisinmob2"); break;
		case 6: SetLocalString(oBerk, "SOUND", "as_pl_prisinmob3"); break;
		case 7: SetLocalString(oBerk, "SOUND", "as_pl_prisinmob4"); break;
	}
	
	if (nEvent == 1)
		SetLocalString(oBerk, "Berk_Type", "Rioter");
	
	SetLocalInt(oBerk, "QUEST_CR", nLevel);
	
	return oBerk;

}

void DetailRioter(object oBerk) {

	int nGender = Random(2);
	SetLocalInt(oBerk, "GENDER", nGender);
		
	int nHead = Random(7);
	int nHair = Random(26);
	
	struct CreatureCoreAppearance currentAppearance = PS_GetCreatureCoreAppearance(oBerk);
	currentAppearance.Gender = nGender;
	currentAppearance.HeadVariation = nHead;
	currentAppearance.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oBerk, currentAppearance);
	
	string sName = "Rioter";
	string sDescription = "A berk with some greivances.";
	int nRand = Random(8)+1;
	switch(nRand) {
		case 1: sName = "Enraged Berk"; break;
		case 2: sName = "Clueless Rioter"; break;
		case 3: sName = "Angry Addle-cover"; break;
		case 4: sName = "Foaming Fellow"; break;
		case 5: sName = "Ful-Foamer"; break;
		case 6: sName = "Narky Cutter"; break;
		case 7: sName = "Rioter"; break;
		case 8: sName = "Blood with a Grievance"; break;
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

int ShouldTriggerDebtorQuest(object oPC, object oBerk) {

	string sDebtorQuest = "ps_quest_debtorspole";
	int nHasDebtorQuest = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sDebtorQuest);
	
	//Making it prioritize suspicious berk over standard berk, because testing
	//if (d100() < 50)
	//	return FALSE;
	
	if (nHasDebtorQuest <= 0)
		return FALSE;
	if (nHasDebtorQuest >= 5)
		return FALSE;
		
	int nDebtor = 0;
	if (GetLocalInt(oPC, "DEBTOR_1_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_1_LOCATION"))) 
		nDebtor = 1;
	if (GetLocalInt(oPC, "DEBTOR_2_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_2_LOCATION"))) 
		nDebtor = 2;
	if (GetLocalInt(oPC, "DEBTOR_3_DONE") <= 0 && (GetTag(GetArea(oPC)) == GetLocalString(oPC, "DEBTOR_3_LOCATION"))) 
		nDebtor = 3;
		
	if (GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_GENDER") == GetLocalInt(oBerk, "GENDER")) {
		return nDebtor;
	} else {
		return FALSE;
	}

}

int GetActiveEvent(int event_type) {
	int nMaxEvents = GetNumberOfActiveNPCEvents(event_type);
	int nEventToFetch = Random(nMaxEvents);
	int nCurrentEvent = GetActiveNPCEvent(event_type, nEventToFetch);
	
	return nCurrentEvent;
}