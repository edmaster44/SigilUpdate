#include "ff_safevar"

#include "ps_randomlootgenerator"
#include "gm_include"

void GiveNothing();
void specialDrop(object oPC);
void GiveSpecialItem(object oPC, string sStore, string squareName);
void GiveRandomItem(object oPC);
void DoubleMoney(object oPC, int money);
void TripleMoney(object oPC, int money);
void GoldenSquare(object oPC, int money);

void main () {

	object oPC = GetPCSpeaker();
	int nGoldAmount = PS_GetLocalInt(OBJECT_SELF, "money_wagered");
	PS_DeleteLocalInt(OBJECT_SELF, "money_wagered");
	PS_SetLocalInt(OBJECT_SELF, "SPINNING", 1);
	int netWorth = PS_GetLocalInt(oPC, "fw_mynetworth");
	int randomNum = Random(1000); //Golden square roll
	//Note: The golden square can only be won if your bet is 500 or less; this 
	//ensures that no more than 500,000 is ever given out here.
	//1/28/17: golden square is also only winnable if your networth is under 10,000
	//There is a 1 in 5 chance of winning something at every level.
	if (nGoldAmount <= 500) {
		if (randomNum == 0 && netWorth < 10000) {
			DelayCommand(7.5f, GoldenSquare(oPC, nGoldAmount));
			return;
		}
		randomNum = Random(15);
		if (randomNum == 0)
			DelayCommand(7.5f, GiveSpecialItem(oPC, "pl_fw_ordinary", "Magician's"));
		else if (randomNum == 1)
			DelayCommand(7.5f, DoubleMoney(oPC, nGoldAmount));
		else if (randomNum == 2)
			DelayCommand(7.5f, TripleMoney(oPC, nGoldAmount));
		else
			DelayCommand(7.5f, GiveNothing());
	}
	else if (nGoldAmount <= 5000) {
		if (randomNum == 0 && nGoldAmount <= 500) {
			DelayCommand(7.5f, GoldenSquare(oPC, nGoldAmount));
			return;
		}
		randomNum = Random(30);
		if (randomNum == 0) {
			if ((GetHitDice(oPC) <= 10 && nGoldAmount <= 500) ||
				(GetHitDice(oPC) <= 15 && nGoldAmount <= 1000) ||
				(GetHitDice(oPC) <= 20 && nGoldAmount <= 2500) ||
				(GetHitDice(oPC) <= 25 && nGoldAmount <= 5000))
				DelayCommand(7.5f, GiveRandomItem(oPC));
			else
				DelayCommand(7.5f, specialDrop(oPC));
		}
		else if (randomNum == 1)
			DelayCommand(7.5f, DoubleMoney(oPC, nGoldAmount));
		else if (randomNum == 2 && nGoldAmount <= 1000)
			DelayCommand(7.5f, TripleMoney(oPC, nGoldAmount));
		else if (randomNum == 3)
			DelayCommand(7.5f, specialDrop(oPC));
		else if (randomNum <= 5 || PS_GetLocalInt(oPC, "HASWON") == 0)
			DelayCommand(7.5f, GiveSpecialItem(oPC, "pl_fw_ordinary", "Magician's"));
		else
			DelayCommand(7.5f, GiveNothing());
	}
	else if (nGoldAmount <= 10000) {
		randomNum = Random(60);
		if (randomNum == 0) 
			DelayCommand(7.5f, GiveRandomItem(oPC));
		else if (randomNum <= 2)
			DelayCommand(7.5f, DoubleMoney(oPC, nGoldAmount));
		else if (randomNum == 3)
			DelayCommand(7.5f, TripleMoney(oPC, nGoldAmount));
		else if (randomNum <= 5)
			DelayCommand(7.5f, specialDrop(oPC));
		else if (randomNum <= 8 || PS_GetLocalInt(oPC, "HASWON") == 0)
			DelayCommand(7.5f, GiveSpecialItem(oPC, "pl_fw_ordinary", "Magician's"));
		else if (randomNum <= 10)
			DelayCommand(7.5f, GiveSpecialItem(oPC, "pl_fw_purples", "Royal"));
		else if (randomNum <= 12)
			DelayCommand(7.5f, GiveSpecialItem(oPC, "ps_store_leilani", "Ruby"));
		else
			DelayCommand(7.5f, GiveNothing());
	}
	else
		DelayCommand(7.5f,	GiveNothing());
		
	DelayCommand(7.5f, PS_DeleteLocalInt(OBJECT_SELF, "SPINNING"));
}

//***********************************************************************8

void specialDrop(object oPC){

	// get the material from 2das instead of from code. Note that because
	// I've made precious metals such as gold, platinum, white gold, etc
	// be on both the metal and the misc lists (shows up in crafting as base 
	// metal for jewelery and as misc material for weapons, armor, shields, and bracers)
	// this means that people are more likely to get a precious metal that provides
	// nothing but a crafring point than they are something that provides a special 
	// property. I'm ok with that. -FlattedFifth.
	string sChosen2da;
	switch (Random(4)){
		case 0: sChosen2da = "scod_craft_leather"; break;
		case 1: sChosen2da = "scod_craft_metal"; break;
		case 2: sChosen2da = "scod_craft_misc"; break;
		case 3: sChosen2da = "scod_craft_wood"; break;
	}
	
	int nNumRows = GetNum2DARows(sChosen2da);
	// if the 2da is metal, there's 2 useless mats: copper and iron
	// at rows 0 and 1. otherwise, there's 1 useless mat at row 0
	if (sChosen2da == "scod_craft_metal") nNumRows -= 2;
	else nNumRows -= 1;
	
	int nChosenRow = Random(nNumRows);
	// skip the iron, wood, copper, etc
	if (sChosen2da == "scod_craft_metal") nChosenRow += 2;
	else nChosenRow += 1;
	
	string sIngot = Get2DAString(sChosen2da, "BASE_RESREF", nChosenRow);
	string sIngotName = Get2DAString(sChosen2da, "LABEL", nChosenRow);
	object oItem = CreateItemOnObject( sIngot, oPC);
	// error catching
	if (sIngot != "" && sIngot != "****"){
		PS_SetLocalInt(oPC, "HASWON", 1);
		SpeakString("Congratulations, "+GetName(oPC)+", you win one " + sIngotName + " from the Crafter's Square!");
	} else SpeakString("Too bad, "+GetName(oPC)+", try again!");
	
	/*
	switch (nRandom)
	{
		case 1: sIngot = "ps_cfrt_ing_pd"; break;
		case 2: sIngot = "ps_cfrt_ing_bi"; break;
		case 3: sIngot = "ps_crft_demonscale"; break;
		case 4: sIngot = "ps_crft_plk_tb"; break;
		case 5: sIngot = "ps_crft_dragonhide_blk"; break;
		case 6: sIngot = "ps_crft_dragonhide_blu"; break;
		case 7: sIngot = "ps_crft_plk_db"; break;
		case 8: sIngot = "ps_crft_drgsnw"; break;
		case 9: sIngot = "ps_crft_dragonhide_grn"; break;
		case 10: sIngot = "ps_crft_dragonhide_red"; break;
		case 11: sIngot = "ps_crft_dragonhide_wht"; break;	
		case 12: sIngot = "ps_cfrt_ing_mi"; break;
		case 13: sIngot = "ps_crft_ing_au"; break;
		case 14: sIngot = "ps_crft_formamb"; break;	
		case 15: sIngot = "ps_crft_reggear"; break;
		case 16: sIngot = "ps_crft_ing_ms"; break;					
		case 17: sIngot = "ps_cfrt_ing_bg"; break;
		case 18: sIngot = "ps_crft_ing_gs"; break;	
		case 19: sIngot = "ps_crft_ing_rv"; break;	
		case 20: sIngot = "ps_cfrt_ing_mi"; break;
		case 21: sIngot = "ps_crft_plk_ao"; break;	
		case 22: sIngot = "ps_cfrt_ing_by"; break;
		case 23: sIngot = "ps_crft_ing_ap"; break;	
		case 24: sIngot = "ps_crft_ing_rv"; break;
		case 25: sIngot = "ps_cfrt_ing_bg"; break;	
		case 26: sIngot = "ps_cfrt_ing_st"; break;
		case 27: sIngot = "ps_crft_celestplume"; break;	
		case 28: sIngot = "ps_cfrt_ing_gm"; break;
		case 29: sIngot = "ps_crft_devilscale"; break;	
		case 30: sIngot = "ps_cfrt_ing_tt"; break;	
		case 31: sIngot = "ps_cfrt_ing_by"; break;
		case 32: sIngot = "ps_crft_ophidian"; break;	
		case 33: sIngot = "ps_crft_neufly"; break;	
		case 34: sIngot = "ps_cfrt_ing_tt"; break;
		case 35: sIngot = "ps_crft_ing_ap"; break;	
		case 36: sIngot = "ps_cfrt_ing_ab"; break;
		case 37: sIngot = "ps_crft_ing_ob"; break;	
		case 38: sIngot = "ps_crft_ing_gs"; break;	
		default: sIngot = "ps_crft_ing_ms"; break;
	}
	
	object oItem = CreateItemOnObject( sIngot, oPC);
	PS_SetLocalInt(oPC, "HASWON", 1);
	SpeakString("Congratulations, "+GetName(oPC)+", you have won the Crafter's Square!");
	*/
}

//Gives a special item!
//pl_fw_purples
//ps_store_leilani
//pl_fw_ordinary
void GiveSpecialItem(object oPC, string sStore, string squareName) {
	object oStore = GetObjectByTag(sStore);
	int count = PS_GetLocalInt(oStore, "count");
	if (count <= 0) {
		object oItem = GetFirstItemInInventory(oStore);
		while (GetIsObjectValid(oItem)) {
			count++;
			oItem = GetNextItemInInventory(oStore);
		}
		PS_SetLocalInt(oStore, "count", count);
	}
	int chosen = Random(count);
	count = 0;
	object oGiven;
	object oItem = GetFirstItemInInventory(oStore);
	while (GetIsObjectValid(oItem)) {
		if (count == chosen) {
			oGiven = CopyItem(oItem, oPC, TRUE);
			return;
		}
		count++;
		oItem = GetNextItemInInventory(oStore);
	}
	if (GetIsObjectValid(oGiven)) {
		PS_SetLocalInt(oPC, "HASWON", 1);
		SpeakString("Congratulations, "+GetName(oPC)+", you have won the "+squareName+" Square!");
	}
	else
		GiveNothing();
}

void GiveRandomItem(object oPC) {
	object oItem;
	int nType = 0;
	int rand = Random(45);
	if (rand == 0)
		nType = BASE_ITEM_AMULET;
	else if (rand == 1)
		nType = BASE_ITEM_ARMOR;
	else if (rand == 2)
		nType = BASE_ITEM_BASTARDSWORD;
	else if (rand == 3)
		nType = BASE_ITEM_BATTLEAXE;
	else if (rand == 4)
		nType = BASE_ITEM_BELT;
	else if (rand == 5)
		nType = BASE_ITEM_BOOTS;
	else if (rand == 6)
		nType = BASE_ITEM_BRACER;
	else if (rand == 7)
		nType = BASE_ITEM_CLOAK;
	else if (rand == 8)
		nType = BASE_ITEM_CLUB;
	else if (rand == 9)
		nType = BASE_ITEM_DAGGER;
	else if (rand == 10)
		nType = BASE_ITEM_FALCHION;
	else if (rand == 11)
		nType = BASE_ITEM_DWARVENWARAXE;
	else if (rand == 12)
		nType = BASE_ITEM_FALCHION;
	else if (rand == 13)
		nType = BASE_ITEM_FLAIL;
	else if (rand == 14)
		nType = BASE_ITEM_GLOVES;
	else if (rand == 15)
		nType = BASE_ITEM_GREATAXE;
	else if (rand == 16)
		nType = BASE_ITEM_GREATSWORD;
	else if (rand == 17)
		nType = BASE_ITEM_HALBERD;
	else if (rand == 18)
		nType = BASE_ITEM_HANDAXE;
	else if (rand == 19)
		nType = BASE_ITEM_HELMET;
	else if (rand == 20)
		nType = BASE_ITEM_KAMA;
	else if (rand == 21)
		nType = BASE_ITEM_KATANA;
	else if (rand == 22)
		nType = BASE_ITEM_KUKRI;
	else if (rand == 23)
		nType = BASE_ITEM_LARGESHIELD;
	else if (rand == 24)
		nType = BASE_ITEM_LIGHTCROSSBOW;
	else if (rand == 25)
		nType = BASE_ITEM_LIGHTFLAIL;
	else if (rand == 26)
		nType = BASE_ITEM_LIGHTHAMMER;
	else if (rand == 27)
		nType = BASE_ITEM_LIGHTMACE;
	else if (rand == 28)
		nType = BASE_ITEM_LONGBOW;
	else if (rand == 29)
		nType = BASE_ITEM_LONGSWORD;
	else if (rand == 30)
		nType = BASE_ITEM_MACE;
	else if (rand == 31)
		nType = BASE_ITEM_MORNINGSTAR;
	else if (rand == 32)
		nType = BASE_ITEM_RAPIER;
	else if (rand == 33)
		nType = BASE_ITEM_QUARTERSTAFF;
	else if (rand == 34)
		nType = BASE_ITEM_RING;
	else if (rand == 35)
		nType = BASE_ITEM_SCIMITAR;
	else if (rand == 36)
		nType = BASE_ITEM_SCYTHE;
	else if (rand == 37)
		nType = BASE_ITEM_SHORTBOW;
	else if (rand == 38)
		nType = BASE_ITEM_SHORTSWORD;
	else if (rand == 39)
		nType = BASE_ITEM_SICKLE;
	else if (rand == 40)
		nType = BASE_ITEM_SLING;
	else if (rand == 41)
		nType = BASE_ITEM_SPEAR;
	else if (rand == 42)
		nType = BASE_ITEM_TOWERSHIELD;
	else if (rand == 43)
		nType = BASE_ITEM_WARHAMMER;
	else if (rand == 44)
		nType = BASE_ITEM_WARMACE;
	oItem = SRLG_GiveRandomLeveledItem(oPC, nType);
	PS_SetLocalInt(oPC, "HASWON", 1);
	SpeakString("Congratulations, "+GetName(oPC)+", you have won the Trickster's Square!");
}

void DoubleMoney(object oPC, int money) {
	money = money*2;
	GiveGoldToCreature(oPC, money, TRUE);
	PS_SetLocalInt(oPC, "HASWON", 1);
	SpeakString("Congratulations, "+GetName(oPC)+", you have won the Banker's Square!");
}

void TripleMoney(object oPC, int money) {
	money = money*3;
	GiveGoldToCreature(oPC, money, TRUE);
	PS_SetLocalInt(oPC, "HASWON", 1);
	SpeakString("Congratulations, "+GetName(oPC)+", you have won the Lord's Square!");
}

void GoldenSquare(object oPC, int money) {
	SpeakString("Why, this IS your lucky day! Ladies and Gentlemen, "+GetName(oPC)+" has won the GOLDEN SQUARE!");
	money = money*1000;
	PS_SetLocalInt(oPC, "HASWON", 1);
	GiveGoldToCreature(oPC, money, TRUE);
}

void GiveNothing() {
	SpeakString("I'm sorry, it doesn't look like you've won anything.");
}