//Contains the epic quest pools for the moment
//Should move to database later; purely here for ease of access
//
//There are three epic level treasure pools of pre-made items
//replace / fill as appropriate for quest rewards; meant to give some
//randomness to end-game quests
//
//Mimi Fearthegn
//6/18/19

string PickFromQuestTreasureLow();
string PickFromQuestTreasureMed();
string PickFromQuestTreasureHigh();

//picks out item from the treasure pools
//nPool can equal
//TREASURE_QUEST_LOW
//TREASURE_QUEST_MED
//TREASURE_QUEST_HIGH
string PickEpicLevelReward(int nPool) {

	switch(nPool) {
		case 5: return PickFromQuestTreasureLow(); break;
		case 6: return PickFromQuestTreasureMed(); break;
		case 7: return PickFromQuestTreasureHigh(); break;
	}

	return PickFromQuestTreasureLow();
}

//Epic Treasure Pool (low)
//Replace / modify list as needed
string PickFromQuestTreasureLow() {

	int numOfItems = 3; //number of items in the list below
	
	switch(Random(numOfItems)+1) {
	
		case 1: return "ed_belt_coolness"; //Abyss Bind
		case 2: return "ps_luca_acid_ageis"; //Acid Ageis
		case 3: return "ps_luca_alchemical_gun"; //Alchemical Gun
	
	}
	
	return "";

}

//Epic Treasure Pool (Medium)
//Replace / modify list as needed
string PickFromQuestTreasureMed() {

	int numOfItems = 3; //number of items in the list below
	
	switch(Random(numOfItems)+1) {
	
		case 1: return "ps_amulet_weakness"; //Amulet of Physical Weakness
		case 2: return "ps_book_acook"; //Anarchist's Cookbook
		case 3: return "ps_luca_staff_ancestralrecall"; //Ancestral Recall
	
	}
	
	return "";

}

//Epic Treasure Pool (High)
//Replace / modify list as needed
string PickFromQuestTreasureHigh() {

	int numOfItems = 3; //number of items in the list below
	
	switch(Random(numOfItems)+1) {
	
		case 1: return "ps_staff_ankh"; //Ankh Staff of Osiris
		case 2: return "ps_ring_aureon"; //Arcane Ring of Aureon
		case 3: return "ps_bplate_aot"; //Armor of Thorns
	
	}
	
	return "";

}