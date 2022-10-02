//ga_take_soulcontracts
//Takes all your soul contracts, and gives you gold/exp
//Or alternatively, another reward if you take that conversation path

#include "ps_inc_treasuregeneration"
#include "nw_i0_plot"
#include "ps_inc_functions"

const int GPAWARD = 300;
const int XPAWARD = 100;

void main(int nRewardType) {

	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	//Decide how good the item is based on PC HD
	int nCR = GetHitDice(oPC);
	int TREASURE_LEVEL = 0;
	if (nCR < 10)
		TREASURE_LEVEL = 1;
	else if (nCR < 20)
		TREASURE_LEVEL = 2;
	else 
		TREASURE_LEVEL = 3;
	
	int iGold = 0;
	int iXp = 0;
	
	object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem)) {
	
		if(GetTag(oItem) == "ps_soul_contract_abyss" ||
			GetTag(oItem) == "ps_soul_contract_baator" ||
			GetTag(oItem) == "ps_soul_contract_gehenna") {
			
	 		DestroyObject(oItem);
			iGold += GPAWARD;
			iXp += XPAWARD;
			
     	}
		
     	oItem = GetNextItemInInventory(oPC);
		
    }
	
	PS_GiveXPReward(oPC, iXp);
	
	if (nRewardType == 1) {
		GiveGoldToCreature(oPC, iGold);
	} else if (nRewardType == 2) { //Armor Reward
		CreateArmorOnTarget(oPC, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 3) { //Weapon
		CreateWeaponOnTarget(oPC, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 4) { //Boots
		CreateWearableOnTarget(oPC, "treasure_boots", 71, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 5) { //Trinket
		CreateJunkOnTarget(oPC, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 6) { //Jewelry
		CreateJewelryOnTarget(oPC, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 7) { //Cloak
		CreateWearableOnTarget(oPC, "treasure_cloaks", 12, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	}else if (nRewardType == 8) { //Belt
		CreateWearableOnTarget(oPC, "treasure_belts", 5, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 9) { //Helmet
		CreateWearableOnTarget(oPC, "treasure_helmets", 35, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 10) { //Shield
		CreateShieldOnTarget(oPC, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	} else if (nRewardType == 11) { //Gloves
		CreateGlovesOnTarget(oPC, TREASURE_LEVEL);
		iGold -= 1500;
		if (iGold > 0)
			GiveGoldToCreature(oPC, iGold); //Give leftovers as gold
	}

}