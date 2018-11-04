#include "ps_inc_treasuregeneration"

void main () {

	object oPC = GetLastUsedBy();
	int nLootLevel = d4();
	
	SpeakString("Generating loot of "+IntToString(nLootLevel)+" treasure level", TALKVOLUME_SHOUT);
	
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