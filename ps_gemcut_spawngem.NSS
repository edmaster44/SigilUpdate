#include "ps_inc_gemstones"

void main () {

	InitializeGemstoneBox();
	object oPC = GetLastUsedBy();
	
	CreateRandomGemstoneOnSpawnOrChest(oPC, d4());
	
}