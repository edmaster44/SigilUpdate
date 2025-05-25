

#include "ps_randomlootgenerator"
#include "ps_inc_achievements"

void main()
{
	// SendMessageToPC(GetFirstPC(), "We're inside the call-back script gui_ps_itemgambling_callback");

	object oPC = OBJECT_SELF;

	// read back the item type and the price from the local vars
	int price = GetLocalInt(oPC, "SRLG_PRICE");
	int nType = GetLocalInt(oPC, "SRLG_TYPE");
	DeleteLocalInt(oPC, "SRLG_PRICE");
	DeleteLocalInt(oPC, "SRLG_TYPE");

	// own enough money?
	int playerGold = GetGold(oPC);
	if (playerGold < price)
	{
		SendMessageToPC(oPC, "You do not have enough gold.");
		return;
	}
	
	object oItem = OBJECT_INVALID;
	oItem = SRLG_GiveRandomLeveledItem(oPC, nType);

	if (oItem != OBJECT_INVALID)
	{
		// subtract money
		TakeGoldFromCreature(price, oPC, TRUE);
		
		// Rename the created item	
		string newName = "Stolen " + GetFirstName(oItem);
		SetFirstName(oItem, newName);
			
		IncrementAchievement(oPC, 34);

		// Set as stolen so it can't be sold
		SetStolenFlag(oItem, TRUE);
	}
	else
	{
		// SendMessageToPC(oPC, "There was an error in the random loot generator, could not create item.");
	}
}