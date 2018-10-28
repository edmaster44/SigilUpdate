#include "ps_inc_gemstones"

void main () {

	object oPC = GetLastUsedBy();
	SendMessageToPC(oPC, "found gem!");
	CreateRandomGemstoneOnSpawnOrChest(oPC, d4());
	
}