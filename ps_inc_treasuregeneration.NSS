//***************************************************
//Handles new loot generation
//Created 11-2-18 - Mimi Fearthegn
//***************************************************
#include "ginc_debug"
#include "ps_inc_randomitems"
//***************************************************
//Loot Levels
const int TREASURE_LOW = 1;
const int TREASURE_MEDIUM = 2;
const int TREASURE_HIGH = 3;
const int TREASURE_EPIC = 4;
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
void UploadItemToDatabase(string sItem, string sTable, object oTarget, int nTreasureLevel) {
	object oItem = CreateItemOnObject(sItem, oTarget);
	string sTag = GetTag(oItem);
	string sName = GetName(oItem);
	string sQuery = "INSERT INTO "+sTable+" SET name='"+sName+"', resref='"+sTag+"', treasure_level='"+IntToString(nTreasureLevel)+"'";
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
//Alchemy Generation
//***************************************************

//Old potion list; for database upload only
//remove later
string RandomPotion(object oTarget, int nRandom, int nTreasureType = TREASURE_LOW) {

	string sPotion = "";
	if (nTreasureType == TREASURE_LOW) {
        switch (nRandom) {
			case 1: sPotion = "ps_potions1_01"; break;
			case 2: sPotion = "ps_potions1_02"; break;
			case 3: sPotion = "ps_potions1_03"; break;
			case 4: sPotion = "ps_potions1_04"; break;
			case 7: sPotion = "ps_potions1_05"; break;
			case 10: sPotion = "ps_potions1_06"; break;
			case 11: sPotion = "ps_potions1_07"; break;
			case 12: sPotion = "ps_potions1_08"; break;
			case 13: sPotion = "ps_potions1_09"; break;
			case 14: sPotion = "ps_potions2_01"; break;
			case 16: sPotion = "ps_potions2_02"; break;
			case 17: sPotion = "ps_potions2_03"; break;
			case 18: sPotion = "ps_potions2_04"; break;
			case 19: sPotion = "ps_potions2_05"; break;
			case 22: sPotion = "ps_potions2_06"; break;
			case 23: sPotion = "ps_potions2_07"; break;
			case 24: sPotion = "ps_potions2_08"; break;
			case 25: sPotion = "ps_potions2_09"; break;
			case 26: sPotion = "ps_potions2_10"; break;
			case 27: sPotion = "ps_potions2_11"; break;
			case 29: sPotion = "ps_potions2_12"; break;
			case 30: sPotion = "ps_potions2_13"; break;
			case 31: sPotion = "ps_potions2_14"; break;
			case 32: sPotion = "ps_potion_lessersequencer"; break;
			default: sPotion = ""; break;
		}
		return sPotion;
	} else if (nTreasureType == TREASURE_MEDIUM) {
        switch (nRandom) {
			case 1: sPotion = "ps_potions3_01"; break;
			case 2: sPotion = "ps_potions3_02"; break;
			case 3: sPotion = "ps_potions3_03"; break;
			case 4: sPotion = "ps_potions3_04"; break;
			case 5: sPotion = "ps_potions3_05"; break;
			case 6: sPotion = "ps_potions3_06"; break;
			case 7: sPotion = "ps_potions3_07"; break;
			case 8: sPotion = "ps_potions3_08"; break;
			case 9: sPotion = "ps_potions3_09"; break;
			case 10: sPotion = "ps_potions4_01"; break;
			case 11: sPotion = "ps_potions4_02"; break;
			case 12: sPotion = "ps_potions4_03"; break;
			case 13: sPotion = "ps_potions4_04"; break;
			case 14: sPotion = "ps_potions4_05"; break;
			case 15: sPotion = "ps_potions4_06"; break;
			case 16: sPotion = "ps_potion_lessersequencer"; break;
			case 17: sPotion = "ps_potion_jhuild"; break;
			case 18: sPotion = "ps_potion_sequencer"; break;
		}
	} else if (nTreasureType == TREASURE_HIGH) {
        switch (nRandom) {
			case 1: sPotion = "ps_potions5_01"; break;
			case 2: sPotion = "ps_potions5_02"; break;
			case 3: sPotion = "ps_potion_greatersequencer"; break;
		}
    }
	return sPotion;
}