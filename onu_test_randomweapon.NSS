#include "nwnx_sql"
#include "ps_inc_randomitems"

void main () {

	object oPC = GetLastUsedBy();
	object oChest = OBJECT_SELF;
	
	int nRand = Random(5);
	switch (nRand) {
		case 0: CreateRandomItemOfCategoryOnTarget(oChest, "W"); break;
		case 1: CreateRandomItemOfCategoryOnTarget(oChest, "W"); break;
		case 2: CreateRandomItemOfCategoryOnTarget(oChest, "A"); break;
		case 3: CreateRandomItemOfCategoryOnTarget(oChest, "A"); break;
		case 4: CreateRandomItemOfCategoryOnTarget(oChest, "M"); break;
	}
}