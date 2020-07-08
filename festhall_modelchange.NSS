//Swap out the model's clothes every time she goes to the back
string GetClothing();
void ChangeClothing(object oModel);
void WalkToWaypoint(int nIndex);
void PlayPrettyAnimations();

void main() {

	object oModel = OBJECT_SELF;
	
	int nWP = GetLocalInt(oModel, "Current_Waypoint");
	if (nWP <= 0 || nWP >= 11) //clamp value
		nWP = 1;
		
	if (nWP == 1) {
		ChangeClothing(oModel);
	} else {
		WalkToWaypoint(nWP);
	}
		
	nWP++;
	SetLocalInt(oModel, "Current_Waypoint", nWP);

}

void WalkToWaypoint(int nIndex) {
	
	string sWP;
	if (nIndex < 10)
		sWP = "WP_festhallnpc_model_female_0"+IntToString(nIndex);
	else
		sWP = "WP_festhallnpc_model_female_"+IntToString(nIndex);
		
	object oWP = GetWaypointByTag(sWP);
	if (GetIsObjectValid(oWP)) {
		AssignCommand(OBJECT_SELF, ActionMoveToObject(oWP));
		
		if (nIndex == 6) {
			DelayCommand(4.5f, PlayPrettyAnimations());
		}
	}
}

void PlayPrettyAnimations() {
	switch(Random(2)+1) {
		case 1: PlayCustomAnimation(OBJECT_SELF, "flirt", FALSE); break;
		case 2: PlayCustomAnimation(OBJECT_SELF, "liftswordup", FALSE); break;
	}
}

void ChangeClothing(object oModel) {
	
	string newClothes = GetClothing();
	if (newClothes != "") {
		AssignCommand(oModel, ActionSpeakString("Creating new outfit: "+newClothes, TALKVOLUME_SHOUT));
		object oOutfit = CreateItemOnObject(newClothes, oModel);
		SetDroppableFlag(oOutfit, FALSE);
		SetIdentified(oOutfit, TRUE);
		
		object oldOutfit = GetItemInSlot(INVENTORY_SLOT_CHEST, oModel);
		if (GetIsObjectValid(oldOutfit))
			DestroyObject(oldOutfit);
		
		DelayCommand(0.1f, AssignCommand(oModel, ActionEquipItem(oOutfit, INVENTORY_SLOT_CHEST)));
		DelayCommand(0.2f, ActionEquipMostEffectiveArmor());
	} else {
		AssignCommand(oModel, ActionSpeakString("No new clothes :( ", TALKVOLUME_SHOUT));
	}
		
}

string GetClothing() {

	int nRand = Random(12)+1;
	switch(nRand) {
		case 1: return "de_cagerfashion_1f";
		case 2: return "de_cagerfashion_2f";
		case 3: return "de_cagerfashion_3f";
		case 4: return "de_cagerfashion_1b";
		case 5: return "de_cagerfashion_2b";
		case 6: return "de_cagerfashion_3b";
		case 7: return "de_cagerfashion_4b";
		case 8: return "de_cagerfashion_5b";
		case 9: return "de_cagerfashion_6b";
		case 10: return "de_cagerfashion_7b";
		case 11: return "de_cagerfashion_8b";
		case 12: return "de_cagerfashion_9b";
	}
	return "de_cagerfashion_1f";
	
}