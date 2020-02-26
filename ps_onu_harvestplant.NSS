//********************************************
//Allows PC to harvest off of a plant
//Important Variables
//ItemToGive = resref of the item to create
//********************************************

void CreateHerb(object oPC, string sToGive) {

	CreateItemOnObject(sToGive, oPC);

}

void main() {

	object oPC = GetLastUsedBy();
	
	int nHarvested = GetLocalInt(OBJECT_SELF, "HARVESTED");
	if (nHarvested > 0)
		return;
	
	SetLocalInt(OBJECT_SELF, "HARVESTED", 1);

	string sToGive = GetLocalString(OBJECT_SELF, "ItemToGive");
	
	PlayCustomAnimation(oPC, "getground", FALSE);
	
	DelayCommand(0.5f, CreateHerb(oPC, sToGive));
	
	DestroyObject(OBJECT_SELF, 0.75f);

}