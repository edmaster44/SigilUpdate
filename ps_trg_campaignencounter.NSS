//Uses the Dynamic Encounter system to create an encounter of the 
//correct CR for the entering PC
//Currently being used for campaign things; expand more later
#include "ps_inc_dynamicencounters"
#include "ps_inc_functions"
#include "x0_i0_anims"
#include "ps_inc_advscript"

//CAMPAIGN_SPAWN_TYPE
//0 = Harmonium
//1 = Fleeing Townsfolk

void SpawnHarmoniumEncounter(object oWP, int nLevel, object oPC = OBJECT_INVALID);
void SpawnCommonerEncounter(object oWP, int nLevel, object oPC = OBJECT_INVALID);
void SpawnHarmoniumScout(object oWP, int nLevel, object oPC = OBJECT_INVALID);
void SpawnTreasureChest(object oWP, int nLevel);

void main() {

	object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC))
		return;
	
	object oEncounter = GetLocalObject(OBJECT_SELF, "ENCOUNTER_SPAWNED");
	if (GetIsObjectValid(oEncounter)) {
		return;
	}
	
	int lastDone = CheckTimeStamp();
	if (lastDone < 600) //happens once per 10 minutes
		return;
	TimeStamp();
	
	//Get party average level
	int iMAX = PS_GetMaxPartylevel(oPC);
	int nLevel = FloatToInt(PS_GetAvgPartylevel(oPC, iMAX));
	nLevel -= 5; //lower slightly because we don't want max challenge
	if (nLevel < 6) //don't kill the lowbie!
		return;
	
	object oWP = GetWaypointByTag("wp_"+GetTag(OBJECT_SELF));
	int nSpawnType = GetLocalInt(OBJECT_SELF, "CAMPAIGN_SPAWN_TYPE");
	
	if (nSpawnType == 1) {
		SpawnCommonerEncounter(oWP, nLevel);
	} else if (nSpawnType == 2) {
		SpawnHarmoniumScout(oWP, nLevel);
	} else if (nSpawnType == 3) {
		SpawnTreasureChest(oWP, nLevel);
	} else {
		SpawnHarmoniumEncounter(oWP, nLevel);
	}
	
}

void SpawnTreasureChest(object oWP, int nLevel) {

	string toGen = "ps_genspawnchest_10";
	if (nLevel > 20) {
		toGen = "ps_genspawnchest_11";
	}
	
	object oChest;
	if (!GetIsObjectValid(GetNearestObjectByTag("chest_"+GetTag(OBJECT_SELF)))) {
		oChest = CreateObject(OBJECT_TYPE_PLACEABLE, toGen, GetLocation(oWP), FALSE, "chest_"+GetTag(OBJECT_SELF));
	}
}

void SpawnCommonerEncounter(object oWP, int nLevel, object oPC = OBJECT_INVALID) {

	WriteTimestampedLogEntry("Creating commoner campaign encounter in "+GetTag(GetArea(oWP)));
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "creating encounter");
	}
	
	object oCommoner = CreateObject(OBJECT_TYPE_CREATURE, "de_commoner_1", GetLocation(oWP));
	
	int nGender = Random(2);
	int nHead = Random(7);
	int nHair = Random(26);
	
	struct CreatureCoreAppearance currentAppearance = PS_GetCreatureCoreAppearance(oCommoner);
	currentAppearance.Gender = nGender;
	currentAppearance.HeadVariation = nHead;
	currentAppearance.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oCommoner, currentAppearance);
	
	assignProtectiveItems(oCommoner, FALSE);
	makeInventoryUndroppable(oCommoner);
	
	SetFirstName(oCommoner, "Hiver");
	SetLastName(oCommoner, "");
	SetDescription(oCommoner, "This looks like a Cager of lower middle class status; better than you'd normally expect in the Hive. They're a bit furtive as they go about their daily business, however.");
	DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(100), oCommoner));
	
}

void SpawnHarmoniumScout(object oWP, int nLevel, object oPC = OBJECT_INVALID) {

	WriteTimestampedLogEntry("Creating harmonium campaign encounter in "+GetTag(GetArea(oWP)));

	int nClass = CLASS_TYPE_RANGER;
	int nClassRoll = Random(5)+1;
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "creating encounter");
	}
	
	//Switch between class types
	switch(nClassRoll) {
		case 1: nClass = CLASS_TYPE_RANGER; break;
		case 2: nClass = CLASS_TYPE_ARCANE_ARCHER; break;
		case 3: nClass = CLASS_TYPE_ROGUE; break; 
		case 4: nClass = CLASS_TYPE_FIGHTER; break;
		case 5: nClass = CLASS_TYPE_WARLOCK; break;
	}
	
	object oBerk = CreateScaledCreatureofClass(oWP, nLevel, nClass, STANDARD_FACTION_HOSTILE);
	if (!GetIsObjectValid(oBerk)) {
		return;
	}
	
	SetFirstName(oBerk, "Harmonium Scout");
	SetLastName(oBerk, "");
	SetDescription(oBerk, "The red armor marks this scout as Harmonium. . . but they definitely aren't wearing the current Harmonium uniform that you know.");
	
	if (nClass == CLASS_TYPE_FIGHTER)
		SetLocalInt(oBerk, "CAMPAIGN_HARMONIUM", 1);
	else
		SetLocalInt(oBerk, "CAMPAIGN_HARMONIUM_SCOUT", 1); //have this give them the correct armor/weapon once we have it
	
	//Have to have the right alignment!
	AdjustAlignment(oBerk, ALIGNMENT_EVIL, 100);
	AdjustAlignment(oBerk, ALIGNMENT_LAWFUL, 100);
	
	assignProtectiveItems(oBerk, TRUE);
	assignWeaponToCreature(oBerk, TRUE);
	makeInventoryUndroppable(oBerk);
	
	DelayCommand(0.2f, AssignCommand(oBerk, ActionEquipMostEffectiveArmor()));
	if (nClass == CLASS_TYPE_ARCANE_ARCHER || nClass == CLASS_TYPE_ROGUE)
		DelayCommand(0.6f, AssignCommand(oBerk, ActionEquipMostDamagingRanged()));
	else
		DelayCommand(0.6f, AssignCommand(oBerk, ActionEquipMostDamagingMelee()));
	
	DelayCommand(1.0f, SetTag(oBerk, "dark_harmonium_scout"));
	
	DelayCommand(2.0, ExecuteScript("nw_c2_default9", oBerk));
}

void SpawnHarmoniumEncounter(object oWP, int nLevel, object oPC = OBJECT_INVALID) {

	WriteTimestampedLogEntry("Creating harmonium campaign encounter in "+GetTag(GetArea(oWP)));

	int nClass = CLASS_TYPE_FIGHTER;
	int nClassRoll = Random(3)+1;
	
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "creating encounter");
	}
	
	//Switch between class types
	switch(nClassRoll) {
		case 1: nClass = CLASS_TYPE_FIGHTER; break;
		case 2: nClass = CLASS_TYPE_FIGHTER; break;
		case 3: nClass = CLASS_TYPE_CLERIC; break; 
	}
	
	object oBerk = CreateScaledCreatureofClass(oWP, nLevel, nClass, STANDARD_FACTION_HOSTILE);
	if (!GetIsObjectValid(oBerk)) {
		return;
	}
	
	SetFirstName(oBerk, "Harmonium Patroller");
	SetLastName(oBerk, "");
	SetDescription(oBerk, "The red armor marks this patrol as Harmonium. . . but they definitely aren't wearing the current Harmonium uniform that you know.");
	SetLocalInt(oBerk, "CAMPAIGN_HARMONIUM", 1); //have this give them the correct armor/weapon once we have it
	
	//Have to have the right alignment!
	AdjustAlignment(oBerk, ALIGNMENT_EVIL, 100);
	AdjustAlignment(oBerk, ALIGNMENT_LAWFUL, 100);
	
	assignProtectiveItems(oBerk, TRUE);
	assignWeaponToCreature(oBerk, TRUE);
	makeInventoryUndroppable(oBerk);
	
	DelayCommand(0.2f, AssignCommand(oBerk, ActionEquipMostEffectiveArmor()));
	DelayCommand(0.6f, AssignCommand(oBerk, ActionEquipMostDamagingMelee()));
	
	DelayCommand(1.0f, SetTag(oBerk, "dark_harmonium_patrol"));
	
	DelayCommand(2.0, ExecuteScript("nw_c2_default9", oBerk));

}