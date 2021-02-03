// NW_C2_DEFAULT9
/*
    Default OnSpawn handler
    To create customized spawn scripts, use the "Custom OnSpawn" script template.
*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/11/2002
//:://////////////////////////////////////////////////
//:: Updated 2003-08-20 Georg Zoeller: Added check for variables to active spawn in conditions without changing the spawnscript
// ChazM 6/20/05 ambient anims flag set on spawn for encounter cratures.
// ChazM 1/6/06 modified call to WalkWayPoints()
// DBR 2/03/06  Added option for a spawn script (AI stuff, but also handy in general)
// ChazM 8/22/06 Removed reference to "kinc_globals".
// ChazM 3/8/07 Added campaign level creature spawn modifications script.  Moved excess commented code out to template.
// ChazM 4/5/07 Incorporeal creatures immune to non magic weapons

#include "x0_i0_anims"
#include "x2_inc_switches"
#include "ps_monstersrbugfix"
#include "ps_inc_treasuregeneration"

void main()
{
    // Run this campaign's standard creature spawn modifications script (set in module load)
	object oSPAWN = OBJECT_SELF;
	object oINVALID = OBJECT_INVALID;
    string sScriptSpawnCreature = GetGlobalString("N2_SCRIPT_SPAWN_CREATURE");
    if (sScriptSpawnCreature != "")	ExecuteScript(sScriptSpawnCreature, oSPAWN);
	
	// ***** Spawn-In Conditions ***** //
    // See x2_inc_switches for more information about these
	string sFLAG;
	int nFLAG;
	int nCOUNT = 1;
	while (nCOUNT <= 4)
	{
		switch (nCOUNT)
		{
			case 1: // Enable stealth mode by setting a variable on the creature. Great for ambushes
					sFLAG = CREATURE_VAR_USE_SPAWN_STEALTH; nFLAG = NW_FLAG_STEALTH; break;
			case 2: // Make creature enter search mode after spawning by setting a variable. Great for guards, etc
					sFLAG = CREATURE_VAR_USE_SPAWN_SEARCH; nFLAG = NW_FLAG_SEARCH; break;
			case 3: // Enable immobile ambient animations by setting a variable
					sFLAG = CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE; nFLAG = NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS; break;
			case 4: // Enable mobile ambient animations by setting a variable
					sFLAG = CREATURE_VAR_USE_SPAWN_AMBIENT; nFLAG = NW_FLAG_AMBIENT_ANIMATIONS; break;
		}
		if (GetCreatureFlag(oSPAWN, sFLAG) == TRUE) SetSpawnInCondition(nFLAG);
		nCOUNT = nCOUNT + 1;
	}
	
    // ***** DEFAULT GENERIC BEHAVIOR ***** //
    // * Goes through and sets up which shouts the NPC will listen to.
    SetListeningPatterns();

    // * Walk among a set of waypoints if they exist.
    // * 1. Find waypoints with the tag "WP_" + NPC TAG + "_##" and walk
    // *    among them in order.
    // * 2. If the tag of the Way Point is "POST_" + NPC TAG, stay there
    // *    and return to it after combat.
    //
    // * If "NW_FLAG_DAY_NIGHT_POSTING" is set, you can also
    // * create waypoints with the tags "WN_" + NPC Tag + "_##"
    // * and those will be walked at night. (The standard waypoints
    // * will be walked during the day.)
    // * The night "posting" waypoint tag is simply "NIGHT_" + NPC tag.
    WalkWayPoints(FALSE, "spawn");
    
	/* Create weapon for creatures that need one
	if(GetLocalInt(oSPAWN, "WEAPON_SPAWN") > 0)
	{
		CTG_GetSpecificBaseTypeTreasureItem(oSPAWN,TREASURE_BASE_TYPE_WEAPON_NOAMMO, 
	}*/

	//creature items: doesn't work since droppable on one item means all items droppable
	object oITEM = GetFirstItemInInventory(oSPAWN);
	while(oITEM != oINVALID)
	{
		if(GetBaseItemType(oITEM) == BASE_ITEM_CRAFTMATERIALMED && !GetDroppableFlag(oITEM) && d100() > 70)
		{
			SetDroppableFlag(oITEM, TRUE);
		}
		oITEM = GetNextItemInInventory(oSPAWN);
	}
	
	// Create a small amount of treasure on the creature
	int nNODROP = GetLocalInt(GetModule(), "X2_L_NOTREASURE");
	nNODROP = GetLocalInt(oSPAWN, "X2_L_NOTREASURE");
	
	int nRACE = GetRacialType(oSPAWN);
	switch (nRACE)
	{
		case RACIAL_TYPE_ANIMAL:
		case RACIAL_TYPE_BEAST:
		case RACIAL_TYPE_CONSTRUCT:
		case RACIAL_TYPE_ELEMENTAL:
		case RACIAL_TYPE_VERMIN:
		nNODROP = TRUE;
	}
	
	//Not all creatures are eligible to drop loot!
	//But if they are. . . 
	if (nNODROP == FALSE) {
	
		float fChallenge = GetChallengeRating(oSPAWN);
		int nLOOT = 0;
		int nLOOTCHANCE = 20;
		if (fChallenge < 10.0f) {
			nLOOT = 1;  //TREASURE_TYPE_LOW
		} else if (fChallenge < 20.0f) {
			nLOOT = 2; //TREASURE_TYPE_MEDIUM
		} else if (fChallenge <= 25.0f) {
			nLOOT = 3;  //TREASURE_TYPE_HIGH
		} else {
			nLOOT = 4;  //TREASURE_TYPE_EPIC
		}
		
		//1% to spawn special material depending on area
		if (Random(1000) < 10) SpecialDrop(GetTag(GetArea(oSPAWN)), oSPAWN); 
		
		//Generate general loot!
		if (d100() <= nLOOTCHANCE){
			GenerateTreasureItemOnTarget(oSPAWN, nLOOT);
		}
	}
	
	//Creature specific drop
	//depends on two variables set on the creature: 
	//creature_drop = item resref
	//creature_drop_chance = drop chance
	CreateCreatureDrop(OBJECT_SELF);

	// Encounter creatures use ambient animations
	if (GetIsEncounterCreature()) SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS, TRUE);

	// If Incorporeal, apply changes
	if (GetCreatureFlag(oSPAWN, CREATURE_VAR_IS_INCORPOREAL) == TRUE)
	{
		effect eGHOST = EffectConcealment(50);
		eGHOST = EffectLinkEffects(eGHOST, EffectDamageReduction(1000, DAMAGE_POWER_PLUS_ONE));
		eGHOST = EffectLinkEffects(eGHOST, EffectCutsceneGhost());
		eGHOST = SupernaturalEffect(eGHOST);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGHOST, oSPAWN);
	}
    
	//SR fix
	DelayCommand(0.0f, ApplySRFix(oSPAWN));
	
	//DBR 2/03/06 - added option for a spawn script (ease of AI hookup)
	string sSpawnScript=GetLocalString(oSPAWN, "SpawnScript");
	if (sSpawnScript!="") ExecuteScript(sSpawnScript, oSPAWN);
}

void OldLoot() {
		//Old Loot Code
		/*if (Random(2000) < 10) SpecialDrop(GetTag(GetArea(oSPAWN)), oSPAWN); 
		if (Random(2000) < 10) CreateRandomDropItem(oSPAWN);
		if (Random(2000) < 10) CardsCreateCardOnSpawnOrChest(oSPAWN);
		float fCHALLENGE = GetChallengeRating(oSPAWN);
		int nLOOT = 1; //TREASURE_TYPE_LOW
		if (fCHALLENGE >= 20.0) nLOOT = 3; //TREASURE_TYPE_HIGH
		else if (fCHALLENGE >= 10.0) nLOOT = 2; //TREASURE_TYPE_MED
		if (Random(2000) < 400) GenerateTreasure(nLOOT, oSPAWN, oSPAWN);
		
		if (fCHALLENGE > 25.0) nLOOT = 4; //TREASURE_TYPE_EPIC (only used for gems right now)
		if (Random(1000) < 10) CreateRandomGemstoneOnSpawnOrChest(oSPAWN, nLOOT);*/
}