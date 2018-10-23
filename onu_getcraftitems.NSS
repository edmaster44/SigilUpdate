#include "ps_inc_gemstones"

int GenerateGemSize() {
	
	int nRand = d100();
	if (nRand <= 5) //5% chance for a large gemstone
		return 2; 
	else if (nRand <= 15) //10% chance for a medium gemstone
		return 1;
	else
		return 0;
}

int GenerateGemQuality() {

	int nRand = d100();
	if (nRand <= 5) //5% chance for flawless quality gem
		return 2;
	else if (nRand <= 25) //20% chance for regular quality gem
		return 1;
	else	//75% chance for flawed gem
		return 0;
}

string RollGemstoneColor() {
	int nRand = Random(6);
	switch (nRand) {
		case 0: return "gemstone_rough_red";
		case 1: return "gemstone_rough_blue";
		case 2: return "gemstone_rough_green";
		case 3: return "gemstone_rough_yellow";
		case 4: return "gemstone_rough_black";
		case 5: return "gemstone_rough_pearl";
		case 6: return "gemstone_rough_white";
	}
	return "gemstone_rough_pearl";
}

void CreateGemstoneOnPC(object oPC, string sGem) {
	int nSize = GenerateGemSize();
	int nQuality = GenerateGemQuality();
	object oItem = CreateItemOnObject(sGem, oPC, 1, sGem+"_q"+IntToString(nQuality)+"_c"+IntToString(nSize), TRUE);
	SendMessageToPC(oPC, "creating: "+sGem+"_q"+IntToString(nQuality)+"_c"+IntToString(nSize));
	string sName = GetName(oItem);
	SetFirstName(oItem, sName+" - <Color=Gray>"+GetSizeString(nSize)+"</Color>");
}

void main () {
	
	//chest_crafting_materials
	object oPC = GetLastUsedBy();
	/*object oChest = GetNearestObjectByTag("chest_crafting_materials");
	
	object oItem = GetFirstItemInInventory(oChest);
	while(GetIsObjectValid(oItem)) {
	
		CopyItem(oItem, oPC, TRUE);
		oItem = GetNextItemInInventory(oChest);
		
	}*/
	string sGem = RollGemstoneColor();
	SendMessageToPC(oPC, sGem);
	CreateGemstoneOnPC(oPC, sGem);

}