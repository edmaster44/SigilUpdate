

#include "ps_randomlootgenerator"

void main()
{
	object oPC = ((GetPCSpeaker() == OBJECT_INVALID) ? OBJECT_SELF : GetPCSpeaker());
	int price = GetLocalInt(oPC, "SRLG_PRICE");
	int nType = GetLocalInt(oPC, "SRLG_TYPE");
	DeleteLocalInt(oPC, "SRLG_PRICE");
	DeleteLocalInt(oPC, "SRLG_TYPE");

	object oItem = OBJECT_INVALID;
	string tokenTag = "";
	if(price > 0) {
		int playerGold = GetGold(oPC);
		if (playerGold < price)
		{
			SendMessageToPC(oPC, "You do not have enough gold.");
			return;
		}
		oItem = SRLG_GiveRandomLeveledItem(oPC, nType);
	}
	else {
		int itemLevel = 0;
		switch(price) {
		case -10:
			tokenTag = "ps_randomitem_token10";
			itemLevel = 10;
			break;
		case -20:
			tokenTag = "ps_randomitem_token20";
			itemLevel = 20;
			break;
		case -30:
			tokenTag = "ps_randomitem_token30";
			itemLevel = 30;
			break;
		}
		if(!GetIsObjectValid(GetItemPossessedBy(oPC, tokenTag))) {
			SendMessageToPC(oPC, "You do not have the right ticket.");
			return;
		}
		oItem = SRLG_GiveRandomItem(oPC, nType, GetPointEquivalentForLevel(itemLevel));
	}
	
	if (oItem != OBJECT_INVALID)
	{
		if(price > 0) {
			TakeGoldFromCreature(price, oPC, TRUE);
		}
		else {
			DestroyObject(GetItemPossessedBy(oPC, tokenTag));
		}
		string newName = "Strange " + GetFirstName(oItem);
		SetFirstName(oItem, newName);
		SetStolenFlag(oItem, TRUE);
	}
	else
		SendMessageToPC(oPC, "ERROR random loot generator could not create item");
}