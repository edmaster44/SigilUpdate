//ga_take_gemstoneshards
//Takes all your gemstone shards
//For every 10 you have (5 if a godsman), gives a random gemstone
//For less or leftovers, he gives the face value of gold

#include "ps_inc_treasuregeneration"
#include "nw_i0_plot"

const float GPAWARD = 250.0f;

int GetFaction(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}

int GetLootLevel(object oPC) {

	int nRand = Random(4)+1;
	switch (nRand) {
		case 1: return TREASURE_LOW;
		case 2: return TREASURE_MEDIUM;
		case 3: return TREASURE_HIGH;
		case 4: return TREASURE_EPIC;
	}
	
	return TREASURE_LOW;

}

void main() {

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	
	float numShards = IntToFloat(GetNumItems(oPC, "gemstone_gravel"));
	int numGems = 0;
	float goldPercen = 0.0f;
	float fGem = 0.0f;
	if (GetFaction(oPC) == 4) { //Godsman 
		fGem = numShards/5.0f;
	} else {
		fGem = numShards/10.0f;
	}
	
	numGems = FloatToInt(fGem);
	goldPercen = fGem-IntToFloat(numGems); //make sure leftovers turn into gold
	//SendMessageToPC(oPC, FloatToString(numShards)+" shards = "+IntToString(numGems)+" gems and "+FloatToString(GPAWARD*goldPercen)+" gold");
	
	if (goldPercen > 0.0f) {
		int goldAmount = FloatToInt(GPAWARD*goldPercen);
		if (goldAmount > 0) 
			GiveGoldToCreature(oPC, goldAmount);
	}
	
	while (numGems > 0) {
		//randomize loot level each time
		int lootLevel = GetLootLevel(oPC);
		CreateRandomGemstoneOnSpawnOrChest(oPC, lootLevel);
		numGems--;
	}
	
	TakeNumItems(oPC, "gemstone_gravel", FloatToInt(numShards));

}