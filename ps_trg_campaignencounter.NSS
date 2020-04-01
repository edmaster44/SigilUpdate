//Uses the Dynamic Encounter system to create an encounter of the 
//correct CR for the entering PC
//Currently being used for campaign things; expand more later
#include "ps_inc_dynamicencounters"
#include "ps_inc_functions"
#include "x0_i0_anims"

void SpawnHarmoniumEncounter(object oWP, int nLevel, object oPC = OBJECT_INVALID);

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
	
	int nNum = d2();
	int nCount = 0;
	while (nCount < nNum) {
		SpawnHarmoniumEncounter(oWP, nLevel);
		nCount++;
	}
	
}

void SpawnHarmoniumEncounter(object oWP, int nLevel, object oPC = OBJECT_INVALID) {

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