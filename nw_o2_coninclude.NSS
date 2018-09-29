//::///////////////////////////////////////////////
//:: NW_O2_CONINCLUDE.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  This include file handles the random treasure
  distribution for treasure from creatures and containers
 [ ] Documented
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent, Andrew
//:: Created On:  November - May
//:: Modified for Sigil: City of Doors.
//:: Last modifications by Clangeddin (2017)
//:://////////////////////////////////////////////

#include "ginc_debug"

// * ---------
// * CONSTANTS
// * ---------

// * SIX LEVEL RANGES
const int RANGE_1_MIN = 0;
const int RANGE_1_MAX = 5;

const int RANGE_2_MIN = 6;
const int RANGE_2_MAX = 8;

const int RANGE_3_MIN = 9;
const int RANGE_3_MAX = 10;

const int RANGE_4_MIN = 11;
const int RANGE_4_MAX = 13;

const int RANGE_5_MIN = 14;
const int RANGE_5_MAX = 16;

const int RANGE_6_MIN = 17;
const int RANGE_6_MAX = 100;
	
// * NUMBER OF ITEMS APPEARING
// if there is a treasure drop, this is the likelihood of multiple drops, based on Treasure Type.
const int NUMBER_LOW_ONE   = 90;  const int NUMBER_MED_ONE    = 60; const int NUMBER_HIGH_ONE   = 40;  const int NUMBER_BOSS_ONE = 100;
const int NUMBER_LOW_TWO   = 9;   const int NUMBER_MED_TWO    = 30; const int NUMBER_HIGH_TWO   = 40;  const int NUMBER_BOSS_TWO = 0;
const int NUMBER_LOW_THREE = 1;   const int NUMBER_MED_THREE  = 10; const int NUMBER_HIGH_THREE = 20;  const int NUMBER_BOSS_THREE = 0;

const int NUMBER_BOOK_ONE = 75;
const int NUMBER_BOOK_TWO = 20;
const int NUMBER_BOOK_THREE = 5;

// * AMOUNT OF GOLD BY VALUE
// the relative amount for each gold drop.  The base amount is scaled by level (of the creature for creature treasure).
const float LOW_MOD_GOLD = 0.5;   const float MEDIUM_MOD_GOLD = 1.0; const float HIGH_MOD_GOLD = 3.0;
	
// * FREQUENCY OF ITEM TYPE APPEARING BY TREASURE TYPE
    // * FREQUENCY OF ITEM TYPE APPEARING BY TREASURE TYPE
    const int LOW_PROB_BOOK    	= 5;  	const int MEDIUM_PROB_BOOK 		= 4;	const int HIGH_PROB_BOOK 	= 3;
    const int LOW_PROB_ANIMAL  	= 0;  	const int MEDIUM_PROB_ANIMAL 	= 0;  	const int HIGH_PROB_ANIMAL 	= 0;
    const int LOW_PROB_JUNK    	= 2;  	const int MEDIUM_PROB_JUNK 		= 1;  	const int HIGH_PROB_JUNK 	= 1;
    const int LOW_PROB_GOLD 	= 0;   const int MEDIUM_PROB_GOLD 		= 0; 	const int HIGH_PROB_GOLD 	= 0;
    const int LOW_PROB_GEM  	= 10;    const int MEDIUM_PROB_GEM 		= 20; 	const int HIGH_PROB_GEM 	= 18;
    const int LOW_PROB_JEWEL 	= 3;    const int MEDIUM_PROB_JEWEL 	= 0; 	const int HIGH_PROB_JEWEL 	= 0;
    const int LOW_PROB_ARCANE 	= 20;   	const int MEDIUM_PROB_ARCANE 	= 22; 	const int HIGH_PROB_ARCANE 	= 26;
    //CoD: lumping all scrolls into arcane
	const int LOW_PROB_DIVINE 	= 0;   	const int MEDIUM_PROB_DIVINE 	= 0;  	const int HIGH_PROB_DIVINE 	= 0;
    const int LOW_PROB_AMMO 	= 10;   const int MEDIUM_PROB_AMMO 		= 8;  	const int HIGH_PROB_AMMO  	= 7;
    const int LOW_PROB_KIT 		= 8;    const int MEDIUM_PROB_KIT 		= 6;  	const int HIGH_PROB_KIT   	= 4;
    const int LOW_PROB_POTION 	= 35;   const int MEDIUM_PROB_POTION 	= 30; 	const int HIGH_PROB_POTION	= 30;
    const int LOW_PROB_TABLE2 	= 7;   	const int MEDIUM_PROB_TABLE2 	= 9; 	const int HIGH_PROB_TABLE2	= 11;

// * readability constants
const int    TREASURE_LOW = 1;
const int    TREASURE_MEDIUM = 2;
const int    TREASURE_HIGH = 3;
const int    TREASURE_BOSS = 4;
const int    TREASURE_BOOK = 5;

// * JUMP_LEVEL is used in a Specific item function
// * in the case where a generic item is called for within that function
// * it will create a generic item by adding JUMP_LEVEL to the character's
// * hit die for the purposes of the treasure evaluation.
// * May 2002: Lowered JUMP_LEVEL from 3 to 2

const int JUMP_LEVEL = 2;

// BDF - OEI: 7/6/06
// Bioware's hard-coded systems do not allow for easy migration to NWN2 due to an excess of hard-coded data values
// integrated with their logic.  Below are various constants that define certain quantities that are
// valid in NWN2, but not necessarily NWN1.
const int NWN2_MAX_NUM_ITEMS_BOOKS = 32;

//SCOD drop probabilities:
const int SCOD_WEAPONS = 33;
const int SCOD_ARMORS = 23;
const int SCOD_BOOTS = 4;
const int SCOD_CLOAKS = 6;
const int SCOD_BRACERS = 6;
const int SCOD_BELTS = 5;
const int SCOD_HATS = 5;
const int SCOD_SHIELDS = 5;
const int SCOD_JEWELRY = 7;
const int SCOD_MISC = 6;


///////////////////////////////////////
//* Declarations
///////////////////////////////////////

void CreateBook(object oTarget);
void CreateNWN1Book(object oTarget);
void CreateRecipeBook(object oTarget);


void CreateGenericExotic(object oTarget, object oAdventurer, int nModifier = 0);
void CreateGenericMonkWeapon(object oTarget, object oAdventurer, int nModifier = 0);
void CreateSpecificMonkWeapon(object oTarget, object oAdventurer, int nModifier = 0);
void CreateGenericDruidWeapon(object oTarget, object oAdventurer, int nModifier = 0);
void CreateSpecificDruidWeapon(object oTarget, object oAdventurer, int nModifier = 0);
void CreateGenericWizardWeapon(object oTarget, object oAdventurer, int nModifier = 0);
void CreateSpecificWizardWeapon(object oTarget, object oAdventurer, int nModifier = 0);
int nDetermineClassToUse(object oCharacter);


///////////////////////////////////////
// * IMPLEMENTATION
///////////////////////////////////////

// * Comment the speakstring in to debug treasure generation
void dbSpeak(string s)
{
//   SpeakString(s);
}

//* made this function to help with debugging
void dbCreateItemOnObject(string sItemTemplate, object oTarget = OBJECT_SELF, int nStackSize = 1)
{
/*
    if (sItemTemplate == "")
    {
        PrintString("blank item passed into dbCreateItemOnObject. Please report as bug to Brent.");
    }
    dbSpeak(sItemTemplate);
*/

    //sItemTemplate = GetStringLowerCase

    if (nStackSize == 1)
    {
        // * checks to see if this is a throwing item and if it is
        // * it creates more

        string sRoot = GetSubString(sItemTemplate, 0, 6);
        //dbSpeak("ROOT: " + sRoot);
        if (GetStringLowerCase(sRoot) == "nw_wth")
        {
            nStackSize = Random(30) + 1;
        }
    }
    object oItem = CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
	PrintString ("Created " + IntToString(nStackSize) + " of " + sItemTemplate + " on " + GetName(oTarget));
    if (GetIsObjectValid(oItem) == FALSE && sItemTemplate != "NW_IT_GOLD001")
    {

        // * check to see if item is there in a stack, if not give warning
        if (GetIsObjectValid(GetItemPossessedBy(oTarget, GetStringUpperCase(sItemTemplate))) == FALSE &&
            GetIsObjectValid(GetItemPossessedBy(oTarget, GetStringLowerCase(sItemTemplate))) == FALSE)
        {
			string sErrorOutput = "nw_o2_coninclude: ******" + sItemTemplate + " is an invalid item template. Please report as bug. [Note that this is not reproducible as this item was randomly chosen]";
            
			PrintString("**DESIGN***");
            PrintString( sErrorOutput );
            PrintString("*******");
			
			PrettyError( sErrorOutput );
        }
    }

}


// *
// * GET FUNCTIONS
// *

// * Returns the object that either last opened the container or destroyed it
object GetLastOpener()
{
    if (GetIsObjectValid(GetLastOpenedBy()) == TRUE)
    {
        //dbSpeak("LastOpener: GetLastOpenedBy " + GetTag(GetLastOpenedBy()));
        return GetLastOpenedBy();
    }
    else
    if (GetIsObjectValid(GetLastKiller()) == TRUE)
    {
        //dbSpeak("LastOpener: GetLastAttacker");
        return GetLastKiller();
    }
    //dbSpeak("LastOpener: The Object is Invalid you weenie!");
    return OBJECT_INVALID;
}

//::///////////////////////////////////////////////
//:: GetRange
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if nHD matches the correct
    level range for the indicated nCategory.
    (i.e., First to Fourth level characters
    are considered Range1)
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int GetRange(int nCategory, int nHD)
{
    int nMin = 0; int nMax = 0;
    switch (nCategory)
    {
        case 6: nMin = RANGE_6_MIN; nMax = RANGE_6_MAX; break;
        case 5: nMin = RANGE_5_MIN; nMax = RANGE_5_MAX; break;
        case 4: nMin = RANGE_4_MIN; nMax = RANGE_4_MAX; break;
        case 3: nMin = RANGE_3_MIN; nMax = RANGE_3_MAX; break;
        case 2: nMin = RANGE_2_MIN; nMax = RANGE_2_MAX; break;
        case 1: nMin = RANGE_1_MIN; nMax = RANGE_1_MAX; break;
    }

   //dbSpeak("nMin = " + IntToString(nMin));
   //dbSpeak("nMax = " + IntToString(nMax));
   //dbSpeak("GetRange.nHD = " + IntToString(nHD));
   if (nHD >= nMin && nHD <= nMax)
   {
    return TRUE;
   }

  return FALSE;

}

//::///////////////////////////////////////////////
//:: GetNumberOfItems
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the number of items to create.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////
int GetNumberOfItems(int nTreasureType)
{
    int nItems = 0;
    int nRandom = 0;

    int nProbThreeItems = 0;
    int nProbTwoItems = 0;
    int nProbOneItems = 0;

    if (nTreasureType == TREASURE_LOW)
    {
     nProbThreeItems = NUMBER_LOW_THREE;
     nProbTwoItems = NUMBER_LOW_TWO;
     nProbOneItems = NUMBER_LOW_ONE;
    }
    else
    if (nTreasureType == TREASURE_MEDIUM)
    {
     nProbThreeItems = NUMBER_MED_THREE;
     nProbTwoItems = NUMBER_MED_TWO;
     nProbOneItems = NUMBER_MED_ONE;
    }
    else
    if (nTreasureType == TREASURE_HIGH)
    {
     nProbThreeItems = NUMBER_HIGH_THREE;
     nProbTwoItems = NUMBER_HIGH_TWO;
     nProbOneItems = NUMBER_HIGH_ONE;
    }
    else
    if (nTreasureType == TREASURE_BOSS)
    {
     nProbThreeItems = NUMBER_BOSS_THREE;
     nProbTwoItems = NUMBER_BOSS_TWO;
     nProbOneItems = NUMBER_BOSS_ONE;
    }
    else
    if (nTreasureType == TREASURE_BOOK)
    {
     nProbThreeItems = NUMBER_BOOK_THREE;
     nProbTwoItems = NUMBER_BOOK_TWO;
     nProbOneItems = NUMBER_BOOK_ONE;
    }


    nRandom = d100();
    if (nRandom <= nProbThreeItems)
    {
        nItems = 3;
    }
    else
    if (nRandom <= nProbTwoItems + nProbThreeItems)
    {
        nItems = 2;
    }
    else
    {
        nItems = 1;
    }

    // * May 13 2002: Cap number of items, in case of logic error
    if (nItems > 3)
    {
        nItems = 3;
    }

    return nItems;
}


// *
// * TREASURE GENERATION FUNCTIONS
// *
    // *
    // * Non-Scaling Treasure
    // *
    void CreateBook(object oTarget)
    {	
		/* CoD: replacing with custom books
		int iBookRoll = Random(10) + 1;
		
		if (iBookRoll <= 7)
		{
			CreateRecipeBook(oTarget);
		}
		else
		{
			CreateNWN1Book(oTarget);
		}
		*/
		
		int iBook = Random(93) + 1;
        string sRes = "ps_lorebook_";

        if (iBook < 10)
        {
            sRes += "00";
        }
		else if (iBook < 100)
		{
			sRes += "0";
		}
		
        sRes += IntToString(iBook);
		
        //dbSpeak("Create book");
		dbCreateItemOnObject(sRes, oTarget);
    }

    void CreateNWN1Book(object oTarget)
    {
        //int nBook1 = Random(31) + 1;	// totally awesome magic numbers, guys!;
        int nBook1 = Random( NWN2_MAX_NUM_ITEMS_BOOKS ) + 1;
        string sRes = "NW_IT_BOOK0";

        if (nBook1 < 10)
        {
            sRes = sRes + "0" + IntToString(nBook1);
        }
        else
        {
            sRes = sRes + IntToString(nBook1);
        }
        //dbSpeak("Create book");
		dbCreateItemOnObject(sRes, oTarget);
    }
	
    void CreateRecipeBook(object oTarget)
    {
        int iBook = Random(27) + 1;
		// highest book is 29, but 22 and 26 are skipped
		if (iBook>=22) iBook++;
		if (iBook>=26) iBook++;
			
        string sRes = "n2_crft_book_recipe0";

        if (iBook < 10)
        {
            sRes += "0";
        }
        sRes += IntToString(iBook);
		
        //dbSpeak("Create book");
		dbCreateItemOnObject(sRes, oTarget);
    }

    void CreateAnimalPart(object oTarget)
    {

        string sRes = "";
        int nResult = Random(1) + 1;
        switch (nResult)
        {
            // case 1: sRes = "NW_IT_MSMLMISC20"; break;
            // case 2: sRes = "NW_IT_MMIDMISC05"; break;
            case 1: sRes = "NW_IT_MMIDMISC06"; break;
        }
        //dbSpeak("animal");
        dbCreateItemOnObject(sRes, oTarget);
    }

	string rune()
	{
		int nRandom = Random(96) + 1;
		string sItem = "ps_rune_";
		
		if (nRandom < 10)
		{
			sItem += "0";
		}
		
		sItem += IntToString(nRandom);	
		
		return sItem;	
	}
	
	string valmisc()
	{
		int nRandom = Random(22) + 1;
		string sItem = "";
        switch (nRandom)
		{
			case 1: sItem="ps_valmisc_enigmabottle"; break;
			case 2: sItem="ps_valmisc_gnomishminestock"; break;
			case 3: sItem="ps_valmisc_spirithawkfeather"; break;
			case 4: sItem="ps_valmisc_kutunuoleaves"; break;
			case 5: sItem="ps_valmisc_hellfirepowder"; break;
			case 6: sItem="ps_valmisc_goldtrophy"; break;
			case 7: sItem="ps_valmisc_mithrilscepter"; break;
			case 8: sItem="ps_valmisc_smallmirror"; break;	
			case 9: sItem="ps_valmisc_armoroil"; break;	
			case 10: sItem="ps_valmisc_bagofwind"; break;				
			case 11: sItem="ps_valmisc_beginnersalembic"; break;				
			case 12: sItem="ps_valmisc_beginnersdecensor"; break;				
			case 13: sItem="ps_valmisc_beginnersretort"; break;				
			case 14: sItem="ps_valmisc_bottledpest"; break;				
			case 15: sItem="ps_valmisc_disrupt"; break;				
			case 16: sItem="ps_valmisc_glyph"; break;				
			case 17: sItem="ps_valmisc_healingmushrooms"; break;				
			case 18: sItem="ps_valmisc_oilweapon"; break;				
			case 19: sItem="ps_valmisc_sandblindness"; break;				
			case 20: sItem="ps_valmisc_skeletonkey"; break;				
			case 21: sItem="ps_valmisc_webcannister"; break;				
			case 22: sItem="ps_valmisc_embalming"; break;				
		}		
		return sItem;		
	}		
	
    void CreateJunk(object oTarget)
    {
        string sRes = "NW_IT_TORCH001";
        int NUM_ITEMS = 17;
        int nResult = Random(NUM_ITEMS) + 1;
        int nKit = 0;
        switch (nResult)
        {
            case 1: sRes = "NW_IT_MPOTION021"; break; //ale
            case 2: sRes = rune(); break;   // ale
            case 3: sRes = "NW_IT_MPOTION023"; break; // wine
            case 4: sRes = valmisc(); break; // ale
            case 5: sRes = "NW_IT_MPOTION022"; break; // spirits
            case 6: sRes = "NW_IT_TORCH001"; break; //torch
			case 7: sRes = "nw_it_mring021";  break;
			case 8: sRes = "nw_it_mneck020";  break;
			case 9: sRes = "nw_it_mring022";  break;
			case 10: sRes = "nw_it_mneck023";  break;
			case 11: sRes = "nw_it_mneck021";  break;
			case 12: sRes = "nw_it_mring023";  break;
			case 13: sRes = "ps_painting_ladyofpain"; break;
			case 14: sRes = "ps_painting_liquidmoon"; break; 
			case 15: sRes = "ps_painting_multiverse"; break; 
			case 16: sRes = "ps_painting_solitude"; break; 
			case 17: sRes = "ps_painting_whirlpool"; break;
        }
		
        dbCreateItemOnObject(sRes, oTarget);
    }
	
    // * Scaling Treasure
    void CreateGold(object oTarget, object oAdventurer, int nTreasureType, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        int nAmount = 0;

        if (GetRange(1, nHD)) nAmount = d12(2);
        else if (GetRange(2, nHD)) nAmount = d20(2);
        else if (GetRange(3, nHD)) nAmount = d20(3);
        else if (GetRange(4, nHD)) nAmount = d20(5);
		else if (GetRange(5, nHD)) nAmount = d20(8);
        else if (GetRange(6, nHD)) nAmount = d20(10);
		
        float nMod = 0.0;
        if (nTreasureType == TREASURE_LOW) nMod = LOW_MOD_GOLD;
        else if (nTreasureType == TREASURE_MEDIUM) nMod = MEDIUM_MOD_GOLD;
        else if (nTreasureType == TREASURE_HIGH) nMod = HIGH_MOD_GOLD;

        // * always at least 1gp is created
        nAmount = FloatToInt(nAmount * nMod);
        if (nAmount <= 0) nAmount = 1;
		
        //dbSpeak("gold");
        dbCreateItemOnObject("NW_IT_GOLD001", oTarget, nAmount);
    }
	
	//Gem drops will now be taken care of separately; Rewriting this to preserve
	//drop rates for golems, but otherwise redirecting to CreateJunk
	//Will need to revisit when we redo loot tables - 5/20/18, MimiFearthegn
    void CreateGem(object oTarget, object oAdventurer, int nTreasureType, int nModifier = 0)
    {
        string sGem = "nw_it_gem001";
        if (nTreasureType == TREASURE_LOW) {
			CreateJunk(oTarget); return;
        } else if (nTreasureType == TREASURE_MEDIUM) {
			int nRand = d100();
			if (nRand < 80) {
				CreateJunk(oTarget); return;
			} else if (nRand < 90) {
				sGem = "ps_golem_brass";
			}  else  {
				sGem = "ps_golem_quartz";
			}
        } else if (nTreasureType == TREASURE_HIGH) {
		
			int nRand = d100();
			if (nRand < 88) {
				CreateJunk(oTarget); return;
			} else  {
				sGem = "ps_golem_mithral";
			}
        }
		
      dbCreateItemOnObject(sGem, oTarget, 1);
	  
    }
	
    void CreateJewel(object oTarget, object oAdventurer, int nTreasureType, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sJewel = "";

        if (GetRange(1, nHD))        // 15 gp avg; 75 gp max
        {
          int nRandom = d2();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";   break;
            case 2: sJewel = "nw_it_mneck020";   break;
          }
        }
        else if (GetRange(2, nHD))   // 30 GP Avg; 150 gp Max
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";            break;
            case 2: case 3: sJewel = "nw_it_mneck020";    break;
            case 4: sJewel = "nw_it_mring022";            break;
            case 5: case 6: sJewel = "nw_it_mneck023";            break;          }
        }
        else if (GetRange(3, nHD))  // 75GP Avg; 500 gp max
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";           break;
            case 2: case 3: sJewel = "nw_it_mneck020";   break;
            case 4: case 5: sJewel = "nw_it_mring022";   break;
            case 6: sJewel = "nw_it_mneck021";           break;
          }
        }
        else if (GetRange(4, nHD))  // 150 gp avg; 1000 gp max
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring021";            break;
            case 2: sJewel = "nw_it_mring022";            break;
            case 3: case 4: case 5: sJewel = "nw_it_mneck021";    break;
            case 6: sJewel = "nw_it_mring023";            break;
          }
        }
        else if (GetRange(5, nHD))  // 300 gp avg; any
        {
          int nRandom = d8();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring022";           break;
            case 2: case 3: sJewel = "nw_it_mneck021";   break;
            case 4: case 5: case 6: sJewel = "nw_it_mring023"; break;
            case 7: case 8: sJewel = "nw_it_mneck022";               break;
          }
        }
        else if (GetRange(6, nHD))
        {
          int nRandom = d6();
          switch (nRandom)
          {
            case 1: sJewel = "nw_it_mring022";              break;
            case 2: sJewel = "nw_it_mneck021";              break;
            case 3: case 4: sJewel = "nw_it_mring023";      break;
            case 5: case 6: sJewel = "nw_it_mneck022";      break;
          }
        }
      //dbSpeak("Create Jewel");

      dbCreateItemOnObject(sJewel, oTarget, 1);

    }
    // * returns the valid upper limit for any arcane spell scroll
/*    int TrimLevel(int nScroll, int nLevel)
    {   int nMax = 5;
        switch (nLevel)
        {
            case 0: nMax = 4; break;
            case 1: nMax = 13; break;
            case 2: nMax = 21; break;
            case 3: nMax = 15; break;
            case 4: nMax = 17; break;
            case 5: nMax = 13; break;
            case 6: nMax = 14; break;
            case 7: nMax = 8; break;
            case 8: nMax = 9; break;
            case 9: nMax = 12; break;
        }
        if (nScroll > nMax) nScroll = nMax;
        return nScroll;

    }
*/	
	
// returns the valid upper limit for an original NWN1 arcane spell scroll
int GetNW_ArcaneScrollMax(int nLevel)
{   
	int nMax = 0;
    switch (nLevel)
    {
        case 0: nMax = 10; break;
        case 1: nMax = 57; break;
        case 2: nMax = 64; break;
        case 3: nMax = 58; break;
        case 4: nMax = 47; break;
        case 5: nMax = 36; break;
        case 6: nMax = 42; break;
        case 7: nMax = 28; break;
        case 8: nMax = 28; break;
        case 9: nMax = 25; break;
    }
    return nMax;
}


// certain numbers have been removed
int GetNW_ArcaneScrollSkip(int nLevel, int nCount)
{   
	//int nSkip = 0;
    switch (nLevel)
    {
        case 2: 
			if (nCount >= 15)
				nCount++;
			if (nCount >= 17)
				nCount++;
			break;
        case 4:
			if (nCount >= 1)
				nCount++;
			break;
		
        case 6:
			if (nCount >= 11)
				nCount++;
			break;
		
        case 8: 
			if (nCount >= 6)
				nCount++;
			break;
		
        case 9:
			if (nCount >= 11)
				nCount++;
			break;

    }
    return nCount;
}

int GetNW_ArcaneScrollRandom(int nLevel)
{
	// get max speel for this spell level
	int nNumSpellsInLevel = GetNW_ArcaneScrollMax(nLevel);
	// pick a random one
	int nScrollNum =  Random(nNumSpellsInLevel) + 1;
	// Skip the scrolls that have been deleted
	//nScrollNum = GetNW_ArcaneScrollSkip(nLevel, nScrollNum);
	return nScrollNum;
}
	
	
// * nModifier is to 'raise' the level of the oAdventurer
void CreateArcaneScroll(object oTarget, object oAdventurer, int nModifier = 0)
{
	//int nMaxSpells = 21;
	int nHD = GetHitDice(oAdventurer) + nModifier;
	int nScroll = 1;
	int nLevel = 1;
	
	if (GetRange(1, nHD))           // l 1-2
	{
	  nLevel = d2();
	  //nScroll =  Random(nMaxSpells) + 1;
	}
	else if (GetRange(2, nHD))      // l 1-4
	{
	  nLevel = d4();
	  //nScroll =  Random(nMaxSpells) + 1;
	}
	else if (GetRange(3, nHD))    // l 2-6
	{
	  nLevel = d6();
	  if (nLevel < 2) nLevel = 2;
	
	  //nScroll =  Random(nMaxSpells) + 1;
	}
	else if (GetRange(4, nHD))   // l 3-8
	{
	  nLevel = d8();
	  if (nLevel < 3) nLevel = 3;
	
	  //nScroll =  Random(nMaxSpells) + 1;
	}
	else if (GetRange(5, nHD))   // l 4-9
	{
	  nLevel = d8() + 1;
	  if (nLevel < 4) nLevel = 4;
	
	  //nScroll =  Random(nMaxSpells) + 1;
	}
	else if (GetRange(6, nHD))   // 5 -9
	{
	  nLevel = d8() + 1;
	  if (nLevel < 5) nLevel = 5;
	//nScroll =  Random(nMaxSpells) + 1;
	
	}
	
	nScroll = GetNW_ArcaneScrollRandom(nLevel);

	// * Trims the level of the scroll to match the max # of scrolls in each level range
	//nScroll = TrimLevel(nScroll, nLevel);
	
	string sRes; // = "nw_it_sparscr216";
	
	if (nScroll < 10)
	{
	    sRes = "ps_scrolls" + IntToString(nLevel) + "_0" + IntToString(nScroll);
	}
	else
	{
	    sRes = "ps_scrolls" + IntToString(nLevel) + "_" + IntToString(nScroll);
	}
	dbCreateItemOnObject(sRes, oTarget, 1);
}

    void CreateDivineScroll(object oTarget, object oAdventurer, int nModifier=0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sScroll = "";
        if (GetRange(1, nHD))
        {
            int nRandom = Random(3) + 1; //d4();
            switch (nRandom)
            {
                case 1: sScroll = "nw_it_spdvscr201"; break;
                //case 2: sScroll = "nw_it_spdvscr202"; break;
                case 3: sScroll = "nw_it_spdvscr203"; break;
                case 2: sScroll = "nw_it_spdvscr204"; break;
            }
        }
        else if (GetRange(2, nHD))
        {
            int nRandom = Random(7) + 1; //d8();
            switch (nRandom)
            {
				// 7/6/06 BDF - OEI:
				// Case 2 used to be "nw_it_spdvscr202", but that item doesn't exist in NWN2.
				// Decided to shift all the data up one position and kept case 8 as is so that
				// there are no cases that don't return a valid value.
				// This just means that "nw_it_spdvscr402" has a higher drop percentage,
				// but really, life goes on. :)
                case 1: sScroll = "nw_it_spdvscr201"; break;
                //case 2: sScroll = "nw_it_spdvscr202"; break;
                case 2: sScroll = "nw_it_spdvscr203"; break;
                case 3: sScroll = "nw_it_spdvscr204"; break;
                case 4: sScroll = "nw_it_spdvscr301"; break;
                case 5: sScroll = "nw_it_spdvscr302"; break;
                case 6: sScroll = "nw_it_spdvscr401"; break;
                case 7: sScroll = "nw_it_spdvscr402"; break;
            }

        }
        else if (GetRange(3, nHD))
        {
            int nRandom = Random(8) + 1;
            switch (nRandom)
            {
                case 1: sScroll = "nw_it_spdvscr201"; break;
                //case 2: sScroll = "nw_it_spdvscr202"; break;
                case 3: sScroll = "nw_it_spdvscr203"; break;
                case 4: sScroll = "nw_it_spdvscr204"; break;
                case 5: sScroll = "nw_it_spdvscr301"; break;
                case 6: sScroll = "nw_it_spdvscr302"; break;
                case 7: sScroll = "nw_it_spdvscr401"; break;
                case 8: sScroll = "nw_it_spdvscr402"; break;
                case 2: sScroll = "nw_it_spdvscr501"; break;
            }

        }
        else
        {
            int nRandom = Random(7) + 1;
            switch (nRandom)
            {
                case 1: sScroll = "nw_it_spdvscr301"; break;
                case 2: sScroll = "nw_it_spdvscr302";  break;
                case 3: sScroll = "nw_it_spdvscr401"; break;
                case 4: sScroll = "nw_it_spdvscr402"; break;
                case 5: sScroll = "nw_it_spdvscr501"; break;
                case 6: sScroll = "nw_it_spdvscr701"; break;
                case 7: sScroll = "nw_it_spdvscr702";  break;
            }
        }
        //dbSpeak("Divine Scroll");

        dbCreateItemOnObject(sScroll, oTarget, 1);

    }
    void CreateAmmo(object oTarget, object oAdventurer, int nModifier=0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sAmmo = "";

        if (GetRange(1, nHD))           // * 200 gp max
        {
            //int nRandom = d3();
			int nRandom = Random(28) + 1;
            switch (nRandom)
            {
				case 1: sAmmo = "ps_arrow_+1";  break;
				case 2: sAmmo = "ps_arrow_+2";  break;
				case 3: sAmmo = "ps_arrow_alchemicalsilver";  break;
				case 4: sAmmo = "ps_arrow_coldiron";  break;
				case 5: sAmmo = "ps_arrow_mildpoison";  break;
				case 6: sAmmo = "ps_arrow_acid";  break;
				case 7: sAmmo = "ps_arrow_fire";  break;
				case 8: sAmmo = "ps_arrow_frost";  break;
				case 9: sAmmo = "ps_arrow_electric";  break;
				case 10: sAmmo = "ps_arrow_piercing";  break;
				case 11: sAmmo = "ps_arrow_vampiric";  break;
				case 12: sAmmo = "ps_bolt_alchemicalsilver";  break;
				case 13: sAmmo = "ps_bolt_+1";  break;
				case 14: sAmmo = "ps_bolt_+2";  break;
				case 15: sAmmo = "ps_bolt_fire";  break;
				case 16: sAmmo = "ps_bolt_frost";  break;
				case 17: sAmmo = "ps_bolt_electric";  break;
				case 18: sAmmo = "ps_bolt_piercing";  break;
				case 19: sAmmo = "ps_bolt_coldiron";  break;
				case 20: sAmmo = "ps_bolt_mildpoison";  break;
				case 21: sAmmo = "ps_bolt_paralytic";  break;
				case 22: sAmmo = "ps_bullet_+1";  break;
				case 23: sAmmo = "ps_bullet_alchemicalsilver";  break;
				case 24: sAmmo = "ps_bullet_+2";  break;
				case 25: sAmmo = "ps_bullet_coldiron";  break;
				case 26: sAmmo = "ps_bullet_frost";  break;
				case 27: sAmmo = "ps_bullet_electric";  break;
				case 28: sAmmo = "ps_bullet_fire";  break;
            }
          }
        else if (GetRange(2, nHD))       // * 800 gp max
        {
            //int nRandom = d6();
			int nRandom = Random(31) + 1;
            switch (nRandom)
            {
                case 1: sAmmo = "nw_wammar001"; break;
                case 2: sAmmo = "nw_wammbo001"; break;
                case 3: sAmmo = "nw_wammbo002"; break;
				case 4: sAmmo = "ps_arrow_+3";  break;
				case 5: sAmmo = "ps_arrow_+4";  break;
				case 6: sAmmo = "ps_arrow_acid";  break;
				case 7: sAmmo = "ps_arrow_fire";  break;
				case 8: sAmmo = "ps_arrow_frost";  break;
				case 9: sAmmo = "ps_arrow_electric";  break;
				case 10: sAmmo = "ps_arrow_piercing";  break;
				case 11: sAmmo = "ps_arrow_vampiric";  break;
				case 12: sAmmo = "ps_arrow_freezing";  break;
				case 13: sAmmo = "ps_arrow_slowing";  break;
				case 14: sAmmo = "ps_arrow_bleeding";  break;
				case 15: sAmmo = "ps_bolt_+4";  break;
				case 16: sAmmo = "ps_bolt_+3";  break;
				case 17: sAmmo = "ps_bolt_fire";  break;
				case 18: sAmmo = "ps_bolt_frost";  break;
				case 19: sAmmo = "ps_bolt_electric";  break;
				case 20: sAmmo = "ps_bolt_piercing";  break;
				case 21: sAmmo = "ps_bolt_mildpoison";  break;
				case 22: sAmmo = "ps_bolt_paralytic";  break;
				case 23: sAmmo = "ps_bullet_frost";  break;
				case 24: sAmmo = "ps_bullet_electric";  break;
				case 25: sAmmo = "ps_bullet_fire";  break;
				case 26: sAmmo = "ps_bullet_+3";  break;
				case 27: sAmmo = "ps_bullet_+4";  break;
				case 28: sAmmo = "ps_bullet_screaming";  break;
				case 29: sAmmo = "ps_bullet_smiting";  break;
				case 30: sAmmo = "ps_bullet_farelsgold";  break;
				case 31: sAmmo = "ps_bullet_giantsbane";  break;
            }
        }
        else if (GetRange(3, nHD))    // *  - 2500 gp
        {
            //int nRandom = d20();
			int nRandom = Random(51) + 1;
            switch (nRandom)
            {
                case 1: sAmmo = "nw_wammar001";   break;
                case 2: sAmmo = "nw_wammbo001";   break;
                case 3: sAmmo = "nw_wammbo001";   break;
                case 4: sAmmo = "nw_wammar001";  break;
                case 5: sAmmo = "nw_wammbo001";  break;
                case 6: sAmmo = "nw_wammbo002";   break;
                case 7: sAmmo = "nw_wammbo003";  break;
                case 8: sAmmo = "nw_wammbu002";  break;
                case 9: sAmmo = "nw_wammar002";  break;
                case 10: sAmmo = "nw_wammar001"; break;
                case 11: sAmmo = "nw_wammar003"; break;
                case 12: sAmmo = "nw_wammar004"; break;
                case 13: sAmmo = "nw_wammar005"; break;
                case 14: sAmmo = "nw_wammar006"; break;
                case 15: sAmmo = "nw_wammbo004";  break;
                case 16: sAmmo = "nw_wammbo005"; break;
                case 17: sAmmo = "nw_wammbu004"; break;
                case 18: sAmmo = "nw_wammbu005"; break;
                case 19: sAmmo = "nw_wammbu006"; break;
                case 20: sAmmo = "nw_wammbu007"; break;
				case 21: sAmmo = "ps_arrow_adamantine";  break;
				case 22: sAmmo = "ps_arrow_+4";  break;
				case 23: sAmmo = "ps_arrow_+5";  break;
				case 24: sAmmo = "ps_arrow_acid";  break;
				case 25: sAmmo = "ps_arrow_fire";  break;
				case 26: sAmmo = "ps_arrow_frost";  break;
				case 27: sAmmo = "ps_arrow_electric";  break;
				case 28: sAmmo = "ps_arrow_piercing";  break;
				case 29: sAmmo = "ps_arrow_vampiric";  break;
				case 30: sAmmo = "ps_arrow_freezing";  break;
				case 31: sAmmo = "ps_arrow_slowing";  break;
				case 32: sAmmo = "ps_arrow_bleeding";  break;
				case 33: sAmmo = "ps_bolt_+4";  break;
				case 34: sAmmo = "ps_bolt_+5";  break;
				case 35: sAmmo = "ps_bolt_fire";  break;
				case 36: sAmmo = "ps_bolt_frost";  break;
				case 37: sAmmo = "ps_bolt_electric";  break;
				case 38: sAmmo = "ps_bolt_piercing";  break;
				case 39: sAmmo = "ps_bolt_mildpoison";  break;
				case 40: sAmmo = "ps_bolt_paralytic";  break;
				case 41: sAmmo = "ps_bolt_adamantine";  break;
				case 42: sAmmo = "ps_bullet_adamantine";  break;
				case 43: sAmmo = "ps_bullet_frost";  break;
				case 44: sAmmo = "ps_bullet_electric";  break;
				case 45: sAmmo = "ps_bullet_fire";  break;
				case 46: sAmmo = "ps_bullet_+5";  break;
				case 47: sAmmo = "ps_bullet_+4";  break;
				case 48: sAmmo = "ps_bullet_screaming";  break;
				case 49: sAmmo = "ps_bullet_smiting";  break;
				case 50: sAmmo = "ps_bullet_farelsgold";  break;
				case 51: sAmmo = "ps_bullet_giantsbane";  break;
            }
        }
        else
        {
            int nRandom = d20();
            switch (nRandom)
            {
                case 1: sAmmo = "nw_wammbu001";      break;
                case 2: sAmmo = "nw_wammbu001";     break;
                case 3: sAmmo = "nw_wammbu003";     break;
                case 4: sAmmo = "nw_wammar001";     break;
                case 5: sAmmo = "nw_wammbo001";      break;
                case 6: sAmmo = "nw_wammbo002";     break;
                case 7: sAmmo = "nw_wammbo003";     break;
                case 8: sAmmo = "nw_wammbu002";     break;
                case 9: sAmmo = "nw_wammar002";     break;
                case 10: sAmmo = "nw_wammar001";    break;
                case 11: sAmmo = "nw_wammar003";    break;
                case 12: sAmmo = "nw_wammar004";     break;
                case 13: sAmmo = "nw_wammar005";    break;
                case 14: sAmmo = "nw_wammar006";    break;
                case 15: sAmmo = "nw_wammbo004";    break;
                case 16: sAmmo = "nw_wammbo005";    break;
                case 17: sAmmo = "nw_wammbu004";    break;
                case 18: sAmmo = "nw_wammbu005";    break;
                case 19: sAmmo = "nw_wammbu006";    break;
                case 20: sAmmo = "nw_wammbu007";    break;
            }
        }
        //dbSpeak("ammo");
        dbCreateItemOnObject(sAmmo, oTarget, Random(30) + 1); // create up to 30 of the specified ammo type
    }

    void CreateTrapKit(object oTarget, object oAdventurer, int nModifier = 0)
    {
      int nHD = GetHitDice(oAdventurer) + nModifier;
      string sKit = "";
        if (GetRange(1, nHD))      // 200
        {
            int nRandom = d3();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap001";    break;
                case 2: sKit = "nw_it_trap029";    break;
                case 3: sKit = "nw_it_trap033";    break;
            }
        }
        else if (GetRange(2, nHD))  // 800
        {
            int nRandom = d12();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap001";    break;
                case 2: sKit = "nw_it_trap029";    break;
                case 3: sKit = "nw_it_trap033";    break;
                case 4: sKit = "nw_it_trap002";    break;
                case 5: sKit = "nw_it_trap030";    break;
                case 6: sKit = "nw_it_trap037";    break;
                case 7: sKit = "nw_it_trap034";   break;
                case 8: sKit = "nw_it_trap005";   break;
                case 9: sKit = "nw_it_trap038";   break;
                case 10: sKit = "nw_it_trap041";   break;
                case 11: sKit = "nw_it_trap003";    break;
                case 12: sKit = "nw_it_trap031";   break;
            }

        }
        else if (GetRange(3, nHD))   // 200 - 2500
        {
            int nRandom = Random(17) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap002";  break;
                case 2: sKit = "nw_it_trap030";  break;
                case 3: sKit = "nw_it_trap037";  break;
                case 4: sKit = "nw_it_trap034";   break;
                case 5: sKit = "nw_it_trap005";  break;
                case 6: sKit = "nw_it_trap038";   break;
                case 7: sKit = "nw_it_trap041";   break;
                case 8: sKit = "nw_it_trap003";   break;
                case 9: sKit = "nw_it_trap031";   break;
                case 10: sKit = "nw_it_trap035";   break;
                case 11: sKit = "nw_it_trap006";   break;
                case 12: sKit = "nw_it_trap042";   break;
                case 13: sKit = "nw_it_trap004";   break;
                case 14: sKit = "nw_it_trap032";   break;
                case 15: sKit = "nw_it_trap039";    break;
                case 16: sKit = "nw_it_trap009";   break;
                case 17: sKit = "nw_it_trap036";   break;
            }

       }
        else if (GetRange(4, nHD))  // 800 - 10000
        {
            int nRandom = Random(19) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap035";  break;
                case 2: sKit = "nw_it_trap006";  break;
                case 3: sKit = "nw_it_trap042";  break;
                case 4: sKit = "nw_it_trap004";   break;
                case 5: sKit = "nw_it_trap032";   break;
                case 6: sKit = "nw_it_trap039";   break;
                case 7: sKit = "nw_it_trap009";   break;
                case 8: sKit = "nw_it_trap036";   break;
                case 9: sKit = "nw_it_trap013";   break;
                case 10: sKit = "nw_it_trap040";  break;
                case 11: sKit = "nw_it_trap007";  break;
                case 12: sKit = "nw_it_trap043";  break;
                case 13: sKit = "nw_it_trap010";  break;
                case 14: sKit = "nw_it_trap017";  break;
                case 15: sKit = "nw_it_trap021"; break;
                case 16: sKit = "nw_it_trap014"; break;
                case 17: sKit = "nw_it_trap025"; break;
                case 18: sKit = "nw_it_trap008";  break;
                case 19: sKit = "nw_it_trap044";  break;
            }

        }
        else if (GetRange(5, nHD))  // 2000 -16500
        {
            int nRandom = Random(18) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap039";   break;
                case 2: sKit = "nw_it_trap009";   break;
                case 3: sKit = "nw_it_trap036";   break;
                case 4: sKit = "nw_it_trap013";   break;
                case 5: sKit = "nw_it_trap040";   break;
                case 6: sKit = "nw_it_trap007";   break;
                case 7: sKit = "nw_it_trap043";   break;
                case 8: sKit = "nw_it_trap010";  break;
                case 9: sKit = "nw_it_trap017";  break;
                case 10: sKit = "nw_it_trap021";  break;
                case 11: sKit = "nw_it_trap014";  break;
                case 12: sKit = "nw_it_trap025";  break;
                case 13: sKit = "nw_it_trap008";  break;
                case 14: sKit = "nw_it_trap044";  break;
                case 15: sKit = "nw_it_trap018";  break;
                case 16: sKit = "nw_it_trap011";  break;
                case 17: sKit = "nw_it_trap022";  break;
                case 18: sKit = "nw_it_trap026";  break;
            }

        }
        else if (GetRange(6, nHD))   // 2000 - ?
        {
            int nRandom = Random(27) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_trap039";  break;
                case 2: sKit = "nw_it_trap009";  break;
                case 3: sKit = "nw_it_trap036";  break;
                case 4: sKit = "nw_it_trap013";  break;
                case 5: sKit = "nw_it_trap040";  break;
                case 6: sKit = "nw_it_trap007";  break;
                case 7: sKit = "nw_it_trap043";  break;
                case 8: sKit = "nw_it_trap010"; break;
                case 9: sKit = "nw_it_trap017"; break;
                case 10: sKit = "nw_it_trap021"; break;
                case 11: sKit = "nw_it_trap014"; break;
                case 12: sKit = "nw_it_trap025"; break;
                case 13: sKit = "nw_it_trap008"; break;
                case 14: sKit = "nw_it_trap044"; break;
                case 15: sKit = "nw_it_trap018"; break;
                case 16: sKit = "nw_it_trap011"; break;
                case 17: sKit = "nw_it_trap022"; break;
                case 18: sKit = "nw_it_trap026"; break;
                case 19: sKit = "nw_it_trap015"; break;
                case 20: sKit = "nw_it_trap012"; break;
                case 21: sKit = "nw_it_trap019"; break;
                case 22: sKit = "nw_it_trap023"; break;
                case 23: sKit = "nw_it_trap016"; break;
                case 24: sKit = "nw_it_trap027"; break;
                case 25: sKit = "nw_it_trap020"; break;
                case 26: sKit = "nw_it_trap024"; break;
                case 27: sKit = "nw_it_trap028"; break;
             }

        }
        //dbSpeak("Create Trapkit");
        dbCreateItemOnObject(sKit, oTarget, 1);

    }
    void CreateHealingKit(object oTarget, object oAdventurer, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sKit = "";
        if (GetRange(1, nHD))      // 200
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit001";  break;
            }
        }
        else if (GetRange(2, nHD))  // 800
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit001";  break;
                case 2: sKit = "nw_it_medkit002";  break;
            }

        }
        else if (GetRange(3, nHD))   // 200 - 2500
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit002"; break;
                case 2: sKit = "nw_it_medkit003";  break;
            }

       }
        else if (GetRange(4, nHD))  // 800 - 10000
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit003";break;
                case 2: sKit = "nw_it_medkit004"; break;
            }

        }
        else if (GetRange(5, nHD))  // 2000 -16500
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit003"; break;
                case 2: sKit = "nw_it_medkit004";break;
            }

        }
        else if (GetRange(6, nHD))   // 2000 - ?
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_medkit003"; break;
                case 2: sKit = "nw_it_medkit004";break;
             }

        }
        //dbSpeak("Create Healing Kit");

        dbCreateItemOnObject(sKit, oTarget, 1);

    }
    void CreateLockPick(object oTarget, object oAdventurer, int nModifier = 0)
    {
        int nHD = GetHitDice(oAdventurer) + nModifier;
        string sKit = "";
        if (GetRange(1, nHD))      // 200
        {
            int nRandom = d8();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks001";   break;
                case 2: sKit = "nw_it_picks002";   break;
                case 3: sKit = "nw_it_picks001";   break;
                case 4: sKit = "nw_it_picks001";   break;
                case 5: sKit = "nw_it_picks001";   break;
                case 6: sKit = "nw_it_picks001";   break;
                case 7: sKit = "nw_it_picks001";   break;
                case 8: sKit = "nw_it_picks001";   break;
            }
        }
        else if (GetRange(2, nHD))  // 800
        {
            int nRandom = d6();
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks001";   break;
                case 2: sKit = "nw_it_picks002";    break;
                case 3: sKit = "nw_it_picks003";   break;
                case 4: sKit = "nw_it_picks002";    break;
                case 5: sKit = "nw_it_picks002";    break;
                case 6: sKit = "nw_it_picks002";    break;
            }

        }
        else if (GetRange(3, nHD))   // 200 - 2500
        {
            int nRandom = Random(2) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks003";  break;
                case 2: sKit = "nw_it_picks004";  break;
            }

       }
        else if (GetRange(4, nHD))  // 800 - 10000
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks004";  break;
            }

        }
        else if (GetRange(5, nHD))  // 2000 -16500
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks004"; break;
            }

        }
        else if (GetRange(6, nHD))   // 2000 - ?
        {
            int nRandom = Random(1) + 1;
            switch (nRandom)
            {
                case 1: sKit = "nw_it_picks004"; break;
             }

        }
       //dbSpeak("Create Lockpick");

        dbCreateItemOnObject(sKit, oTarget, 1);

    }
    void CreateKit(object oTarget, object oAdventurer, int nModifier = 0)
    {
        // * April 23 2002: Major restructuring of this function
        // * to allow me to

        switch (Random(8) + 1)
        {
            case 1: CreateTrapKit(oTarget, oAdventurer, nModifier); break;
            case 2: case 3: case 4: case 5: CreateHealingKit(oTarget, oAdventurer, nModifier); break;
            case 6: case 7: case 8: CreateLockPick(oTarget, oAdventurer, nModifier); break;
        }
    }

    void CreatePotion_old(object oTarget, object oAdventurer, int nModifier = 0)
    {
		return;
		
        string sPotion = "";
        int nHD = GetHitDice(oAdventurer) + nModifier;

        if (GetRange(1, nHD))
        {
            int nRandom = d10();
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: sPotion = "nw_it_mpotion001"; break;
                case 5: case 6: case 7: sPotion = "nw_it_mpotion020";  break;
                case 8: sPotion = "nw_it_mpotion002";  break;
                case 9: sPotion = "nw_it_mpotion009";  break;
                case 10: sPotion = "nw_it_mpotion005";  break;
            }

        }
        else if (GetRange(2, nHD))
        {
           int nRandom = Random(28) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: sPotion = "nw_it_mpotion001"; break;
                case 4: case 5: case 6: case 7: case 8: sPotion = "nw_it_mpotion020";  break;
                case 9: case 10: case 11: case 12: sPotion = "nw_it_mpotion002";  break;
                case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                //case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 17: sPotion = "nw_it_mpotion006";  break;
            }
        }
        else if (GetRange(3, nHD))
        {
           int nRandom = Random(28) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8:
                case 9: case 10: case 11: case 12:
                case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                //case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 17: sPotion = "nw_it_mpotion006";  break;
            }
        }
        else if (GetRange(4, nHD))
        {
           int nRandom = Random(28) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8:
                case 9: case 10: case 11: case 12: sPotion = "nw_it_mpotion003"; break;
                case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                //case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 17: sPotion = "nw_it_mpotion006";  break;
            }
        }
        else  // keep 5 and 6 the same
        {
           int nRandom = Random(28) + 1;
            switch (nRandom)
            {
                case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8:
                case 9: sPotion = "nw_it_mpotion003" ;
                case 10: case 11: case 12: case 13: case 14: sPotion = "nw_it_mpotion003";  break;
                case 15: sPotion = "nw_it_mpotion009";  break;
                case 16: sPotion = "nw_it_mpotion005";  break;
                //case 17: sPotion = "nw_it_mpotion007";  break;
                case 18: sPotion = "nw_it_mpotion008";  break;
                case 19: sPotion = "nw_it_mpotion010";  break;
                case 20: sPotion = "nw_it_mpotion011";  break;
                case 21: sPotion = "nw_it_mpotion013";  break;
                case 22: sPotion = "nw_it_mpotion014";  break;
                case 23: sPotion = "nw_it_mpotion015";  break;
                case 24: sPotion = "nw_it_mpotion016";  break;
                case 25: sPotion = "nw_it_mpotion017";  break;
                case 26: sPotion = "nw_it_mpotion018";  break;
                case 27: sPotion = "nw_it_mpotion019";  break;
                case 28: sPotion = "nw_it_mpotion004";  break;
                case 17: sPotion = "nw_it_mpotion006";  break;
            }
        }
        //dbSpeak("Create Potion");
        dbCreateItemOnObject(sPotion, oTarget, 1);
    }

    void CreatePotion(object oTarget, object oAdventurer, int nTreasureType = TREASURE_LOW)
    {
        string sPotion = "";
	    if (nTreasureType == TREASURE_LOW)
		{
		    int nRandom = Random(32) + 1;
            switch (nRandom)
			{
				case 1: sPotion = "ps_potions1_01"; break;
				case 2: sPotion = "ps_potions1_02"; break;
				case 3: sPotion = "ps_potions1_03"; break;
				case 4: case 5: case 6: sPotion = "ps_potions1_04"; break;
				case 7: case 8: case 9: sPotion = "ps_potions1_05"; break;
				case 10: sPotion = "ps_potions1_06"; break;
				case 11: sPotion = "ps_potions1_07"; break;
				case 12: sPotion = "ps_potions1_08"; break;
				case 13: sPotion = "ps_potions1_09"; break;
				case 14: case 15: sPotion = "ps_potions2_01"; break;
				case 16: sPotion = "ps_potions2_02"; break;
				case 17: sPotion = "ps_potions2_03"; break;
				case 18: sPotion = "ps_potions2_04"; break;
				case 19: case 20: case 21: sPotion = "ps_potions2_05"; break;
				case 22: sPotion = "ps_potions2_06"; break;
				case 23: sPotion = "ps_potions2_07"; break;
				case 24: sPotion = "ps_potions2_08"; break;
				case 25: sPotion = "ps_potions2_09"; break;
				case 26: sPotion = "ps_potions2_10"; break;
				case 27: case 28: sPotion = "ps_potions2_11"; break;
				case 29: sPotion = "ps_potions2_12"; break;
				case 30: sPotion = "ps_potions2_13"; break;
				case 31: sPotion = "ps_potions2_14"; break;
				case 32: sPotion = "ps_potion_lessersequencer"; break;
			}
		}
		else if (nTreasureType == TREASURE_MEDIUM)
		{
			int nRandom = Random(100);
			int nRandpot = 0;
			if(10<=nRandom)
			{
				nRandpot = Random(9)+1;
				sPotion = "ps_potions1_0" + IntToString(nRandpot);
			}
			else if(20<=nRandom)
			{
				nRandpot = Random(14)+1;
				if(nRandpot < 10)
				{
					sPotion = "ps_potions2_0" + IntToString(nRandpot);
				}
				else
				{
					sPotion = "ps_potions2_" + IntToString(nRandpot);
				}			
			}
			else if(60<=nRandom)
			{
				nRandpot = Random(9)+1;
				sPotion = "ps_potions3_0" + IntToString(nRandpot);			
			}
			else if(90<=nRandom)
			{
				nRandpot = Random(6)+1;
				sPotion = "ps_potions4_0" + IntToString(nRandpot);						
			}
			else if(94<=nRandom)
			{sPotion = "ps_potion_lessersequencer";}
			else if(97<=nRandom)
			{sPotion = "ps_potion_jhuild";}
			else
			{sPotion = "ps_potion_sequencer";}
			
		}
		else if (nTreasureType == TREASURE_HIGH)
		{
			int nRandom = Random(100);
			int nRandpot = 0;
			if(5<=nRandom)
			{
				nRandpot = Random(9)+1;
				sPotion = "ps_potions1_0" + IntToString(nRandpot);
			}
			else if(10<=nRandom)
			{
				nRandpot = Random(14)+1;
				if(nRandpot < 10)
				{
					sPotion = "ps_potions2_0" + IntToString(nRandpot);
				}
				else
				{
					sPotion = "ps_potions2_" + IntToString(nRandpot);
				}			
			}
			else if(25<=nRandom)
			{
				nRandpot = Random(9)+1;
				sPotion = "ps_potions3_0" + IntToString(nRandpot);			
			}
			else if(40<=nRandom)
			{
				nRandpot = Random(6)+1;
				sPotion = "ps_potions4_0" + IntToString(nRandpot);						
			}
			else if(53<=nRandom)
			{
				nRandpot = Random(2)+1;
				sPotion = "ps_potions5_0" + IntToString(nRandpot);						
			}
			else if(78<=nRandom)
			{
				nRandpot = Random(9)+1;
				sPotion = "ps_potions4_0" + IntToString(nRandpot);						
			}
			else if(85<=nRandom)
			{sPotion = "ps_potion_greatersequencer";}			
			else if(92<=nRandom)
			{sPotion = "ps_potion_lessersequencer";}
			else if(95<=nRandom)
			{sPotion = "ps_potion_jhuild";}
			else
			{sPotion = "ps_potion_sequencer";}
		}
		
        dbCreateItemOnObject(sPotion, oTarget, 1);
    }
	
	string LowSCODitem()
	{
	 int nRandom = d100();
	 string sItem = "";
	 int nItem = 0;
	 
	 if (nRandom <= SCOD_WEAPONS)
	 {
		nItem = Random(669) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_bastardsword_baatorian";  break;
			case 2: sItem = "ps_battleaxe_baatorian";  break;
			case 3: sItem = "ps_dagger_baatorian";  break;
			case 4: sItem = "ps_waraxe_baatorian";  break;
			case 5: sItem = "ps_falchion_baatorian";  break;
			case 6: sItem = "ps_greataxe_baatorian";  break;
			case 7: sItem = "ps_greatsword_baatorian";  break;
			case 8: sItem = "ps_halberd_baatorian";  break;
			case 9: sItem = "ps_handaxe_baatorian";  break;
			case 10: sItem = "ps_kama_baatorian";  break;
			case 11: sItem = "ps_katana_baatorian";  break;
			case 12: sItem = "ps_kukri_baatorian";  break;
			case 13: sItem = "ps_longsword_baatorian";  break;
			case 14: sItem = "ps_morningstar_baatorian";  break;
			case 15: sItem = "ps_rapier_baatorian";  break;
			case 16: sItem = "ps_scimitar_baatorian";  break;
			case 17: sItem = "ps_scythe_baatorian";  break;
			case 18: sItem = "ps_shortsword_baatorian";  break;
			case 19: sItem = "ps_sickle_baatorian";  break;
			case 20: sItem = "ps_bastardsword_constructruin";  break;
			case 21: sItem = "ps_battleaxe_constructruin";  break;
			case 22: sItem = "ps_dagger_constructruin";  break;
			case 23: sItem = "ps_dwarvenwaraxe_constructruin";  break;
			case 24: sItem = "ps_falchion_constructruin";  break;
			case 25: sItem = "ps_flail_constructruin";  break;
			case 26: sItem = "ps_greataxe_constructruin";  break;
			case 27: sItem = "ps_greatsword_constructruin";  break;
			case 28: sItem = "ps_halberd_constructruin";  break;
			case 29: sItem = "ps_hammer_constructruin";  break;
			case 30: sItem = "ps_handaxe_constructruin";  break;
			case 31: sItem = "ps_kama_constructruin";  break;
			case 32: sItem = "ps_katana_constructruin";  break;
			case 33: sItem = "ps_kukri_constructruin";  break;
			case 34: sItem = "ps_longsword_constructruin";  break;
			case 35: sItem = "ps_mace_constructruin";  break;
			case 36: sItem = "ps_morningstar_constructruin";  break;
			case 37: sItem = "ps_quarterstaff_constructruin";  break;
			case 38: sItem = "ps_rapier_constructruin";  break;
			case 39: sItem = "ps_scimitar_constructruin";  break;
			case 40: sItem = "ps_scythe_constructruin";  break;
			case 41: sItem = "ps_shortsword_constructruin";  break;
			case 42: sItem = "ps_sickle_constructruin";  break;
			case 43: sItem = "ps_spear_constructruin";  break;
			case 44: sItem = "ps_warhammer_constructruin";  break;
			case 45: sItem = "ps_warmace_constructruin";  break;
			case 46: sItem = "ps_bastardsword_deathsruin";  break;
			case 47: sItem = "ps_battleaxe_deathsruin";  break;
			case 48: sItem = "ps_dagger_deathsruin";  break;
			case 49: sItem = "ps_dwarvenwaraxe_deathsruin";  break;
			case 50: sItem = "ps_falchion_deathsruin";  break;
			case 51: sItem = "ps_flail_deathsruin";  break;
			case 52: sItem = "ps_greataxe_deathsruin";  break;
			case 53: sItem = "ps_greatsword_deathsruin";  break;
			case 54: sItem = "ps_halberd_deathsruin";  break;
			case 55: sItem = "ps_handaxe_deathsruin";  break;
			case 56: sItem = "ps_kama_deathsruin";  break;
			case 57: sItem = "ps_katana_deathsruin";  break;
			case 58: sItem = "ps_kukri_deathsruin";  break;
			case 59: sItem = "ps_lighthammer_deathsruin";  break;
			case 60: sItem = "ps_longsword_deathsruin";  break;
			case 61: sItem = "ps_mace_deathsruin";  break;
			case 62: sItem = "ps_morningstar_deathsruin";  break;
			case 63: sItem = "ps_quarterstaff_deathsruin";  break;
			case 64: sItem = "ps_rapier_deathsruin";  break;
			case 65: sItem = "ps_scimitar_deathsruin";  break;
			case 66: sItem = "ps_scythe_deathsruin";  break;
			case 67: sItem = "ps_shortsword_deathsruin";  break;
			case 68: sItem = "ps_sickle_deathsruin";  break;
			case 69: sItem = "ps_spear_deathsruin";  break;
			case 70: sItem = "ps_warhammer_deathsruin";  break;
			case 71: sItem = "ps_warmace_deathsruin";  break;
			case 72: sItem = "ps_bastardsword_elementalruin";  break;
			case 73: sItem = "ps_battleaxe_elementalruin";  break;
			case 74: sItem = "ps_dagger_elementalruin";  break;
			case 75: sItem = "ps_dwarvenwaraxe_elementalruin";  break;
			case 76: sItem = "ps_flail_elementalruin";  break;
			case 77: sItem = "ps_falchion_elementalruin";  break;
			case 78: sItem = "ps_greataxe_elementalruin";  break;
			case 79: sItem = "ps_greatsword_elementalruin";  break;
			case 80: sItem = "ps_halberd_elementalruin";  break;
			case 81: sItem = "ps_handaxe_elementalruin";  break;
			case 82: sItem = "ps_kama_elementalruin";  break;
			case 83: sItem = "ps_katana_elementalruin";  break;
			case 84: sItem = "ps_kukri_elementalruin";  break;
			case 85: sItem = "ps_lighthammer_elementalruin";  break;
			case 86: sItem = "ps_longsword_elementalruin";  break;
			case 87: sItem = "ps_mace_elementalruin";  break;
			case 88: sItem = "ps_morningstar_elementalruin";  break;
			case 89: sItem = "ps_quarterstaff_elementalruin";  break;
			case 90: sItem = "ps_rapier_elementalruin";  break;
			case 91: sItem = "ps_scimitar_elementalruin";  break;
			case 92: sItem = "ps_scythe_elementalruin";  break;
			case 93: sItem = "ps_shortsword_elementalruin";  break;
			case 94: sItem = "ps_sickle_elementalruin";  break;
			case 95: sItem = "ps_spear_elementalruin";  break;
			case 96: sItem = "ps_warhammer_elementalruin";  break;
			case 97: sItem = "ps_warmace_elementalruin";  break;
			case 98: sItem = "ps_bastardsword_masterwork";  break;
			case 99: sItem = "ps_battleaxe_masterwork";  break;
			case 100: sItem = "ps_dagger_masterwork";  break;
			case 101: sItem = "ps_dwarvenwaraxe_masterwork";  break;
			case 102: sItem = "ps_falchion_masterwork";  break;
			case 103: sItem = "ps_flail_masterwork";  break;
			case 104: sItem = "ps_greataxe_masterwork";  break;
			case 105: sItem = "ps_greatsword_masterwork";  break;
			case 106: sItem = "ps_halberd_masterwork";  break;
			case 107: sItem = "ps_handaxe_masterwork";  break;
			case 108: sItem = "ps_kama_masterwork";  break;
			case 109: sItem = "ps_katana_masterwork";  break;
			case 110: sItem = "ps_kukri_masterwork";  break;
			case 111: sItem = "ps_lighthammer_masterwork";  break;
			case 112: sItem = "ps_longsword_masterwork";  break;
			case 113: sItem = "ps_mace_masterwork";  break;
			case 114: sItem = "ps_morningstar_masterwork";  break;
			case 115: sItem = "ps_quarterstaff_masterwork";  break;
			case 116: sItem = "ps_rapier_masterwork";  break;
			case 117: sItem = "ps_scimitar_masterwork";  break;
			case 118: sItem = "ps_scythe_masterwork";  break;
			case 119: sItem = "ps_shortsword_masterwork";  break;
			case 120: sItem = "ps_sickle_masterwork";  break;
			case 121: sItem = "ps_spear_masterwork";  break;
			case 122: sItem = "ps_warhammer_masterwork";  break;
			case 123: sItem = "ps_warmace_masterwork";  break;
			case 124: sItem = "ps_shortsword_feint";  break;
			case 125: sItem = "ps_bow_prowess";  break;
			case 126: sItem = "ps_greataxe_brutal";  break;
			case 127: sItem = "ps_staff_greaterblast";  break;
			case 128: sItem = "ps_kukri_crippling";  break;
			case 129: sItem = "ps_staff_lesserblast";  break;
			case 130: sItem = "ps_rapier_parry";  break;
			case 131: sItem = "ps_staff_magebattle";  break;
			case 132: sItem = "ps_longsword_mirror";  break;
			case 133: sItem = "ps_staff_blasting";  break;
			case 134: sItem = "ps_crossbow_unlimitedammo0";  break;
			case 135: sItem = "ps_crossbow_unlimitedammo1";  break;
			case 136: sItem = "ps_crossbow_unlimitedammo2";  break;
			case 137: sItem = "ps_lcrossbow_unlimitedammo0";  break;
			case 138: sItem = "ps_lcrossbow_unlimitedammo1";  break;
			case 139: sItem = "ps_lcrossbow_unlimitedammo2";  break;
			case 140: sItem = "ps_lbow_unlimitedammo0";  break;
			case 141: sItem = "ps_lbow_unlimitedammo1";  break;
			case 142: sItem = "ps_lbow_unlimitedammo2";  break;
			case 143: sItem = "ps_sbow_unlimitedammo0";  break;
			case 144: sItem = "ps_sbow_unlimitedammo1";  break;
			case 145: sItem = "ps_sbow_unlimitedammo2";  break;
			case 146: sItem = "ps_sling_unlimitedammo0";  break;
			case 147: sItem = "ps_sling_unlimitedammo1";  break;
			case 148: sItem = "ps_sling_unlimitedammo2";  break;
			case 149: sItem = "ps_bastardsword_naturesruin";  break;
			case 150: sItem = "ps_battleaxe_naturesruin";  break;
			case 151: sItem = "ps_dagger_naturesruin";  break;
			case 152: sItem = "ps_falchion_naturesruin";  break;
			case 153: sItem = "ps_flail_naturesruin";  break;
			case 154: sItem = "ps_greataxe_naturesruin";  break;
			case 155: sItem = "ps_greatsword_naturesruin";  break;
			case 156: sItem = "ps_halberd_naturesruin";  break;
			case 157: sItem = "ps_handaxe_naturesruin";  break;
			case 158: sItem = "ps_kama_naturesruin";  break;
			case 159: sItem = "ps_katana_naturesruin";  break;
			case 160: sItem = "ps_kukri_naturesruin";  break;
			case 161: sItem = "ps_lighthammer_naturesruin";  break;
			case 162: sItem = "ps_longsword_naturesruin";  break;
			case 163: sItem = "ps_mace_naturesruin";  break;
			case 164: sItem = "ps_morningstar_naturesruin";  break;
			case 165: sItem = "ps_rapier_naturesruin";  break;
			case 166: sItem = "ps_quarterstaff_naturesruin";  break;
			case 167: sItem = "ps_scimitar_naturesruin";  break;
			case 168: sItem = "ps_scythe_naturesruin";  break;
			case 169: sItem = "ps_shortsword_naturesruin";  break;
			case 170: sItem = "ps_sickle_naturesruin";  break;
			case 171: sItem = "ps_spear_naturesruin";  break;
			case 172: sItem = "ps_dwarvenwaraxe_naturesruin";  break;
			case 173: sItem = "ps_warhammer_naturesruin";  break;
			case 174: sItem = "ps_warmace_naturesruin";  break;
			case 175: sItem = "ps_mace_soldiersmight";  break;
			case 176: sItem = "ps_lightcrossbow_swiftflier";  break;
			case 177: sItem = "ps_dart_teleport";  break;
			case 178: sItem = "ps_shuriken_teleport";  break;
			case 179: sItem = "ps_throwingaxe_teleport";  break;
			case 180: sItem = "ps_bastardsword_truesteel";  break;
			case 181: sItem = "ps_battleaxe_truesteel";  break;
			case 182: sItem = "ps_dagger_truesteel";  break;
			case 183: sItem = "ps_waraxe_truesteel";  break;
			case 184: sItem = "ps_falchion_truesteel";  break;
			case 185: sItem = "ps_flail_truesteel";  break;
			case 186: sItem = "ps_greataxe_truesteel";  break;
			case 187: sItem = "ps_greatsword_truesteel";  break;
			case 188: sItem = "ps_halberd_truesteel";  break;
			case 189: sItem = "ps_handaxe_truesteel";  break;
			case 190: sItem = "ps_kama_truesteel";  break;
			case 191: sItem = "ps_katana_truesteel";  break;
			case 192: sItem = "ps_kukri_truesteel";  break;
			case 193: sItem = "ps_lighthammer_truesteel";  break;
			case 194: sItem = "ps_longsword_truesteel";  break;
			case 195: sItem = "ps_mace_truesteel";  break;
			case 196: sItem = "ps_morningstar_truesteel";  break;
			case 197: sItem = "ps_rapier_truesteel";  break;
			case 198: sItem = "ps_scimitar_truesteel";  break;
			case 199: sItem = "ps_scythe_truesteel";  break;
			case 200: sItem = "ps_shortsword_truesteel";  break;
			case 201: sItem = "ps_sickle_truesteel";  break;
			case 202: sItem = "ps_warhammer_truesteel";  break;
			case 203: sItem = "ps_battleaxe_deepstoneprogeny";  break;
			case 204: sItem = "mst_axgr_slv_3";  break;
			case 205: sItem = "mst_axgr_cld_3";  break;
			case 206: sItem = "mst_axgr_drk_3";  break;
			case 207: sItem = "NW_WAXGR001";  break;
			case 208: sItem = "NW_WAXMGR002";  break;
			case 209: sItem = "NW_WAXMGR009";  break;
			case 210: sItem = "NW_WAXMGR006";  break;
			case 211: sItem = "mst_axgr_mth_3";  break;
			case 212: sItem = "NW_WAXMGR003";  break;
			case 213: sItem = "NW_WAXMGR008";  break;
			case 214: sItem = "mst_axbt_slv_3";  break;
			case 215: sItem = "mst_axdv_slv_3";  break;
			case 216: sItem = "mst_axhn_slv_3";  break;
			case 217: sItem = "NW_WAXBT001";  break;
			case 218: sItem = "NW_WAXMBT002";  break;
			case 219: sItem = "NW_WAXMBT010";  break;
			case 220: sItem = "mst_axbt_cld_3";  break;
			case 221: sItem = "mst_axdv_cld_3";  break;
			case 222: sItem = "mst_axhn_cld_3";  break;
			case 223: sItem = "mst_axbt_drk_3";  break;
			case 224: sItem = "mst_axdv_drk_3";  break;
			case 225: sItem = "mst_axhn_drk_3";  break;
			case 226: sItem = "X2_WDWRAXE001";  break;
			case 227: sItem = "X2_WMDWRAXE003";  break;
			case 228: sItem = "X2_WMDWRAXE002";  break;
			case 229: sItem = "NW_WAXMHN003";  break;
			case 230: sItem = "NW_WAXMHN010";  break;
			case 231: sItem = "NW_WAXMHN002";  break;
			case 232: sItem = "NW_WAXHN001";  break;
			case 233: sItem = "NW_WAXMHN008";  break;
			case 234: sItem = "mst_axbt_mth_3";  break;
			case 235: sItem = "mst_axdv_mth_3";  break;
			case 236: sItem = "mst_axhn_mth_3";  break;
			case 237: sItem = "NW_WAXMBT008";  break;
			case 238: sItem = "NW_IT_NOVEL006";  break;
			case 239: sItem = "NW_WAXMHN004";  break;
			case 240: sItem = "n2_unw_sic3";  break;
			case 241: sItem = "n2_unw_dwa1";  break;
			case 242: sItem = "n2_unw_sli3";  break;
			case 243: sItem = "n2_unw_hal2";  break;
			case 244: sItem = "n2_unw_hxb1";  break;
			case 245: sItem = "n2_unw_dag1";  break;
			case 246: sItem = "n2_unw_hxb2";  break;
			case 247: sItem = "n2_unw_kat1";  break;
			case 248: sItem = "n2_unw_gsw3";  break;
			case 249: sItem = "n2_unw_fal3";  break;
			case 250: sItem = "n2_unw_lsw3";  break;
			case 251: sItem = "n2_unw_sbw3";  break;
			case 252: sItem = "n2_unw_mor1";  break;
			case 253: sItem = "n2_unw_dag12";  break;
			case 254: sItem = "n2_unw_scy3";  break;
			case 255: sItem = "n2_unw_scy2";  break;
			case 256: sItem = "mst_swbs_slv_3";  break;
			case 257: sItem = "NW_WSWBS001";  break;
			case 258: sItem = "NW_WSWMBS002";  break;
			case 259: sItem = "NW_WSWMBS009";  break;
			case 260: sItem = "mst_swbs_cld_3";  break;
			case 261: sItem = "mst_swbs_drk_3";  break;
			case 262: sItem = "mst_swbs_mth_3";  break;
			case 263: sItem = "NW_WSWMBS005";  break;
			case 264: sItem = "mst_swgs_slv_3";  break;
			case 265: sItem = "X1_WSWMGS001";  break;
			case 266: sItem = "mst_swgs_cld_3";  break;
			case 267: sItem = "mst_swgs_drk_3";  break;
			case 268: sItem = "NW_WSWGS001";  break;
			case 269: sItem = "NW_WSWMGS002";  break;
			case 270: sItem = "NW_WSWMGS011";  break;
			case 271: sItem = "NW_WSWMGS009";  break;
			case 272: sItem = "mst_swgs_mth_3";  break;
			case 273: sItem = "NW_WSWMGS005";  break;
			case 274: sItem = "NW_WSWMGS006";  break;
			case 275: sItem = "mst_swdg_slv_3";  break;
			case 276: sItem = "mst_spka_slv_3";  break;
			case 277: sItem = "mst_spku_slv_3";  break;
			case 278: sItem = "mst_spsc_slv_3";  break;
			case 279: sItem = "NW_WSPMSC004";  break;
			case 280: sItem = "mst_swdg_cld_3";  break;
			case 281: sItem = "mst_spka_cld_3";  break;
			case 282: sItem = "nx2_dagger_bottle";  break;
			case 283: sItem = "mst_spku_cld_3";  break;
			case 284: sItem = "mst_spsc_cld_3";  break;
			case 285: sItem = "NW_WSWDG001";  break;
			case 286: sItem = "ps_wizally";  break;
			case 287: sItem = "NW_WSWMDG008";  break;
			case 288: sItem = "mst_swdg_drk_3";  break;
			case 289: sItem = "mst_spka_drk_3";  break;
			case 290: sItem = "mst_spku_drk_3";  break;
			case 291: sItem = "mst_spsc_drk_3";  break;
			case 292: sItem = "NW_WSPMKA006";  break;
			case 293: sItem = "NW_WSPMSC008";  break;
			case 294: sItem = "NW_WSPMSC009";  break;
			case 295: sItem = "NW_WSPMKA004";  break;
			case 296: sItem = "NW_WSPMKA007";  break;
			case 297: sItem = "NW_WSPKA001";  break;
			case 298: sItem = "NW_WSPMKA002";  break;
			case 299: sItem = "NW_WSPMKA008";  break;
			case 300: sItem = "NW_WSPKU001";  break;
			case 301: sItem = "NW_WSPMKU002";  break;
			case 302: sItem = "NW_WSPMKU008";  break;
			case 303: sItem = "NW_WSPMKU003";  break;
			case 304: sItem = "NW_WSPMKU007";  break;
			case 305: sItem = "mst_swdg_mth_3";  break;
			case 306: sItem = "mst_spka_mth_3";  break;
			case 307: sItem = "mst_spku_mth_3";  break;
			case 308: sItem = "mst_spsc_mth_3";  break;
			case 309: sItem = "NW_WSPMKU004";  break;
			case 310: sItem = "NW_WSPMKA005";  break;
			case 311: sItem = "NW_WSWMDG007";  break;
			case 312: sItem = "NW_WSPMKU006";  break;
			case 313: sItem = "NW_WSPSC001";  break;
			case 314: sItem = "NW_WSPMSC002";  break;
			case 315: sItem = "NW_WSPMSC010";  break;
			case 316: sItem = "NW_WSPMSC005";  break;
			case 317: sItem = "NW_WSWMDG006";  break;
			case 318: sItem = "NW_WSPMSC006";  break;
			case 319: sItem = "N2_WSWMDG001";  break;
			case 320: sItem = "X1_WSWMDG001";  break;
			case 321: sItem = "ps_wizally";  break; //The Wizard's Ally
			case 322: sItem = "NW_WSPMKA003";  break;
			case 323: sItem = "mst_swls_slv_3";  break;
			case 324: sItem = "mst_swls_mth_3";  break;
			case 325: sItem = "NW_WSWLS001";  break;
			case 326: sItem = "NW_WSWMLS002";  break;
			case 327: sItem = "NW_WSWMLS010";  break;
			case 328: sItem = "NW_WSWMLS007";  break;
			case 329: sItem = "mst_swss_slv_3";  break;
			case 330: sItem = "NW_WSWMSS005";  break;
			case 331: sItem = "mst_swss_cld_3";  break;
			case 332: sItem = "mst_swss_drk_3";  break;
			case 333: sItem = "NW_WSWMSS008";  break;
			case 334: sItem = "mst_swss_mth_3";  break;
			case 335: sItem = "NW_WSWSS001";  break;
			case 336: sItem = "NW_WSWMSS002";  break;
			case 337: sItem = "NW_WSWMSS009";  break;
			case 338: sItem = "N2_WSWMSS001";  break;
			case 339: sItem = "NW_WSWMSC006";  break;
			case 340: sItem = "mst_swfl_slv_3";  break;
			case 341: sItem = "mst_swka_slv_3";  break;
			case 342: sItem = "mst_swrp_slv_3";  break;
			case 343: sItem = "mst_swsc_slv_3";  break;
			case 344: sItem = "NW_WSWMRP004";  break;
			case 345: sItem = "NW_WSWMRP006";  break;
			case 346: sItem = "mst_swfl_cld_3";  break;
			case 347: sItem = "mst_swka_cld_3";  break;
			case 348: sItem = "mst_swrp_cld_3";  break;
			case 349: sItem = "mst_swsc_cld_3";  break;
			case 350: sItem = "mst_swfl_drk_3";  break;
			case 351: sItem = "mst_swka_drk_3";  break;
			case 352: sItem = "mst_swrp_drk_3";  break;
			case 353: sItem = "mst_swsc_drk_3";  break;
			case 354: sItem = "NW_WSWMSC008";  break;
			case 355: sItem = "N2_WSWFL001";  break;
			case 356: sItem = "N2_WSWMFL001";  break;
			case 357: sItem = "N2_WSWMFL002";  break;
			case 358: sItem = "NW_WSWMKA005";  break;
			case 359: sItem = "N2_WSWMFL008";  break;
			case 360: sItem = "NW_WSWKA001";  break;
			case 361: sItem = "NW_WSWMKA002";  break;
			case 362: sItem = "NW_WSWMKA010";  break;
			case 363: sItem = "mst_swfl_mth_3";  break;
			case 364: sItem = "mst_swka_mth_3";  break;
			case 365: sItem = "mst_swrp_mth_3";  break;
			case 366: sItem = "mst_swsc_mth_3";  break;
			case 367: sItem = "NW_WSWMRP008";  break;
			case 368: sItem = "NW_WSWMRP009";  break;
			case 369: sItem = "NW_WSWRP001";  break;
			case 370: sItem = "NW_WSWMRP002";  break;
			case 371: sItem = "NW_WSWMRP010";  break;
			case 372: sItem = "NW_WSWMRP007";  break;
			case 373: sItem = "NW_WSWMSC005";  break;
			case 374: sItem = "NW_WSWMSC004";  break;
			case 375: sItem = "NW_WBLCL001";  break;
			case 376: sItem = "NW_WBLMCL002";  break;
			case 377: sItem = "NW_WBLMCL010";  break;
			case 378: sItem = "mst_blcl_zal_3";  break;
			case 379: sItem = "NW_WBLMCL004";  break;
			case 380: sItem = "NW_WBLMCL003";  break;
			case 381: sItem = "mst_blcl_dsk_3";  break;
			case 382: sItem = "NW_WBLMCL008";  break;
			case 383: sItem = "x2_it_iwoodclub";  break;
			case 384: sItem = "mst_blfl_slv_3";  break;
			case 385: sItem = "mst_blfl_cld_3";  break;
			case 386: sItem = "mst_blfl_drk_3";  break;
			case 387: sItem = "NW_WBLMFL007";  break;
			case 388: sItem = "NW_WBLFL001";  break;
			case 389: sItem = "NW_WBLMFL002";  break;
			case 390: sItem = "NW_WBLMFL010";  break;
			case 391: sItem = "NW_WBLMFL006";  break;
			case 392: sItem = "NW_WBLMFL008";  break;
			case 393: sItem = "NW_WBLMFL005";  break;
			case 394: sItem = "mst_blfl_mth_3";  break;
			case 395: sItem = "NW_WBLMFL004";  break;
			case 396: sItem = "mst_blhl_slv_3";  break;
			case 397: sItem = "mst_blhw_slv_3";  break;
			case 398: sItem = "mst_blhl_cld_3";  break;
			case 399: sItem = "mst_blhw_cld_3";  break;
			case 400: sItem = "NW_WBLMHL004";  break;
			case 401: sItem = "mst_blhl_drk_3";  break;
			case 402: sItem = "mst_blhw_drk_3";  break;
			case 403: sItem = "NW_WBLMHL006";  break;
			case 404: sItem = "NW_WBLMHL005";  break;
			case 405: sItem = "NW_WBLMHW006";  break;
			case 406: sItem = "NW_WBLMHW003";  break;
			case 407: sItem = "NW_WBLMHW005";  break;
			case 408: sItem = "NW_WBLHL001";  break;
			case 409: sItem = "NW_WBLMHL002";  break;
			case 410: sItem = "NW_WBLMHL010";  break;
			case 411: sItem = "mst_blhl_mth_3";  break;
			case 412: sItem = "mst_blhw_mth_3";  break;
			case 413: sItem = "NW_WBLMHW009";  break;
			case 414: sItem = "NW_WBLMHW010";  break;
			case 415: sItem = "NW_WBLMHL008";  break;
			case 416: sItem = "NW_WBLHW001";  break;
			case 417: sItem = "NW_WBLMHW002";  break;
			case 418: sItem = "NW_WBLMHW011";  break;
			case 419: sItem = "mst_blml_slv_3";  break;
			case 420: sItem = "mst_bldm_slv_3";  break;
			case 421: sItem = "NW_WDBMMA004";  break;
			case 422: sItem = "mst_blml_cld_3";  break;
			case 423: sItem = "mst_bldm_cld_3";  break;
			case 424: sItem = "mst_blml_drk_3";  break;
			case 425: sItem = "mst_bldm_drk_3";  break;
			case 426: sItem = "NW_WDBMMA006";  break;
			case 427: sItem = "NW_WBLMML006";  break;
			case 428: sItem = "NW_WDBMMA008";  break;
			case 429: sItem = "NW_WBLMML004";  break;
			case 430: sItem = "NW_WBLML001";  break;
			case 431: sItem = "NW_WBLMML002";  break;
			case 432: sItem = "NW_WBLMML011";  break;
			case 433: sItem = "NW_WBLMML009";  break;
			case 434: sItem = "mst_blml_mth_3";  break;
			case 435: sItem = "mst_bldm_mth_3";  break;
			case 436: sItem = "NW_WBLMML005";  break;
			case 437: sItem = "NW_WDBMMA005";  break;
			case 438: sItem = "NW_WDBMA001";  break;
			case 439: sItem = "NW_WDBMMA002";  break;
			case 440: sItem = "NW_WDBMMA010";  break;
			case 441: sItem = "mst_blms_slv_3";  break;
			case 442: sItem = "NW_WBLMMS003";  break;
			case 443: sItem = "mst_blms_ada_3";  break;
			case 444: sItem = "mst_blms_drk_3";  break;
			case 445: sItem = "NW_WBLMMS008";  break;
			case 446: sItem = "mst_blms_mth_3";  break;
			case 447: sItem = "NW_WBLMS001";  break;
			case 448: sItem = "NW_WBLMMS002";  break;
			case 449: sItem = "NW_WBLMMS010";  break;
			case 450: sItem = "NW_WBLMMS007";  break;
			case 451: sItem = "NW_WDBMQS003";  break;
			case 452: sItem = "mst_dbqs_dsk_3";  break;
			case 453: sItem = "x2_it_iwoodstaff";  break;
			case 454: sItem = "NW_WDBMQS004";  break;
			case 455: sItem = "NW_WDBQS001";  break;
			case 456: sItem = "NW_WDBMQS002";  break;
			case 457: sItem = "NW_WDBMQS008";  break;
			case 458: sItem = "NW_WDBMQS007";  break;
			case 459: sItem = "NW_WDBMQS005";  break;
			case 460: sItem = "mst_dbqs_zal_3";  break;
			case 461: sItem = "NW_WMGST006";  break;
			case 462: sItem = "NW_WMGST005";  break;
			case 463: sItem = "NW_WMGST004";  break;
			case 464: sItem = "ps_staff_command";  break;
			case 465: sItem = "ps_staff_lessersorcerers";  break;
			case 466: sItem = "ps_staff_lessermages";  break;
			case 467: sItem = "NW_WPLMSS010";  break;
			case 468: sItem = "NW_WPLMSS002";  break;
			case 469: sItem = "NW_WPLSS001";  break;
			case 470: sItem = "NW_WPLMSC009";  break;
			case 471: sItem = "NW_WPLMSC008";  break;
			case 472: sItem = "mst_plss_zal_3";  break;
			case 473: sItem = "NW_WPLMHB004";  break;
			case 474: sItem = "x2_it_venomhb";  break;
			case 475: sItem = "NW_WPLMSS006";  break;
			case 476: sItem = "NW_WPLMSC010";  break;
			case 477: sItem = "NW_WPLMSC002";  break;
			case 478: sItem = "NW_WPLSC001";  break;
			case 479: sItem = "NW_WPLMHB008";  break;
			case 480: sItem = "NW_WPLMSC003";  break;
			case 481: sItem = "mst_plsc_mth_3";  break;
			case 482: sItem = "mst_plhb_mth_3";  break;
			case 483: sItem = "NW_WPLMHB010";  break;
			case 484: sItem = "NW_WPLMHB002";  break;
			case 485: sItem = "NW_WPLHB001";  break;
			case 486: sItem = "NW_WPLMSS008";  break;
			case 487: sItem = "mst_plss_dsk_3";  break;
			case 488: sItem = "mst_plsc_drk_3";  break;
			case 489: sItem = "mst_plhb_drk_3";  break;
			case 490: sItem = "mst_plsc_cld_3";  break;
			case 491: sItem = "mst_plhb_cld_3";  break;
			case 492: sItem = "NW_WPLMSS007";  break;
			case 493: sItem = "NW_WPLMSS005";  break;
			case 494: sItem = "NW_WPLMHB003";  break;
			case 495: sItem = "mst_plsc_slv_3";  break;
			case 496: sItem = "mst_plhb_slv_3";  break;
			case 497: sItem = "NW_WTHMDT006";  break;
			case 498: sItem = "x2_it_acidbomb";  break;
			case 499: sItem = "X1_WMGRENADE001";  break;
			case 500: sItem = "nx2_dart_silver";  break;
			case 501: sItem = "nx2_shuri_silver";  break;
			case 502: sItem = "nx2_taxe_silver";  break;
			case 503: sItem = "X1_WMGRENADE002";  break;
			case 504: sItem = "NW_WTHMDT004";  break;
			case 505: sItem = "NW_WTHMAX004";  break;
			case 506: sItem = "NW_WTHMAX005";  break;
			case 507: sItem = "X1_WMGRENADE004";  break;
			case 508: sItem = "nx2_dart_ciron";  break;
			case 509: sItem = "nx2_shuri_ciron";  break;
			case 510: sItem = "nx2_taxe_ciron";  break;
			case 511: sItem = "NW_WTHDT001";  break;
			case 512: sItem = "NW_WTHMDT002";  break;
			case 513: sItem = "NW_WTHMDT008";  break;
			case 514: sItem = "NW_WTHMDT009";  break;
			case 515: sItem = "NW_WTHMAX007";  break;
			case 516: sItem = "NW_WTHMDT003";  break;
			case 517: sItem = "x2_it_firebomb";  break;
			case 518: sItem = "NW_WTHMSH007";  break;
			case 519: sItem = "n2_it_acid_3";  break;
			case 520: sItem = "n2_it_chok_3";  break;
			case 521: sItem = "n2_it_alch_3";  break;
			case 522: sItem = "n2_it_tang_3";  break;
			case 523: sItem = "n2_it_holy_3";  break;
			case 524: sItem = "n2_it_tang_3";  break;
			case 525: sItem = "n2_it_thun_3";  break;
			case 526: sItem = "X1_WMGRENADE005";  break;
			case 527: sItem = "NW_WTHMDT005";  break;
			case 528: sItem = "n2_it_acid_2";  break;
			case 529: sItem = "n2_it_chok_2";  break;
			case 530: sItem = "n2_it_alch_2";  break;
			case 531: sItem = "n2_it_tang_2";  break;
			case 532: sItem = "n2_it_holy_2";  break;
			case 533: sItem = "n2_it_tang_2";  break;
			case 534: sItem = "n2_it_thun_2";  break;
			case 535: sItem = "n2_it_acid_4";  break;
			case 536: sItem = "n2_it_chok_4";  break;
			case 537: sItem = "n2_it_alch_4";  break;
			case 538: sItem = "n2_it_tang_4";  break;
			case 539: sItem = "n2_it_holy_4";  break;
			case 540: sItem = "n2_it_tang_4";  break;
			case 541: sItem = "n2_it_thun_4";  break;
			case 542: sItem = "NW_WTHMSH006";  break;
			case 543: sItem = "NW_WTHMAX006";  break;
			case 544: sItem = "NW_WTHMSH005";  break;
			case 545: sItem = "NW_WTHSH001";  break;
			case 546: sItem = "NW_WTHMSH002";  break;
			case 547: sItem = "NW_WTHMSH008";  break;
			case 548: sItem = "NW_WTHMSH009";  break;
			case 549: sItem = "NW_WTHMSH003";  break;
			case 550: sItem = "X1_WMGRENADE006";  break;
			case 551: sItem = "NW_WTHAX001";  break;
			case 552: sItem = "NW_WTHMAX002";  break;
			case 553: sItem = "NW_WTHMAX008";  break;
			case 554: sItem = "NW_WTHMAX009";  break;
			case 555: sItem = "mwr_bwxh_dsk_4";  break;
			case 556: sItem = "NW_WBWMXH004";  break;
			case 557: sItem = "mwr_bwxl_dsk_4";  break;
			case 558: sItem = "NW_WBWMXH005";  break;
			case 559: sItem = "NW_WBWMXH007";  break;
			case 560: sItem = "NW_WBWXH001";  break;
			case 561: sItem = "NW_WBWMXH002";  break;
			case 562: sItem = "NW_WBWMXH008";  break;
			case 563: sItem = "NW_WBWMXH009";  break;
			case 564: sItem = "NW_WBWXL001";  break;
			case 565: sItem = "NW_WBWMXL002";  break;
			case 566: sItem = "NW_WBWMXL008";  break;
			case 567: sItem = "N2_WBWMXH001";  break;
			case 568: sItem = "NW_WBWMXL009";  break;
			case 569: sItem = "N2_WBWMXL001";  break;
			case 570: sItem = "NW_WBWMXL005";  break;
			case 571: sItem = "mwr_bwxh_shd_3";  break;
			case 572: sItem = "mwr_bwxl_shd_3";  break;
			case 573: sItem = "mwr_bwxh_zal_3";  break;
			case 574: sItem = "mwr_bwxl_zal_3";  break;
			case 575: sItem = "NW_WBWMLN010";  break;
			case 576: sItem = "NW_WBWMLN011";  break;
			case 577: sItem = "NW_WBWMLN002";  break;
			case 578: sItem = "NW_WBWLN001";  break;
			case 579: sItem = "NW_WBWMLN008";  break;
			case 580: sItem = "nx2_clbow_dprecise";  break;
			case 581: sItem = "nx2_clbow_precise";  break;
			case 582: sItem = "nx2_clbow_05";  break;
			case 583: sItem = "mwr_bwln_dsk_4";  break;
			case 584: sItem = "NW_WBWMLN004";  break;
			case 585: sItem = "NW_WBWMLN006";  break;
			case 586: sItem = "mwr_bwln_shd_3";  break;
			case 587: sItem = "N2_WBWMLN002";  break;
			case 588: sItem = "mwr_bwln_zal_3";  break;
			case 589: sItem = "NW_WBWMSH011";  break;
			case 590: sItem = "NW_WBWMSH010";  break;
			case 591: sItem = "mwr_bwsh_dsk_4";  break;
			case 592: sItem = "NW_WBWMSH003";  break;
			case 593: sItem = "mwr_bwsh_shd_3";  break;
			case 594: sItem = "NW_WBWSH001";  break;
			case 595: sItem = "NW_WBWMSH002";  break;
			case 596: sItem = "NW_WBWMSH008";  break;
			case 597: sItem = "NW_WBWMSH009";  break;
			case 598: sItem = "mwr_bwsh_zal_3";  break;
			case 599: sItem = "N2_WBWMSH002";  break;
			case 600: sItem = "NW_WBWMSL007";  break;
			case 601: sItem = "NW_WBWSL001";  break;
			case 602: sItem = "NW_WBWMSL001";  break;
			case 603: sItem = "NW_WBWMSL009";  break;
			case 604: sItem = "NW_WBWMSL010";  break;
			case 605: sItem = "NW_WBWMSL005";  break;
			case 606: sItem = "ps_staff_abyssaliron";  break;
			case 607: sItem = "ps_greatsword_afterlife";  break;
			case 608: sItem = "ps_staff_celestialmight";  break;
			case 609: sItem = "ps_spear_conflagrant";  break;
			case 610: sItem = "ps_warmace_enervatingstrike";  break;
			case 611: sItem = "ps_staff_wavesanddepths";  break;
			case 612: sItem = "ps_staff_windsandsky";  break;
			case 613: sItem = "ps_mace_undying";  break;
			case 614: sItem = "ps_longsword_courage";  break;
			case 615: sItem = "ps_bow_foulwind";  break;
			case 616: sItem = "ps_longsword_atonement";  break;
			case 617: sItem = "ps_crossbow_souleating";  break;
			case 618: sItem = "ps_cudgelidiocy";  break;
			case 619: sItem = "ps_dagger_grievous";  break;
			case 620: sItem = "ps_crossbow_darklauncher";  break;
			case 621: sItem = "ps_flachion_executioner";  break;
			case 622: sItem = "ps_hammer_recreation";  break;		
			case 623: sItem = "ps_kukri_hamstring";  break;		
			case 624: sItem = "ps_heartseeker";  break;		
			case 625: sItem = "ps_scimitar_jinxing";  break;		
			case 626: sItem = "ps_spear_lightning";  break;		
			case 627: sItem = "ps_sickle_lunaravenger";  break;					
			case 628: sItem = "ps_warmace_smashing";  break;	
			case 629: sItem = "ps_staff_salt";  break;	
			case 630: sItem = "ps_blade_screaming";  break;	
			case 631: sItem = "ps_handaxe_shacklecutter";  break;	
			case 632: sItem = "ps_sling_warding";  break;	
			case 633: sItem = "ps_staff_apprentice";  break;	
			case 634: sItem = "ps_sickle_taintedharvest";  break;	
			case 635: sItem = "ps_flail_entangler";  break;	
			case 636: sItem = "ps_rapier_water";  break;
			case 637: sItem = "ps_greataxe_cursed-1";  break;
			case 638: sItem = "ps_battleaxe_cursed-1";  break;
			case 639: sItem = "ps_waraxe_cursed-1";  break;
			case 640: sItem = "ps_handaxe_cursed-1";  break;
			case 641: sItem = "ps_bastardsword_cursed-1";  break;
			case 642: sItem = "ps_greatsword_cursed-1";  break;
			case 643: sItem = "ps_greatsword_cursed-2";  break;
			case 644: sItem = "ps_dagger_cursed-1";  break;
			case 645: sItem = "ps_kama_cursed-1";  break;
			case 646: sItem = "ps_kukri_cursed-1";  break;
			case 647: sItem = "ps_sickle_cursed-1";  break;
			case 648: sItem = "ps_longsword_cursed-1";  break;
			case 649: sItem = "ps_falchion_cursed-1";  break;
			case 650: sItem = "ps_katana_cursed-1";  break;
			case 651: sItem = "ps_rapier_cursed-1";  break;
			case 652: sItem = "ps_scimitar_cursed-1";  break;
			case 653: sItem = "ps_shortsword_cursed-1";  break;
			case 654: sItem = "ps_club_cursed-1";  break;
			case 655: sItem = "ps_flail_cursed-1";  break;
			case 656: sItem = "ps_lighthammer_cursed-1";  break;
			case 657: sItem = "ps_warhammer_cursed-1";  break;
			case 658: sItem = "ps_mace_cursed-1";  break;
			case 659: sItem = "ps_warmace_cursed-1";  break;
			case 660: sItem = "ps_morningstar_cursed-1";  break;
			case 661: sItem = "ps_quarterstaff_cursed-1";  break;
			case 662: sItem = "ps_halberd_cursed-1";  break;
			case 663: sItem = "ps_scythe_cursed-1";  break;
			case 664: sItem = "ps_spear_cursed-1";  break;
			case 665: sItem = "ps_heavyxbow_cursed-1";  break;
			case 666: sItem = "ps_lightxbow_cursed-1";  break;
			case 667: sItem = "ps_longbow_cursed-1";  break;
			case 668: sItem = "ps_shortbow_cursed-1";  break;
			case 669: sItem = "ps_sling_cursed-1";  break;		
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS)
	 {
		nItem = Random(90) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_lightarmor_broewndefamily";  break;
			case 2: sItem = "ps_lightarmor_jaredwidowmaker";  break;
			case 3: sItem = "ps_clothing_lessermagesrobe";  break;
			case 4: sItem = "ps_clothing_lessersorcerersrobe";  break;
			case 5: sItem = "ps_clothing_vestofescape";  break;
			case 6: sItem = "ps_armor_astralbreast";  break;
			case 7: sItem = "ps_mediumarmor_scattertrailhide";  break;
			case 8: sItem = "ps_heavyarmor_freedom";  break;
			case 9: sItem = "ps_armor_astralband";  break;
			case 10: sItem = "ps_armor_astralfull";  break;
			case 11: sItem = "ps_armor_astralhalf";  break;
			case 12: sItem = "NW_MCLOTH011";  break;
			case 13: sItem = "NW_MCLOTH014";  break;
			case 14: sItem = "NW_MCLOTH013";  break;
			case 15: sItem = "NW_MCLOTH006";  break;
			case 16: sItem = "X0_CLOTH003";  break;
			case 17: sItem = "NW_MCLOTH017";  break;
			case 18: sItem = "NW_MCLOTH015";  break;
			case 19: sItem = "NW_MCLOTH018";  break;
			case 20: sItem = "NW_MCLOTH019";  break;
			case 21: sItem = "NW_MAARCL021";  break;
			case 22: sItem = "NW_AARCL011";  break;
			case 23: sItem = "NW_MAARCL051";  break;
			case 24: sItem = "NW_MAARCL064";  break;
			case 25: sItem = "n2_pca_bguard";  break;
			case 26: sItem = "mwa_hvbm_drk_3";  break;
			case 27: sItem = "mwa_hvfp_drk_3";  break;
			case 28: sItem = "mwa_hvhp_drk_3";  break;
			case 29: sItem = "NW_MAARCL024";  break;
			case 30: sItem = "NW_MAARCL022";  break;
			case 31: sItem = "NW_AARCL007";  break;
			case 32: sItem = "NW_MAARCL053";  break;
			case 33: sItem = "NW_MAARCL068";  break;
			case 34: sItem = "NW_AARCL006";  break;
			case 35: sItem = "NW_MAARCL052";  break;
			case 36: sItem = "NW_MAARCL069";  break;
			case 37: sItem = "NW_MAARCL026";  break;
			case 38: sItem = "NW_MAARCL059";  break;
			case 39: sItem = "mwa_ltcs_ada_4";  break;
			case 40: sItem = "NW_MAARCL011";  break;
			case 41: sItem = "NW_MAARCL013";  break;
			case 42: sItem = "NW_MAARCL032";  break;
			case 43: sItem = "NW_MAARCL012";  break;
			case 44: sItem = "P_HHM_CH01";  break;
			case 45: sItem = "NW_MAARCL046";  break;
			case 46: sItem = "NW_MAARCL067";  break;
			case 47: sItem = "mwa_ltcs_drk_3";  break;
			case 48: sItem = "NW_AARCL001";  break;
			case 49: sItem = "NW_MAARCL044";  break;
			case 50: sItem = "NW_MAARCL071";  break;
			case 51: sItem = "NW_MAARCL072";  break;
			case 52: sItem = "NW_MAARCL043";  break;
			case 53: sItem = "NW_AARCL009";  break;
			case 54: sItem = "NW_MAARCL007";  break;
			case 55: sItem = "NW_AARCL002";  break;
			case 56: sItem = "NW_MAARCL045";  break;
			case 57: sItem = "NW_MAARCL075";  break;
			case 58: sItem = "NW_MAARCL065";  break;
			case 59: sItem = "NW_MAARCL049";  break;
			case 60: sItem = "NW_AARCL010";  break;
			case 61: sItem = "NW_AARCL004";  break;
			case 62: sItem = "NW_MAARCL035";  break;
			case 63: sItem = "NW_MAARCL066";  break;
			case 64: sItem = "mwa_mdbp_drk_3";  break;
			case 65: sItem = "mwa_mdsm_drk_3";  break;
			case 66: sItem = "mwa_mdcm_drk_3";  break;
			case 67: sItem = "NW_AARCL008";  break;
			case 68: sItem = "NW_MAARCL047";  break;
			case 69: sItem = "NW_MAARCL070";  break;
			case 70: sItem = "NW_AARCL003";  break;
			case 71: sItem = "NW_MAARCL048";  break;
			case 72: sItem = "NW_MAARCL073";  break;
			case 73: sItem = "ps_breastplate_sunflame";  break;
			case 74: sItem = "ps_hide_beastskin";  break;
			case 75: sItem = "ps_bonearmor";  break;
			case 76: sItem = "ps_cinderarmor";  break;
			case 77: sItem = "ps_leather_zombie";  break;
			case 78: sItem = "ps_rags_cursed-1";  break;
			case 79: sItem = "ps_bandedmail_cursed-1";  break;
			case 80: sItem = "ps_fullplate_cursed-1";  break;
			case 81: sItem = "ps_halfplate_cursed-1";  break;
			case 82: sItem = "ps_chainshirt_cursed-1";  break;
			case 83: sItem = "ps_leather_cursed-1";  break;
			case 84: sItem = "ps_leather_cursed-2";  break;
			case 85: sItem = "ps_paddedarmor_cursed-1";  break;
			case 86: sItem = "ps_studdedleather_cursed-1";  break;
			case 87: sItem = "ps_breastplate_cursed-1";  break;
			case 88: sItem = "ps_chainmail_cursed-1";  break;
			case 89: sItem = "ps_hidearmor_cursed-1";  break;
			case 90: sItem = "ps_scalemail_cursed-1";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS)
	 {
		nItem = Random(18) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_boots_dashingboots";  break;
			case 2: sItem = "ps_boots_kickingboots";  break;
			case 3: sItem = "ps_boots_sturdyfeetofpim";  break;
			case 4: sItem = "NW_IT_MBOOTS002";  break;
			case 5: sItem = "NW_IT_MBOOTS015";  break;
			case 6: sItem = "nw_it_mboots010";  break;
			case 7: sItem = "nw_it_mboots011";  break;
			case 8: sItem = "NW_IT_MBOOTS001";  break;
			case 9: sItem = "NW_IT_MBOOTS006";  break;
			case 10: sItem = "NW_IT_MBOOTS018";  break;
			case 11: sItem = "NW_IT_MBOOTS019";  break;
			case 12: sItem = "X0_IT_MBOOTS001";  break;
			case 13: sItem = "X0_IT_MBOOTS003";  break;
			case 14: sItem = "X0_IT_MBOOTS002";  break;
			case 15: sItem = "ps_boots_cursed-1";  break;
			case 16: sItem = "ps_boots_cursed-2";  break;
			case 17: sItem = "ps_boots_cursed-3";  break;
			case 18: sItem = "ps_boots_cursed-4";  break;
			case 19: sItem = "ps_bt_quickling_l";  break;
			case 20: sItem = "ps_bt_tap";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS)
	 {
		nItem = Random(18) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_cloak_blackflame";  break;
			case 2: sItem = "X0_MAARCL030";  break;
			case 3: sItem = "NW_MAARCL057";  break;
			case 4: sItem = "NW_MAARCL104";  break;
			case 5: sItem = "NW_MAARCL055";  break;
			case 6: sItem = "NW_MAARCL088";  break;
			case 7: sItem = "nw_maarcl098";  break;
			case 8: sItem = "nw_maarcl097";  break;
			case 9: sItem = "nw_maarcl096";  break;
			case 10: sItem = "nw_maarcl099";  break;
			case 11: sItem = "X0_MAARCL025";  break;
			case 12: sItem = "X0_MAARCL026";  break;
			case 13: sItem = "NW_MAARCL030";  break;
			case 14: sItem = "NW_MAARCL031";  break;
			case 15: sItem = "NW_MAARCL092";  break;
			case 16: sItem = "X1_IT_MCLOAK001";  break;
			case 17: sItem = "ps_cloak_shadow";  break;
			case 18: sItem = "ps_cloak_cursed-1";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS)
	 {
		nItem = Random(33) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_gloves_swordplaying";  break;
			case 2: sItem = "ps_gloves_healer";  break;
			case 3: sItem = "ps_gloves_lesserweaponhandling";  break;
			case 4: sItem = "ps_gloves_trappers";  break;
			case 5: sItem = "X0_IT_MBRACER001";  break;
			case 6: sItem = "NW_IT_MBRACER002";  break;
			case 7: sItem = "NW_IT_MBRACER007";  break;
			case 8: sItem = "NW_IT_MBRACER001";  break;
			case 9: sItem = "NW_IT_MBRACER003";  break;
			case 10: sItem = "X1_IT_MGLOVE001";  break;
			case 11: sItem = "NW_IT_MBRACER013";  break;
			case 12: sItem = "X0_IT_MGLOVE001";  break;
			case 13: sItem = "nw_it_mglove004";  break;
			case 14: sItem = "nw_it_mglove007";  break;
			case 15: sItem = "nw_it_mglove009";  break;
			case 16: sItem = "X0_IT_MGLOVE003";  break;
			case 17: sItem = "NW_IT_MGLOVE016";  break;
			case 18: sItem = "NW_IT_MGLOVE017";  break;
			case 19: sItem = "NW_IT_MGLOVE022";  break;
			case 20: sItem = "NW_IT_MGLOVE021";  break;
			case 21: sItem = "nw_it_mglove005";  break;
			case 22: sItem = "NW_IT_MGLOVE003";  break;
			case 23: sItem = "NW_IT_MGLOVE026";  break;
			case 24: sItem = "NW_IT_MGLOVE027";  break;
			case 25: sItem = "NW_IT_MBRACER012";  break;
			case 26: sItem = "x2_nash_glove";  break;
			case 27: sItem = "ps_gauntlets_anarchic";  break;
			case 28: sItem = "ps_gauntlets_axiomatic";  break;
			case 29: sItem = "ps_gauntlets_holy";  break;
			case 30: sItem = "ps_gauntlets_unholy";  break;
			case 31: sItem = "ps_gloves_cursed-1";  break;
			case 32: sItem = "ps_gloves_cursed-2";  break;
			case 33: sItem = "ps_gloves_cursed-3";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS)
	 {
		nItem = Random(12) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_belt_agility+1";  break;
			case 2: sItem = "ps_belt_agility+2";  break;
			case 3: sItem = "ps_belt_lesserguidinglight";  break;
			case 4: sItem = "ps_belt_encirclingscale";  break;
			case 5: sItem = "nx2_belt_str_02";  break;
			case 6: sItem = "nx2_belt_magebelt";  break;
			case 7: sItem = "nx2_belt_bpouch";  break;
			case 8: sItem = "NW_IT_MBELT005";  break;
			case 9: sItem = "nx2_belt_rogueharness";  break;
			case 10: sItem = "ps_belt_cursed-1";  break;
			case 11: sItem = "ps_belt_cursed-2";  break;
			case 12: sItem = "ps_belt_cursed-3";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS)
	 {
		nItem = Random(17) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_helmet_blindsight";  break;
			case 2: sItem = "ps_helmet_goldencirclet";  break;
			case 3: sItem = "x2_it_adahelm";  break;
			case 4: sItem = "NW_ARMHE012";  break;
			case 5: sItem = "X0_ARMHE009";  break;
			case 6: sItem = "X0_ARMHE016";  break;
			case 7: sItem = "NW_ARMHE011";  break;
			case 8: sItem = "X0_ARMHE001";  break;
			case 9: sItem = "NW_ARMHE008";  break;
			case 10: sItem = "ps_hat_friendship";  break;
			case 11: sItem = "ps_helm_bewilderment";  break;
			case 12: sItem = "ps_helm_blindness";  break;
			case 13: sItem = "ps_helm_hopelessness";  break;
			case 14: sItem = "ps_helm_terror";  break;
			case 15: sItem = "ps_helmfarseeing";  break;
			case 16: sItem = "ps_helmet_cursed-1";  break;
			case 17: sItem = "ps_helmet_cursed-2";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS)
	 {
		nItem = Random(37) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_towershield_astraldrift";  break;
			case 2: sItem = "ps_lightshield_astraldrift";  break;
			case 3: sItem = "ps_heavyshield_astraldrift";  break;
			case 4: sItem = "mwa_shhv_drk_3";  break;
			case 5: sItem = "mwa_shhv_dsk_3";  break;
			case 6: sItem = "X2_IT_IWOODSHLDL";  break;
			case 7: sItem = "NW_ASHLW001";  break;
			case 8: sItem = "NW_ASHMLW002";  break;
			case 9: sItem = "NW_ASHMLW008";  break;
			case 10: sItem = "X0_ASHMLW003";  break;
			case 11: sItem = "mwa_shhv_zal_3";  break;
			case 12: sItem = "mwa_shlt_drk_3";  break;
			case 13: sItem = "mwa_shlt_dsk_3";  break;
			case 14: sItem = "NW_ASHMSW005";  break;
			case 15: sItem = "x2_it_ironwshlds";  break;
			case 16: sItem = "NW_ASHSW001";  break;
			case 17: sItem = "NW_ASHMSW002";  break;
			case 18: sItem = "NW_ASHMSW008";  break;
			case 19: sItem = "NW_ASHMSW003";  break;
			case 20: sItem = "nw_ashmsw010";  break;
			case 21: sItem = "nw_ashmsw011";  break;
			case 22: sItem = "mwa_shtw_drk_3";  break;
			case 23: sItem = "mwa_shtw_dsk_3";  break;
			case 24: sItem = "NW_ASHMTO005";  break;
			case 25: sItem = "nw_ashmto010";  break;
			case 26: sItem = "nw_ashmto011";  break;
			case 27: sItem = "x2_it_ironwshldt";  break;
			case 28: sItem = "NW_ASHTO001";  break;
			case 29: sItem = "NW_ASHMTO002";  break;
			case 30: sItem = "NW_ASHMTO008";  break;
			case 31: sItem = "ps_shield_elements";  break;
			case 32: sItem = "ps_shield_holy";  break;
			case 33: sItem = "ps_shieldofdeflection";  break;
			case 34: sItem = "ps_heavyshield_cursed-1";  break;
			case 35: sItem = "ps_lightshield_cursed-1";  break;
			case 36: sItem = "ps_towershield_cursed-1";  break;
			case 37: sItem = "ps_towershield_cursed-2";  break;
		}
     }
	 else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS + SCOD_JEWELRY)
	 {
		nItem = Random(70) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_amulet_lesserhealth";  break;
			case 2: sItem = "ps_ring_bonering";  break;
			case 3: sItem = "ps_ring_acidresistancelesser";  break;
			case 4: sItem = "ps_ring_lessercharming";  break;
			case 5: sItem = "ps_ring_coldresistancelesser";  break;
			case 6: sItem = "ps_ring_electricresistancelesser";  break;
			case 7: sItem = "ps_ring_fireresistancelesser";  break;
			case 8: sItem = "ps_ring_sonicresistancelesser";  break;
			case 9: sItem = "ps_ring_purpledragonsring";  break;
			case 10: sItem = "ps_ring_lesserarcher";  break;
			case 11: sItem = "ps_ring_lesserbrawler";  break;
			case 12: sItem = "ps_ring_lesserswordsman";  break;
			case 13: sItem = "ps_ring_charming";  break;
			case 14: sItem = "ps_ring_diseaseresistance";  break;
			case 15: sItem = "NW_IT_MNECK001";  break;
			case 16: sItem = "NW_IT_MNECK012";  break;
			case 17: sItem = "X0_IT_MNECK001";  break;
			case 18: sItem = "nw_it_mneck024";  break;
			case 19: sItem = "nw_it_mneck025";  break;
			case 20: sItem = "X2_IT_MNECK001";  break;
			case 21: sItem = "X0_IT_MNECK005";  break;
			case 22: sItem = "NW_IT_MNECK020";  break;
			case 23: sItem = "NW_IT_MNECK023";  break;
			case 24: sItem = "X0_IT_MNECK007";  break;
			case 25: sItem = "X0_IT_MNECK002";  break;
			case 26: sItem = "X0_IT_MNECK004";  break;
			case 27: sItem = "X2_IT_MNECK005";  break;
			case 28: sItem = "NW_IT_MNECK003";  break;
			case 29: sItem = "NW_IT_MNECK007";  break;
			case 30: sItem = "NW_IT_MNECK008";  break;
			case 31: sItem = "NW_IT_MNECK021";  break;
			case 32: sItem = "NW_IT_MNECK016";  break;
			case 33: sItem = "NW_IT_MNECK006";  break;
			case 34: sItem = "NW_IT_MRING021";  break;
			case 35: sItem = "NW_IT_MRING006";  break;
			case 36: sItem = "NW_IT_MRING014";  break;
			case 37: sItem = "ps_ring_necro";  break;
			case 38: sItem = "ps_ring_nullification";  break;
			case 39: sItem = "ps_ring_summon";  break;
			case 40: sItem = "NW_IT_MRING010";  break;
			case 41: sItem = "NW_IT_MRING009";  break;
			case 42: sItem = "n2_it_mring006";  break;
			case 43: sItem = "n2_it_mring002";  break;
			case 44: sItem = "n2_it_mring003";  break;
			case 45: sItem = "X0_IT_MRING005";  break;
			case 46: sItem = "nw_it_mring024";  break;
			case 47: sItem = "nw_it_mring025";  break;
			case 48: sItem = "NW_IT_MRING012";  break;
			case 49: sItem = "NW_IT_MRING011";  break;
			case 50: sItem = "NW_IT_MRING005";  break;
			case 51: sItem = "NW_IT_MRING001";  break;
			case 52: sItem = "NW_IT_MRING008";  break;
			case 53: sItem = "NW_IT_MRING031";  break;
			case 54: sItem = "NW_IT_MRING013";  break;
			case 55: sItem = "n2_it_mring009";  break;
			case 56: sItem = "n2_it_mring008";  break;
			case 57: sItem = "n2_it_mring007";  break;
			case 58: sItem = "NW_IT_NOVEL001";  break;
			case 59: sItem = "NW_IT_MRING022";  break;
			case 60: sItem = "ps_ring_unluck";  break;
			case 61: sItem = "ps_neclase_cursed-1";  break;
			case 62: sItem = "ps_neclase_cursed-2";  break;
			case 63: sItem = "ps_neclase_cursed-3";  break;
			case 64: sItem = "ps_ring_cursed-1";  break;
			case 65: sItem = "ps_ring_cursed-2";  break;
			case 66: sItem = "ps_ring_cursed-3";  break;
			case 67: sItem = "ps_poly_mg_abylt";  break;
			case 68: sItem = "ps_ring_ultravision"; break;
			case 69: sItem = "ps_misc_hornofvalkyrie"; break;
			case 70: sItem = "ps_ring_bells"; break; 
		}
     }
	 else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS + SCOD_JEWELRY + SCOD_MISC)
	 {
		nItem = Random(36) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_container_magicpouch";  break;
			case 2: sItem = "ps_container_lesserbag";  break;
			case 3: sItem = "ps_instrument_canaithmandolin";  break;
			case 4: sItem = "ps_instrument_dosslute";  break;
			case 5: sItem = "ps_instrument_lingeringdrum";  break;
			case 6: sItem = "ps_instrument_hauntingdrum";  break;
			case 7: sItem = "ps_instrument_fifeblasting";  break;
			case 8: sItem = "ps_instrument_lingeringflute";  break;
			case 9: sItem = "ps_instrument_fochluchanbandore";  break;
			case 10: sItem = "ps_instrument_lingeringlute";  break;
			case 11: sItem = "ps_instrument_charmlute";  break;
			case 12: sItem = "ps_instrument_macfuirmidhcithern";  break;
			case 13: sItem = "ps_misc_alchemistpoisonset";  break;
			case 14: sItem = "ps_misc_bindedfang";  break;
			case 15: sItem = "ps_misc_iounstone01";  break;
			case 16: sItem = "ps_misc_iounstone02";  break;
			case 17: sItem = "ps_misc_voodoodoll";  break;
			case 18: sItem = "ps_misc_exoticperfume";  break;
			case 19: sItem = "ps_misc_iounstone03";  break;
			case 20: sItem = "ps_misc_ghoulshand";  break;
			case 21: sItem = "ps_misc_impskull";  break;
			case 22: sItem = "ps_misc_iounstone04";  break;
			case 23: sItem = "ps_misc_iounstone05";  break;
			case 24: sItem = "ps_misc_iounstone06";  break;
			case 25: sItem = "ps_misc_iounstone07";  break;
			case 26: sItem = "X0_IT_MSMLMISC01";  break;
			case 27: sItem = "X0_IT_MSMLMISC02";  break;
			case 28: sItem = "nx2_misc_lifecoin";  break;
			case 29: sItem = "X0_IT_MTHNMISC04";  break;
			case 30: sItem = "X0_IT_MTHNMISC05";  break;
			case 31: sItem = "X0_IT_MTHNMISC06";  break;
			case 32: sItem = "X0_IT_MTHNMISC13";  break;
			case 33: sItem = "X0_IT_MSMLMISC05";  break;
			case 34: sItem = "X0_IT_MTHNMISC21";  break;
			case 35: sItem = "ps_scripture_unbinding";  break;
			case 36: sItem = "ps_rock-cursed-1";  break;
		}
     }
	 
	 return sItem;
	}
	
	string MediumSCODitem()
	{
	 int nRandom = d100();
	 string sItem = "";
	 int nItem = 0;
	 
	 if (nRandom <= SCOD_WEAPONS)
	 {
		nItem = Random(231) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_crossbow_unlimitedammo3";  break;
			case 2: sItem = "ps_crossbow_unlimitedammo4";  break;
			case 3: sItem = "ps_lcrossbow_unlimitedammo3";  break;
			case 4: sItem = "ps_lcrossbow_unlimitedammo4";  break;
			case 5: sItem = "ps_lbow_unlimitedammo3";  break;
			case 6: sItem = "ps_lbow_unlimitedammo4";  break;
			case 7: sItem = "ps_sbow_unlimitedammo3";  break;
			case 8: sItem = "ps_sbow_unlimitedammo4";  break;
			case 9: sItem = "ps_sling_unlimitedammo3";  break;
			case 10: sItem = "ps_sling_unlimitedammo4";  break;
			case 11: sItem = "NW_WAXMGR004";  break;
			case 12: sItem = "N2_WAXMGR001";  break;
			case 13: sItem = "NW_WAXMGR011";  break;
			case 14: sItem = "X0_WAXMGR001";  break;
			case 15: sItem = "NW_WAXMGR005";  break;
			case 16: sItem = "X1_WAXMGR001";  break;
			case 17: sItem = "NW_WAXMGR010";  break;
			case 18: sItem = "NW_WAXMBT003";  break;
			case 19: sItem = "NW_WAXMBT011";  break;
			case 20: sItem = "X0_WAXMBT001";  break;
			case 21: sItem = "NW_WAXMHN005";  break;
			case 22: sItem = "X2_WMDWRAXE004";  break;
			case 23: sItem = "X2_WMDWRAXE005";  break;
			case 24: sItem = "X0_WAXMHN001";  break;
			case 25: sItem = "NW_WAXMHN011";  break;
			case 26: sItem = "NW_WAXMHN009";  break;
			case 27: sItem = "NW_WAXMBT004";  break;
			case 28: sItem = "NW_WAXMHN006";  break;
			case 29: sItem = "NW_WAXMBT009";  break;
			case 30: sItem = "N2_WAXMBT001";  break;
			case 31: sItem = "n2_unw_bst3";  break;
			case 32: sItem = "n2_unw_rap2";  break;
			case 33: sItem = "n2_unw_bax3";  break;
			case 34: sItem = "n2_unw_lsw2";  break;
			case 35: sItem = "n2_unw_ssw2";  break;
			case 36: sItem = "n2_unw_gax3";  break;
			case 37: sItem = "n2_unw_gax2";  break;
			case 38: sItem = "n2_unw_mor3";  break;
			case 39: sItem = "n2_unw_lbw2";  break;
			case 40: sItem = "n2_unw_scy1";  break;
			case 41: sItem = "n2_unw_gax1";  break;
			case 42: sItem = "n2_unw_clb2";  break;
			case 43: sItem = "n2_unw_lbw1";  break;
			case 44: sItem = "n2_unw_sci3";  break;
			case 45: sItem = "n2_unw_kuk2";  break;
			case 46: sItem = "n2_unw_kat2";  break;
			case 47: sItem = "n2_unw_lbw3";  break;
			case 48: sItem = "n2_unw_kat3";  break;
			case 49: sItem = "n2_unw_ssw1";  break;
			case 50: sItem = "n2_unw_ssw3";  break;
			case 51: sItem = "n2_unw_sic1";  break;
			case 52: sItem = "n2_unw_bst1";  break;
			case 53: sItem = "n2_unw_sli1";  break;
			case 54: sItem = "n2_unw_spr3";  break;
			case 55: sItem = "n2_unw_bst2";  break;
			case 56: sItem = "n2_unw_lxb3";  break;
			case 57: sItem = "n2_unw_whm2";  break;
			case 58: sItem = "n2_unw_bax1";  break;
			case 59: sItem = "n2_unw_hal3";  break;
			case 60: sItem = "n2_unw_sbw1";  break;
			case 61: sItem = "n2_unw_hax1";  break;
			case 62: sItem = "ps_warmace_strength";  break;
			case 63: sItem = "n2_unw_dwa2";  break;
			case 64: sItem = "n2_unw_lfl1";  break;
			case 65: sItem = "n2_unw_hax2";  break;
			case 66: sItem = "n2_unw_hxb3";  break;
			case 67: sItem = "n2_unw_qst2";  break;
			case 68: sItem = "n2_unw_whm1";  break;
			case 69: sItem = "n2_unw_dwa3";  break;
			case 70: sItem = "n2_unw_whm3";  break;
			case 71: sItem = "n2_unw_qst1";  break;
			case 72: sItem = "n2_unw_lha2";  break;
			case 73: sItem = "n2_unw_rap1";  break;
			case 74: sItem = "n2_unw_clb1";  break;
			case 75: sItem = "n2_unw_qst3";  break;
			case 76: sItem = "n2_unw_kam1";  break;
			case 77: sItem = "n2_unw_sci2";  break;
			case 78: sItem = "n2_unw_spr2";  break;
			case 79: sItem = "n2_unw_mac3";  break;
			case 80: sItem = "n2_unw_rap3";  break;
			case 81: sItem = "n2_unw_fal2";  break;
			case 82: sItem = "n2_unw_sci1";  break;
			case 83: sItem = "n2_unw_lsw1";  break;
			case 84: sItem = "n2_unw_kuk1";  break;
			case 85: sItem = "n2_unw_lha1";  break;
			case 86: sItem = "n2_unw_dag3";  break;
			case 87: sItem = "n2_unw_mor2";  break;
			case 88: sItem = "n2_unw_lha3";  break;
			case 89: sItem = "n2_unw_hal1";  break;
			case 90: sItem = "n2_unw_sli2";  break;
			case 91: sItem = "n2_unw_sbw2";  break;
			case 92: sItem = "n2_unw_gsw2";  break;
			case 93: sItem = "n2_unw_dma3";  break;
			case 94: sItem = "NW_WSWMBS004";  break;
			case 95: sItem = "NW_WSWMBS010";  break;
			case 96: sItem = "X0_WSWMBS001";  break;
			case 97: sItem = "NW_WSWMBS003";  break;
			case 98: sItem = "NW_WSWMBS007";  break;
			case 99: sItem = "NW_WSWMGS012";  break;
			case 100: sItem = "X0_WSWMGS001";  break;
			case 101: sItem = "N2_WSWMGS001";  break;
			case 102: sItem = "NW_IT_NOVEL009";  break;
			case 103: sItem = "NW_WSWMGS010";  break;
			case 104: sItem = "NW_WSWMGS004";  break;
			case 105: sItem = "NW_WSWMDG003";  break;
			case 106: sItem = "NW_WSPMKU005";  break;
			case 107: sItem = "NW_WSWMDG009";  break;
			case 108: sItem = "X0_WSWMDG001";  break;
			case 109: sItem = "NW_WSPMKA009";  break;
			case 110: sItem = "X0_WSPMKA001";  break;
			case 111: sItem = "X0_WSPMKU001";  break;
			case 112: sItem = "NW_WSPMKU009";  break;
			case 113: sItem = "NW_WSPMSC011";  break;
			case 114: sItem = "X0_WSPMSC001";  break;
			case 115: sItem = "NW_WSWMLS005";  break;
			case 116: sItem = "NW_IT_NOVEL007";  break;
			case 117: sItem = "NW_WSWMLS012";  break;
			case 118: sItem = "X0_WSWMLS001";  break;
			case 119: sItem = "NW_WSWMLS004";  break;
			case 120: sItem = "X0_WSWMSS001";  break;
			case 121: sItem = "NW_WSWMSS011";  break;
			case 122: sItem = "NW_WSWMSS003";  break;
			case 123: sItem = "X2_IT_CREWMMUICE";  break;
			case 124: sItem = "NW_WSWMSS004";  break;
			case 125: sItem = "X1_WSWMLS001";  break;
			case 126: sItem = "NW_WSWMSC007";  break;
			case 127: sItem = "N2_WSWMFL009";  break;
			case 128: sItem = "mst_swsc_jerro";  break;
			case 129: sItem = "N2_WSWMSC001";  break;
			case 130: sItem = "NW_WSWMKA009";  break;
			case 131: sItem = "nx1_scimitar01";  break;
			case 132: sItem = "X0_WSWMSC001";  break;
			case 133: sItem = "NW_WSWMSC011";  break;
			case 134: sItem = "X0_WSWMRP001";  break;
			case 135: sItem = "NW_WSWMRP011";  break;
			case 136: sItem = "NW_WSWMRP005";  break;
			case 137: sItem = "X0_WSWMKA001";  break;
			case 138: sItem = "NW_WSWMKA011";  break;
			case 139: sItem = "N2_WSWMRP001";  break;
			case 140: sItem = "N2_WSWMFL004";  break;
			case 141: sItem = "N2_WSWMFL003";  break;
			case 142: sItem = "nx1_rapier_ruin";  break;
			case 143: sItem = "NW_WSWMKA004";  break;
			case 144: sItem = "NW_WSWMSC009";  break;
			case 145: sItem = "N2_WSWMFL006";  break;
			case 146: sItem = "NW_WSWMKA006";  break;
			case 147: sItem = "NW_WBLMCL006";  break;
			case 148: sItem = "X0_WBLMCL001";  break;
			case 149: sItem = "NW_WBLMCL011";  break;
			case 150: sItem = "NW_WBLMCL009";  break;
			case 151: sItem = "NW_WBLMCL005";  break;
			case 152: sItem = "NW_WBLMFL011";  break;
			case 153: sItem = "X0_WBLMFL001";  break;
			case 154: sItem = "N2_WBLMFL001";  break;
			case 155: sItem = "X0_WBLMHW001";  break;
			case 156: sItem = "NW_WBLMHW012";  break;
			case 157: sItem = "NW_WBLMHL009";  break;
			case 158: sItem = "X0_WBLMHL001";  break;
			case 159: sItem = "NW_WBLMHL011";  break;
			case 160: sItem = "N2_WBLMHW001";  break;
			case 161: sItem = "NW_WBLMHL003";  break;
			case 162: sItem = "NW_WDBMMA011";  break;
			case 163: sItem = "X0_WDBMMA001";  break;
			case 164: sItem = "X0_WBLMML001";  break;
			case 165: sItem = "NW_WBLMML012";  break;
			case 166: sItem = "NW_WBLMML010";  break;
			case 167: sItem = "NW_WBLMML007";  break;
			case 168: sItem = "NW_WDBMMA009";  break;
			case 169: sItem = "n2_wblmml002";  break;
			case 170: sItem = "X0_WBLMMS001";  break;
			case 171: sItem = "NW_WBLMMS011";  break;
			case 172: sItem = "NW_WBLMMS004";  break;
			case 173: sItem = "NW_WBLMMS006";  break;
			case 174: sItem = "N2_WDBMQS001";  break;
			case 175: sItem = "X0_WDBMQS001";  break;
			case 176: sItem = "NW_WDBMQS009";  break;
			case 177: sItem = "x2_it_rakstaff";  break;
			case 178: sItem = "NW_IT_NOVEL008";  break;
			case 179: sItem = "ps_staff_mages";  break;
			case 180: sItem = "ps_staff_sorcerers";  break;
			case 181: sItem = "NW_WPLMSS007";  break;
			case 182: sItem = "N2_WPLMHB001";  break;
			case 183: sItem = "NW_WPLMSS009";  break;
			case 184: sItem = "NW_WPLMHB011";  break;
			case 185: sItem = "X0_WPLMHB001";  break;
			case 186: sItem = "NW_WPLMSC005";  break;
			case 187: sItem = "NW_WPLMSC011";  break;
			case 188: sItem = "X0_WPLMSC001";  break;
			case 189: sItem = "NW_WPLMSS011";  break;
			case 190: sItem = "X0_WPLMSS001";  break;
			case 191: sItem = "N2_WPLMSC001";  break;
			case 192: sItem = "NW_WPLMSC006";  break;
			case 193: sItem = "NW_WBWMXL009";  break;
			case 194: sItem = "X0_WBWMXL001";  break;
			case 195: sItem = "NW_WBWMXH009";  break;
			case 196: sItem = "X0_WBWMXH001";  break;
			case 197: sItem = "X0_WBWMXH002";  break;
			case 198: sItem = "X0_WBWMXL002";  break;
			case 199: sItem = "NW_WBWMXH003";  break;
			case 200: sItem = "NW_WBWMXL003";  break;
			case 201: sItem = "NW_WBWMXH004";  break;
			case 202: sItem = "NW_WBWMXL007";  break;
			case 203: sItem = "NW_WBWMXL004";  break;
			case 204: sItem = "NW_WBWMXL006";  break;
			case 205: sItem = "NW_WBWMXH006";  break;
			case 206: sItem = "N2_WBWMLN001";  break;
			case 207: sItem = "NW_WBWMLN003";  break;
			case 208: sItem = "X0_WBWMLN001";  break;
			case 209: sItem = "NW_WBWMLN009";  break;
			case 210: sItem = "X0_WBWMLN002";  break;
			case 211: sItem = "X0_WBWMLN003";  break;
			case 212: sItem = "NW_WBWMLN012";  break;
			case 213: sItem = "X0_WBWMSH003";  break;
			case 214: sItem = "NW_WBWMSH012";  break;
			case 215: sItem = "NW_WBWMSH006";  break;
			case 216: sItem = "NW_WBWMSH004";  break;
			case 217: sItem = "WBWMSH005";  break;
			case 218: sItem = "N2_WBWMSH001";  break;
			case 219: sItem = "NW_WBWMSL008";  break;
			case 220: sItem = "X0_WBWMSL002";  break;
			case 221: sItem = "X0_WBWMSL001";  break;
			case 222: sItem = "NW_WBWMSL003";  break;
			case 223: sItem = "ps_staff_etherealness";  break;
			case 224: sItem = "ps_staff_planes";  break;
			case 225: sItem = "ps_shortsword_corrupted";  break;
			case 226: sItem = "ps_shortsword_ioun";  break;
			case 227: sItem = "ps_shortsword_minutefire";  break;
			case 228: sItem = "nw_wswmbs006"; break;
			case 229: sItem = "ps_poly_wp_mechan";  break;
			case 230: sItem = "ps_whip_strike1"; break;
			case 231: sItem = "ps_giantsword_unmaker"; break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS)
	 {
		nItem = Random(83) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_clothing_sorcerersrobe";  break;
			case 2: sItem = "ps_clothing_magesrobe";  break;
			case 3: sItem = "ps_mediumarmor_chainmailspeed";  break;
			case 4: sItem = "ps_breastplate_rog";  break;
			case 5: sItem = "ps_mediumarmor_umberhulk";  break;
			case 6: sItem = "ps_splintmail_forbiddenjade";  break;
			case 7: sItem = "ps_heavyarmor_umberhulk";  break;
			case 8: sItem = "n2_pca_dragon";  break;
			case 9: sItem = "n2_pca_duelist";  break;
			case 10: sItem = "NW_MCLOTH016";  break;
			case 11: sItem = "NW_MCLOTH012";  break;
			case 12: sItem = "x2_it_pmrobe";  break;
			case 13: sItem = "nx1_pca_redwizard";  break;
			case 14: sItem = "nx1_cloth05";  break;
			case 15: sItem = "NW_MCLOTH007";  break;
			case 16: sItem = "NW_MCLOTH008";  break;
			case 17: sItem = "NW_MCLOTH010";  break;
			case 18: sItem = "X1_MCLOTH001";  break;
			case 19: sItem = "NW_MCLOTH009";  break;
			case 20: sItem = "NW_MCLOTH020";  break;
			case 21: sItem = "NW_MCLOTH021";  break;
			case 22: sItem = "mwa_hvbm_ada_3";  break;
			case 23: sItem = "mwa_hvfp_ada_4";  break;
			case 24: sItem = "mwa_hvhp_ada_4";  break;
			case 25: sItem = "n2_pca_champion";  break;
			case 26: sItem = "NW_MAARCL025";  break;
			case 27: sItem = "NW_MAARCL076";  break;
			case 28: sItem = "X0_MAARCL019";  break;
			case 29: sItem = "n2_pca_defend";  break;
			case 30: sItem = "NW_MAARCL080";  break;
			case 31: sItem = "X0_MAARCL023";  break;
			case 32: sItem = "NW_MAARCL081";  break;
			case 33: sItem = "X0_MAARCL021";  break;
			case 34: sItem = "X0_MAARCL036";  break;
			case 35: sItem = "NW_MAARCL020";  break;
			case 36: sItem = "NW_MAARCL062";  break;
			case 37: sItem = "NW_MAARCL063";  break;
			case 38: sItem = "X0_MAARCL037";  break;
			case 39: sItem = "n2_pca_warpriest";  break;
			case 40: sItem = "mwa_hvfp_wyh_3";  break;
			case 41: sItem = "mwa_hvhp_wyh_3";  break;
			case 42: sItem = "NW_MAARCL004";  break;
			case 43: sItem = "n2_pca_trickster";  break;
			case 44: sItem = "NW_MAARCL001";  break;
			case 45: sItem = "NW_MCLOTH005";  break;
			case 46: sItem = "n2_pca_assassin";  break;
			case 47: sItem = "NW_MAARCL079";  break;
			case 48: sItem = "X0_MAARCL009";  break;
			case 49: sItem = "n2_pca_hscout";  break;
			case 50: sItem = "NW_MAARCL083";  break;
			case 51: sItem = "X0_MAARCL003";  break;
			case 52: sItem = "NW_MAARCL002";  break;
			case 53: sItem = "X0_MAARCL001";  break;
			case 54: sItem = "NW_MAARCL084";  break;
			case 55: sItem = "mwa_ltlt_slh_3";  break;
			case 56: sItem = "mwa_ltsl_slh_3";  break;
			case 57: sItem = "n2_pca_sthief";  break;
			case 58: sItem = "n2_pca_sdancer";  break;
			case 59: sItem = "NW_MAARCL008";  break;
			case 60: sItem = "nx1_pca_stormlord";  break;
			case 61: sItem = "X0_MAARCL005";  break;
			case 62: sItem = "NW_MAARCL087";  break;
			case 63: sItem = "mwa_mdbp_ada_4";  break;
			case 64: sItem = "mwa_mdcm_ada_4";  break;
			case 65: sItem = "mwa_mdsm_ada_4";  break;
			case 66: sItem = "NW_MAARCL014";  break;
			case 67: sItem = "NW_MAARCL016";  break;
			case 68: sItem = "NW_MAARCL077";  break;
			case 69: sItem = "X0_MAARCL015";  break;
			case 70: sItem = "NW_MAARCL078";  break;
			case 71: sItem = "X0_MAARCL013";  break;
			case 72: sItem = "NW_MAARCL058";  break;
			case 73: sItem = "NW_MAARCL036";  break;
			case 74: sItem = "NW_MAARCL037";  break;
			case 75: sItem = "n2_pca_berserk";  break;
			case 76: sItem = "NW_MAARCL082";  break;
			case 77: sItem = "X0_MAARCL007";  break;
			case 78: sItem = "mwa_mdhd_slh_3";  break;
			case 79: sItem = "NW_MAARCL085";  break;
			case 80: sItem = "X0_MAARCL011";  break;
			case 81: sItem = "mwa_mdbp_wyh_3";  break;
			case 82: sItem = "mwa_mdsm_wyh_3";  break;
			case 83: sItem = "ps_fullplate_solar"; break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS)
	 {
		nItem = Random(15) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_boots_stalwartdefender";  break;
			case 2: sItem = "ps_boots_dragonslippers";  break;
			case 3: sItem = "NW_IT_MBOOTS016";  break;
			case 4: sItem = "nw_it_mboots012";  break;
			case 5: sItem = "nw_it_mboots013";  break;
			case 6: sItem = "NW_IT_MBOOTS005";  break;
			case 7: sItem = "NW_IT_MBOOTS007";  break;
			case 8: sItem = "NW_IT_MBOOTS008";  break;
			case 9: sItem = "NW_IT_MBOOTS020";  break;
			case 10: sItem = "NW_IT_MBOOTS021";  break;
			case 11: sItem = "NW_IT_MBOOTS004";  break;
			case 12: sItem = "X0_IT_MBOOTS004";  break;
			case 13: sItem = "x2_nash_boot";  break;
			case 14: sItem = "ps_boots_minuteacceleration"; break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS)
	 {
		nItem = Random(17) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_cloak_movement";  break;
			case 2: sItem = "X0_MAARCL038";  break;
			case 3: sItem = "X0_MAARCL039";  break;
			case 4: sItem = "NW_MAARCL105";  break;
			case 5: sItem = "NW_MAARCL106";  break;
			case 6: sItem = "NW_MAARCL089";  break;
			case 7: sItem = "NW_MAARCL090";  break;
			case 8: sItem = "X0_MAARCL027";  break;
			case 9: sItem = "X0_MAARCL028";  break;
			case 10: sItem = "nw_maarcl102";  break;
			case 11: sItem = "nw_maarcl101";  break;
			case 12: sItem = "nw_maarcl100";  break;
			case 13: sItem = "nw_maarcl103";  break;
			case 14: sItem = "X0_MAARCL034";  break;
			case 15: sItem = "x2_nash_cloak";  break;
			case 16: sItem = "NW_MAARCL093";  break;
			case 17: sItem = "NW_MAARCL094";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS)
	 {
		nItem = Random(27) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_gloves_unholy";  break;
			case 2: sItem = "ps_gloves_weaponhandling";  break;
			case 3: sItem = "ps_gloves_greatertrapper";  break;
			case 4: sItem = "ps_gloves_reinforced";  break;
			case 5: sItem = "NW_IT_MBRACER008";  break;
			case 6: sItem = "NW_IT_MBRACER009";  break;
			case 7: sItem = "NW_IT_MBRACER004";  break;
			case 8: sItem = "NW_IT_MBRACER005";  break;
			case 9: sItem = "N2_IT_MGLOVE001";  break;
			case 10: sItem = "NW_IT_MGLOVE018";  break;
			case 11: sItem = "NW_IT_MGLOVE019";  break;
			case 12: sItem = "NW_IT_MGLOVE024";  break;
			case 13: sItem = "NW_IT_MGLOVE023";  break;
			case 14: sItem = "NW_IT_MGLOVE028";  break;
			case 15: sItem = "NW_IT_MGLOVE029";  break;
			case 16: sItem = "X0_IT_MGLOVE002";  break;
			case 17: sItem = "nw_it_mglove010";  break;
			case 18: sItem = "nw_it_mglove013";  break;
			case 19: sItem = "nw_it_mglove015";  break;
			case 20: sItem = "X0_IT_MGLOVE004";  break;
			case 21: sItem = "nw_it_mglove011";  break;
			case 22: sItem = "NW_IT_MGLOVE001";  break;
			case 23: sItem = "ps_gauntlets_anarchicgreater";  break;
			case 24: sItem = "ps_gauntlets_axiomaticgreater";  break;
			case 25: sItem = "ps_gauntlets_holygreater";  break;
			case 26: sItem = "ps_gauntlets_unholygreater";  break;
			case 27: sItem = "ps_bracer_spider"; break; 
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS)
	 {
		nItem = Random(10) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_belt_agility+3";  break;
			case 2: sItem = "ps_belt_agility+4";  break;
			case 3: sItem = "ps_belt_guidinglight";  break;
			case 4: sItem = "NW_IT_MBELT002";  break;
			case 5: sItem = "NW_IT_MBELT007";  break;
			case 6: sItem = "X0_IT_MBELT003";  break;
			case 7: sItem = "X0_IT_MBELT005";  break;
			case 8: sItem = "X0_IT_MBELT001";  break;
			case 9: sItem = "x2_belt_001";  break;
			case 10: sItem = "X0_IT_MBELT006";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS)
	 {
		nItem = Random(14) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_helmet_aellonsthinkinghat";  break;
			case 2: sItem = "ps_helmet_anagrysmindmaze";  break;
			case 3: sItem = "ps_helmet_helmofdarkness";  break;
			case 4: sItem = "ps_helmet_shroudofnight";  break;
			case 5: sItem = "ps_helmet_thieveshood";  break;
			case 6: sItem = "X0_ARMHE014";  break;
			case 7: sItem = "n2_helm_finch";  break;
			case 8: sItem = "X0_ARMHE010";  break;
			case 9: sItem = "nx2_helm_int_06";  break;
			case 10: sItem = "X0_ARMHE002";  break;
			case 11: sItem = "X0_ARMHE013";  break;
			case 12: sItem = "X2_ARMHE002";  break;
			case 13: sItem = "NW_IT_NOVEL004";  break;
			case 14: sItem = "NW_ARMHE009";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS)
	 {
		nItem = Random(23) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_heavyshield_umberhulk";  break;
			case 2: sItem = "ps_heavyshield_silver";  break;
			case 3: sItem = "ps_lightshield_mithral";  break;
			case 4: sItem = "ps_lightshield_umberhulk";  break;
			case 5: sItem = "ps_towershield_umberhulk";  break;
			case 6: sItem = "mwa_shhv_ada_4";  break;
			case 7: sItem = "NW_ASHMLW009";  break;
			case 8: sItem = "X0_ASHMLW001";  break;
			case 9: sItem = "NW_ASHMLW005";  break;
			case 10: sItem = "NW_ASHMLW004";  break;
			case 11: sItem = "NW_ASHMLW007";  break;
			case 12: sItem = "mwa_shlt_ada_4";  break;
			case 13: sItem = "NW_ASHMSW004";  break;
			case 14: sItem = "NW_ASHMSW009";  break;
			case 15: sItem = "NW_ASHMSW006";  break;
			case 16: sItem = "X0_ASHMSW001";  break;
			case 17: sItem = "mwa_shlt_zal_3";  break;
			case 18: sItem = "mwa_shtw_ada_4";  break;
			case 19: sItem = "NW_ASHMTO003";  break;
			case 20: sItem = "X0_ASHMTO001";  break;
			case 21: sItem = "NW_ASHMTO009";  break;
			case 22: sItem = "NW_ASHMTO004";  break;
			case 23: sItem = "NW_ASHMTO007";  break;
		}
     }
	 else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS + SCOD_JEWELRY)
	 {
		nItem = Random(55) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_amulet_health";  break;
			case 2: sItem = "ps_amulet_protecteddalliances";  break;
			case 3: sItem = "ps_amulet_medallionthought";  break;
			case 4: sItem = "ps_ring_shieldother";  break;
			case 5: sItem = "ps_ring_acidresistance";  break;
			case 6: sItem = "ps_ring_archer";  break;
			case 7: sItem = "ps_ring_brawler";  break;
			case 8: sItem = "ps_ring_coldresistance";  break;
			case 9: sItem = "ps_ring_electricresistance";  break;
			case 10: sItem = "ps_ring_fireresistance";  break;
			case 11: sItem = "ps_ring_freedom";  break;
			case 12: sItem = "ps_ring_evasion";  break;
			case 13: sItem = "ps_ring_sonicresistance";  break;
			case 14: sItem = "ps_ring_swordsman";  break;
			case 15: sItem = "ps_ring_undeadcontrol";  break;
			case 16: sItem = "NW_IT_MNECK013";  break;
			case 17: sItem = "NW_IT_MNECK014";  break;
			case 18: sItem = "NW_IT_MNECK005";  break;
			case 19: sItem = "nw_it_mneck026";  break;
			case 20: sItem = "nw_it_mneck027";  break;
			case 21: sItem = "X2_IT_MNECK002";  break;
			case 22: sItem = "NW_IT_MNECK022";  break;
			case 23: sItem = "NW_IT_MNECK033";  break;
			case 24: sItem = "NW_IT_MNECK009";  break;
			case 25: sItem = "NW_IT_MNECK010";  break;
			case 26: sItem = "NW_IT_MNECK018";  break;
			case 27: sItem = "NW_IT_MNECK017";  break;
			case 28: sItem = "X0_IT_MRING007";  break;
			case 29: sItem = "X0_IT_MRING009";  break;
			case 30: sItem = "NW_IT_MRING023";  break;
			case 31: sItem = "x2_nash_ring";  break;
			case 32: sItem = "NW_IT_MRING015";  break;
			case 33: sItem = "NW_IT_MRING016";  break;
			case 34: sItem = "n2_it_mring004";  break;
			case 35: sItem = "n2_it_mring005";  break;
			case 36: sItem = "nw_it_mring026";  break;
			case 37: sItem = "nw_it_mring027";  break;
			case 38: sItem = "NW_IT_MRING007";  break;
			case 39: sItem = "NW_IT_MRING003";  break;
			case 40: sItem = "X0_IT_MRING011";  break;
			case 41: sItem = "NW_IT_MRING018";  break;
			case 42: sItem = "NW_IT_MRING019";  break;
			case 43: sItem = "NW_IT_MRING032";  break;
			case 44: sItem = "n2_IT_MRING001";  break;
			case 45: sItem = "n2_it_mring010";  break;
			case 46: sItem = "n2_it_mring011";  break;
			case 47: sItem = "X1_IT_MRING002";  break;
			case 48: sItem = "X1_IT_MRING001";  break;
			case 49: sItem = "x2_ring_pet";  break;
			case 50: sItem = "ps_poly_mg_abyl";  break;
			case 51: sItem = "ps_poly_mg_abyh";  break;
			case 52: sItem = "ps_amulet_negativechain"; break;
			case 53: sItem = "ps_ring_vex"; break;
			case 54: sItem = "ps_ring_bell"; break; 
			case 55: sItem = "ps_ring_wedding10"; break;
		}
     }
	 else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS + SCOD_JEWELRY + SCOD_MISC)
	 {
		nItem = Random(13) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_container_magicbag";  break;
			case 2: sItem = "ps_container_greaterbag";  break;
			case 3: sItem = "ps_instrument_austruthflute";  break;
			case 4: sItem = "ps_misc_flameberry";  break;
			case 5: sItem = "ps_misc_iceberry";  break;
			case 6: sItem = "nx2_misc_lifecoin";  break;
			case 7: sItem = "X0_IT_MTHNMISC14";  break;
			case 8: sItem = "X0_IT_MSMLMISC03";  break;
			case 9: sItem = "X0_IT_MSMLMISC06";  break;
			case 10: sItem = "NW_IT_MSMLMISC05";  break;
			case 11: sItem = "ps_misc_magickeenscabbard"; break;
			case 12: sItem = "ps_book_otherwordly"; break; 
			case 13: sItem = "ps_misc_gemofshrapnels"; break; 
		}
     }
	 
	 return sItem;
	}

	string HighSCODitem()
	{
	 int nRandom = d100();
	 string sItem = "";
	 int nItem = 0;
	 
	 if (nRandom <= SCOD_WEAPONS)
	 {
		nItem = Random(283) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_crossbow_unlimitedammo5";  break;
			case 2: sItem = "ps_crossbow_unlimitedammo4";  break;
			case 3: sItem = "ps_lcrossbow_unlimitedammo5";  break;
			case 4: sItem = "ps_lcrossbow_unlimitedammo4";  break;
			case 5: sItem = "ps_lbow_unlimitedammo5";  break;
			case 6: sItem = "ps_lbow_unlimitedammo4";  break;
			case 7: sItem = "ps_sbow_unlimitedammo5";  break;
			case 8: sItem = "ps_sbow_unlimitedammo4";  break;
			case 9: sItem = "ps_sling_unlimitedammo5";  break;
			case 10: sItem = "ps_sling_unlimitedammo4";  break;
			case 11: sItem = "ps_greatsword_aeollian";  break;
			case 12: sItem = "ps_bastardsword_blackknight";  break;
			case 13: sItem = "ps_greatsword_chilltouch";  break;
			case 14: sItem = "ps_greatsword_darkdealer";  break;
			case 15: sItem = "ps_holysword02";  break;
			case 16: sItem = "ps_usword_frostburn";  break;
			case 17: sItem = "ps_longsword_greyayne";  break;
			case 18: sItem = "ps_holysword04";  break;
			case 19: sItem = "ps_holysword03";  break;
			case 20: sItem = "ps_holysword05";  break;
			case 21: sItem = "ps_falchion_moonblade";  break;
			case 22: sItem = "ps_holysword01";  break;
			case 23: sItem = "ps_warhammer_rockbreaker";  break;
			case 24: sItem = "ps_katana_shadowbane";  break;
			case 25: sItem = "ps_kukri_shortclaw";  break;
			case 26: sItem = "ps_quarterstaff_staffofspikes";  break;
			case 27: sItem = "ps_club_thumper";  break;
			case 28: sItem = "ps_longsword_mord";  break;
			case 29: sItem = "X0_WAXMGR002";  break;
			case 30: sItem = "X0_WAXMGR001";  break;
			case 31: sItem = "nx1_greataxe01";  break;
			case 32: case 230: sItem = "N2_WAXMHN001";  break;
			case 33: case 231: sItem = "X0_WAXMBT001";  break;
			case 34: case 232: sItem = "X0_WAXMBT002";  break;
			case 35: sItem = "X2_WMDWRAXE005";  break;
			case 36: sItem = "X2_WMDWRAXE006";  break;
			case 37: case 233: sItem = "X0_WAXMHN001";  break;
			case 38: case 234: sItem = "X0_WAXMHN002";  break;
			case 39: sItem = "n2_unw_clb3";  break;
			case 40: case 235: sItem = "X0_WSWMBS001";  break;
			case 41: case 236: sItem = "X0_WSWMBS002";  break;
			case 42: case 237: sItem = "X0_WSWMGS002";  break;
			case 43: case 238: sItem = "X0_WSWMGS001";  break;
			case 44: case 239: sItem = "X0_WSWMGS001";  break;
			case 45: case 240: sItem = "X0_WSWMGS002";  break;
			case 46: case 241: sItem = "X0_WSPMSC002";  break;
			case 47: case 242: sItem = "X0_WSPMSC001";  break;
			case 48: case 243: sItem = "X0_WSPMKU002";  break;
			case 49: case 244: sItem = "X0_WSPMKU001";  break;
			case 50: sItem = "NW_WSWMDG005";  break;
			case 51: sItem = "N2_WSPMKU001";  break;
			case 52: case 245: sItem = "X0_WSPMKA002";  break;
			case 53: case 246: sItem = "X0_WSPMKA001";  break;
			case 54: case 247: sItem = "X0_WSWMDG002";  break;
			case 55: case 248: sItem = "X0_WSWMDG001";  break;
			case 56: sItem = "X1_WSWMLS002";  break;
			case 57: case 249: sItem = "X0_WSWMSS002";  break;
			case 58: case 250: sItem = "X0_WSWMSS001";  break;
			case 59: sItem = "N2_WSWMSS003";  break;
			case 60: sItem = "N2_WSWMFL004";  break;
			case 61: sItem = "N2_WSWMFL005";  break;
			case 62: sItem = "N2_WSWMRP001";  break;
			case 63: sItem = "X2_IT_CREMUMKAT2";  break; //fixed version
			case 64: case 251: sItem = "X0_WSWMKA002";  break;
			case 65: case 252: sItem = "X0_WSWMKA001";  break;
			case 66: case 253: sItem = "X0_WSWMRP002";  break;
			case 67: case 254: sItem = "X0_WSWMRP001";  break;
			case 68: case 255: sItem = "X0_WSWMSC002";  break;
			case 69: case 256: sItem = "X0_WSWMSC001";  break;
			case 70: sItem = "NW_WSWMKA009";  break;
			case 71: case 257: sItem = "X0_WBLMCL001";  break;
			case 72: case 258: sItem = "X0_WBLMCL002";  break;
			case 73: case 259: sItem = "X0_WBLMFL002";  break;
			case 74: case 260: sItem = "X0_WBLMFL001";  break;
			case 75: sItem = "NW_WBLMFL009";  break;
			case 76: sItem = "NW_WBLMHW004";  break;
			case 77: sItem = "N2_WBLMHL001";  break;
			case 78: case 261: sItem = "X0_WBLMHL002";  break;
			case 79: case 262: sItem = "X0_WBLMHL001";  break;
			case 80: case 263: sItem = "X0_WBLMHW002";  break;
			case 81: case 264: sItem = "X0_WBLMHW001";  break;
			case 82: case 265: sItem = "X0_WDBMMA002";  break;
			case 83: case 266: sItem = "X0_WBLMML002";  break;
			case 84: case 267: sItem = "X0_WBLMML001";  break;
			case 85: case 268: sItem = "X0_WBLMMS002";  break;
			case 86: case 269: sItem = "X0_WBLMMS001";  break;
			case 87: sItem = "NW_WBLMMS009";  break;
			case 88: case 282: sItem = "X0_WDBMQS002";  break;
			case 89: case 283: sItem = "X0_WDBMQS001";  break;
			case 90: sItem = "n2_wmgst001";  break;
			case 91: sItem = "NW_WMGST003";  break;
			case 92: sItem = "ps_staff_greatermages";  break;
			case 93: sItem = "ps_staff_greatersorcerers";  break;
			case 94: sItem = "nw_wmgst00302";  break;
			case 95: sItem = "nw_wmgst0030";  break;
			case 96: sItem = "nw_wmgst003010";  break;
			case 97: sItem = "nw_wmgst003000";  break;
			case 98: sItem = "nw_wmgst00301";  break;
			case 99: sItem = "nw_wmgst00300";  break;
			case 100: sItem = "nw_wmgst0030000";  break;
			case 101: case 270: sItem = "X0_WPLMSS002";  break;
			case 102: case 271: sItem = "X0_WPLMSS001";  break;
			case 103: case 272: sItem = "X0_WPLMSC002";  break;
			case 104: case 273: sItem = "X0_WPLMSC001";  break;
			case 105: sItem = "NW_WPLMHB009";  break;
			case 106: sItem = "NW_WPLMSS004";  break;
			case 107: case 274: sItem = "X0_WPLMHB002";  break;
			case 108: case 275: sItem = "X0_WPLMHB001";  break;
			case 109: sItem = "nx1_spear001";  break;
			case 110: sItem = "NW_WPLMSC004";  break;
			case 111: sItem = "NW_WPLMHB006";  break;
			case 112: sItem = "nx1_lightcrossbow01";  break;
			case 113: case 276: sItem = "X0_WBWMLN004";  break;
			case 114: case 277: sItem = "X0_WBWMLN003";  break;
			case 115: case 278: sItem = "X0_WBWMLN002";  break;
			case 116: case 279: sItem = "X0_WBWMSH004";  break;
			case 117: case 280: sItem = "X0_WBWMSH003";  break;
			case 118: case 281: sItem = "X0_WBWMSH002";  break;
			case 119: sItem = "nx1_longbow01";  break;
			case 120: sItem = "ps_handaxe_abyssalaxe";  break;
			case 121: sItem = "ps_battleaxe_death";  break;
			case 122: sItem = "ps_dwarvenwaraxe_fiendslayer";  break;
			case 123: sItem = "ps_kama_flash";  break;
			case 124: sItem = "ps_flail_kytonchains";  break;
			case 125: sItem = "ps_battleaxe_life";  break;
			case 126: sItem = "ps_katana_meltdown";  break;
			case 127: sItem = "ps_greataxe_morkkyddan";  break;
			case 128: sItem = "ps_dagger_pitfiendfang";  break;
			case 129: sItem = "ps_halberd_prismatichalberd";  break;
			case 130: sItem = "ps_lighthammer_runed";  break;
			case 131: sItem = "ps_warmace_spinecrusher";  break;
			case 132: sItem = "ps_falchion_whitefang";  break;
			case 133: sItem = "ps_hcrossbow_mechanus";  break;
			case 134: sItem = "ps_staff_vitalization";  break;
			case 135: sItem = "ps_halberd_spinesplitter";  break;
			case 136: sItem = "ps_bastardsword_equalizer";  break;
			case 137: sItem = "ps_magistaff001";  break;
			case 138: sItem = "ps_magistaff002";  break;
			case 139: sItem = "ps_magistaff003";  break;
			case 140: sItem = "ps_magistaff004";  break;
			case 141: sItem = "ps_magistaff005";  break;
			case 142: sItem = "ps_magistaff006";  break;
			case 143: sItem = "ps_magistaff007";  break;
			case 144: sItem = "ps_katana_arrowcutter";  break;
			case 145: sItem = "ps_katana_momentum";  break;
			case 146: sItem = "ps_falchion_outsiderhunter";  break;
			case 147: sItem = "ps_falchion_deepdrinker";  break;
			case 148: sItem = "ps_longsword_wideblade";  break;
			case 149: sItem = "ps_longsword_frostshard";  break;
			case 150: sItem = "ps_rapier_dancing";  break;
			case 151: sItem = "ps_rapier_minutepower";  break;
			case 152: sItem = "ps_longsword_liquidfireshard";  break;
			case 153: sItem = "ps_longsword_flameshard";  break;
			case 154: sItem = "ps_longsword_electricshard";  break;
			case 155: sItem = "ps_longbow_flamevolley";  break;
			case 156: sItem = "ps_xbow_blamblazer";  break;
			case 157: sItem = "ps_xbow_chokuno";  break;
			case 158: sItem = "ps_xbow_demonstalker";  break;
			case 159: sItem = "ps_xbow_monsterscourge";  break;
			case 160: sItem = "n2_unw_rap3";  break;
			case 161: sItem = "ps_itemset_aarcher3";  break;
			case 162: sItem = "ps_itemset_swordsaint1";  break;
			case 163: sItem = "ps_ssword_illeffect";  break;
			case 164: sItem = "ps_scimitar_curveswerve";  break;
			case 165: sItem = "ps_club_natureswrath";  break;
			case 166: sItem = "ps_sbow_minilbowgnomedoom";  break;
			case 167: sItem = "ps_spear_ragingodin";  break;
			case 168: sItem = "ps_scythe_blessedofnerull";  break;
			case 169: sItem = "ps_bsword_swordofbastard";  break;
			case 170: sItem = "ps_flail_chainsofglory";  break;
			case 171: sItem = "ps_wmace_cripplinghammer";  break;
			case 172: sItem = "ps_whammer_lawslongreach";  break;
			case 173: sItem = "ps_sickle_crescentmoon";  break;
			case 174: sItem = "ps_qstaff_philosophysolidified";  break;
			case 175: sItem = "ps_mace_cross";  break;
			case 176: sItem = "ps_mace_aceofmace";  break;
			case 177: sItem = "ps_morningstar_warningscar";  break;
			case 178: sItem = "ps_kama_friction";  break;
			case 179: sItem = "ps_whip_wasp";  break;
			case 180: sItem = "ps_bastardsword_chaosblade"; break;
			case 181: sItem = "ps_bow_dryads"; break;
			case 182: sItem = "ps_battleaxe_deafeningclang"; break;
			case 183: sItem = "ps_bsword_shroudspawn"; break;
			case 184: sItem = "ps_bsword_shroudspawn"; break;
			case 185: sItem = "ps_club_largethumper"; break;
			case 186: sItem = "ps_club_balagarnscane"; break;
			case 187: sItem = "ps_dagger_raels"; break;
			case 188: sItem = "ps_dagger_slowpoke"; break;
			case 189: sItem = "ps_dagger_sleeperagent"; break; 
			case 190: sItem = "ps_earthbound"; break;
			case 191: sItem = "ps_finesserapier"; break;
			case 192: sItem = "ps_flameboundhammer"; break; 
			case 193: sItem = "ps_flaming "; break;
			case 194: sItem = "ps_longsword_augmented"; break;
			case 195: sItem = "ps_longbow_whirlwind"; break;
			case 196: sItem = "ps_longsword_rancor"; break;
			case 197: sItem = "ps_rubystaff"; break;
			case 198: sItem = "ps_revenge"; break;
			case 199: sItem = "ps_gauntlet_solarstouch"; break;
			case 200: sItem = "ps_gauntlet_devilsgrip"; break;
			case 201: sItem = "ps_gauntlet_inevitablefist"; break;
			case 202: sItem = "ps_giantaxe_frostreaver"; break;
			case 203: sItem = "ps_greatsword_greateraeollian"; break;
			case 204: sItem = "ps_greatsword_greaterchilltouch"; break;
			case 205: sItem = "ps_gsword_harbinger"; break;
			case 206: sItem = "ps_gauntlet_spikedknuckles"; break; 
			case 207: sItem = "ps_whip_dagger"; break; 
			case 208: sItem = "ps_whip_balor"; break; 
			case 209: sItem = "ps_whip_torment"; break;
			case 210: sItem = "ps_whip_strike2"; break;
			case 211: sItem = "ps_waterbornscimitar"; break;
			case 212: sItem = "ps_usword_frostburnfusion"; break;
			case 213: sItem = "ps_undeadbane"; break;
			case 214: sItem = "ps_holysword07"; break;
			case 215: sItem = "ps_holysword08"; break;
			case 216: sItem = "ps_holysword06"; break;
			case 217: sItem = "ps_magicstaff_meleemagery"; break;
			case 218: sItem = "ps_quarterstaff_twosidedblade"; break;
			case 219: sItem = "ps_club_codofwar"; break; 
			case 220: sItem = "ps_staff_withering"; break;
			case 221: sItem = "ps_bastardsword_chaosblade"; break; 
			case 222: sItem = "ps_bastardsword_death"; break; 
			case 223: sItem = "ps_scimitar_shock"; break; 
			case 224: sItem = "ps_scimitar_awe"; break; 
			case 225: sItem = "ps_staff_boomstick"; break; 
			case 226: sItem = "thechaosmansblade0"; break;
			case 227: sItem = "ps_dagger_sacrifice"; break;
			case 228: sItem = "tagteam2"; break;
			case 229: sItem = "oathkeeper2"; break; 
			
			
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS)
	 {
		nItem = Random(53) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_armor_assassin";  break;
			case 2: sItem = "ps_armor_monk";  break;
			case 3: sItem = "ps_clothing_greatermagesrobe";  break;
			case 4: sItem = "ps_clothing_greatersorcerersrobe";  break;
			case 5: sItem = "ps_mediumarmor_lessergolem";  break;
			case 6: sItem = "ps_heavyarmor_deepguardian";  break;
			case 7: sItem = "NW_MCLOTH004";  break;
			case 8: sItem = "NW_MCLOTH003";  break;
			case 9: sItem = "nx1_pca_invisblade";  break;
			case 10: sItem = "NW_MCLOTH001";  break;
			case 11: sItem = "n2_mcloth001";  break;
			case 12: sItem = "NW_MCLOTH021";  break;
			case 13: sItem = "NW_MCLOTH022";  break;
			case 14: sItem = "NW_MCLOTH002";  break;
			case 15: sItem = "X0_MAARCL019";  break;
			case 16: sItem = "X0_MAARCL020";  break;
			case 17: sItem = "X0_MAARCL023";  break;
			case 18: sItem = "X0_MAARCL021";  break;
			case 19: sItem = "X0_MAARCL022";  break;
			case 20: sItem = "X0_MAARCL024";  break;
			case 21: sItem = "n2_pca_archer";  break;
			case 22: sItem = "X0_MAARCL009";  break;
			case 23: sItem = "X0_MAARCL010";  break;
			case 24: sItem = "NW_MAARCL033";  break;
			case 25: sItem = "X0_MAARCL003";  break;
			case 26: sItem = "X0_MAARCL004";  break;
			case 27: sItem = "n2_pca_nw9";  break;
			case 28: sItem = "X0_MAARCL002";  break;
			case 29: sItem = "X0_MAARCL001";  break;
			case 30: sItem = "X0_MAARCL006";  break;
			case 31: sItem = "X0_MAARCL005";  break;
			case 32: sItem = "X0_MAARCL015";  break;
			case 33: sItem = "X0_MAARCL016";  break;
			case 34: sItem = "X0_MAARCL013";  break;
			case 35: sItem = "X0_MAARCL014";  break;
			case 36: sItem = "NW_MAARCL061";  break;
			case 37: sItem = "NW_MAARCL015";  break;
			case 38: sItem = "X0_MAARCL007";  break;
			case 39: sItem = "X0_MAARCL008";  break;
			case 40: sItem = "X0_MAARCL011";  break;
			case 41: sItem = "X0_MAARCL012";  break;
			case 42: sItem = "NW_IT_NOVEL003";  break;
			case 43: sItem = "ps_fullplate_mechanusgears";  break;
			case 44: sItem = "ps_itemset_brazen1";  break;
			case 45: sItem = "ps_itemset_fallshad4";  break;
			case 46: sItem = "ps_itemset_swordsaint3";  break;
			case 47: sItem = "ps_armor_flametwin"; break;
			case 48: sItem = "ps_chainmail_devotion"; break;
			case 49: sItem = "ps_fullplate_faith"; break;
			case 50: sItem = "ps_fierytunic"; break; 
			case 51: sItem = "ps_fullplate_shiningarmor"; break; 
			case 52: sItem = "ps_leather_arcanetrickster"; break; 
			case 53: sItem = "ps_chainshirt_bladedancer"; break;
			
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS)
	 {
		nItem = Random(10) + 1;
		switch (nItem)
		{
			case 1: sItem = "NW_IT_MBOOTS017";  break;
			case 2: sItem = "nw_it_mboots013";  break;
			case 3: sItem = "nw_it_mboots014";  break;
			case 4: sItem = "NW_IT_MBOOTS008";  break;
			case 5: sItem = "NW_IT_MBOOTS009";  break;
			case 6: sItem = "NW_IT_MBOOTS021";  break;
			case 7: sItem = "NW_IT_MBOOTS022";  break;
			case 8: sItem = "ps_itemset_brazen4";  break;
			case 9: sItem = "ps_itemset_fallshad1";  break;
			case 10: sItem = "ps_itemset_slaadskin1";  break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS)
	 {
		nItem = Random(18) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_cloak_finchscomforting";  break;
			case 2: sItem = "ps_cloak_elderdoom";  break;
			case 3: sItem = "X0_MAARCL032";  break;
			case 4: sItem = "X0_MAARCL033";  break;
			case 5: sItem = "X2_IT_MCLOAK004";  break;
			case 6: sItem = "X2_IT_MCLOAK005";  break;
			case 7: sItem = "NW_MAARCL090";  break;
			case 8: sItem = "NW_MAARCL091";  break;
			case 9: sItem = "X0_MAARCL029";  break;
			case 10: sItem = "X0_MAARCL028";  break;
			case 11: sItem = "NW_MAARCL094";  break;
			case 12: sItem = "NW_MAARCL095";  break;
			case 13: sItem = "X0_MAARCL035";  break;
			case 14: sItem = "ps_poly_clk_succubus";  break;
			case 15: sItem = "ps_itemset_fallshad2";  break;
			case 16: sItem = "ps_itemset_iggwilv1";  break;
			case 17: sItem = "ps_itemset_slaadskin2";  break;
			case 18: sItem = "ps_cloak_blades"; break; 
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS)
	 {
		nItem = Random(28) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_bracer_gnarlthornssacrifice";  break;
			case 2: sItem = "ps_gloves_greaterweaponhandling";  break;
			case 3: sItem = "ps_bracer_redguard";  break;
			case 4: sItem = "NW_IT_MBRACER010";  break;
			case 5: sItem = "NW_IT_MBRACER006";  break;
			case 6: sItem = "X0_IT_MBRACER002";  break;
			case 7: sItem = "nx1_glove01";  break;
			case 8: sItem = "nx2_glove_str_04";  break;
			case 9: sItem = "nx2_glove_str_06";  break;
			case 10: sItem = "NW_IT_MGLOVE019";  break;
			case 11: sItem = "NW_IT_MGLOVE020";  break;
			case 12: sItem = "NW_IT_MGLOVE025";  break;
			case 13: sItem = "NW_IT_MGLOVE024";  break;
			case 14: sItem = "NW_IT_MGLOVE029";  break;
			case 15: sItem = "NW_IT_MGLOVE030";  break;
			case 16: sItem = "X2_IT_MGLOVE022";  break;
			case 17: sItem = "ps_gloves_handsofvampire";  break;
			case 18: sItem = "ps_gauntlet_stunning";  break;
			case 19: sItem = "ps_gauntlet_lightningstrike";  break;
			case 20: sItem = "ps_poly_brc_lolth";  break;
			case 21: sItem = "ps_itemset_aarcher2";  break;
			case 22: sItem = "ps_itemset_brazen3";  break;
			case 23: sItem = "ps_itemset_iggwilv2";  break;
			case 24: sItem = "ps_itemset_slaadskin3";  break;
			case 25: sItem = "ps_itemset_swordsaint2";  break;
			case 26: sItem = "ps_bracer_magus2"; break; 
			case 27: sItem = "ps_bracer_shields"; break;
			case 28: sItem = "ps_bracer_blinddevotion"; break; 
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS)
	 {
		nItem = Random(15) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_belt_agility+4";  break;
			case 2: sItem = "ps_belt_agility+5";  break;
			case 3: sItem = "ps_belt_greaterguidinglight";  break;
			case 4: sItem = "ps_belt_ceremonialuthgardt";  break;
			case 5: sItem = "NW_IT_MBELT007";  break;
			case 6: sItem = "NW_IT_MBELT008";  break;
			case 7: sItem = "X0_IT_MBELT008";  break;
			case 8: sItem = "X0_IT_MBELT007";  break;
			case 9: sItem = "X0_IT_MBELT004";  break;
			case 10: sItem = "ps_itemset_aarcher1";  break;
			case 11: sItem = "ps_belt_inertial"; break;
			case 12: sItem = "ps_belt_lion"; break;
			case 13: sItem = "ps_belt_raumathar"; break;
			case 14: sItem = "ps_belt_construct"; break;
			case 15: sItem = "ps_belt_faraneyth"; break;
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS)
	 {
		nItem = Random(13) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_helmet_cowlofwarding";  break;
			case 2: sItem = "X0_ARMHE010";  break;
			case 3: sItem = "nx2_helm_int_06";  break;
			case 4: sItem = "X0_ARMHE012";  break;
			case 5: sItem = "N2_ARHE001";  break;
			case 6: sItem = "x2_helm_002";  break;
			case 7: sItem = "ps_helmet_actions";  break;
			case 8: sItem = "ps_itemset_brazen2";  break;
			case 9: sItem = "ps_itemset_fallshad3";  break;
			case 10: sItem = "ps_itemset_iggwilv3";  break;
			case 11: sItem = "ps_helmet_eye"; break;
			case 12: sItem = "ps_helm_chromatic"; break;
			case 13: sItem = "ps_helm_coven"; break; 
		}
     }
     else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS)
	 {
		nItem = Random(13) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_lightshield_void";  break;
			case 2: sItem = "ps_towershield_browndragon";  break;
			case 3: sItem = "ps_towershield_chaosshield";  break;
			case 4: sItem = "NW_ASHMLW006";  break;
			case 5: sItem = "X0_ASHMLW001";  break;
			case 6: sItem = "X0_ASHMLW002";  break;
			case 7: sItem = "NW_ASHMLW003";  break;
			case 8: sItem = "X0_ASHMSW001";  break;
			case 9: sItem = "X0_ASHMSW002";  break;
			case 10: sItem = "NW_ASHMTO006";  break;
			case 11: sItem = "X0_ASHMTO002";  break;
			case 12: sItem = "X0_ASHMTO001";  break;
			case 13: sItem = "ps_heavyshield_nullifier"; break;
		}
     }
	 else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS + SCOD_JEWELRY)
	 {
		nItem = Random(45) + 1;
		switch (nItem)
		{
			case 1: sItem = "ps_amulet_scarabgreaterprotection";  break;
			case 2: sItem = "ps_amulet_greaterhealth";  break;
			case 3: sItem = "ps_ring_acidresistancegreater";  break;
			case 4: sItem = "ps_ring_coldresistancegreater";  break;
			case 5: sItem = "ps_ring_electricresistancegreate";  break;
			case 6: sItem = "ps_ring_fireresistancegreater";  break;
			case 7: sItem = "ps_ring_sonicresistancegreater";  break;
			case 8: sItem = "ps_ring_imadrielsrespite";  break;
			case 9: sItem = "ps_ring_energyresist";  break;
			case 10: sItem = "ps_ring_ninelives";  break;
			case 11: sItem = "NW_IT_MNECK014";  break;
			case 12: sItem = "NW_IT_MNECK015";  break;
			case 13: sItem = "X0_IT_MNECK006";  break;
			case 14: sItem = "NW_IT_MNECK034";  break;
			case 15: sItem = "nx1_amulet001";  break;
			case 16: sItem = "nw_it_mneck027";  break;
			case 17: sItem = "nw_it_mneck028";  break;
			case 18: sItem = "NW_IT_MNECK010";  break;
			case 19: sItem = "NW_IT_MNECK011";  break;
			case 20: sItem = "NW_IT_MNECK019";  break;
			case 21: sItem = "NW_IT_MNECK004";  break;
			case 22: sItem = "NW_IT_MNECK002";  break;
			case 23: sItem = "NW_IT_MNECK018";  break;
			case 24: sItem = "NW_IT_MRING029";  break;
			case 25: sItem = "nx1_ring16";  break;
			case 26: sItem = "NW_IT_MRING016";  break;
			case 27: sItem = "NW_IT_MRING017";  break;
			case 28: sItem = "nw_it_mring027";  break;
			case 29: sItem = "nw_it_mring028";  break;
			case 30: sItem = "NW_IT_MRING019";  break;
			case 31: sItem = "NW_IT_MRING020";  break;
			case 32: sItem = "NW_IT_MRING033";  break;
			case 33: sItem = "nx1_ring12";  break;
			case 34: sItem = "ps_poly_mg_abyg";  break;
			case 35: sItem = "ps_poly_am_maglub";  break;
			case 36: sItem = "ps_itemset_celglory1";  break;
			case 37: sItem = "ps_itemset_celglory2";  break;
			case 38: sItem = "ps_itemset_celglory3";  break;
			case 39: sItem = "ps_amulet_mighty"; break;
			case 40: sItem = "ps_ring_zero"; break;
			case 41: sItem = "ps_ring_devil"; break; 
			case 42: sItem = "ps_amulet_crimson"; break; 
			case 43: sItem = "ps_ring_pi"; break; 
			case 44: sItem = "ps_amulet_mohoin"; break;
			case 45: sItem = "ps_amulet_Kaleido"; break; 
			case 46: sItem = "ps_ring_claw"; break; 
		}
     }
	 else if (nRandom <= SCOD_WEAPONS + SCOD_ARMORS + SCOD_BOOTS + SCOD_CLOAKS + SCOD_BRACERS + SCOD_BELTS + SCOD_HATS + SCOD_SHIELDS + SCOD_JEWELRY + SCOD_MISC)
	 {
		nItem = Random(7) + 1;
		switch (nItem)
		{
			case 1: sItem = "NW_IT_CONTAIN006";  break;
			case 2: sItem = "ps_misc_lichslyrics";  break;
			case 3: sItem = "ps_misc_magicelectrifier";  break;
			case 4: sItem = "nx2_misc_lifecoin";  break;
			case 5: sItem = "ps_misc_shapersalembic"; break;
			case 6: sItem = "ps_misc_shapersdecensor"; break;
			case 7: sItem = "ps_misc_shapersretort"; break;
		}
     }
	 
	 return sItem;
	}

	void CreateSCODitem(object oCreateOn, object oLastOpener, int nTreasureType)
	{
	    string sItem = "";
		switch (nTreasureType)
		{
			case TREASURE_LOW: sItem = LowSCODitem(); break;
			case TREASURE_MEDIUM: sItem = MediumSCODitem(); break;
			case TREASURE_HIGH: sItem = HighSCODitem(); break;
		}
		dbCreateItemOnObject(sItem, oCreateOn, 1);
	}
	
    //::///////////////////////////////////////////////
    //:: CreateTable2GenericItem
    //:: Copyright (c) 2002 Bioware Corp.
    //:://////////////////////////////////////////////
    /*
        Creates an item based upon the class of
        oAdventurer
    */
    //:://////////////////////////////////////////////
    //:: Created By:  Brent
    //:: Created On:
    //:://////////////////////////////////////////////
        void CreateGenericMiscItem(object oTarget, object oAdventurer, int nModifier=0)
        {
            int nHD = GetHitDice(oAdventurer) + nModifier;
            string sItem = "";
            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = Random(6) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mglove004"; break;
                 case 2: sItem = "nw_it_mglove004"; break;
                 case 3: sItem = "nw_it_mglove005"; break;
                 //case 4: sItem = "nw_it_mglove006"; break;
                 case 5: sItem = "nw_it_mglove007"; break;
                 //case 6: sItem = "nw_it_mglove008"; break;
                 case 6: sItem = "nw_it_mglove009"; break;
                 case 4: sItem = "nw_mcloth006"; break;
                 //case 4: sItem = "nw_it_mglove012"; break;
                }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(24) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_mcloth006"; break;
                 case 2: sItem = "nw_it_mring009"; break;
                 case 3: sItem = "nw_it_mring009"; break;
                 case 4: sItem = "nw_it_mring010"; break;
                 case 5: sItem = "nw_it_mring011"; break;
                 case 6: sItem = "nw_it_mboots010"; break;
                 case 7: sItem = "nw_it_mneck024"; break;
                 case 8: sItem = "nw_mcloth007"; break;
                 case 9: sItem = "nw_it_mring024"; break;
                 case 10: sItem = "nw_it_mring012"; break;
                 case 11: sItem = "nw_mcloth008"; break;
                 case 12: sItem = "nw_it_mglove010"; break;
                 case 13: sItem = "nw_it_mglove011"; break;
                 case 14: sItem = "nw_it_mglove013"; break;
                 //case 15: sItem = "nw_it_mglove014"; break;
                 case 16: sItem = "nw_it_mglove015"; break;
                 case 17: sItem = "nw_maarcl097"; break;
                 case 18: sItem = "nw_maarcl097"; break;
                 case 19: sItem = "nw_maarcl099"; break;
                 case 20: sItem = "nw_it_mneck032"; break;
                 case 21: sItem = "nw_mcloth010"; break;
                 case 22: sItem = "nw_it_mbracer002"; break;
                 case 23: sItem = "nw_it_mneck001"; break;
                 case 24: sItem = "nw_maarcl055"; break;
                 case 15: sItem = "nw_mcloth009"; break;
                }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(43) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mring009"; break;
                 case 2: sItem = "nw_it_mring009"; break;
                 case 3: sItem = "nw_it_mring010"; break;
                 case 4: sItem = "nw_it_mring011"; break;
                 case 5: sItem = "nw_it_mboots010"; break;
                 case 6: sItem = "nw_it_mneck024"; break;
                 case 7: sItem = "nw_mcloth007"; break;
                 case 8: sItem = "nw_it_mring024"; break;
                 case 9: sItem = "nw_it_mring012"; break;
                 case 10: sItem = "nw_mcloth008"; break;
                 case 11: sItem = "nw_it_mglove010"; break;
                 case 12: sItem = "nw_it_mglove011"; break;
                 case 13: sItem = "nw_it_mglove013"; break;
                 //case 14: sItem = "nw_it_mglove014"; break;
                 case 15: sItem = "nw_it_mglove015"; break;
                 case 16: sItem = "nw_it_contain003"; break;
                 case 17: sItem = "nw_maarcl097"; break;
                 case 18: sItem = "nw_maarcl099"; break;
                 case 19: sItem = "nw_it_mneck032"; break;
                 case 20: sItem = "nw_mcloth010"; break;
                 case 21: sItem = "nw_it_mbracer002"; break;
                 case 22: sItem = "nw_it_mneck001"; break;
                 case 23: sItem = "nw_maarcl055"; break;
                 case 24: sItem = "nw_mcloth009"; break;
                 case 25: sItem = "nw_it_mring001"; break;
                 case 26: sItem = "nw_it_mboots001"; break;
                 case 27: sItem = "nw_it_mbracer001"; break;
                 case 28: sItem = "nw_it_mneck007"; break;
                 case 29: sItem = "nw_maarcl096"; break;
                 case 30: sItem = "nw_it_mglove003"; break;
                 case 31: sItem = "nw_it_contain004"; break;
                 case 32: sItem = "nw_it_mneck031"; break;
                 case 33: sItem = "nw_it_mring006"; break;
                 case 34: sItem = "nw_it_mneck006"; break;
                 case 35: sItem = "nw_it_mneck029"; break;
                 case 36: sItem = "nw_it_mring013"; break;
                 case 37: sItem = "nw_it_mboots011"; break;
                 case 38: sItem = "nw_it_mneck025"; break;
                 case 39: sItem = "nw_it_mbelt009"; break;
                 case 40: sItem = "nw_it_mbelt010"; break;
                 case 41: sItem = "nw_it_mbelt011"; break;
                 case 42: sItem = "nw_it_mring025"; break;
                 case 43: sItem = "nw_it_mring025"; break;
                 case 14: sItem = "nw_maarcl031"; break;

                }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(48) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mring001"; break;
                 case 2: sItem = "nw_it_mboots001"; break;
                 case 3: sItem = "nw_it_mbracer001"; break;
                 case 4: sItem = "nw_it_mneck007"; break;
                 case 5: sItem = "nw_maarcl096"; break;
                 case 6: sItem = "nw_it_mglove003"; break;
                 case 7: sItem = "nw_it_mneck031"; break;
                 case 8: sItem = "nw_it_mneck031"; break;
                 case 9: sItem = "nw_it_mring006"; break;
                 case 10: sItem = "nw_it_mneck006"; break;
                 case 11: sItem = "nw_it_mneck029"; break;
                 case 12: sItem = "nw_it_mring013"; break;
                 case 13: sItem = "nw_it_mboots011"; break;
                 case 14: sItem = "nw_it_mneck025"; break;
                 case 15: sItem = "nw_it_mbelt009"; break;
                 case 16: sItem = "nw_it_mbelt010"; break;
                 case 17: sItem = "nw_it_mbelt011"; break;
                 case 18: sItem = "nw_it_mring025"; break;
                 case 19: sItem = "nw_it_mring025"; break;
                 case 20: sItem = "nw_it_mbracer007"; break;
                 case 21: sItem = "nw_it_mbracer007"; break;
                 case 22: sItem = "nw_it_mneck012"; break;
                 case 23: sItem = "nw_maarcl088"; break;
                 case 24: sItem = "nw_it_mboots012"; break;
                 case 25: sItem = "nw_it_mneck026"; break;
                 case 26: sItem = "nw_it_mboots006"; break;
                 case 27: sItem = "nw_it_mbracer003"; break;
                 case 28: sItem = "nw_it_mneck008"; break;
                 case 29: sItem = "nw_it_mring008"; break;
                 case 30: sItem = "nw_maarcl056"; break;
                 case 31: sItem = "nw_maarcl092"; break;
                 case 32: sItem = "nw_it_mring014"; break;
                 case 33: sItem = "nw_it_mneck016"; break;
                 case 34: sItem = "nw_it_mboots013"; break;
                 case 35: sItem = "nw_it_mneck027"; break;
                 case 36: sItem = "nw_it_mbracer008"; break;
                 case 37: sItem = "nw_it_mneck013"; break;
                 case 38: sItem = "nw_maarcl089"; break;
                 case 39: sItem = "nw_it_mbelt012"; break;
                 case 40: sItem = "nw_it_mbelt013"; break;
                 case 41: sItem = "nw_it_mbelt014"; break;
                 case 42: sItem = "nw_it_mring027"; break;
                 case 43: sItem = "nw_it_mboots007"; break;
                 case 44: sItem = "nw_it_mbracer004"; break;
                 case 45: sItem = "nw_it_mneck009"; break;
                 case 46: sItem = "nw_it_mring018"; break;
                 case 47: sItem = "nw_maarcl093"; break;
                 case 48: sItem = "nw_it_mboots002"; break;

                }
            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                int nRandom = Random(42) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mbracer007"; break;
                 case 2: sItem = "nw_it_mbracer007"; break;
                 case 3: sItem = "nw_it_mneck012"; break;
                 case 4: sItem = "nw_maarcl088"; break;
                 case 5: sItem = "nw_it_mboots012"; break;
                 case 6: sItem = "nw_it_mneck026"; break;
                 case 7: sItem = "nw_it_mboots006"; break;
                 case 8: sItem = "nw_it_mbracer003"; break;
                 case 9: sItem = "nw_it_mneck008"; break;
                 case 10: sItem = "nw_it_mring008"; break;
                 case 11: sItem = "nw_maarcl056"; break;
                 case 12: sItem = "nw_maarcl092"; break;
                 case 13: sItem = "nw_it_mring014"; break;
                 case 14: sItem = "nw_it_mneck016"; break;
                 case 15: sItem = "nw_it_mboots013"; break;
                 case 16: sItem = "nw_it_mneck027"; break;
                 case 17: sItem = "nw_it_mbracer008"; break;
                 case 18: sItem = "nw_it_mneck013"; break;
                 case 19: sItem = "nw_maarcl089"; break;
                 case 20: sItem = "nw_it_mbelt012"; break;
                 case 21: sItem = "nw_it_mbelt013"; break;
                 case 22: sItem = "nw_it_mbelt014"; break;
                 case 23: sItem = "nw_it_mring027"; break;
                 case 24: sItem = "nw_it_mboots007"; break;
                 case 25: sItem = "nw_it_mbracer004"; break;
                 case 26: sItem = "nw_it_mneck009"; break;
                 case 27: sItem = "nw_it_mring018"; break;
                 case 28: sItem = "nw_maarcl093"; break;
                 case 29: sItem = "nw_it_mboots002"; break;
                 case 30: sItem = "nw_it_mboots014"; break;
                 case 31: sItem = "nw_it_mneck028"; break;
                 case 32: sItem = "nw_it_mring015"; break;
                 case 33: sItem = "nw_it_mbracer009"; break;
                 case 34: sItem = "nw_it_mneck014"; break;
                 case 35: sItem = "nw_maarcl090"; break;
                 case 36: sItem = "nw_it_mring028"; break;
                 case 37: sItem = "nw_it_mneck017"; break;
                 case 38: sItem = "nw_it_mboots008"; break;
                 case 39: sItem = "nw_it_mbracer005"; break;
                 case 40: sItem = "nw_it_mneck010"; break;
                 case 41: sItem = "nw_it_mmidmisc02"; break;
                 case 42: sItem = "nw_it_mring019"; break;
                }
            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                int nRandom = Random(30) + 1;
                switch (nRandom)
                {
                 case 1: sItem = "nw_it_mring027"; break;
                 case 2: sItem = "nw_it_mboots007"; break;
                 case 3: sItem = "nw_it_mbracer004"; break;
                 case 4: sItem = "nw_it_mneck009"; break;
                 case 5: sItem = "nw_it_mring018"; break;
                 case 6: sItem = "nw_maarcl093"; break;
                 case 7: sItem = "nw_it_mboots002"; break;
                 case 8: sItem = "nw_it_mboots014"; break;
                 case 9: sItem = "nw_it_mneck028"; break;
                 case 10: sItem = "nw_it_mring015"; break;
                 case 11: sItem = "nw_it_mbracer009"; break;
                 case 12: sItem = "nw_it_mneck014"; break;
                 case 13: sItem = "nw_maarcl090"; break;
                 case 14: sItem = "nw_it_mring028"; break;
                 case 15: sItem = "nw_it_mneck017"; break;
                 case 16: sItem = "nw_it_mboots008"; break;
                 case 17: sItem = "nw_it_mbracer005"; break;
                 case 18: sItem = "nw_it_mneck010"; break;
                 case 19: sItem = "nw_it_mmidmisc02"; break;
                 case 20: sItem = "nw_maarcl094"; break;
                 case 21: sItem = "nw_it_mring019"; break;
                 case 22: sItem = "nw_it_mring016"; break;
                 case 23: sItem = "nw_it_mbracer010"; break;
                 case 24: sItem = "nw_it_mneck015"; break;
                 case 25: sItem = "nw_maarcl091"; break;
                 case 26: sItem = "nw_it_mboots009"; break;
                 case 27: sItem = "nw_it_mbracer006"; break;
                 case 28: sItem = "nw_it_mneck011"; break;
                 case 29: sItem = "nw_maarcl095"; break;
                 case 30: sItem = "nw_it_mneck018"; break;
                }
             }
             //dbSpeak("Create Misc");

             dbCreateItemOnObject(sItem, oTarget, 1);
         }

         // * this function just returns an item that is more appropriate
         // * for this class. Only wizards, sorcerers, clerics, monks, rogues and bards get this
        void CreateGenericClassItem(object oTarget, object oAdventurer, int nSpecific =0)
        {


            if (GetLevelByClass(CLASS_TYPE_DRUID, oAdventurer)>= 1)
            {
                if (nSpecific == 0)
                {
                    CreateGenericDruidWeapon(oTarget, oAdventurer);
                }
                else
                {
                    CreateSpecificDruidWeapon(oTarget, oAdventurer);
                }
            }
            else
            if (GetLevelByClass(CLASS_TYPE_WIZARD, oAdventurer)>= 1 || GetLevelByClass(CLASS_TYPE_SORCERER, oAdventurer) >= 1)
            {
                // * 30% chance of getting a magic scroll else get a weapon suited for a wizard
                if (Random(100) + 1 > 70)
                {
                    // * grab an arcane scroll as if the wizard had +4 levels
                    CreateArcaneScroll(oTarget, oAdventurer, 4);
                }
                else
                if (nSpecific == 0)
                {
                    CreateGenericWizardWeapon(oTarget, oAdventurer);
                }
                else
                {
                    CreateSpecificWizardWeapon(oTarget, oAdventurer);
                }


            }
            else
            if (GetLevelByClass(CLASS_TYPE_CLERIC, oAdventurer)>= 1)
            {
                  int nRandom = Random(4) + 1;
                  string sItem = "nw_it_medkit001";
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_it_medkit001"; break;
                       case 2: sItem = "nw_it_medkit002"; break;
                       case 3: sItem = "nw_it_medkit003"; break;
                       case 4: sItem = "nw_it_medkit004"; break;
                   }
                  dbCreateItemOnObject(sItem, oTarget, 1);
            }
            else
            if (GetLevelByClass(CLASS_TYPE_MONK, oAdventurer)>= 1)
            {
                //dbSpeak("in monk function");
                if (nSpecific == 0)
                {
                    CreateGenericMonkWeapon(oTarget, oAdventurer);
                }
                else
                {
                    CreateSpecificMonkWeapon(oTarget, oAdventurer);
                }
            }
            else
            if (GetLevelByClass(CLASS_TYPE_ROGUE, oAdventurer)>= 1)
            {
                // * give a misc item as if a couple levels higher
                CreateGenericMiscItem(oTarget, oAdventurer, 2);
            }
            else
            if (GetLevelByClass(CLASS_TYPE_BARD, oAdventurer)>= 1)
            {
                // * give a misc item as if a couple levels higher
                CreateGenericMiscItem(oTarget, oAdventurer, 2);
            }

        }
        void CreateGenericRodStaffWand(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = Random(2) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn013"; break;
                    //case 2: sItem = "nw_wmgwn006"; break;
                    case 2: sItem = "nw_it_gem002";  break;  // gem for variety
                }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(2) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn013"; break;
                    //case 2: sItem = "nw_wmgwn006"; break;
                    case 2: sItem = "nw_it_gem002";  break;// gem for variety
                }
            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(3) + 1;
                switch (nRandom)
                {
                    //case 1: sItem = "nw_wmgwn006"; break;
                    case 2: sItem = "nw_wmgwn004"; break;
                    case 3: sItem = "nw_wmgrd002"; break;
                    case 1: sItem = "nw_wmgwn012"; break;
                }
            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(11) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn004"; break;
                    case 2: sItem = "nw_wmgwn002"; break;
                    case 3: sItem = "nw_wmgwn007"; break;
                    case 4: sItem = "nw_wmgwn003"; break;
                    case 5: sItem = "nw_wmgwn010"; break;
                    case 6: sItem = "nw_wmgwn011"; break;
                    case 7: sItem = "nw_wmgwn005"; break;
                    case 8: sItem = "nw_wmgwn008"; break;
                    case 9: sItem = "nw_wmgwn009"; break;
                    case 10: sItem = "nw_wmgrd002"; break;
                    case 11: sItem = "nw_wmgwn012"; break;
                }

            }
            else  // * 2500 - 16500
            {
                int nRandom = d8();
                switch (nRandom)
                {
                    case 1: sItem = "nw_wmgwn002"; break;
                    case 2: sItem = "nw_wmgwn007"; break;
                    case 3: sItem = "nw_wmgwn003"; break;
                    case 4: sItem = "nw_wmgwn010"; break;
                    case 5: sItem = "nw_wmgwn011"; break;
                    case 6: sItem = "nw_wmgwn005"; break;
                    case 7: sItem = "nw_wmgwn008"; break;
                    case 8: sItem = "nw_wmgwn009"; break;
                }

            }
          //dbSpeak("Generic Rod staff wand");

           dbCreateItemOnObject(sItem, oTarget, 1);
        }

        void CreateGenericMonkWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wbwsl001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspka001"; break;
                       case 7: sItem = "nw_wbwxh001"; break;
                       case 8: sItem = "nw_waxhn001"; break;
                       case 9: sItem = "nw_wbwxl001"; break;
                       case 10: sItem = "nw_wthmsh002"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wbwsl001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspka001"; break;
                       case 7: sItem = "nw_wbwxh001"; break;
                       case 8: sItem = "nw_waxhn001"; break;
                       case 9: sItem = "nw_wbwxl001"; break;
                       case 10: sItem = "nw_wthmsh002"; break;
                       case 11: sItem = "nw_wbwmsl001"; break;
                       case 12: sItem = "nw_wbwmxh002"; break;
                       case 13: sItem = "nw_wthmsh008"; break;
                       case 14: sItem = "nw_wbwmxl002"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl001"; break;
                       case 2: sItem = "nw_wbwmxh002"; break;
                       case 3: sItem = "nw_wthmsh008"; break;
                       case 4: sItem = "nw_wbwmxl002"; break;
                       case 5: sItem = "nw_wthmsh009"; break;
                       case 6: sItem = "nw_wblmcl002"; break;
                       case 7: sItem = "nw_wdbmqs002"; break;
                       case 8: sItem = "nw_wswmdg002"; break;
                       case 9: sItem = "nw_wspmka002"; break;
                       case 10: sItem = "nw_waxmhn002"; break;
                       case 11: sItem = "nw_wbwmsl009"; break;
                       case 12: sItem = "nw_wbwmxh008"; break;
                       case 13: sItem = "nw_wbwmxl008"; break;
                   }


            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh009"; break;
                       case 2: sItem = "nw_wblmcl002"; break;
                       case 3: sItem = "nw_wdbmqs002"; break;
                       case 4: sItem = "nw_wswmdg002"; break;
                       case 5: sItem = "nw_wspmka002"; break;
                       case 6: sItem = "nw_waxmhn002"; break;
                       case 7: sItem = "nw_wbwmsl009"; break;
                       case 8: sItem = "nw_wbwmxh008"; break;
                       case 9: sItem = "nw_wbwmxl008"; break;
                       case 10: sItem = "nw_wbwmsl010"; break;
                       case 11: sItem = "nw_wbwmxh009"; break;
                       case 12: sItem = "nw_wbwmxl009"; break;
                       case 13: sItem = "nw_wblmcl010"; break;
                       case 14: sItem = "nw_wdbmqs008"; break;
                       case 15: sItem = "nw_wswmdg008"; break;
                       case 16: sItem = "nw_wspmka008"; break;
                       case 17: sItem = "nw_waxmhn010"; break;
                   }
            }
            else  // * 2500 - 16500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl010"; break;
                       case 2: sItem = "nw_wbwmxh009"; break;
                       case 3: sItem = "nw_wbwmxl009"; break;
                       case 4: sItem = "nw_wblmcl010"; break;
                       case 5: sItem = "nw_wdbmqs008"; break;
                       case 6: sItem = "nw_wswmdg008"; break;
                       case 7: sItem = "nw_wspmka008"; break;
                       case 8: sItem = "nw_waxmhn010"; break;
                       case 9: sItem = "nw_wblmcl011"; break;
                       case 10: sItem = "nw_wdbmqs009"; break;
                       case 11: sItem = "nw_wswmdg009"; break;
                       case 12: sItem = "nw_wspmka009"; break;
                       case 13: sItem = "nw_waxmhn011"; break;
                   }
            }
          //dbSpeak("Generic Monk Weapon");

           dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificMonkWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {

            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 800
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh003"; break;
                       case 2: sItem = "nw_wthmsh006"; break;
                       case 3: CreateGenericMonkWeapon(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                  }

            }
            else if (GetRange(2, nHD))   // * 2500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh003"; break;
                       case 2: sItem = "nw_wthmsh006"; break;
                       case 3: sItem = "nw_wthmsh004"; break;
                       case 4: sItem = "nw_wthmsh007"; break;
                       case 5: sItem = "NW_IT_MGLOVE016"; break;
                       case 6: sItem = "NW_IT_MGLOVE021"; break;
                       case 7: sItem = "NW_IT_MGLOVE026"; break;
                       case 8: CreateGenericMonkWeapon(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(21) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh006"; break;
                       case 2: sItem = "nw_wthmsh004"; break;
                       case 3: sItem = "nw_wthmsh007"; break;
                       case 4: sItem = "nw_wbwmsl005"; break;
                       case 5: sItem = "nw_wbwmxh005"; break;
                       case 6: sItem = "nw_wspmka004"; break;
                       case 7: sItem = "nw_wbwmxl005"; break;
                       case 8: sItem = "nw_wspmka007"; break;
                       case 9: sItem = "nw_wswmdg006"; break;
                       case 10: sItem = "nw_wspmka005"; break;
                       case 11: sItem = "NW_IT_MGLOVE016"; break;
                       case 12: sItem = "NW_IT_MGLOVE021"; break;
                       case 13: sItem = "NW_IT_MGLOVE026"; break;

                       case 14: sItem = "NW_IT_MGLOVE017"; break;
                       case 15: sItem = "NW_IT_MGLOVE022"; break;
                       case 16: sItem = "NW_IT_MGLOVE027"; break;

                       case 17: sItem = "NW_IT_MGLOVE018"; break;
                       case 18: sItem = "NW_IT_MGLOVE023"; break;
                       case 19: sItem = "NW_IT_MGLOVE028"; break;

                       case 20: sItem = "NW_IT_MGLOVE029"; break;
                       case 21: sItem = "NW_IT_MGLOVE030"; break;


                   }

            }
            else if (GetRange(4, nHD))   // * 2500 -16500
            {
                  int nRandom = Random(22) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsl005"; break;
                       case 2: sItem = "nw_wbwmxh005"; break;
                       case 3: sItem = "nw_wspmka004"; break;
                       case 4: sItem = "nw_wbwmxl005"; break;
                       case 5: sItem = "nw_wspmka007"; break;
                       case 6: sItem = "nw_wswmdg006"; break;
                       case 7: sItem = "nw_wspmka005"; break;
                       case 8: sItem = "nw_wblmcl004"; break;
                       case 9: sItem = "nw_wblmcl003"; break;
                       case 10: sItem = "nw_wbwmsl003"; break;
                       case 11: sItem = "nw_wbwmxh003"; break;
                       case 12: sItem = "nw_waxmhn004"; break;
                       case 13: sItem = "nw_wbwmxl003"; break;

                       case 14: sItem = "NW_IT_MGLOVE017"; break;
                       case 15: sItem = "NW_IT_MGLOVE022"; break;

                       case 16: sItem = "NW_IT_MGLOVE018"; break;
                       case 17: sItem = "NW_IT_MGLOVE023"; break;
                       case 18: sItem = "NW_IT_MGLOVE028"; break;

                       case 19: sItem = "NW_IT_MGLOVE029"; break;
                       case 20: sItem = "NW_IT_MGLOVE030"; break;

                       case 21: sItem = "NW_IT_MGLOVE019"; break;
                       case 22: sItem = "NW_IT_MGLOVE024"; break;


                   }

            }
            else  // * 16000 +
            {
                  int nRandom = Random(24) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wspmka006"; break;
                       case 3: sItem = "nw_wbwmxl004"; break;
                       case 4: sItem = "nw_wspmka003"; break;
                       case 5: sItem = "nw_wbwmxl007"; break;
                       case 6: sItem = "nw_waxmhn003"; break;
                       case 7: sItem = "nw_wblmcl005"; break;
                       case 8: sItem = "nw_wswmdg004"; break;
                       case 9: sItem = "nw_wbwmsl007"; break;
                       case 10: sItem = "nw_wbwmxh004"; break;
                       case 11: sItem = "nw_waxmhn005"; break;
                       case 12: sItem = "nw_wbwmxh007"; break;
                       case 13: sItem = "nw_wswmdg003"; break;
                       case 14: sItem = "nw_wswmdg007"; break;
                       case 15: sItem = "nw_wbwmsl006"; break;
                       case 16: sItem = "nw_wbwmsl008"; break;
                       case 17: sItem = "nw_wblmcl006"; break;
                       case 18: sItem = "nw_wbwmsl004"; break;
                       case 19: sItem = "nw_waxmhn006"; break;
                       case 20: sItem = "nw_wbwmxh006"; break;
                       case 21: sItem = "nw_wswmdg005"; break;
                       case 22: sItem = "nw_wbwmxl006"; break;

                       case 23: sItem = "NW_IT_MGLOVE020"; break;
                       case 24: sItem = "NW_IT_MGLOVE025"; break;

                   }

            }
           //dbSpeak("Specific Monk Weapon");

           dbCreateItemOnObject(sItem, oTarget, 1);

        }

        void CreateGenericDruidWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthdt001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wplss001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspsc001"; break;
                       case 7: sItem = "nw_wswsc001"; break;
                       case 8: sItem = "nw_wthmdt002"; break;
                   }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthdt001"; break;
                       case 2: sItem = "nw_wblcl001"; break;
                       case 3: sItem = "nw_wdbqs001"; break;
                       case 4: sItem = "nw_wplss001"; break;
                       case 5: sItem = "nw_wswdg001"; break;
                       case 6: sItem = "nw_wspsc001"; break;
                       case 7: sItem = "nw_wswsc001"; break;
                       case 8: sItem = "nw_wthmdt002"; break;
                       case 9: sItem = "nw_wthmdt005"; break;
                       case 10: sItem = "nw_wbwmsl001"; break;
                       case 11: sItem = "nw_wthmdt008"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt005"; break;
                       case 2: sItem = "nw_wbwmsl001"; break;
                       case 3: sItem = "nw_wthmdt008"; break;
                       case 4: sItem = "nw_wthmdt009"; break;
                       case 5: sItem = "nw_wthmdt006"; break;
                       case 6: sItem = "nw_wblmcl002"; break;
                       case 7: sItem = "nw_wdbmqs002"; break;
                       case 8: sItem = "nw_wplmss002"; break;
                       case 9: sItem = "nw_wswmdg002"; break;
                       case 10: sItem = "nw_wspmsc002"; break;
                       case 11: sItem = "nw_wswmsc002"; break;
                       case 12: sItem = "nw_wthmdt003"; break;
                       case 13: sItem = "nw_wbwmsl009"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(19) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt009"; break;
                       case 2: sItem = "nw_wthmdt006"; break;
                       case 3: sItem = "nw_wblmcl002"; break;
                       case 4: sItem = "nw_wdbmqs002"; break;
                       case 5: sItem = "nw_wplmss002"; break;
                       case 6: sItem = "nw_wswmdg002"; break;
                       case 7: sItem = "nw_wspmsc002"; break;
                       case 8: sItem = "nw_wswmsc002"; break;
                       case 9: sItem = "nw_wthmdt003"; break;
                       case 10: sItem = "nw_wbwmsl009"; break;
                       case 11: sItem = "nw_wthmdt007"; break;
                       case 12: sItem = "nw_wthmdt004"; break;
                       case 13: sItem = "nw_wbwmsl010"; break;
                       case 14: sItem = "nw_wblmcl010"; break;
                       case 15: sItem = "nw_wdbmqs008"; break;
                       case 16: sItem = "nw_wplmss010"; break;
                       case 17: sItem = "nw_wswmdg008"; break;
                       case 18: sItem = "nw_wspmsc010"; break;
                       case 19: sItem = "nw_wswmsc010"; break;
                   }

            }
            else  // * 2500 - 16500
            {
                  int nRandom = Random(15) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmdt007"; break;
                       case 2: sItem = "nw_wthmdt004"; break;
                       case 3: sItem = "nw_wbwmsl010"; break;
                       case 4: sItem = "nw_wblmcl010"; break;
                       case 5: sItem = "nw_wdbmqs008"; break;
                       case 6: sItem = "nw_wplmss010"; break;
                       case 7: sItem = "nw_wswmdg008"; break;
                       case 8: sItem = "nw_wspmsc010"; break;
                       case 9: sItem = "nw_wswmsc010"; break;
                       case 10: sItem = "nw_wblmcl011"; break;
                       case 11: sItem = "nw_wdbmqs009"; break;
                       case 12: sItem = "nw_wplmss011"; break;
                       case 13: sItem = "nw_wswmdg009"; break;
                       case 14: sItem = "nw_wspmsc011"; break;
                       case 15: sItem = "nw_wswmsc011"; break;
                   }

            }
          //dbSpeak("Generic Druid weapon");

           dbCreateItemOnObject(sItem, oTarget, 1);


        }
        void CreateSpecificDruidWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {

            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericDruidWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;

            }
            else if (GetRange(2, nHD))   // * 2500
            {
                CreateGenericDruidWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmsl005"; break;
                       case 4: sItem = "nw_wswmdg006"; break;
                       case 5: CreateGenericDruidWeapon(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 -16500
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmsl005"; break;
                       case 4: sItem = "nw_wswmdg006"; break;
                       case 5: sItem = "nw_wblmcl004"; break;
                       case 6: sItem = "nw_wdbmqs004"; break;
                       case 7: sItem = "nw_wblmcl003"; break;
                       case 8: sItem = "nw_wbwmsl003"; break;
                       case 9: sItem = "nw_wswmsc004"; break;
                       case 10: sItem = "nw_wplmss005"; break;
                   }

            }
            else  // * 16000 +
            {
                  int nRandom = Random(18) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs003"; break;
                       case 2: sItem = "nw_wblmcl005"; break;
                       case 3: sItem = "nw_wplmss007"; break;
                       case 4: sItem = "nw_wswmdg004"; break;
                       case 5: sItem = "nw_wbwmsl007"; break;
                       case 6: sItem = "nw_wplmss006"; break;
                       case 7: sItem = "nw_wswmsc006"; break;
                       case 8: sItem = "nw_wswmdg003"; break;
                       case 9: sItem = "nw_wswmdg007"; break;
                       case 10: sItem = "nw_wswmsc007"; break;
                       case 11: sItem = "nw_wbwmsl006"; break;
                       case 12: sItem = "nw_wbwmsl008"; break;
                       case 13: sItem = "nw_wdbmqs007"; break;
                       case 14: sItem = "nw_wblmcl006"; break;
                       case 15: sItem = "nw_wbwmsl004"; break;
                       case 16: sItem = "nw_wswmsc005"; break;
                       case 17: sItem = "nw_wplmss004"; break;
                       case 18: sItem = "nw_wswmdg005"; break;
                   }

            }
          //dbSpeak("specific druid weapon");

           dbCreateItemOnObject(sItem, oTarget, 1);

        }

        void CreateGenericWizardWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblcl001"; break;
                       case 2: sItem = "nw_wdbqs001"; break;
                       case 3: sItem = "nw_wswdg001"; break;
                       case 4: sItem = "nw_wbwxh001"; break;
                       case 5: sItem = "nw_wbwxl001"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblcl001"; break;
                       case 2: sItem = "nw_wdbqs001"; break;
                       case 3: sItem = "nw_wswdg001"; break;
                       case 4: sItem = "nw_wbwxh001"; break;
                       case 5: sItem = "nw_wbwxl001"; break;
                       case 6: sItem = "nw_wbwmxl002"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl002"; break;
                       case 2: sItem = "nw_wblmcl002"; break;
                       case 3: sItem = "nw_wdbmqs002"; break;
                       case 4: sItem = "nw_wswmdg002"; break;
                       case 5: sItem = "nw_wbwmxh008"; break;
                       case 6: sItem = "nw_wbwmxl008"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl002"; break;
                       case 2: sItem = "nw_wdbmqs002"; break;
                       case 3: sItem = "nw_wswmdg002"; break;
                       case 4: sItem = "nw_wbwmxh008"; break;
                       case 5: sItem = "nw_wbwmxl008"; break;
                       case 6: sItem = "nw_wbwmxh009"; break;
                       case 7: sItem = "nw_wbwmxl009"; break;
                       case 8: sItem = "nw_wblmcl010"; break;
                       case 9: sItem = "nw_wdbmqs008"; break;
                       case 10: sItem = "nw_wswmdg008"; break;
                   }

            }
            else  // * 2500 - 16500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxh009"; break;
                       case 2: sItem = "nw_wbwmxl009"; break;
                       case 3: sItem = "nw_wblmcl010"; break;
                       case 4: sItem = "nw_wdbmqs008"; break;
                       case 5: sItem = "nw_wswmdg008"; break;
                       case 6: sItem = "nw_wblmcl011"; break;
                       case 7: sItem = "nw_wdbmqs009"; break;
                       case 8: sItem = "nw_wswmdg009"; break;
                   }

            }
          //dbSpeak("Generic Wizard or Sorcerer Weapon");

           dbCreateItemOnObject(sItem, oTarget, 1);

        }
        void CreateSpecificWizardWeapon(object oTarget, object oAdventurer, int nModifier = 0)
        {

            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericWizardWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;
            }
            else if (GetRange(2, nHD))   // * 2500
            {
                CreateGenericWizardWeapon(oTarget, oAdventurer, JUMP_LEVEL); return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmxh005"; break;
                       case 4: sItem = "nw_wbwmxl005"; break;
                       case 5: sItem = "nw_wswmdg006"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 -16500
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs006"; break;
                       case 3: sItem = "nw_wbwmxh005"; break;
                       case 4: sItem = "nw_wbwmxl005"; break;
                       case 5: sItem = "nw_wswmdg006"; break;
                       case 6: sItem = "nw_wblmcl004"; break;
                       case 7: sItem = "nw_wdbmqs004"; break;
                       case 8: sItem = "nw_wblmcl003"; break;
                       case 9: sItem = "nw_wbwmxh003"; break;
                       case 10: sItem = "nw_wbwmxl003"; break;
                   }

            }
            else  // * 16000 +
            {
                  int nRandom = Random(15) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wdbmqs003"; break;
                       case 3: sItem = "nw_wbwmxl004"; break;
                       case 4: sItem = "nw_wbwmxl007"; break;
                       case 5: sItem = "nw_wblmcl005"; break;
                       case 6: sItem = "nw_wswmdg004"; break;
                       case 7: sItem = "nw_wbwmxh004"; break;
                       case 8: sItem = "nw_wbwmxh007"; break;
                       case 9: sItem = "nw_wswmdg003"; break;
                       case 10: sItem = "nw_wswmdg007"; break;
                       case 11: sItem = "nw_wdbmqs007"; break;
                       case 12: sItem = "nw_wblmcl006"; break;
                       case 13: sItem = "nw_wbwmxh006"; break;
                       case 14: sItem = "nw_wswmdg005"; break;
                       case 15: sItem = "nw_wbwmxl006"; break;
                   }

            }
          //dbSpeak("Specific Wizard or Sorcerer Weapon");

           dbCreateItemOnObject(sItem, oTarget, 1);

        }

        void CreateGenericSimple(object oTarget, object oAdventurer, int nModifier = 0)
        {
           string sItem = "";
           int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = d12();
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthdt001"; break;
                    case 2: sItem = "nw_wblcl001"; break;
                    case 3: sItem = "nw_wbwsl001"; break;
                    case 4: sItem = "nw_wplss001"; break;
                    case 5: sItem = "nw_wdbqs001"; break;
                    case 6: sItem = "nw_wswdg001"; break;
                    case 7: sItem = "nw_wblml001"; break;
                    case 8: sItem = "nw_wbwxh001"; break;
                    case 9: sItem = "nw_wspsc001"; break;
                    case 10: sItem = "nw_wblms001"; break;
                    case 11: sItem = "nw_wbwxl001"; break;
                    case 12: sItem = "nw_wthmdt002"; break;
                }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(17) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthdt001"; break;
                    case 2: sItem = "nw_wblcl001"; break;
                    case 3: sItem = "nw_wbwsl001"; break;
                    case 4: sItem = "nw_wplss001"; break;
                    case 5: sItem = "nw_wdbqs001"; break;
                    case 6: sItem = "nw_wswdg001"; break;
                    case 7: sItem = "nw_wblml001"; break;
                    case 8: sItem = "nw_wbwxh001"; break;
                    case 9: sItem = "nw_wspsc001"; break;
                    case 10: sItem = "nw_wblms001"; break;
                    case 11: sItem = "nw_wbwxl001"; break;
                    case 12: sItem = "nw_wthmdt002"; break;
                    case 13: sItem = "nw_wthmdt005"; break;
                    case 14: sItem = "nw_wbwmsl001"; break;
                    case 15: sItem = "nw_wbwmxh002"; break;
                    case 16: sItem = "nw_wthmdt008"; break;
                    case 17: sItem = "nw_wbwmxl002"; break;
                }
            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(19) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthmdt005"; break;
                    case 2: sItem = "nw_wbwmsl001"; break;
                    case 3: sItem = "nw_wbwmxh002"; break;
                    case 4: sItem = "nw_wthmdt008"; break;
                    case 5: sItem = "nw_wbwmxl002"; break;
                    case 6: sItem = "nw_wthmdt009"; break;
                    case 7: sItem = "nw_wthmdt006"; break;
                    case 8: sItem = "nw_wblmcl002"; break;
                    case 9: sItem = "nw_wplmss002"; break;
                    case 10: sItem = "nw_wdbmqs002"; break;
                    case 11: sItem = "nw_wswmdg002"; break;
                    case 12: sItem = "nw_wblmml002"; break;
                    case 13: sItem = "nw_wspmsc002"; break;
                    case 14: sItem = "nw_wblmms002"; break;
                    case 15: sItem = "nw_wthmdt003"; break;
                    case 16: sItem = "nw_wthmdt003"; break;
                    case 17: sItem = "nw_wbwmsl009"; break;
                    case 18: sItem = "nw_wbwmxh008"; break;
                    case 19: sItem = "nw_wbwmxl008"; break;
                }
            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(27) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthmdt009"; break;
                    case 2: sItem = "nw_wthmdt006"; break;
                    case 3: sItem = "nw_wblmcl002"; break;
                    case 4: sItem = "nw_wplmss002"; break;
                    case 5: sItem = "nw_wdbmqs002"; break;
                    case 6: sItem = "nw_wswmdg002"; break;
                    case 7: sItem = "nw_wblmml002"; break;
                    case 8: sItem = "nw_wspmsc002"; break;
                    case 9: sItem = "nw_wblmms002"; break;
                    case 10: sItem = "nw_wthmdt003"; break;
                    case 11: sItem = "nw_wthmdt003"; break;
                    case 12: sItem = "nw_wbwmsl009"; break;
                    case 13: sItem = "nw_wbwmxh008"; break;
                    case 14: sItem = "nw_wbwmxl008"; break;
                    case 15: sItem = "nw_wthmdt007"; break;
                    case 16: sItem = "nw_wthmdt004"; break;
                    case 17: sItem = "nw_wbwmsl010"; break;
                    case 18: sItem = "nw_wbwmxh009"; break;
                    case 19: sItem = "nw_wbwmxl009"; break;
                    case 20: sItem = "nw_wbwmsl005"; break;
                    case 21: sItem = "nw_wblmcl010"; break;
                    case 22: sItem = "nw_wplmss010"; break;
                    case 23: sItem = "nw_wdbmqs008"; break;
                    case 24: sItem = "nw_wswmdg008"; break;
                    case 25: sItem = "nw_wblmml011"; break;
                    case 26: sItem = "nw_wspmsc010"; break;
                    case 27: sItem = "nw_wblmms010"; break;



                }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                int nRandom = Random(23) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthmdt007"; break;
                    case 2: sItem = "nw_wthmdt004"; break;
                    case 3: sItem = "nw_wbwmsl010"; break;
                    case 4: sItem = "nw_wbwmxh009"; break;
                    case 5: sItem = "nw_wbwmxl009"; break;
                    case 6: sItem = "nw_wbwmsl005"; break;
                    case 7: sItem = "nw_wblmcl010"; break;
                    case 8: sItem = "nw_wplmss010"; break;
                    case 9: sItem = "nw_wdbmqs008"; break;
                    case 10: sItem = "nw_wswmdg008"; break;
                    case 11: sItem = "nw_wblmml011"; break;
                    case 12: sItem = "nw_wspmsc010"; break;
                    case 13: sItem = "nw_wblmms010"; break;
                    case 14: sItem = "nw_wblmms010"; break;
                    case 15: sItem = "nw_wblmms010"; break;
                    case 16: sItem = "nw_wblmms010"; break;
                    case 17: sItem = "nw_wblmcl011"; break;
                    case 18: sItem = "nw_wplmss011"; break;
                    case 19: sItem = "nw_wdbmqs009"; break;
                    case 20: sItem = "nw_wswmdg009"; break;
                    case 21: sItem = "nw_wblmml012"; break;
                    case 22: sItem = "nw_wspmsc011"; break;
                    case 23: sItem = "nw_wblmms011"; break;



                }
            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                int nRandom = Random(7) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wblmcl011"; break;
                    case 2: sItem = "nw_wplmss011"; break;
                    case 3: sItem = "nw_wdbmqs009"; break;
                    case 4: sItem = "nw_wswmdg009"; break;
                    case 5: sItem = "nw_wblmml012"; break;
                    case 6: sItem = "nw_wspmsc011"; break;
                    case 7: sItem = "nw_wblmms011"; break;



                }
            }
            //dbSpeak("Create Generic SImple; Specific = " + IntToString(nModifier));

            dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericMartial(object oTarget, object oAdventurer, int nModifier = 0)
        {
           string sItem = "";

            int nHD = GetHitDice(oAdventurer) +nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                int nRandom = Random(16) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthax001"; break;
                    case 2: sItem = "nw_wblhl001"; break;
                    case 3: sItem = "nw_waxhn001"; break;
                    case 4: sItem = "nw_wblfl001"; break;
                    case 5: sItem = "nw_waxbt001"; break;
                    case 6: sItem = "nw_wplhb001"; break;
                    case 7: sItem = "nw_wswss001"; break;
                    case 8: sItem = "nw_wblhw001"; break;
                    // case 9: sItem = "nw_wblfh001"; break;
                    case 10: sItem = "nw_wswls001"; break;
                    case 11: sItem = "nw_wswsc001"; break;
                    case 12: sItem = "nw_waxgr001"; break;
                    case 13: sItem = "nw_wswrp001"; break;
                    case 14: sItem = "nw_wbwsh001"; break;
                    case 15: sItem = "nw_wswbs001"; break;
                    case 16: sItem = "nw_wswgs001"; break;
                    case 9: sItem = "nw_wbwln001"; break;
                }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                int nRandom = Random(19) + 1;
                switch (nRandom)
                {
                    case 1: sItem = "nw_wthax001"; break;
                    case 2: sItem = "nw_wblhl001"; break;
                    case 3: sItem = "nw_waxhn001"; break;
                    case 4: sItem = "nw_wblfl001"; break;
                    case 5: sItem = "nw_waxbt001"; break;
                    case 6: sItem = "nw_wplhb001"; break;
                    case 7: sItem = "nw_wswss001"; break;
                    case 8: sItem = "nw_wblhw001"; break;
                    //case 9: sItem = "nw_wblfh001"; break;
                    case 10: sItem = "nw_wswls001"; break;
                    case 11: sItem = "nw_wswsc001"; break;
                    case 12: sItem = "nw_waxgr001"; break;
                    case 13: sItem = "nw_wswrp001"; break;
                    case 14: sItem = "nw_wbwsh001"; break;
                    case 15: sItem = "nw_wswbs001"; break;
                    case 16: sItem = "nw_wswgs001"; break;
                    case 17: sItem = "nw_wbwln001"; break;
                    case 18: sItem = "nw_wthmax002"; break;
                    case 19: sItem = "nw_wbwmsh002"; break;
                    case 9: sItem = "nw_wbwmln002"; break;
                }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                int nRandom = Random(19) + 1;
                switch (nRandom)
                {
                         case 1: sItem = "nw_wthmax002"; break;
                         case 2: sItem = "nw_wbwmsh002"; break;
                         case 3: sItem = "nw_wbwmln002"; break;
                         case 4: sItem = "nw_wblmhl002"; break;
                         case 5: sItem = "nw_waxmhn002"; break;
                         case 6: sItem = "nw_wblmfl002"; break;
                         case 7: sItem = "nw_waxmbt002"; break;
                         case 8: sItem = "nw_wplmhb002"; break;
                         case 9: sItem = "nw_wblmhw002"; break;
                         //case 10: sItem = "nw_wblmfh002"; break;
                         case 11: sItem = "nw_wswmls002"; break;
                         case 12: sItem = "nw_wswmsc002"; break;
                         case 13: sItem = "nw_waxmgr002"; break;
                         case 14: sItem = "nw_wswmrp002"; break;
                         case 15: sItem = "nw_wswmbs002"; break;
                         case 16: sItem = "nw_wswmgs002"; break;
                         case 17: sItem = "nw_wthmax008"; break;
                         case 18: sItem = "nw_wbwmsh008"; break;
                         case 19: sItem = "nw_wbwmln008"; break;
                         case 10: sItem = "nw_wswmss002"; break;

                 }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                int nRandom = Random(31) + 1;
                switch (nRandom)
                {
                     case 1: sItem = "nw_wblmhl002"; break;
                     case 2: sItem = "nw_waxmhn002"; break;
                     case 3: sItem = "nw_wblmfl002"; break;
                     case 4: sItem = "nw_waxmbt002"; break;
                     case 5: sItem = "nw_wplmhb002"; break;
                     case 6: sItem = "nw_wblmhw002"; break;
                     //case 7: sItem = "nw_wblmfh002"; break;
                     case 8: sItem = "nw_wswmls002"; break;
                     case 9: sItem = "nw_wswmsc002"; break;
                     case 10: sItem = "nw_waxmgr002"; break;
                     case 11: sItem = "nw_wswmrp002"; break;
                     case 12: sItem = "nw_wswmbs002"; break;
                     case 13: sItem = "nw_wswmgs002"; break;
                     case 14: sItem = "nw_wthmax008"; break;
                     case 15: sItem = "nw_wbwmsh008"; break;
                     case 16: sItem = "nw_wbwmln008"; break;
                     case 17: sItem = "nw_wbwmsh009"; break;
                     case 18: sItem = "nw_wbwmln009"; break;
                     case 19: sItem = "nw_wblmhl010"; break;
                     case 20: sItem = "nw_waxmhn010"; break;
                     case 21: sItem = "nw_wblmfl010"; break;
                     case 22: sItem = "nw_waxmbt010"; break;
                     case 23: sItem = "nw_wplmhb010"; break;
                     case 24: sItem = "nw_wblmhw011"; break;
                     //case 25: sItem = "nw_wblmfh010"; break;
                     case 26: sItem = "nw_wswmls010"; break;
                     case 27: sItem = "nw_waxmgr009"; break;
                     case 28: sItem = "nw_wswmbs009"; break;
                     case 29: sItem = "nw_wswmgs011"; break;
                     case 30: sItem = "nw_wswmrp010"; break;
                    case 31: sItem = "nw_wswmsc010"; break;
                    case 25: sItem = "nw_wswmss002"; break;
                    case 7: sItem = "nw_wswmss009"; break;
                 }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(19) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmsh009"; break;
                       case 2: sItem = "nw_wbwmln009"; break;
                       case 3: sItem = "nw_wblmhl010"; break;
                       case 4: sItem = "nw_waxmhn010"; break;
                       case 5: sItem = "nw_wblmfl010"; break;
                       case 6: sItem = "nw_waxmbt010"; break;
                       case 7: sItem = "nw_wplmhb010"; break;
                       case 8: sItem = "nw_wblmhw011"; break;
                       //case 9: sItem = "nw_wblmfh010"; break;
                       case 10: sItem = "nw_wswmls010"; break;
                       case 11: sItem = "nw_waxmgr009"; break;
                       case 12: sItem = "nw_wswmbs009"; break;
                       case 13: sItem = "nw_wswmgs011"; break;
                       case 14: sItem = "nw_wthmax009"; break;
                        case 15: sItem = "nw_wswmrp010"; break;
                        case 16: sItem = "nw_wswmrp011"; break;
                        case 17: sItem = "nw_wswmsc010"; break;
                        case 18: sItem = "nw_wswmss009"; break;
                        case 19: sItem = "nw_wswmsc011"; break;
                        case 9: sItem = "nw_wswmss011"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax009"; break;
                       case 2: sItem = "nw_waxmhn011"; break;
                       case 3: sItem = "nw_wblmfl011"; break;
                       case 4: sItem = "nw_waxmbt011"; break;
                       case 5: sItem = "nw_wplmhb011"; break;
                       case 6: sItem = "nw_wblmhw012"; break;
                       //case 7: sItem = "nw_wblmfh011"; break;
                       case 8: sItem = "nw_wswmls012"; break;
                       case 9: sItem = "nw_waxmgr011"; break;
                       case 10: sItem = "nw_wswmbs010"; break;
                       case 11: sItem = "nw_wswmgs012"; break;
                        case 12: sItem = "nw_wswmrp011"; break;
                        case 13: sItem = "nw_wswmsc011"; break;
                        case 7: sItem = "nw_wswmss011"; break;
                   }

            }

            //dbSpeak("Create Generic Martial");

           dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericExotic(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";

            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(7) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wspka001"; break;
                       case 3: sItem = "nw_wspku001"; break;
                       case 4: sItem = "nw_wplsc001"; break;
                       //case 5: sItem = "nw_wdbax001"; break;
                       case 6: sItem = "nw_wdbma001"; break;
                       case 7: sItem = "nw_wswka001"; break;
                       case 5: sItem = "nw_wthmsh002"; break;
                       //case 5: sItem = "nw_wdbsw001"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthsh001"; break;
                       case 2: sItem = "nw_wspka001"; break;
                       case 3: sItem = "nw_wspku001"; break;
                       case 4: sItem = "nw_wplsc001"; break;
                       //case 5: sItem = "nw_wdbax001"; break;
                       case 6: sItem = "nw_wdbma001"; break;
                       case 7: sItem = "nw_wswka001"; break;
                       case 8: sItem = "nw_wthmsh002"; break;
                       //case 9: sItem = "nw_wdbsw001"; break;
                       case 10: sItem = "nw_wthmsh005"; break;
                       case 11: sItem = "nw_wspmka002"; break;
                       case 12: sItem = "nw_wspmku002"; break;
                       case 13: sItem = "nw_wplmsc002"; break;
                       //case 14: sItem = "nw_wdbmax002"; break;
                       case 5: sItem = "nw_wdbmma002"; break;
                       case 9: sItem = "nw_wswmka002"; break;
                       //case 5: sItem = "nw_wdbmsw002"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       //case 1: sItem = "nw_wdbsw001"; break;
                       case 2: sItem = "nw_wthmsh005"; break;
                       case 3: sItem = "nw_wspmka002"; break;
                       case 4: sItem = "nw_wspmku002"; break;
                       case 5: sItem = "nw_wplmsc002"; break;
                       //case 6: sItem = "nw_wdbmax002"; break;
                       case 1: sItem = "nw_wdbmma002"; break;
                       case 6: sItem = "nw_wswmka002"; break;
                       //case 6: sItem = "nw_wdbmsw002"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh005"; break;
                       case 2: sItem = "nw_wspmka002"; break;
                       case 3: sItem = "nw_wspmku002"; break;
                       case 4: sItem = "nw_wplmsc002"; break;
                       //case 5: sItem = "nw_wdbmax002"; break;
                       case 6: sItem = "nw_wdbmma002"; break;
                       case 7: sItem = "nw_wswmka002"; break;
                       //case 8: sItem = "nw_wdbmsw002"; break;
                       case 9: sItem = "nw_wthmsh008"; break;
                       case 10: sItem = "nw_wspmka008"; break;
                       case 11: sItem = "nw_wspmku008"; break;
                       case 12: sItem = "nw_wplmsc010"; break;
                       //case 13: sItem = "nw_wdbmax010"; break;
                       case 13: sItem = "nw_wdbmma010"; break;
                       case 8: sItem = "nw_wswmka010"; break;
                       //case 13: sItem = "nw_wdbmsw010"; break;
                       case 5: sItem = "nw_wthmsh009"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wspmka008"; break;
                       case 2: sItem = "nw_wspmku008"; break;
                       case 3: sItem = "nw_wplmsc010"; break;
                       //case 4: sItem = "nw_wdbmax010"; break;
                       case 5: sItem = "nw_wdbmma010"; break;
                       case 6: sItem = "nw_wswmka010"; break;
                       //case 7: sItem = "nw_wdbmsw010"; break;
                       case 8: sItem = "nw_wthmsh009"; break;
                       case 9: sItem = "nw_wspmka009"; break;
                       case 10: sItem = "nw_wspmku009"; break;
                       case 7: sItem = "nw_wplmsc011"; break;
                       //case 12: sItem = "nw_wdbmax011"; break;
                       case 4: sItem = "nw_wdbmma011"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
            int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       //case 1: sItem = "nw_wdbmsw010"; break;
                       case 2: sItem = "nw_wthmsh009"; break;
                       case 3: sItem = "nw_wspmka009"; break;
                       case 4: sItem = "nw_wspmku009"; break;
                       case 5: sItem = "nw_wplmsc011"; break;
                       //case 6: sItem = "nw_wdbmax011"; break;
                       case 6: sItem = "nw_wdbmma011"; break;
                       case 1: sItem = "nw_wswmka011"; break;
                       //case 6: sItem = "nw_wdbmsw011"; break;
                   }

            }
                  //dbSpeak("Create generic exotic");

           dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericLightArmor(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";

            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_aarcl009"; break;
                       case 2: sItem = "nw_ashsw001"; break;
                       case 3: sItem = "nw_aarcl001"; break;
                       case 4: sItem = "nw_aarcl002"; break;
                       case 5: sItem = "nw_aarcl012"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_aarcl009"; break;
                       case 2: sItem = "nw_ashsw001"; break;
                       case 3: sItem = "nw_aarcl001"; break;
                       case 4: sItem = "nw_aarcl002"; break;
                       case 5: sItem = "nw_aarcl012"; break;
                       case 6: sItem = "nw_maarcl043"; break;
                       case 7: sItem = "nw_ashmsw002"; break;
                       case 8: sItem = "nw_maarcl044"; break;
                       case 9: sItem = "nw_maarcl045"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl043"; break;
                       case 2: sItem = "nw_ashmsw002"; break;
                       case 3: sItem = "nw_maarcl044"; break;
                       case 4: sItem = "nw_maarcl045"; break;
                       case 5: sItem = "nw_maarcl072"; break;
                       case 6: sItem = "nw_ashmsw008"; break;
                       case 7: sItem = "nw_maarcl071"; break;
                       case 8: sItem = "nw_maarcl075"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl072"; break;
                       case 2: sItem = "nw_ashmsw008"; break;
                       case 3: sItem = "nw_maarcl071"; break;
                       case 4: sItem = "nw_maarcl075"; break;
                       case 5: sItem = "nw_maarcl084"; break;
                       case 6: sItem = "nw_ashmsw009"; break;
                       case 7: sItem = "nw_maarcl083"; break;
                       case 8: sItem = "nw_maarcl087"; break;
                       case 9: sItem = "nw_maarcl079"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl084"; break;
                       case 2: sItem = "nw_ashmsw009"; break;
                       case 3: sItem = "nw_maarcl083"; break;
                       case 4: sItem = "nw_maarcl087"; break;
                       case 5: sItem = "nw_maarcl079"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl084"; break;
                       case 2: sItem = "nw_ashmsw009"; break;
                       case 3: sItem = "nw_maarcl083"; break;
                       case 4: sItem = "nw_maarcl087"; break;
                       case 5: sItem = "nw_maarcl079"; break;
                   }

            }
                  //dbSpeak("Create Generic light");

           dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericMediumArmor(object oTarget, object oAdventurer, int nModifier = 0)
        {
            int nHD = GetHitDice(oAdventurer) + nModifier;
            string sItem = "";
            if (GetRange(1, nHD))    // * 200
            {
                 int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_arhe001"; break;
                       case 2: sItem = "nw_arhe002"; break;
                       case 3: sItem = "nw_arhe003"; break;
                       case 4: sItem = "nw_arhe004"; break;
                       case 5: sItem = "nw_arhe005"; break;
                       case 6: sItem = "nw_aarcl008"; break;
                       case 7: sItem = "nw_ashlw001"; break;
                       case 8: sItem = "nw_aarcl003"; break;
                       case 9: sItem = "nw_aarcl004"; break;
                       case 10: sItem = "nw_aarcl010"; break;
                   }
            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(16) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_arhe001"; break;
                       case 2: sItem = "nw_arhe002"; break;
                       case 3: sItem = "nw_arhe003"; break;
                       case 4: sItem = "nw_arhe004"; break;
                       case 5: sItem = "nw_arhe005"; break;
                       case 6: sItem = "nw_aarcl008"; break;
                       case 7: sItem = "nw_ashlw001"; break;
                       case 8: sItem = "nw_aarcl003"; break;
                       case 9: sItem = "nw_aarcl004"; break;
                       case 10: sItem = "nw_aarcl010"; break;
                       case 11: sItem = "nw_maarcl047"; break;
                       case 12: sItem = "nw_ashmlw002"; break;
                       case 13: sItem = "nw_maarcl046"; break;
                       case 14: sItem = "nw_maarcl048"; break;
                       case 15: sItem = "nw_maarcl035"; break;
                       case 16: sItem = "nw_maarcl049"; break;
                       //case 17: sItem = "nw_maarcl050"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl047"; break;
                       case 2: sItem = "nw_ashmlw002"; break;
                       case 3: sItem = "nw_maarcl046"; break;
                       case 4: sItem = "nw_maarcl048"; break;
                       case 5: sItem = "nw_maarcl035"; break;
                       case 6: sItem = "nw_maarcl049"; break;
                       //case 7: sItem = "nw_maarcl050"; break;
                       case 8: sItem = "nw_maarcl070"; break;
                       case 7: sItem = "nw_ashmlw008"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                   int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl035"; break;
                       case 2: sItem = "nw_maarcl049"; break;
                       //case 3: sItem = "nw_maarcl050"; break;
                       case 4: sItem = "nw_maarcl070"; break;
                       case 5: sItem = "nw_ashmlw008"; break;
                       case 6: sItem = "nw_maarcl067"; break;
                       case 7: sItem = "nw_maarcl073"; break;
                       case 8: sItem = "nw_maarcl065"; break;
                       case 9: sItem = "nw_maarcl066"; break;
                       case 10: sItem = "nw_maarcl082"; break;
                       case 11: sItem = "nw_ashmlw009"; break;
                       case 12: sItem = "nw_maarcl085"; break;
                       case 13: sItem = "nw_maarcl077"; break;
                       case 3: sItem = "nw_maarcl078"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl070"; break;
                       case 2: sItem = "nw_ashmlw008"; break;
                       case 3: sItem = "nw_maarcl067"; break;
                       case 4: sItem = "nw_maarcl073"; break;
                       case 5: sItem = "nw_maarcl065"; break;
                       case 6: sItem = "nw_maarcl066"; break;
                       case 7: sItem = "nw_maarcl082"; break;
                       case 8: sItem = "nw_ashmlw009"; break;
                       case 9: sItem = "nw_maarcl085"; break;
                       case 10: sItem = "nw_maarcl077"; break;
                       case 11: sItem = "nw_maarcl078"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl070"; break;
                       case 2: sItem = "nw_ashmlw008"; break;
                       case 3: sItem = "nw_maarcl067"; break;
                       case 4: sItem = "nw_maarcl073"; break;
                       case 5: sItem = "nw_maarcl065"; break;
                       case 6: sItem = "nw_maarcl066"; break;
                       case 7: sItem = "nw_maarcl082"; break;
                       case 8: sItem = "nw_ashmlw009"; break;
                       case 9: sItem = "nw_maarcl085"; break;
                       case 10: sItem = "nw_maarcl077"; break;
                       case 11: sItem = "nw_maarcl078"; break;
                   }

            }
                  //dbSpeak("Create Generic medium");

           dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateGenericHeavyArmor(object oTarget, object oAdventurer, int nModifier = 0)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer) + nModifier;

            if (GetRange(1, nHD))    // * 200
            {
                  int nRandom = Random(2) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashto001"; break;
                       //case 2: sItem = "nw_aarcl005"; break;
                       case 2: sItem = "nw_aarcl011"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 800
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashto001"; break;
                       //case 2: sItem = "nw_aarcl005"; break;
                       case 3: sItem = "nw_aarcl011"; break;
                       case 4: sItem = "nw_aarcl006"; break;
                       case 5: sItem = "nw_ashmto002"; break;
                       case 2: sItem = "nw_maarcl051"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       //case 1: sItem = "nw_aarcl005"; break;
                       case 2: sItem = "nw_aarcl011"; break;
                       case 3: sItem = "nw_aarcl006"; break;
                       case 4: sItem = "nw_ashmto002"; break;
                       case 5: sItem = "nw_maarcl051"; break;
                       case 6: sItem = "nw_maarcl052"; break;
                       case 7: sItem = "nw_aarcl007"; break;
                       case 8: sItem = "nw_maarcl053"; break;
                       case 1: sItem = "nw_ashmto008"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl051"; break;
                       case 2: sItem = "nw_maarcl052"; break;
                       case 3: sItem = "nw_aarcl007"; break;
                       case 4: sItem = "nw_maarcl053"; break;
                       case 5: sItem = "nw_ashmto008"; break;
                       case 6: sItem = "nw_maarcl064"; break;
                       // case 7: sItem = "nw_maarcl074"; break;
                       case 8: sItem = "nw_maarcl069"; break;
                       case 9: sItem = "nw_maarcl068"; break;
                       case 10: sItem = "nw_ashmto003"; break;
                       case 11: sItem = "nw_ashmto009"; break;
                       case 12: sItem = "nw_maarcl076"; break;
                       //case 13: sItem = "nw_maarcl086"; break;
                       case 13: sItem = "nw_maarcl081"; break;
                       case 7: sItem = "nw_maarcl080"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashmto008"; break;
                       case 2: sItem = "nw_maarcl064"; break;
                       // case 3: sItem = "nw_maarcl074"; break;
                       case 4: sItem = "nw_maarcl069"; break;
                       case 5: sItem = "nw_maarcl068"; break;
                       case 6: sItem = "nw_ashmto009"; break;
                       case 7: sItem = "nw_maarcl076"; break;
                       //case 8: sItem = "nw_maarcl086"; break;
                       case 8: sItem = "nw_maarcl081"; break;
                       case 3: sItem = "nw_maarcl080"; break;
                   }


            }
            else if (GetRange(6, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashmto009"; break;
                       case 2: sItem = "nw_maarcl076"; break;
                       //case 3: sItem = "nw_maarcl086"; break;
                       case 4: sItem = "nw_maarcl081"; break;
                       case 3: sItem = "nw_maarcl080"; break;
                   }

            }
                 // dbSpeak("Create Generic heavy");

           dbCreateItemOnObject(sItem, oTarget, 1);
        }
        // *
        // * SPECIC TREASURE ITEMS (re: Named Items)
        // *
        void CreateSpecificMiscItem(object oTarget,object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericMiscItem(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericMiscItem(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_maarcl057"; break;
                       case 3: sItem = "nw_it_mbelt005"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl057"; break;
                       case 2: sItem = "nw_it_mbelt005"; break;
                       case 3: sItem = "nw_maarcl101"; break;
                       case 4: sItem = "nw_maarcl102"; break;
                       case 5: sItem = "nw_maarcl103"; break;
                       case 6: sItem = "nw_it_mglove001"; break;
                       case 7: sItem = "nw_maarcl100"; break;
                       //case 8: sItem = "nw_it_mbracer011"; break;
                       case 9: sItem = "nw_it_mmidmisc04"; break;
                       case 10: sItem = "nw_it_mring003"; break;
                       case 11: sItem = "nw_it_mbelt006"; break;
                       case 8: sItem = "nw_it_mbelt002"; break;
                      // case 13: sItem = "nw_it_mmidmisc03"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl101"; break;
                       case 2: sItem = "nw_maarcl101"; break;
                       case 3: sItem = "nw_maarcl102"; break;
                       case 4: sItem = "nw_maarcl103"; break;
                       case 5: sItem = "nw_it_mglove001"; break;
                       case 6: sItem = "nw_maarcl100"; break;
                       //case 7: sItem = "nw_it_mbracer011"; break;
                       case 8: sItem = "nw_it_mmidmisc04"; break;
                       case 9: sItem = "nw_it_mring003"; break;
                       case 10: sItem = "nw_it_mbelt006"; break;
                       case 11: sItem = "nw_it_mbelt002"; break;
                       // case 12: sItem = "nw_it_mmidmisc03"; break;
                       case 13: sItem = "nw_it_mring002"; break;
                       case 14: sItem = "nw_it_mbelt004"; break;
                       case 15: sItem = "nw_it_mring005"; break;
                       case 16: sItem = "nw_it_mboots005"; break;
                       case 17: sItem = "nw_it_mring007"; break;
                       case 7: sItem = "nw_it_mneck003"; break;
                       case 12: sItem = "nw_it_mbelt007"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_it_mbelt002"; break;
                       case 2: sItem = "nw_it_mbelt002"; break;
                       //case 3: sItem = "nw_it_mmidmisc03"; break;
                       case 4: sItem = "nw_it_mring002"; break;
                       case 5: sItem = "nw_it_mbelt004"; break;
                       case 6: sItem = "nw_it_mring005"; break;
                       case 7: sItem = "nw_it_mboots005"; break;
                       case 8: sItem = "nw_it_mring007"; break;
                       case 9: sItem = "nw_it_mneck003"; break;
                       case 10: sItem = "nw_it_mbelt007"; break;
                       case 11: sItem = "nw_it_mboots004"; break;
                       case 12: sItem = "nw_it_mboots003"; break;
                       case 13: sItem = "nw_it_mneck005"; break;
                       case 14: sItem = "nw_it_mbelt008"; break;
                       case 3: sItem = "nw_it_mring020"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(18) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_it_mboots004"; break;
                       case 2: sItem = "nw_it_mboots004"; break;
                       case 3: sItem = "nw_it_mboots003"; break;
                       case 4: sItem = "nw_it_mneck005"; break;
                       case 5: sItem = "nw_it_mbelt008"; break;
                       case 6: sItem = "nw_it_mring020"; break;
                       case 7: sItem = "nw_it_mbelt001"; break;
                       case 8: sItem = "nw_it_mring017"; break;
                       case 9: sItem = "nw_mcloth001"; break;
                       case 10: sItem = "nw_it_mneck019"; break;
                       case 11: sItem = "nw_it_mneck002"; break;
                       case 12: sItem = "nw_it_mneck004"; break;
                       // case 13: sItem = "nw_it_mmidmisc01"; break;
                       case 14: sItem = "nw_mcloth002"; break;
                       case 15: sItem = "nw_mcloth003"; break;
                       case 16: sItem = "nw_mcloth004"; break;
                       case 17: sItem = "nw_it_mbelt003"; break;
                       // * new items
                       case 18: sItem = "NW_IT_MBELT020"; break;
                       case 13: sItem = "NW_IT_MBELT021"; break;
                   }

            }
                dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificRodStaffWand(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericRodStaffWand(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericRodStaffWand(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(4) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wmgst004"; break;
                       case 2: sItem = "nw_wmgst006"; break;
                       case 3: sItem = "nw_wmgmrd003"; break;
                       case 4: sItem = "nw_wmgst004"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(7) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wmgmrd003"; break;
                       case 2: sItem = "nw_wmgst006"; break;
                       case 3: sItem = "nw_wmgmrd003"; break;
                       case 4: sItem = "nw_wmgst004"; break;
                       case 5: sItem = "nw_wmgst005"; break;
                       case 6: sItem = "nw_wmgmrd004"; break;
                       case 7: sItem = "nw_wmgrd002"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(8) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmcl012"; break;
                       case 2: sItem = "nw_wmgmrd003"; break;
                       case 3: sItem = "nw_wmgst004"; break;
                       case 4: sItem = "nw_wmgst005"; break;
                       case 5: sItem = "nw_wblmcl012"; break;
                       case 6: sItem = "nw_wmgmrd004"; break;
                       case 7: sItem = "nw_wmgst002"; break;
                       case 8: sItem = "nw_wmgmrd005"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wmgmrd004"; break;
                       case 2: sItem = "nw_wmgst002"; break;
                       case 3: sItem = "nw_wmgmrd005"; break;
                       case 4: sItem = "nw_wmgmrd002"; break;
                       case 5: sItem = "nw_wmgst003"; break;
                       case 6: sItem = "nw_wblmcl012"; break;
                   }

            }
                dbCreateItemOnObject(sItem, oTarget, 1);
        }


        void CreateSpecificSimple(object oTarget, object oAdventurer)
        {
           string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericSimple(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericSimple(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs005"; break;
                       case 2: sItem = "nw_wdbmqs005"; break;
                       case 3: sItem = "nw_wdbmqs006"; break;
                       case 4: sItem = "nw_wbwmxh005"; break;
                       case 5: sItem = "nw_wbwmxl005"; break;
                       case 6: sItem = "nw_wswmdg006"; break;
                       case 7: sItem = "nw_wblmml006"; break;
                       case 8: sItem = "nw_wspmsc004"; break;
                       case 9: sItem = "nw_wblmms007"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(21) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmqs006"; break;
                       case 2: sItem = "nw_wdbmqs005"; break;
                       case 3: sItem = "nw_wdbmqs006"; break;
                       case 4: sItem = "nw_wbwmxh005"; break;
                       case 5: sItem = "nw_wbwmxl005"; break;
                       case 6: sItem = "nw_wswmdg006"; break;
                       case 7: sItem = "nw_wblmml006"; break;
                       case 8: sItem = "nw_wspmsc004"; break;
                       case 9: sItem = "nw_wblmms007"; break;
                       case 10: sItem = "nw_wblmms003"; break;
                       case 11: sItem = "nw_wblmcl004"; break;
                       case 12: sItem = "nw_wspmsc006"; break;
                       case 13: sItem = "nw_wspmsc006"; break;
                       case 14: sItem = "nw_wdbmqs004"; break;
                       case 15: sItem = "nw_wblmcl003"; break;
                       case 16: sItem = "nw_wbwmsl003"; break;
                       case 17: sItem = "nw_wbwmxh003"; break;
                       //case 18: sItem = "nw_wspmsc003"; break;
                       case 19: sItem = "nw_wplmss005"; break;
                       case 20: sItem = "nw_wplmss005"; break;
                       case 21: sItem = "nw_wbwmxl003"; break;
                       case 18: sItem = "nw_wblmml004"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(26) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmms003"; break;
                       case 2: sItem = "nw_wblmms003"; break;
                       case 3: sItem = "nw_wblmcl004"; break;
                       case 4: sItem = "nw_wspmsc006"; break;
                       case 5: sItem = "nw_wspmsc006"; break;
                       case 6: sItem = "nw_wdbmqs004"; break;
                       case 7: sItem = "nw_wblmcl003"; break;
                       case 8: sItem = "nw_wbwmsl003"; break;
                       case 9: sItem = "nw_wbwmxh003"; break;
                       //case 10: sItem = "nw_wspmsc003"; break;
                       case 11: sItem = "nw_wplmss005"; break;
                       case 12: sItem = "nw_wplmss005"; break;
                       case 13: sItem = "nw_wbwmxl003"; break;
                       case 14: sItem = "nw_wblmml004"; break;
                       case 15: sItem = "nw_wdbmqs003"; break;
                       case 16: sItem = "nw_wbwmxl004"; break;
                       case 17: sItem = "nw_wbwmxl007"; break;
                       case 18: sItem = "nw_wblmml005"; break;
                       case 19: sItem = "nw_wblmcl005"; break;
                       case 20: sItem = "nw_wplmss007"; break;
                       case 21: sItem = "nw_wswmdg004"; break;
                       case 22: sItem = "nw_wbwmsl007"; break;
                       case 23: sItem = "nw_wblmml007"; break;
                       case 24: sItem = "nw_wblmml007"; break;
                       case 25: sItem = "nw_wbwmxh004"; break;
                       case 26: sItem = "nw_wplmss006"; break;
                       case 10: sItem = "nw_wbwmxh007"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(31) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wbwmxl003"; break;
                       case 2: sItem = "nw_wbwmxl003"; break;
                       case 3: sItem = "nw_wblmml004"; break;
                       case 4: sItem = "nw_wdbmqs003"; break;
                       case 5: sItem = "nw_wbwmxl004"; break;
                       case 6: sItem = "nw_wbwmxl007"; break;
                       case 7: sItem = "nw_wblmml005"; break;
                       case 8: sItem = "nw_wblmcl005"; break;
                       case 9: sItem = "nw_wplmss007"; break;
                       case 10: sItem = "nw_wswmdg004"; break;
                       case 11: sItem = "nw_wbwmsl007"; break;
                       case 12: sItem = "nw_wblmml007"; break;
                       case 13: sItem = "nw_wblmml007"; break;
                       case 14: sItem = "nw_wbwmxh004"; break;
                       case 15: sItem = "nw_wplmss006"; break;
                       case 16: sItem = "nw_wbwmxh007"; break;
                       case 17: sItem = "nw_wblmms006"; break;
                       case 18: sItem = "nw_wswmdg003"; break;
                       case 19: sItem = "nw_wswmdg007"; break;
                       case 20: sItem = "nw_wblmms004"; break;
                       case 21: sItem = "nw_wbwmsl006"; break;
                       case 22: sItem = "nw_wbwmsl008"; break;
                       case 23: sItem = "nw_wblmml008"; break;
                       case 24: sItem = "nw_wdbmqs007"; break;
                       case 25: sItem = "nw_wblmcl006"; break;
                       case 26: sItem = "nw_wbwmsl004"; break;
                       case 27: sItem = "nw_wbwmxh006"; break;
                       case 28: sItem = "nw_wplmss004"; break;
                       case 29: sItem = "nw_wswmdg005"; break;
                       case 30: sItem = "nw_wbwmxl006"; break;
                       case 31: sItem = "nw_wspmsc005"; break;

                   }

            }
                dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificMartial(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericMartial(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericMartial(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_wthmax005"; break;
                       case 3: sItem = "nw_wthmax007"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(14) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmax003"; break;
                       case 2: sItem = "nw_wthmax005"; break;
                       case 3: sItem = "nw_wthmax007"; break;
                       case 4: sItem = "nw_wthmax003"; break;
                       case 5: sItem = "nw_wthmax004"; break;
                       case 6: sItem = "nw_wthmax006"; break;
                       case 7: sItem = "nw_wswmrp004"; break;
                       case 8: sItem = "nw_wswmrp004"; break;
                       case 9: sItem = "nw_wblmfl004"; break;
                       case 10: sItem = "nw_wblmhl004"; break;
                       case 11: sItem = "nw_wbwmsh003"; break;
                       case 12: sItem = "nw_wblmhw006"; break;
                       case 13: sItem = "nw_wblmhw006"; break;
                       case 14: sItem = "nw_wbwmln004"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(26) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmfl005"; break;
                       case 2: sItem = "nw_wthmax007"; break;
                       case 3: sItem = "nw_wthmax003"; break;
                       case 4: sItem = "nw_wthmax004"; break;
                       case 5: sItem = "nw_wthmax006"; break;
                       case 6: sItem = "nw_wswmrp004"; break;
                       case 7: sItem = "nw_wswmrp004"; break;
                       case 8: sItem = "nw_wblmfl004"; break;
                       case 9: sItem = "nw_wblmhl004"; break;
                       case 10: sItem = "nw_wbwmsh003"; break;
                       case 11: sItem = "nw_wblmhw006"; break;
                       case 12: sItem = "nw_wblmhw006"; break;
                       case 13: sItem = "nw_wbwmln004"; break;
                       case 14: sItem = "nw_wblmfl005"; break;
                       case 15: sItem = "nw_wswmgs006"; break;
                       case 16: sItem = "nw_waxmgr003"; break;
                       case 17: sItem = "nw_wplmhb004"; break;
                       case 18: sItem = "nw_wblmhw005"; break;
                       //case 19: sItem = "nw_wblmfh004"; break;
                       //case 20: sItem = "nw_wblmfh008"; break;
                       case 21: sItem = "nw_wbwmsh006"; break;
                       case 22: sItem = "nw_wswmsc004"; break;
                       case 23: sItem = "nw_waxmgr006"; break;
                       case 24: sItem = "nw_wswmrp005"; break;
                       case 25: sItem = "nw_wswmls007"; break;
                       case 26: sItem = "nw_wswmgs004"; break;
                       case 20: sItem = "nw_waxmhn004"; break;
                       case 19: sItem = "nw_wswmbs005"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(38) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhw006"; break;
                       case 2: sItem = "nw_wblmhw006"; break;
                       case 3: sItem = "nw_wblmhw006"; break;
                       case 4: sItem = "nw_wbwmln004"; break;
                       case 5: sItem = "nw_wblmfl005"; break;
                       case 6: sItem = "nw_wswmgs006"; break;
                       case 7: sItem = "nw_waxmgr003"; break;
                       case 8: sItem = "nw_wplmhb004"; break;
                       case 9: sItem = "nw_wblmhw005"; break;
                       //case 10: sItem = "nw_wblmfh004"; break;
                       //case 11: sItem = "nw_wblmfh008"; break;
                       case 12: sItem = "nw_wbwmsh006"; break;
                       case 13: sItem = "nw_wswmsc004"; break;
                       case 14: sItem = "nw_waxmgr006"; break;
                       case 15: sItem = "nw_wswmrp005"; break;
                       case 16: sItem = "nw_wswmls007"; break;
                       case 17: sItem = "nw_wswmgs004"; break;
                       case 18: sItem = "nw_waxmhn004"; break;
                       case 19: sItem = "nw_wswmbs005"; break;
                       case 20: sItem = "nw_wblmhl005"; break;
                       case 21: sItem = "nw_wblmhl011"; break;
                       case 22: sItem = "nw_wswmss005"; break;
                       case 23: sItem = "nw_wplmhb003"; break;
                       case 24: sItem = "nw_wbwmln007"; break;
                       case 25: sItem = "nw_wbwmln007"; break;
                       case 26: sItem = "nw_wbwmsh007"; break;
                       case 27: sItem = "nw_waxmbt006"; break;
                       case 28: sItem = "nw_wswmbs006"; break;
                       case 29: sItem = "nw_wblmfl007"; break;
                       case 30: sItem = "nw_waxmhn003"; break;
                       case 31: sItem = "nw_wblmhl006"; break;
                       case 32: sItem = "nw_wblmfl006"; break;
                       case 33: sItem = "nw_wswmls005"; break;
                       case 34: sItem = "nw_wswmss004"; break;
                       case 35: sItem = "nw_wbwmln006"; break;
                       case 36: sItem = "nw_wblmhw003"; break;
                       // case 37: sItem = "nw_wblmfh006"; break;
                       case 38: sItem = "nw_wswmsc006"; break;
                       case 11: sItem = "nw_waxmhn005"; break;
                       //case 40: sItem = "nw_wblmfh003"; break;
                       case 10: sItem = "nw_wswmls006"; break;
                       case 37: sItem = "nw_wswmrp007"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(52) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wblmhl005"; break;
                       case 2: sItem = "nw_wblmhl005"; break;
                       case 3: sItem = "nw_wblmhl011"; break;
                       case 4: sItem = "nw_wswmss005"; break;
                       case 5: sItem = "nw_wplmhb003"; break;
                       case 6: sItem = "nw_wbwmln007"; break;
                       case 7: sItem = "nw_wbwmln007"; break;
                       case 8: sItem = "nw_wbwmsh007"; break;
                       case 9: sItem = "nw_waxmbt006"; break;
                       case 10: sItem = "nw_wswmbs006"; break;
                       case 11: sItem = "nw_wblmfl007"; break;
                       case 12: sItem = "nw_waxmhn003"; break;
                       case 13: sItem = "nw_wblmhl006"; break;
                       case 14: sItem = "nw_wblmfl006"; break;
                       case 15: sItem = "nw_wswmls005"; break;
                       case 16: sItem = "nw_wswmss004"; break;
                       case 17: sItem = "nw_wbwmln006"; break;
                       case 18: sItem = "nw_wblmhw003"; break;
                       //case 19: sItem = "nw_wblmfh006"; break;
                       case 20: sItem = "nw_wswmsc006"; break;
                       case 21: sItem = "nw_waxmhn005"; break;
                       //case 22: sItem = "nw_wblmfh003"; break;
                       case 23: sItem = "nw_wswmls006"; break;
                       case 24: sItem = "nw_wswmrp007"; break;
                       case 25: sItem = "nw_wswmgs005"; break;
                       case 26: sItem = "nw_wswmgs005"; break;
                       case 27: sItem = "nw_waxmgr005"; break;
                       case 28: sItem = "nw_wplmhb007"; break;
                       case 29: sItem = "nw_wswmsc007"; break;
                       case 30: sItem = "nw_wswmrp006"; break;
                       case 31: sItem = "nw_wswmss006"; break;
                       case 32: sItem = "nw_wblmhl009"; break;
                       case 33: sItem = "nw_wswmbs007"; break;
                       case 34: sItem = "nw_wbwmln005"; break;
                       // case 35: sItem = "nw_wblmfh005"; break;
                       case 36: sItem = "nw_wswmgs003"; break;
                       case 37: sItem = "nw_waxmbt003"; break;
                       case 38: sItem = "nw_wswmls004"; break;
                       case 39: sItem = "nw_wbwmsh005"; break;
                       case 40: sItem = "nw_wbwmsh005"; break;
                       case 41: sItem = "nw_waxmbt004"; break;
                       case 42: sItem = "nw_waxmbt004"; break;
                       case 43: sItem = "nw_wblmhl003"; break;
                       case 44: sItem = "nw_wblmhl003"; break;
                       case 45: sItem = "nw_wswmbs003"; break;
                       case 46: sItem = "nw_waxmbt005"; break;
                       case 47: sItem = "nw_waxmhn006"; break;
                       case 48: sItem = "nw_wswmss003"; break;
                       case 49: sItem = "nw_wswmsc005"; break;
                       case 50: sItem = "nw_wplmhb006"; break;
                       case 51: sItem = "nw_wbwmsh004"; break;
                       case 52: sItem = "nw_wswmbs004"; break;
                       case 19: sItem = "nw_wbwmln003"; break;
                       case 35: sItem = "nw_wblmhw004"; break;
                       case 22: sItem = "nw_waxmgr004"; break;
                   }

            }
                dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificExotic(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericExotic(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_wthmsh003"; break;
                       case 3: sItem = "nw_wthmsh006"; break;
                   }

            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericExotic(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_wthmsh003"; break;
                       case 3: sItem = "nw_wthmsh006"; break;
                       case 4: sItem = "nw_wthmsh004"; break;
                       case 5: sItem = "nw_wthmsh007"; break;
                   }

            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wthmsh006"; break;
                       case 2: sItem = "nw_wthmsh006"; break;
                       case 3: sItem = "nw_wthmsh004"; break;
                       case 4: sItem = "nw_wthmsh007"; break;
                       case 5: sItem = "nw_wspmku006"; break;
                       case 6: sItem = "nw_wdbmma003"; break;
                       case 7: sItem = "nw_wswmka005"; break;
                       case 8: sItem = "nw_wspmka004"; break;
                       case 9: sItem = "nw_wspmka007"; break;
                       //case 10: sItem = "nw_wdbmax006"; break;
                       //case 11: sItem = "nw_wdbmsw006"; break;
                       case 11: sItem = "nw_wspmku005"; break;
                       //case 11: sItem = "nw_wdbmsw007"; break;
                       case 10: sItem = "nw_wspmka005"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(12) + 1;
                  switch (nRandom)
                  {
                       case 1:sItem = "nw_wthmsh007"; break;
                       case 2: sItem = "nw_wthmsh007"; break;
                       case 3: sItem = "nw_wspmku006"; break;
                       case 4: sItem = "nw_wdbmma003"; break;
                       case 5: sItem = "nw_wswmka005"; break;
                       case 6: sItem = "nw_wspmka004"; break;
                       case 7: sItem = "nw_wspmka007"; break;
                       //case 8: sItem = "nw_wdbmax006"; break;
                       //case 9: sItem = "nw_wdbmsw006"; break;
                       case 10: sItem = "nw_wspmku005"; break;
                       //case 11: sItem = "nw_wdbmsw007"; break;
                       case 12: sItem = "nw_wspmka005"; break;
                       case 11: sItem = "nw_wplmsc003"; break;
                       //case 14: sItem = "nw_wdbmax005"; break;
                       case 8: sItem = "nw_wspmku004"; break;
                       case 9: sItem = "nw_wdbmma005"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wplmsc003"; break;
                       case 2: sItem = "nw_wspmka005"; break;
                       case 3: sItem = "nw_wplmsc003"; break;
                       //case 4: sItem = "nw_wdbmax005"; break;
                       case 5: sItem = "nw_wspmku004"; break;
                       case 6: sItem = "nw_wdbmma005"; break;
                       case 7: sItem = "nw_wdbmma005"; break;
                       // case 8: sItem = "nw_wdbmax004"; break;
                       case 9: sItem = "nw_wdbmma004"; break;
                       case 10: sItem = "nw_wswmka007"; break;
                       //case 11: sItem = "nw_wdbmsw005"; break;
                       case 12: sItem = "nw_wspmka006"; break;
                       case 13: sItem = "nw_wspmka003"; break;
                       //case 14: sItem = "nw_wdbmax007"; break;
                       case 11: sItem = "nw_wplmsc006"; break;
                       case 4: sItem = "nw_wspmku007"; break;
                       case 8: sItem = "nw_wdbmma006"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(17) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_wdbmma005"; break;
                       case 2: sItem = "nw_wdbmma005"; break;
                       case 3: sItem = "nw_wdbmma005"; break;
                       // case 4: sItem = "nw_wdbmax004"; break;
                       case 5: sItem = "nw_wdbmma004"; break;
                       case 6: sItem = "nw_wswmka007"; break;
                       //case 7: sItem = "nw_wdbmsw005"; break;
                       case 8: sItem = "nw_wspmka006"; break;
                       case 9: sItem = "nw_wspmka003"; break;
                       //case 10: sItem = "nw_wdbmax007"; break;
                       case 11: sItem = "nw_wplmsc006"; break;
                       case 12: sItem = "nw_wspmku007"; break;
                       case 13: sItem = "nw_wdbmma006"; break;
                       case 14: sItem = "nw_wspmku003"; break;
                       case 15: sItem = "nw_wswmka006"; break;
                       case 16: sItem = "nw_wplmsc005"; break;
                       case 17: sItem = "nw_wplmsc005"; break;
                       case 7: sItem = "nw_wswmka004"; break;
                       case 10: sItem = "nw_wswmka004"; break;
                       //case 10: sItem = "nw_wdbmsw004"; break;
                       case 4: sItem = "nw_wplmsc004"; break;
                   }

            }
                dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificLightArmor(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericLightArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                  int nRandom = Random(3) + 1;
                  switch (nRandom)
                  {
                       case 1: CreateGenericLightArmor(oTarget, oAdventurer, JUMP_LEVEL); return; break;
                       case 2: sItem = "nw_ashmsw011"; break;
                       case 3: sItem = "nw_ashmsw010"; break;
                   }
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_ashmsw011"; break;
                       case 2: sItem = "nw_ashmsw011"; break;
                       case 3: sItem = "nw_ashmsw010"; break;
                       case 4: sItem = "nw_maarcl011"; break;
                       case 5: sItem = "nw_ashmsw006"; break;
                       case 6: sItem = "nw_maarcl017"; break;
                       case 7: sItem = "nw_ashmsw005"; break;
                       case 8: sItem = "nw_maarcl013"; break;
                       case 9: sItem = "nw_maarcl012"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(13) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl011"; break;
                       case 2: sItem = "nw_maarcl011"; break;
                       case 3: sItem = "nw_ashmsw006"; break;
                       case 4: sItem = "nw_maarcl017"; break;
                       case 5: sItem = "nw_ashmsw005"; break;
                       case 6: sItem = "nw_maarcl013"; break;
                       case 7: sItem = "nw_maarcl012"; break;
                       case 8: sItem = "nw_ashmsw004"; break;
                       case 9: sItem = "nw_maarcl006"; break;
                       case 10: sItem = "nw_maarcl032"; break;
                       case 11: sItem = "nw_maarcl003"; break;
                       case 12: sItem = "nw_maarcl002"; break;
                       case 13: sItem = "nw_maarcl007"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl012"; break;
                       case 2: sItem = "nw_maarcl012"; break;
                       case 3: sItem = "nw_ashmsw004"; break;
                       case 4: sItem = "nw_maarcl006"; break;
                       case 5: sItem = "nw_maarcl032"; break;
                       case 6: sItem = "nw_maarcl003"; break;
                       case 7: sItem = "nw_maarcl002"; break;
                       //case 8: sItem = "nw_maarcl005"; break;
                       case 9: sItem = "nw_ashmsw003"; break;
                       case 10: sItem = "nw_maarcl001"; break;
                       case 8: sItem = "nw_maarcl034"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       //case 1: sItem = "nw_maarcl005"; break;
                       //case 2: sItem = "nw_maarcl005"; break;
                       case 3: sItem = "nw_ashmsw003"; break;
                       case 4: sItem = "nw_maarcl001"; break;
                       case 5: sItem = "nw_maarcl034"; break;
                       case 6: sItem = "nw_maarcl008"; break;
                       case 7: sItem = "nw_ashmsw007"; break;
                       case 8: sItem = "nw_maarcl033"; break;
                       case 9: sItem = "nw_mcloth005"; break;
                       case 2: sItem = "nw_maarcl009"; break;
                       case 1: sItem = "nw_maarcl004"; break;
                   }

            }
              dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificMediumArmor(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericMediumArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericMediumArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(5) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_armhe008"; break;
                       case 2: sItem = "nw_armhe008"; break;
                       case 3: sItem = "nw_armhe007"; break;
                       case 4: sItem = "nw_armhe009"; break;
                       case 5: sItem = "nw_armhe010"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(9) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_armhe008"; break;
                       case 2: sItem = "nw_armhe008"; break;
                       case 3: sItem = "nw_armhe007"; break;
                       case 4: sItem = "nw_armhe009"; break;
                       case 5: sItem = "nw_armhe010"; break;
                       case 6: sItem = "nw_armhe006"; break;
                       case 7: sItem = "nw_ashmlw007"; break;
                       case 8: sItem = "nw_ashmlw005"; break;
                       case 9: sItem = "nw_maarcl016"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_armhe009"; break;
                       case 2: sItem = "nw_armhe009"; break;
                       case 3: sItem = "nw_armhe010"; break;
                       case 4: sItem = "nw_armhe006"; break;
                       case 5: sItem = "nw_ashmlw007"; break;
                       case 6: sItem = "nw_ashmlw005"; break;
                       case 7: sItem = "nw_maarcl016"; break;
                       case 8: sItem = "nw_maarcl036"; break;
                       case 9: sItem = "nw_ashmlw004"; break;
                       case 10: sItem = "nw_maarcl037"; break;
                       // case 11: sItem = "nw_maarcl040"; break;
                       case 11: sItem = "nw_ashmlw006"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(11) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl016"; break;
                       case 2: sItem = "nw_maarcl016"; break;
                       case 3: sItem = "nw_maarcl036"; break;
                       case 4: sItem = "nw_ashmlw004"; break;
                       case 5: sItem = "nw_maarcl037"; break;
                       //case 6: sItem = "nw_maarcl040"; break;
                       case 7: sItem = "nw_ashmlw006"; break;
                       case 8: sItem = "nw_ashmlw003"; break;
                       case 9: sItem = "nw_maarcl014"; break;
                       case 10: sItem = "nw_maarcl039"; break;
                       case 11: sItem = "nw_maarcl010"; break;
                       case 6: sItem = "nw_maarcl015"; break;
                   }

            }
                  dbCreateItemOnObject(sItem, oTarget, 1);
        }
        void CreateSpecificHeavyArmor(object oTarget, object oAdventurer)
        {
            string sItem = "";
            int nHD = GetHitDice(oAdventurer);

            if (GetRange(1, nHD))    // * 800
            {
                CreateGenericHeavyArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(2, nHD))   // * 200 - 2500
            {
                CreateGenericHeavyArmor(oTarget, oAdventurer, JUMP_LEVEL);
                return;
            }
            else if (GetRange(3, nHD))   // * 800 - 10000
            {
                  int nRandom = Random(6) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl026"; break;
                       case 2: sItem = "nw_maarcl026"; break;
                       case 3: sItem = "nw_maarcl021"; break;
                       case 4: sItem = "nw_ashmto003"; break;
                       case 5: sItem = "nw_maarcl029"; break;
                       case 6: sItem = "nw_maarcl020"; break;
                   }

            }
            else if (GetRange(4, nHD))   // * 2500 - 16500
            {
                  int nRandom = Random(12) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl021"; break;
                       case 2: sItem = "nw_maarcl026"; break;
                       case 3: sItem = "nw_maarcl021"; break;
                       case 4: sItem = "nw_ashmto003"; break;
                       case 5: sItem = "nw_maarcl029"; break;
                       case 6: sItem = "nw_maarcl020"; break;
                       case 7: sItem = "nw_ashmto006"; break;
                       // case 8: sItem = "nw_maarcl041"; break;
                       case 9: sItem = "nw_ashmto005"; break;
                       case 10: sItem = "nw_ashmto007"; break;
                       case 11: sItem = "nw_ashmto010"; break;
                       case 12: sItem = "nw_maarcl022"; break;
                       case 8: sItem = "nw_maarcl018"; break;
                   }

            }
            else if (GetRange(5, nHD))   // * 8000 - 25000
            {
                  int nRandom = Random(12) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl020"; break;
                       case 2: sItem = "nw_maarcl020"; break;
                       case 3: sItem = "nw_ashmto006"; break;
                       //case 4: sItem = "nw_maarcl041"; break;
                       case 5: sItem = "nw_ashmto005"; break;
                       case 6: sItem = "nw_ashmto007"; break;
                       case 7: sItem = "nw_ashmto010"; break;
                       case 8: sItem = "nw_maarcl022"; break;
                       case 9: sItem = "nw_maarcl018"; break;
                       case 10: sItem = "nw_maarcl024"; break;
                       case 11: sItem = "nw_ashmto011"; break;
                       case 12: sItem = "nw_maarcl042"; break;
                       case 4: sItem = "nw_maarcl054"; break;
                   }

            }
            else if (GetRange(6, nHD))   // * 16000 and up
            {
                  int nRandom = Random(10) + 1;
                  switch (nRandom)
                  {
                       case 1: sItem = "nw_maarcl018"; break;
                       case 2: sItem = "nw_maarcl018"; break;
                       case 3: sItem = "nw_maarcl024"; break;
                       case 4: sItem = "nw_ashmto011"; break;
                       case 5: sItem = "nw_maarcl042"; break;
                       case 6: sItem = "nw_maarcl054"; break;
                       case 7: sItem = "nw_ashmto004"; break;
                       case 8: sItem = "nw_maarcl025"; break;
                       case 9: sItem = "nw_maarcl028"; break;
                       case 10: sItem = "nw_maarcl027"; break;
                   }

            }
                  dbCreateItemOnObject(sItem, oTarget, 1);

        }
        // * if nSpecific is = 1 then spawn in 'named' items at the higher levels
    void CreateTable2Item(object oTarget, object oAdventurer, int nSpecific=0)
    {
		return; //removed from CoD for now, until it can be sanity checked.
        //dbSpeak("In CreateTable2Item");
        string sItem = "";
        int nProbMisc = 0;
        int nProbClass = 0;
        int nProbRodStaffWand = 0;
        int nProbSimple = 0;
        int nProbMartial = 0;
        int nProbExotic = 0;
        int nProbLight = 0;
        int nProbMedium = 0;
        int nProbHeavy = 0;

        int nSpecialRanger = 0; // 2 Means to treat the ranger as a barbarian. A 1 is to treat it as a fighter


        // * May 2002: Changed using Preston's multiclass function
        // * it randomly chooses one of your classes
        int nClass =  nDetermineClassToUse(oAdventurer);


        // * SPECIAL RANGER BEHAVIOR
        // * If the ranger has the Heavy Armor proficiency, will treat the ranger
        if ( nClass == CLASS_TYPE_RANGER && GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY))
        {
            nSpecialRanger = 1;
        }
        else
        if (nClass == CLASS_TYPE_RANGER)
        {
            nSpecialRanger = 2;
        }



        //* SETUP probabilities based on Class
        if ( nClass == CLASS_TYPE_FIGHTER || nClass == CLASS_TYPE_PALADIN || nSpecialRanger == 1)
        {
            //dbSpeak("I am fighter or paladin or heavy ranger");
            nProbMisc = 20;
            nProbClass = 0;
            nProbRodStaffWand = 5;
            nProbSimple = 5;
            nProbMartial = 20;
            nProbExotic = 10;
            nProbLight = 5;
            nProbMedium = 15;
            nProbHeavy = 20;
        }
        else
        if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER)
        {
            //dbSpeak("I am wizard or sorcerer");
            nProbMisc = 40;
            nProbClass = 30;
            nProbRodStaffWand = 15;
            nProbSimple = 3;
            nProbMartial = 3;
            nProbExotic = 3;
            nProbLight = 2;
            nProbMedium = 2;
            nProbHeavy = 2;
        }
        else
        if (nClass == CLASS_TYPE_BARBARIAN || nSpecialRanger == 2)
        {
            //dbSpeak("I am barbarian or light ranger");

            nProbMisc = 20;
            nProbClass = 0;
            nProbRodStaffWand = 5;
            nProbSimple = 17;
            nProbMartial = 27;
            nProbExotic = 15;
            nProbLight = 8;
            nProbMedium = 5;
            nProbHeavy = 3;
        }
        else
        if (nClass == CLASS_TYPE_CLERIC)
        {
            //dbSpeak("I am cleric");

            nProbMisc = 20;
            nProbClass = 10;
            nProbRodStaffWand = 10;
            nProbSimple = 25;
            nProbMartial = 7;
            nProbExotic = 5;
            nProbLight = 5;
            nProbMedium = 8;
            nProbHeavy = 10;
        }
        else
        if (nClass == CLASS_TYPE_DRUID)
        {
            //dbSpeak("I am druid");

            nProbMisc = 20;
            nProbClass = 25;
            nProbRodStaffWand = 15;
            nProbSimple = 10;
            nProbMartial = 5;
            nProbExotic = 5;
            nProbLight = 10;
            nProbMedium = 5;
            nProbHeavy = 5;
        }
        else
        if (nClass == CLASS_TYPE_MONK)
        {
            //dbSpeak("I am monk");
            nProbMisc = 20;
            nProbClass = 50;
            nProbRodStaffWand = 2;
            nProbSimple = 7;
            nProbMartial = 2;
            nProbExotic = 7;
            nProbLight = 4;
            nProbMedium = 4;
            nProbHeavy = 4;
        }
        else
        if (nClass == CLASS_TYPE_ROGUE)
        {
            //dbSpeak("I am rogue");

            nProbMisc = 25;
            nProbClass = 10;
            nProbRodStaffWand = 10;
            nProbSimple = 25;
            nProbMartial = 5;
            nProbExotic = 5;
            nProbLight = 10;
            nProbMedium = 5;
            nProbHeavy = 5;
        }
        else
        if (nClass == CLASS_TYPE_BARD)
        {
            //dbSpeak("I am bard");

            nProbMisc = 25;
            nProbClass = 5;
            nProbRodStaffWand = 5;
            nProbSimple = 25;
            nProbMartial = 10;
            nProbExotic = 10;
            nProbLight = 10;
            nProbMedium = 5;
            nProbHeavy = 5;
        }
        //else
        //{
        //    dbSpeak("No Valid Class");
        //}
        //dbSpeak("Table2Item: After Class Distribution");
        //* Create Items based on Probabilities
        int nRandom = d100();
        if (nRandom <= nProbMisc)
        {
            if (nSpecific == 0) CreateGenericMiscItem(oTarget, oAdventurer);
            else CreateSpecificMiscItem(oTarget, oAdventurer);

        }
        else
        if (nRandom <= nProbMisc + nProbClass)
        {   // * no need for a seperate specific function here
            CreateGenericClassItem(oTarget, oAdventurer, nSpecific);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand)
        {
            if (nSpecific == 0) CreateGenericRodStaffWand(oTarget, oAdventurer);
            else CreateSpecificRodStaffWand(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple)
        {
            if (nSpecific == 0) CreateGenericSimple(oTarget, oAdventurer);
            else CreateSpecificSimple(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial)
        {

             if (nSpecific == 0) CreateGenericMartial(oTarget, oAdventurer);
             else CreateSpecificMartial(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic)
        {
            if (nSpecific == 0) CreateGenericExotic(oTarget, oAdventurer);
            else CreateSpecificExotic(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic + nProbLight)
        {
            if (nSpecific == 0) CreateGenericLightArmor(oTarget, oAdventurer);
            else CreateSpecificLightArmor(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic + nProbLight + nProbMedium)
        {
            if (nSpecific == 0) CreateGenericMediumArmor(oTarget, oAdventurer);
            else CreateSpecificMediumArmor(oTarget, oAdventurer);
        }
        else
        if (nRandom <= nProbMisc + nProbClass + nProbRodStaffWand + nProbSimple + nProbMartial + nProbExotic + nProbLight + nProbMedium + nProbHeavy)
        {
            if (nSpecific == 0) CreateGenericHeavyArmor(oTarget, oAdventurer);
            else CreateSpecificHeavyArmor(oTarget, oAdventurer);
        }
        //else
        //{
        //    dbSpeak("Generic Generic or Specific; error: 3524");
        //}
    }

//::///////////////////////////////////////////////
//:: GenerateTreasure
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Generate Treasure
   NOTE: When used by NPCs, the treasure is scaled
   to how powerful the NPC is.

   If used by containers, it is scaled by how
   powerful the PC is.

   PARAMETERS
   oLastOpener = The creature that opened the container
   oCreateOn = The place to put the treasure. If this is
    invalid then the treasure is placed on oLastOpener
*/
//:://////////////////////////////////////////////
//:: Created By:  Andrew
//:://////////////////////////////////////////////

void GenerateTreasure(int nTreasureType, object oLastOpener, object oCreateOn)
{
    //dbSpeak("*********************NEW TREASURE*************************");
	object oINVALID = OBJECT_INVALID;
    // * abort treasure if no one opened the container
    if (oLastOpener == oINVALID) return;

	// * if no valid create on object, then create on oLastOpener
	if (oCreateOn == oINVALID) oCreateOn = oLastOpener;

	// * VARIABLES
   int nProbBook =   0;
   int nProbAnimal = 0;
   int nProbJunk =   0;
   int nProbGold = 0;
   int nProbGem = 0;
   int nProbJewel = 0;
   int nProbArcane = 0;
   int nProbDivine = 0;
   int nProbAmmo = 0;
   int nProbKit = 0;
   int nProbPotion = 0;
   int nProbTable2 = 0;
   int nSpecific = 0;
   int i = 0;
   int nNumberItems = 1; //GetNumberOfItems(nTreasureType);

   // * Set Treasure Type Values
   if (nTreasureType == TREASURE_LOW)
   {
    nProbBook   = LOW_PROB_BOOK;
    nProbAnimal = LOW_PROB_ANIMAL;
    nProbJunk   = LOW_PROB_JUNK;
    nProbGold   = LOW_PROB_GOLD;
    nProbGem    = LOW_PROB_GEM;
    nProbJewel  = LOW_PROB_JEWEL;
    nProbArcane = LOW_PROB_ARCANE;
    nProbDivine  = LOW_PROB_DIVINE;
    nProbAmmo = LOW_PROB_AMMO;
    nProbKit = LOW_PROB_KIT;
    nProbPotion = LOW_PROB_POTION;
    nProbTable2 = LOW_PROB_TABLE2;
   }
   else if (nTreasureType == TREASURE_MEDIUM)
   {
    nProbBook   = MEDIUM_PROB_BOOK;
    nProbAnimal = MEDIUM_PROB_ANIMAL;
    nProbJunk   = MEDIUM_PROB_JUNK;
    nProbGold   = MEDIUM_PROB_GOLD;
    nProbGem    = MEDIUM_PROB_GEM;
    nProbJewel  = MEDIUM_PROB_JEWEL;
    nProbArcane = MEDIUM_PROB_ARCANE;
    nProbDivine  = MEDIUM_PROB_DIVINE;
    nProbAmmo = MEDIUM_PROB_AMMO ;
    nProbKit = MEDIUM_PROB_KIT;
    nProbPotion = MEDIUM_PROB_POTION;
    nProbTable2 = MEDIUM_PROB_TABLE2;
   }
   else if (nTreasureType == TREASURE_HIGH)
   {
    nProbBook   = HIGH_PROB_BOOK;
    nProbAnimal = HIGH_PROB_ANIMAL;
    nProbJunk   = HIGH_PROB_JUNK;
    nProbGold   = HIGH_PROB_GOLD;
    nProbGem    = HIGH_PROB_GEM;
    nProbJewel  = HIGH_PROB_JEWEL;
    nProbArcane = HIGH_PROB_ARCANE;
    nProbDivine  = HIGH_PROB_DIVINE;
    nProbAmmo = HIGH_PROB_AMMO ;
    nProbKit = HIGH_PROB_KIT;
    nProbPotion = HIGH_PROB_POTION;
    nProbTable2 = HIGH_PROB_TABLE2;
   }
   else if (nTreasureType == TREASURE_BOSS)
   { //dbSpeak("boss");
    nProbTable2 = 100;
    nSpecific = 1;
   }
	else if (nTreasureType == TREASURE_BOOK)
	{
		nProbBook = 90;
		nProbArcane = 10;
	}

	//dbSpeak("Generate Treasure nSpecific = " + IntToString(nSpecific));
	int nRandom;
	for (i = 1; i <= nNumberItems; i++)
	{
		nRandom = d100();
     if (nRandom <= nProbBook)
        CreateBook(oCreateOn);                                // * Book
     else if (nRandom <= nProbBook + nProbAnimal)
        CreateAnimalPart(oCreateOn);                          // * Animal
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk)
        CreateJunk(oCreateOn);                                // * Junk
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold)
        CreateGold(oCreateOn, oLastOpener, nTreasureType);    // * Gold
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem)
        CreateGem(oCreateOn, oLastOpener, nTreasureType);     // * Gem
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel)
        CreateJewel(oCreateOn, oLastOpener, nTreasureType);   // * Jewel
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane)
        CreateArcaneScroll(oCreateOn, oLastOpener);   // * Arcane Scroll
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine)
        CreateDivineScroll(oCreateOn, oLastOpener);   // * Divine Scroll
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo)
        CreateAmmo(oCreateOn, oLastOpener);   // * Ammo
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo + nProbKit)
        CreateKit(oCreateOn, oLastOpener);   // * Healing, Trap, or Thief kit
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo + nProbKit + nProbPotion)
        CreatePotion(oCreateOn, oLastOpener);   // * Potion
     else if (nRandom <= nProbBook + nProbAnimal + nProbJunk + nProbGold + nProbGem + nProbJewel + nProbArcane + nProbDivine + nProbAmmo + nProbKit + nProbPotion + nProbTable2)
     {
	 	CreateSCODitem(oCreateOn, oLastOpener, nTreasureType);
        //CreateTable2Item(oCreateOn, oLastOpener, nSpecific);   // * Weapons, Armor, Misc - Class based
     }
   }
}

//:: GenerateNPCTreasure
//:: Copyright (c) 2001 Bioware Corp.
//:: Created By: Brent
//:: Created On: January 2002
//:: Preferrably called from OnSpawn scripts.
//:: Use the random treasure functions to generate appropriate treasure for the creature to drop.
void GenerateNPCTreasure(int nTreasureValue=1, object oTreasureGetter=OBJECT_SELF, object oKiller=OBJECT_SELF)
{
	GenerateTreasure(nTreasureValue, oTreasureGetter, oKiller);
}

//::///////////////////////////////////////////////
//:: ShoutDisturbed
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

// * Container shouts if disturbed
void ShoutDisturbed()
{
    if (GetIsDead(OBJECT_SELF) == TRUE)
    {
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
           if (GetFactionEqual(oTarget, OBJECT_SELF) == TRUE)
           {
               // * Make anyone who is a member of my faction hostile if I am violated
           object oAttacker = GetLastAttacker();
           SetIsTemporaryEnemy(oAttacker,oTarget);
           AssignCommand(oTarget, ActionAttack(oAttacker));
           }
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
        }
    }
    else if (GetIsOpen(OBJECT_SELF) == TRUE)
    {
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
           if (GetFactionEqual(oTarget, OBJECT_SELF) == TRUE)
           {
               // * Make anyone who is a member of my faction hostile if I am violated
           object oAttacker = GetLastOpener();
           SetIsTemporaryEnemy(oAttacker,oTarget);
           AssignCommand(oTarget, ActionAttack(oAttacker));

           }
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

//::///////////////////////////////////////////////
//:: Determine Class to Use
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines which of a NPCs three classes to
    use in the random treasure system
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////
int nDetermineClassToUse(object oCharacter)
{
	int nClass;
    int nTotal = GetHitDice(oCharacter);
    //dbSpeak("Hit dice " + IntToString(nTotal));
    if (nTotal < 1)
    {
        nTotal = 1;
    }
	/*
    float fTotal = IntToFloat(nTotal);
    //if (GetIsObjectValid(oCharacter) == FALSE)
    //{
    //    dbSpeak("DetermineClassToUse: This character is invalid");
    //}

    int nClass1 =  GetClassByPosition(1, oCharacter);
    int nState1 = FloatToInt((IntToFloat(GetLevelByClass(nClass1, oCharacter)) / fTotal) * 100);
    //dbSpeak("Level 1 Class Level = " + IntToString(GetLevelByClass(nClass1,oCharacter)));

    //PrintString("GENERIC SCRIPT DEBUG STRING ********** " +  GetTag(oCharacter) + "Class 1 " + IntToString(nState1));
    //dbSpeak("State 1 " + IntToString(nState1));
    int nClass2 = GetClassByPosition(2, oCharacter);
    int nState2 = FloatToInt((IntToFloat(GetLevelByClass(nClass2, oCharacter)) / fTotal) * 100) + nState1;
    //PrintString("GENERIC SCRIPT DEBUG STRING ********** " + GetTag(oCharacter) + "Class 2 " + IntToString(nState2));

    int nClass3 = GetClassByPosition(3, oCharacter);
    int nState3 = FloatToInt((IntToFloat(GetLevelByClass(nClass3, oCharacter)) / fTotal) * 100) + nState2;
    //PrintString("GENERIC SCRIPT DEBUG STRING ********** " + GetTag(oCharacter) + "Class 3 " + IntToString(nState3));
	*/
    int nClass1 = GetClassByPosition(1, oCharacter);
    int nClass2 = GetClassByPosition(2, oCharacter);
    int nClass3 = GetClassByPosition(3, oCharacter);

    int nState1 = GetLevelByClass(nClass1, oCharacter) * 100 / nTotal;
    int nState2 = GetLevelByClass(nClass2, oCharacter) * 100 / nTotal + nState1;
    // nState3 will always be 100 if there is a third class, or 0 if there isn't
    //int nState3 = GetLevelByClass(nClass3, oCharacter) * 100 / nTotal + nState2;

    // correct for unrecognized classes - assumes the first class will be a non-prestige player class
    if(nClass2 != CLASS_TYPE_INVALID && nClass2 > CLASS_TYPE_WIZARD)
    {
        nClass2 = CLASS_TYPE_INVALID;
        nState1 = nState2;
    }
    if(nClass3 != CLASS_TYPE_INVALID && nClass3 > CLASS_TYPE_WIZARD)
    {
        nClass3 = CLASS_TYPE_INVALID;
        if(nClass2 != CLASS_TYPE_INVALID)
            nState2 = 100;
        else nState1 = 100;
    }

    int nUseClass = d100();
    //PrintString("GENERIC SCRIPT DEBUG STRING ********** " + "D100 Roll " +IntToString(nUseClass));

    //dbSpeak("Before comparison : " + IntToString(nClass1));
    if(nUseClass <= nState1) nClass = nClass1;
    else if(nUseClass > nState1 && nUseClass <= nState2) nClass = nClass2;
    else
    {
        // might be possible to end up here by accident because of a rounding error
        // so just in case...
        if (nClass3 == CLASS_TYPE_INVALID) nClass = nClass1;
        else nClass = nClass3;
    }

    //dbSpeak("Class from determineClass " + IntToString(nClass));
    return nClass;
}