//***************************************************
//Handles new loot generation
//Created 11-2-18 - Mimi Fearthegn
//***************************************************
#include "ginc_debug"
#include "ps_inc_randomitems"
#include "ps_inc_gemstones"
//***************************************************
//Loot Levels
const int TREASURE_LOW = 1;
const int TREASURE_MEDIUM = 2;
const int TREASURE_HIGH = 3;
const int TREASURE_EPIC = 4;
//Gold Levels
const float LOW_MOD_GOLD = 0.5;   
const float MEDIUM_MOD_GOLD = 1.0; 
const float HIGH_MOD_GOLD = 3.0;
const float EPIC_MOD_GOLD = 5.0;
//Categories:
//Paper Products (non-equipable)
//Alchemy (consumable, non-equipable)
const int MAIN_PAPER_PROB = 25;
const int SUB_SCROLL_PROB = 80;
const int SUB_SCROLL_BOOK = 20;
const int MAIN_ALCHEMY_PROB = 33;
//***************************************************
//Utility
//***************************************************
//Grabs the CR of the creature, or the saved int CR on the placeable
int GetChallengeRatingOfTarget(object oTarget) {
	if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) {
		return FloatToInt(GetChallengeRating(oTarget));
	} else {
		return GetLocalInt(oTarget, "CR");
	}
}
//Database upload
void UploadItemToDatabase(string sItem, string sTable, object oTarget, int nTreasureLevel, string sSpecial = "") {
	object oItem = CreateItemOnObject(sItem, oTarget);
	string sTag = GetTag(oItem);
	string sName = GetName(oItem);
	string sQuery = "INSERT INTO "+sTable+" SET name='"+sName+"', resref='"+sTag+"', treasure_level='"+IntToString(nTreasureLevel)+"'";
	if (sSpecial != "") {
		sQuery += ", special='"+sSpecial+"'";
	}
	SendMessageToPC(oTarget, sQuery);
	SQLExecDirect(sQuery);
	DestroyObject(oItem, 0.1f);
}
//***************************************************
//Books and Paper Products
//Does not use database; smaller sets of items
//***************************************************
//Generates one of the custom Sigil lore books on the target
//They all have very regular resrefs, so no database needed
void CreateSigilBookOnTarget(object oTarget) {
   	string sRes = "ps_lorebook_";
	
	int iBook = Random(93) + 1;
	if (iBook < 10) {
    	sRes += "00";
    } else if (iBook < 100) {
		sRes += "0";
	}
	
	sRes += IntToString(iBook);
	CreateTreasureItemOnTarget(sRes, oTarget);
}

//Creates a lore book or random book on target
void CreateBookOnTarget(object oTarget) {
	int nRand = Random(100)+1;
	if (nRand < 90) {
		CreateSigilBookOnTarget(oTarget);
	} else {
		CreateRandomBookOnTarget(oTarget); //novels and such
	}
}

//Gets the maximum id for arcane scrolls
int GetArcaneScrollMaxID(int nLevel)
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

//Gets a random scroll id for the given level
int GetArcaneScrollIDRandom(int nLevel)
{
	int nNumSpellsInLevel = GetArcaneScrollMaxID(nLevel);
	int nScrollNum =  Random(nNumSpellsInLevel) + 1;
	return nScrollNum;
}

//Handles the different naming convention of arcane scrolls
void CreateArcaneScrollOnTarget(object oTarget, int nLevel) {
	int nScroll = GetArcaneScrollIDRandom(nLevel);
	
	string sRes; 
	if (nScroll < 10) {
	    sRes = "ps_scrolls" + IntToString(nLevel) + "_0" + IntToString(nScroll);
	} else {
	    sRes = "ps_scrolls" + IntToString(nLevel) + "_" + IntToString(nScroll);
	}
	CreateTreasureItemOnTarget(sRes, oTarget, 1);
}

//Handles the different naming convention of divine scrolls
void CreateDivineScrollOnTarget(object oTarget, int nLevel) {
	string sScroll = "";
    if (nLevel <= 2) {
		int nRandom = Random(3) + 1; //d4();
       	switch (nRandom) {
       		case 1: sScroll = "nw_it_spdvscr201"; break;
       		case 2: sScroll = "nw_it_spdvscr204"; break;
       		case 3: sScroll = "nw_it_spdvscr203"; break;
       	}
	} else if (nLevel <= 4) {
		int nRandom = Random(7) + 1; //d8();
        switch (nRandom) {
	 		case 1: sScroll = "nw_it_spdvscr201"; break;
            case 2: sScroll = "nw_it_spdvscr203"; break;
            case 3: sScroll = "nw_it_spdvscr204"; break;
            case 4: sScroll = "nw_it_spdvscr301"; break;
            case 5: sScroll = "nw_it_spdvscr302"; break;
            case 6: sScroll = "nw_it_spdvscr401"; break;
            case 7: sScroll = "nw_it_spdvscr402"; break;
        }
	} else if (nLevel <= 5) {
        int nRandom = Random(8) + 1;
        switch (nRandom) {
        	case 1: sScroll = "nw_it_spdvscr201"; break;
            case 2: sScroll = "nw_it_spdvscr501"; break;
            case 3: sScroll = "nw_it_spdvscr203"; break;
            case 4: sScroll = "nw_it_spdvscr204"; break;
            case 5: sScroll = "nw_it_spdvscr301"; break;
            case 6: sScroll = "nw_it_spdvscr302"; break;
            case 7: sScroll = "nw_it_spdvscr401"; break;
            case 8: sScroll = "nw_it_spdvscr402"; break;
		}
	} else {
		int nRandom = Random(7) + 1;
        switch (nRandom) {
        	case 1: sScroll = "nw_it_spdvscr301"; break;
            case 2: sScroll = "nw_it_spdvscr302";  break;
            case 3: sScroll = "nw_it_spdvscr401"; break;
            case 4: sScroll = "nw_it_spdvscr402"; break;
            case 5: sScroll = "nw_it_spdvscr501"; break;
            case 6: sScroll = "nw_it_spdvscr701"; break;
            case 7: sScroll = "nw_it_spdvscr702";  break;
		}
	}
	CreateTreasureItemOnTarget(sScroll, oTarget, 1);
}

//Creates a scroll on the targeted object. You can force the scroll to be arcane or divine
//if both nForceArcane and nForceDivine are false, then there's a 50/50 chance for one or the other
//Also 10% chance of experimental scroll
void CreateScrollOnTarget(object oTarget, int nTreasureLevel = TREASURE_LOW, int nForceArcane = FALSE, int nForceDivine = FALSE) {

	int nScroll = 1;
	int nLevel = 1;
	int nHD = GetChallengeRatingOfTarget(oTarget);
	
	if (nHD < 5) {
		nLevel = d2();
	} else if (nHD < 8) {
		nLevel = d4();
	} else if (nHD < 10) {
		nLevel = d6();
	  	if (nLevel < 2) nLevel = 2;
	} else if (nHD < 13) {
	  	nLevel = d8();
	  	if (nLevel < 3) nLevel = 3;
	} else if (nHD < 16) {
	  	nLevel = d8()+1;
	  	if (nLevel < 4) nLevel = 4;
	} else {
	  	nLevel = d8() + 1;
	  	if (nLevel < 5) nLevel = 5;
	}
	
	if (nForceArcane) {
		CreateArcaneScrollOnTarget(oTarget, nLevel);
	} else if (nForceDivine) {
		CreateDivineScrollOnTarget(oTarget, nLevel);
	} else {
		int nRand = Random(100)+1;
		if (nRand < 45) {
			CreateArcaneScrollOnTarget(oTarget, nLevel);
		} else if (nRand < 45) {
			CreateDivineScrollOnTarget(oTarget, nLevel);
		} else {
			CreateExperimentalScrollOnTarget(oTarget, nTreasureLevel);
		}
	}
}

//Main Paper Products generator
//Does not actually use the TREASURE constants for 
//anything but experimental scrolls
void CreatePaperItemsOnTarget(object oTarget, int nTreasureType = TREASURE_LOW) {
	int nRand = Random(100)+1;
	if (nRand < SUB_SCROLL_PROB) {
		CreateScrollOnTarget(oTarget, nTreasureType);
	} else {
		CreateBookOnTarget(oTarget);
	}
}
//***************************************************
//Junk Items Generation
//***************************************************
//***************************************************
//Alchemy Generation
//***************************************************
//***************************************************
//Gems Generation
//***************************************************
void CreateGemOnTarget(object oTarget, int nTreasureType)
{
	string sGem = "nw_it_gem001";
	if (nTreasureType == TREASURE_LOW) {
		CreateRandomGemstoneOnSpawnOrChest(oTarget, nTreasureType); return;
	} else if (nTreasureType == TREASURE_MEDIUM) {
		int nRand = d100();
		if (nRand < 80) {
			CreateRandomGemstoneOnSpawnOrChest(oTarget, nTreasureType); return;
		} else if (nRand < 90) {
			sGem = "ps_golem_brass";
		}  else  {
			sGem = "ps_golem_quartz";
		}
	} else if (nTreasureType == TREASURE_HIGH || nTreasureType == TREASURE_EPIC) {
		
		int nRand = d100();
		if (nRand < 88) {
			CreateRandomGemstoneOnSpawnOrChest(oTarget, nTreasureType); return;
		} else  {
			sGem = "ps_golem_mithral";
		}
	}
		
	CreateTreasureItemOnTarget(sGem, oTarget, 1);
	  
}
//***************************************************
//Gold Generation
//***************************************************
void CreateGoldOnTarget(object oTarget, int nTreasureType) {
	int nHD = GetChallengeRatingOfTarget(oTarget);
	if (nHD <= 0) {
		nHD = 6*nTreasureType;
	}
	int nAmount = 0;

	if (nHD <= 3) nAmount = d12(2);
	else if (nHD <= 6) nAmount = d20(2);
	else if (nHD <= 9) nAmount = d20(3);
	else if (nHD <= 12) nAmount = d20(5);
	else if (nHD <= 15) nAmount = d20(8);
	else nAmount = d20(10);
		
	float nMod = 0.0;
	if (nTreasureType == TREASURE_LOW) nMod = LOW_MOD_GOLD;
	else if (nTreasureType == TREASURE_MEDIUM) nMod = MEDIUM_MOD_GOLD;
	else if (nTreasureType == TREASURE_HIGH) nMod = HIGH_MOD_GOLD;
	else if (nTreasureType == TREASURE_EPIC) nMod = EPIC_MOD_GOLD;

	// * always at least 1gp is created
	nAmount = FloatToInt(nAmount * nMod);
	if (nAmount <= 0) nAmount = 1;
		
	CreateTreasureItemOnTarget("NW_IT_GOLD001", oTarget, nAmount);
}