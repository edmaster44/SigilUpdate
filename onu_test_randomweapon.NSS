#include "nwnx_sql"
#include "ps_inc_newcrafting"

struct baseitem GetRandomItem(object oPC, string sType = "W") {

	int max = GetNum2DARows("scod_craft_baseitems");
	int index = 0;
	int nChosen = Random(max);
	while (index < max) {
	
		if (GetItemType(index) == sType && index >= nChosen) {
			return LoadBaseItem(index);
		}
		index++;	
	}
	return LoadBaseItem(0);
}

void main () {

	object oPC = GetLastUsedBy();
	
	struct baseitem w = GetRandomItem(oPC, "W");
	SendMessageToPC(oPC, "Generated weapon :"+w.resref);
	struct baseitem a = GetRandomItem(oPC, "A");
	SendMessageToPC(oPC, "Generated weapon :"+a.resref);
	struct baseitem m = GetRandomItem(oPC, "M");
	SendMessageToPC(oPC, "Generated weapon :"+m.resref);


}