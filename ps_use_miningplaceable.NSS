#include "ps_inc_functions"

int GenerateGemSize() {
	
	int nRand = Random(100)+1;
	if (nRand <= 1) //1% chance for a gem up to 100 carats
		return (Random(100)+1); 
	else if (nRand <= 6) //5% chance for a gem up to 50 carats
		return (Random(50)+1);
	else
		return (Random(25)+1); //generally gems up to 25 carats
}

int GenerateGemQuality() {

	int nRand = Random(100)+1;
	if (nRand <= 5) //5% chance for flawless quality gem
		return 3;
	else if (nRand <= 25) //20% chance for regular quality gem
		return 2;
	else	//75% chance for flawed gem
		return 1;
}

void CreateGemstoneOnPC(object oPC, string sGem) {
	int nSize =GenerateGemSize();
	int nQuality = GenerateGemQuality();
	object oItem = CreateItemOnObject(sGem, oPC, 1, sGem+"_q"+IntToString(nQuality)+"_c"+IntToString(nSize), TRUE);
	string sName = GetName(oItem);
	SetFirstName(oItem, sName+" - <Color=Gray><i>"+IntToString(nSize)+" carats</i></Color>");
}

int GetIsGemstone(string sTag) {
	if (FindSubString(sTag, "gemstone_rough", 0) >= 0)
		return TRUE;
	return FALSE;
}

void GiveMinedItem(object oPC) {

	if (d100() < 15) //random chance of failure
		return;

	SendMessageToPC(oPC, "You find an item of interest!");
	int nSpawns = GetLocalInt(OBJECT_SELF, "option_num");
	int nRand = Random(nSpawns)+1;
	
	string sSpawn = GetLocalString(OBJECT_SELF, "item_"+IntToString(nRand));
	if (GetIsGemstone(sSpawn)) {
		CreateGemstoneOnPC(oPC, sSpawn);
	} else {
		CreateItemOnObject(sSpawn, oPC, 1);
	}
	
	int nGiven = GetLocalInt(OBJECT_SELF, "items_given");
	SetLocalInt(OBJECT_SELF, "items_given", nGiven+1);
	
}

void DoMining(object oPC) {
	
	location lPast = GetLocalLocation(OBJECT_SELF, "starting_loc");
	int nGiven = GetLocalInt(OBJECT_SELF, "items_given");
	int nMax = GetLocalInt(OBJECT_SELF, "max_items");
	if (nGiven >= nMax || GetDistanceBetweenLocations(GetLocation(oPC), lPast) > 2.0f) { //kill mine if you've moved
		SendMessageToPC(oPC, "Mine exhausted.");
		AssignCommand(oPC, ClearAllActions());
		DestroyObject(OBJECT_SELF);
		return;
	}
	SendMessageToPC(oPC, "Mining. . .");
	
	PlayCustomAnimation(oPC, "1hS_1attack01", TRUE, 1.0f);
	GiveMinedItem(oPC);

}

void DestroyGemVein(object oPC) {
	SendMessageToPC(oPC, "Mine exhausted.");
	AssignCommand(oPC, ClearAllActions());
	DestroyObject(OBJECT_SELF);
	return;
}

void main () {

	object oPC = GetLastUsedBy();
	
	int lastDone = CheckTimeStamp();
	if (lastDone < 6) //You can't constantly click
		return;
	TimeStamp();
	
	SetLocalLocation(OBJECT_SELF, "starting_loc", GetLocation(oPC));
	int nGiven = GetLocalInt(OBJECT_SELF, "items_given");
	int nMax = GetLocalInt(OBJECT_SELF, "max_items");
	if (nMax <= 0) {
		nMax = Random(2)+1;
		SetLocalInt(OBJECT_SELF, "max_items", nMax);
	}
	
	if (nGiven >= nMax) {
		DestroyGemVein(oPC);
	}
	
	PlayCustomAnimation(oPC, "1hS_1attack01", TRUE, 1.0f); //base attack animation
	
	DelayCommand(1.0f, DoMining(oPC));
	DelayCommand(3.0f, DoMining(oPC));
	DelayCommand(5.0f, DoMining(oPC));
	DelayCommand(5.5f, DestroyGemVein(oPC));
}