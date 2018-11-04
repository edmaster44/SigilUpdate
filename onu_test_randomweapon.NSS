#include "ps_inc_treasuregeneration"
#include "nwnx_sql"
//string sHolder = "ps_utility_itemvariableholder";

//Max items code
/*int GetMaxItemsInDatabaseTable(string sTable = "", int nTreasureLevel = 1, string sSubTable = "", int nCombineLevels = FALSE) {
	object oHolder = GetObjectByTag(sHolder);
	AssignCommand(oHolder, ActionSpeakString("found holder", TALKVOLUME_SHOUT));
	int nMax = GetLocalInt(oHolder, sTable+sSubTable+"_"+IntToString(nTreasureLevel));
	if (nMax > 0)
		return nMax;
	AssignCommand(oHolder, ActionSpeakString("initializing max items in "+sTable, TALKVOLUME_SHOUT));
		
	string sQuery = "SELECT COUNT(*) FROM "+sTable+" WHERE ";
	if (nCombineLevels) 
		sQuery += "treasure_level <= "+IntToString(nTreasureLevel);
	else
		sQuery += "treasure_level = "+IntToString(nTreasureLevel);
	if (sSubTable != "") 
		sQuery += " AND special='"+sSubTable+"'";
	
	AssignCommand(oHolder, ActionSpeakString(sQuery, TALKVOLUME_SHOUT));
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		nMax = StringToInt(SQLGetData(1));
	}
	
	AssignCommand(oHolder, ActionSpeakString("found: "+IntToString(nMax), TALKVOLUME_SHOUT));
	SetLocalInt(oHolder, sTable+sSubTable+"_"+IntToString(nTreasureLevel), nMax);
	return nMax;
}

//Testing pick item from database code
string PickItemFromDatabase(string sTable, int nTreasureLevel, string sSubTable = "", int nCombineLevels = FALSE) {
	object oHolder = GetObjectByTag(sHolder);
	int nMax = GetMaxItemsInDatabaseTable(sTable, nTreasureLevel, sSubTable, nCombineLevels);
	int nRandom = Random(nMax);
	AssignCommand(oHolder, ActionSpeakString("picked: "+IntToString(nRandom), TALKVOLUME_SHOUT));
	
	string sQuery = "SELECT resref FROM "+sTable+" WHERE ";
	if (nCombineLevels) 
		sQuery += "treasure_level <= "+IntToString(nTreasureLevel);
	else
		sQuery += "treasure_level = "+IntToString(nTreasureLevel);
	if (sSubTable != "") 
		sQuery += " AND special='"+sSubTable+"'";
	sQuery += " LIMIT "+IntToString(nRandom)+", 1";
		
	AssignCommand(oHolder, ActionSpeakString(sQuery, TALKVOLUME_SHOUT));
	SQLExecDirect(sQuery);
	string sItem = "ps_utility_error";
	if (SQLFetch() != SQL_ERROR) { 
		sItem = SQLGetData(1);
	}
	AssignCommand(oHolder, ActionSpeakString("returning: "+sItem, TALKVOLUME_SHOUT));
	return sItem;
	
}

//Adds in debug messages for treasure generation
object CreateTreasureItemOnTarget(string sBase, object oTarget, int nStackSize=1, string sNewTag="", int bDisplayFeedback=TRUE) {
	object oObj = CreateItemOnObject(sBase, oTarget, nStackSize, sNewTag, bDisplayFeedback);
	PrintString ("Created " + IntToString(nStackSize) + " of " + sBase + " on " + GetName(oTarget));
	return oObj;   
}*/

void main () {

	SpeakString("here we are", TALKVOLUME_SHOUT);
	object oPC = GetLastUsedBy();
	SendMessageToPC(oPC, "here we are");
	int nLootLevel = d4();
	
	SpeakString("Generating loot of "+IntToString(nLootLevel)+" treasure level", TALKVOLUME_SHOUT);
	
	//string sResref = PickItemFromDatabase("treasure_weapons", nLootLevel);
	//CreateTreasureItemOnTarget(sResref, oPC, 1);
	
	GenerateTreasureItemOnTarget(oPC, nLootLevel);
	/*int nLevel = Random(30)+1;
	int nPoints = GetPointValueForCR(nLevel);
	int nMatLevel = nPoints-2;
	if (nMatLevel <= 0)
		nMatLevel = 0;
	else
		nMatLevel = Random(nMatLevel)+1;
	
	SendMessageToPC(oPC, "generationg a level "+IntToString(nLevel)+" item of "+IntToString(nPoints)+" points");
	
	object oItem;
	int nRand = Random(5);
	switch (nRand) {
		case 0: oItem = CreateRandomItemOfCategory(oPC, "W", nMatLevel); break;
		case 1: oItem = CreateRandomItemOfCategory(oPC, "W", 0); break;
		case 2: oItem = CreateRandomItemOfCategory(oPC, "A", nMatLevel); break;
		case 3: oItem = CreateRandomItemOfCategory(oPC, "A", 0); break;
		case 4: oItem = CreateRandomItemOfCategory(oPC, "M", 0); break;
	}
	
	GiveItemRandomEnchantments(oItem, nPoints);
	GenerateRandomNameAndDescriptionForItem(oItem);
	SetFirstName(oItem, GetName(oItem)+" (Level "+IntToString(nLevel)+")");*/
}