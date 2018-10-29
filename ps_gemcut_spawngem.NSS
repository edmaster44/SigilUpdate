#include "ps_inc_gemstones"

void main () {

	object oPC = GetLastUsedBy();
	CreateRandomGemstoneOnSpawnOrChest(oPC, d4());
	
}