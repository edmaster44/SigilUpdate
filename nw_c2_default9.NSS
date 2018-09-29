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
#include "ps_random_item_spawn"
#include "ps_inc_cards"
#include "nw_o2_coninclude"
#include "ps_inc_gemstones"

void SpecialDrop(string sAREA, object oSPAWN)
{
	string sSPECIAL;
	if(TestStringAgainstPattern("**abyss**", sAREA))
	{
		switch (Random(4))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_pd"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_bi"; break;
			case 2: sSPECIAL = "ps_crft_demonscale"; break;
			case 3: sSPECIAL = "ps_crft_plk_tb"; break;
		}
	}
	else if(TestStringAgainstPattern("**beastland**", sAREA))
	{
		switch (Random(7))
		{
			case 0: sSPECIAL = "ps_crft_dragonhide_blk"; break;
			case 1: sSPECIAL = "ps_crft_dragonhide_blu"; break;
			case 2: sSPECIAL = "ps_crft_plk_db"; break;
			case 3: sSPECIAL = "ps_crft_drgsnw"; break;
			case 4: sSPECIAL = "ps_crft_dragonhide_grn"; break;
			case 5: sSPECIAL = "ps_crft_dragonhide_red"; break;
			case 6: sSPECIAL = "ps_crft_dragonhide_wht"; break;
		}	
	}
	else if(TestStringAgainstPattern("**plateau**", sAREA))
	{
		switch (Random(7))
		{
			case 0: sSPECIAL = "ps_crft_dragonhide_blk"; break;
			case 1: sSPECIAL = "ps_crft_dragonhide_blu"; break;
			case 2: sSPECIAL = "ps_crft_plk_db"; break;
			case 3: sSPECIAL = "ps_crft_drgsnw"; break;
			case 4: sSPECIAL = "ps_crft_dragonhide_grn"; break;
			case 5: sSPECIAL = "ps_crft_dragonhide_red"; break;
			case 6: sSPECIAL = "ps_crft_dragonhide_wht"; break;
		}	
	}
	else if(TestStringAgainstPattern("**carceri**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_mi"; break;
			case 1: sSPECIAL = "ps_crft_ing_au"; break;
		}	
	}
	else if(TestStringAgainstPattern("**demiplane**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_crft_formamb"; break;
			case 1: sSPECIAL = "ps_crft_reggear"; break;			
		}	
	}
	else if(TestStringAgainstPattern("**astral**", sAREA))
	{
		sSPECIAL = "ps_crft_ing_ms";
	}
	else if(TestStringAgainstPattern("**eearth**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_bg"; break;
			case 1: sSPECIAL = "ps_crft_ing_gs"; break;
			case 2: sSPECIAL = "ps_crft_ing_rv"; break;
		}	
	}
	else if(TestStringAgainstPattern("**epicgraywaste**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_mi"; break;
			case 1: sSPECIAL = "ps_crft_plk_ao"; break;
		}	
	}
	else if(TestStringAgainstPattern("**Niflheim**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_mi"; break;
			case 1: sSPECIAL = "ps_crft_plk_ao"; break;
		}	
	}
	else if(TestStringAgainstPattern("**graywaste**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_by"; break;
			case 1: sSPECIAL = "ps_crft_ing_ap"; break;
		}	
	}
	else if(TestStringAgainstPattern("**ice-**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_crft_ing_rv"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_bg"; break;
		}	
	}
	else if(TestStringAgainstPattern("**mercuria**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_st"; break;
			case 1: sSPECIAL = "ps_crft_celestplume"; break;
		}	
	}
	else if(TestStringAgainstPattern("**minauros**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_gm"; break;
			case 1: sSPECIAL = "ps_crft_devilscale"; break;
			case 2: sSPECIAL = "ps_cfrt_ing_tt"; break;
		}
	}
	else if(TestStringAgainstPattern("**ruins**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_by"; break;
			case 1: sSPECIAL = "ps_crft_ophidian"; break;
			case 2: sSPECIAL = "ps_crft_neufly"; break;
		}
	}
	else if(TestStringAgainstPattern("**maldom**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_tt"; break;
			case 1: sSPECIAL = "ps_crft_ing_ap"; break;
		}	
	}
	else if(TestStringAgainstPattern("**clangor**", sAREA))
	{
		switch (Random(3))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_ab"; break;
			case 1: sSPECIAL = "ps_crft_ing_ob"; break;
			case 2: sSPECIAL = "ps_crft_ing_gs"; break;
		}
	}
	else if(TestStringAgainstPattern("**fire**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_crft_ophidian"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_ml"; break;
		}
	}
	else if(TestStringAgainstPattern("**eearth**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_crft_ing_ob"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_ml"; break;
		}
	}
	else if(TestStringAgainstPattern("**limbo**", sAREA))
	{
		switch (Random(2))
		{
			case 0: sSPECIAL = "ps_cfrt_ing_pd"; break;
			case 1: sSPECIAL = "ps_cfrt_ing_ml"; break;
		}
	}
	else return;	
	dbCreateItemOnObject(sSPECIAL, oSPAWN);
}

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
	int nOTHER = FALSE;
	switch (nRACE)
	{
		case RACIAL_TYPE_ANIMAL:
		case RACIAL_TYPE_BEAST:
		case RACIAL_TYPE_CONSTRUCT:
		case RACIAL_TYPE_ELEMENTAL:
		case RACIAL_TYPE_VERMIN:
		nNODROP = TRUE;
		nOTHER = TRUE;
	}
	
	if (nNODROP == FALSE)
	{
		if (Random(2000) < 10) SpecialDrop(GetTag(GetArea(oSPAWN)), oSPAWN); /* remove again later, or redo chance */
		if (Random(2000) < 10) CreateRandomDropItem(oSPAWN);
		if (Random(2000) < 10) CardsCreateCardOnSpawnOrChest(oSPAWN);
		float fCHALLENGE = GetChallengeRating(oSPAWN);
		int nLOOT = 1; //TREASURE_TYPE_LOW
		if (fCHALLENGE >= 20.0) nLOOT = 3; //TREASURE_TYPE_HIGH
		else if (fCHALLENGE >= 10.0) nLOOT = 2; //TREASURE_TYPE_MED
		if (Random(2000) < 400) GenerateTreasure(nLOOT, oSPAWN, oSPAWN);
		
		if (fCHALLENGE > 25.0) nLOOT = 4; //TREASURE_TYPE_EPIC (only used for gems right now)
		if (Random(1000) < 10) CreateRandomGemstoneOnSpawnOrChest(oSPAWN, nLOOT);
	}
	else if (nOTHER == TRUE)
	{
		//This can be eventually used for a separate loot table for animals, beasts, constructs, elementals and vermins.
	}

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