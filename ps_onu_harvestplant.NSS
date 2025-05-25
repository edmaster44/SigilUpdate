

//********************************************
//Allows PC to harvest off of a plant
//Important Variables
//ItemToGive = resref of the item to create
//********************************************

void CreateHerb(object oPC, string sToGive) {

	if (GetDistanceBetween(oPC, OBJECT_SELF) < 1.0f) {
		CreateItemOnObject(sToGive, oPC);
		DestroyObject(OBJECT_SELF, 0.25f);
	}

}

void PlayAnimationDelayed(object oPC, string sAnim) {
	PlayCustomAnimation(oPC, sAnim, FALSE);
}

void main() {

	object oPC = GetLastUsedBy();
	
	int nHarvested = GetLocalInt(OBJECT_SELF, "HARVESTED");
	if (nHarvested > 0)
		return;
	
	SetLocalInt(OBJECT_SELF, "HARVESTED", 1);

	string sToGive = GetLocalString(OBJECT_SELF, "ItemToGive");
	
	AssignCommand(oPC, ActionMoveToObject(OBJECT_SELF));
	
	DelayCommand(0.5f, PlayAnimationDelayed(oPC, "getground"));
	
	DelayCommand(0.75f, CreateHerb(oPC, sToGive));
	

}