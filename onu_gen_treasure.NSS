#include "ps_inc_chest"
void main () {

	object oPC = GetLastUsedBy();
	
	GenerateTreasureItemOnTarget(oPC, d3());

}