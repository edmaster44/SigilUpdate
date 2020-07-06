//Swap out the model's clothes every time she goes to the back

string GetClothing();

void main() {

	object oModel = GetEnteringObject();
	
	AssignCommand(oModel, ActionSpeakString("Object entered", TALKVOLUME_SHOUT));

	if (GetTag(oModel) != "festhallnpc_model_female") 
		return;
		
	string newClothes = GetClothing();
	if (newClothes != "") {
	
		AssignCommand(oModel, ActionSpeakString("Creating new outfit: "+newClothes, TALKVOLUME_SHOUT));
		object oOutfit =	CreateItemOnObject(newClothes, oModel);
		object oldOutfit = GetItemInSlot(INVENTORY_SLOT_CHEST, oModel);
		DestroyObject(oldOutfit);
		ClearAllActions();
		DelayCommand(0.1f, ActionEquipMostEffectiveArmor());
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