#include "ps_inc_treasuregeneration"
//***********************************************************************
//Creates a reasonable pickpocketing reward. This can run from 
//a few gold pieces to an item which you could reasonable lift from
//somebody (jewelry, trinket, gemstone, ammo)
//Pulls from the standard treasure generation script BUT 
//based on the creatures CR - 5 (because no threat)
//***********************************************************************

void main() {

	object oPC = GetPCSpeaker();

	int TREASURE_LEVEL = 1;
	int nCR = GetChallengeRatingOfTarget(OBJECT_SELF);
	nCR -= 5; //lessening CR because this isn't very dangerous
	
	if (nCR < 10)
		TREASURE_LEVEL = 1;
	else if (nCR < 20)
		TREASURE_LEVEL = 2;
	else if (nCR < 25)
		TREASURE_LEVEL = 3;
	else
		TREASURE_LEVEL = 4;
		
	//currently, we have 15% chance for a "better" reward. Otherwise, you get 2-40gp
	int nRandom = Random(100)+1;
	switch (nRandom) {
		case 1: CreateGoldOnTarget(oPC, TREASURE_LEVEL); break; //standard gold reward, based on loot table logic
		case 2: CreateGoldOnTarget(oPC, TREASURE_LEVEL); break; //standard gold reward, based on loot table logic
		case 3: GiveGoldToCreature(oPC, d8(10)); break; //small gold reward, 10-80
		case 4: GiveGoldToCreature(oPC, d20(5)); break; //medium gold reward, 5-100
		case 5: GiveGoldToCreature(oPC, d10(10)); break; //small gold reward, 10-100
		case 6: GiveGoldToCreature(oPC, d20(10)); break; //large gold reward, 10-2000
		case 7: CreateJewelryOnTarget(oPC, TREASURE_LEVEL); break; //jewelry spawn
		case 8: CreateJewelryOnTarget(oPC, TREASURE_LEVEL); break; //jewelry spawn
		case 9: CreateJunkOnTarget(oPC, TREASURE_LEVEL); break; //trinket spawn
		case 10: CreateJunkOnTarget(oPC, TREASURE_LEVEL); break; //trinket spawn
		case 11: CreateJunkOnTarget(oPC, TREASURE_LEVEL); break; //trinket spawn
		case 12: CreateJunkOnTarget(oPC, TREASURE_LEVEL); break; //trinket spawn
		case 13: CreateJunkOnTarget(oPC, TREASURE_LEVEL); break; //trinket spawn
		case 14: CreateGemOnTarget(oPC, TREASURE_LEVEL); break; //gem spawn
		case 15: CreateGemOnTarget(oPC, TREASURE_LEVEL); break; //gem spawn
		default: GiveGoldToCreature(oPC, d20(3)); break; //default gold reward, 3-60
	}

}