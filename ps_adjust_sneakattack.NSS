// Adjusts sneak dice to let all classes stack together
// Very flexible, just add other classes / feats to take into account in the calculation part.
// PS_AdjustSneakAttack is called on levelup
// This does NOT affect Neverwinter Nine's Franctic Reaction, or Death Attack, or Bleeding Wounds
// Update 12/02/2018 - Now adds Epic Precision to those with 5d6 sneak attack or more (including the above).

// By Electrohydra
// michel.remillard1@gmail.com
// Last edited 12/02/2018

#include "aaa_lycan_inc"
#include "aaa_constants"

const int SNEAKATTACK1 = 221;

const int SNEAKATTACK2 = 345;
const int SNEAKATTACK3 = 346;
const int SNEAKATTACK4 = 347;
const int SNEAKATTACK5 = 348;
const int SNEAKATTACK6 = 349;
const int SNEAKATTACK7 = 350;
const int SNEAKATTACK8 = 351;
const int SNEAKATTACK9 = 352;
const int SNEAKATTACK10 = 353;

const int SNEAKATTACK11 = 1032;
const int SNEAKATTACK12 = 1033;
const int SNEAKATTACK13 = 1034;
const int SNEAKATTACK14 = 1035;
const int SNEAKATTACK15 = 1036;
const int SNEAKATTACK16 = 1037;
const int SNEAKATTACK17 = 1038;
const int SNEAKATTACK18 = 1039;
const int SNEAKATTACK19 = 1040;
const int SNEAKATTACK20 = 1041;

const int DEATHATTACK1 = 455;
const int DEATHATTACK2 = 456;
const int DEATHATTACK3 = 457;
const int DEATHATTACK4 = 458;
const int DEATHATTACK5 = 459;

const int BLACKGUARDSNEAKATTACK1 = 460;
const int BLACKGUARDSNEAKATTACK2 = 461;
const int BLACKGUARDSNEAKATTACK3 = 462;

const int ARCANETRICKSTERSNEAKATTACK1 = 1502;
const int ARCANETRICKSTERSNEAKATTACK2 = 1503;
const int ARCANETRICKSTERSNEAKATTACK3 = 1504;
const int ARCANETRICKSTERSNEAKATTACK4 = 1505;
const int ARCANETRICKSTERSNEAKATTACK5 = 1506;

const int SHADOWTHIEFSNEAKATTACK1 = 1562;
const int SHADOWTHIEFSNEAKATTACK2 = 1563;
const int SHADOWTHIEFSNEAKATTACK3 = 1564;

const int CLASS_ROGUE = 8;
const int CLASS_SHADOWDANCER = 27;
const int CLASS_BLACKGUARD = 31;
const int CLASS_ARCANETRICKSTER = 40;
const int CLASS_SHADOWTHIEF = 46;
const int CLASS_RONIN = 67;
const int CLASS_VAMPIRE_LUPUS = 78;
const int CLASS_ARCANETRICKSTER2 = 83;
const int CLASS_MARQUISCAMBION = 99;
const int CLASS_LYCAN = 104;
const int CLASS_SHIFTING_INFILTRATOR = 212;
const int CLASS_ASSASSIN = 30;
const int CLASS_NEVERWINTER_NINE = 47;
const int CLASS_SLAYER_OF_DOMIEL = 41;
const int CLASS_INVISIBLE_BLADE = 57;

const int FEAT_EPIC_PRECISION = 2128;
const int FEAT_FRANTIC_REACTIONS = 1806;

void RemoveSneakDice(object oPC);

void AddSneakDice(object oPC);

void PS_AdjustSneakAttack(object oPC)
{
	RemoveSneakDice(oPC);
	
	AddSneakDice(oPC);
}

void RemoveSneakDice(object oPC)
{
	FeatRemove(oPC, SNEAKATTACK1);
	
	int feat = SNEAKATTACK2;
	while (feat <= SNEAKATTACK10)
	{
		FeatRemove(oPC, feat);
		++feat;
	}
	
	feat = SNEAKATTACK11;
	while (feat <= SNEAKATTACK20)
	{
		FeatRemove(oPC, feat);
		++feat;
	}
	
	feat = BLACKGUARDSNEAKATTACK1;
	while (feat <= BLACKGUARDSNEAKATTACK3)
	{
		FeatRemove(oPC, feat);
		++feat;
	}
	
	feat = ARCANETRICKSTERSNEAKATTACK1;
	while (feat <= ARCANETRICKSTERSNEAKATTACK5)
	{
		FeatRemove(oPC, feat);
		++feat;
	}
	
	feat = SHADOWTHIEFSNEAKATTACK1;
	while (feat <= SHADOWTHIEFSNEAKATTACK3)
	{
		FeatRemove(oPC, feat);
		++feat;
	}
	
	// Remove Epic Precision
	FeatRemove(oPC, FEAT_EPIC_PRECISION);
}

void AddSneakDice(object oPC)
{
	// First we find out how man dice the character should have. Careful with rounding with integers!
	int sneakDice = 0;
	
	sneakDice += (GetLevelByClass(CLASS_ROGUE, oPC) + 1) / 2;
	sneakDice += (GetLevelByClass(CLASS_BLACKGUARD, oPC) - 1) / 3;	
	sneakDice += GetLevelByClass(CLASS_ARCANETRICKSTER, oPC) / 2;
	sneakDice += (GetLevelByClass(CLASS_SHADOWTHIEF, oPC) + 1) / 2;
	sneakDice += (GetLevelByClass(CLASS_RONIN, oPC) +1 ) / 2 ;
	sneakDice += GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) / 2;
	sneakDice += GetLevelByClass(CLASS_SHADOWDANCER,oPC) / 3;
	sneakDice += GetLevelByClass(CLASS_ARCANETRICKSTER2, oPC) / 2;
	sneakDice += GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION, oPC) / 2;
	sneakDice += (GetLevelByClass(CLASS_SHIFTING_INFILTRATOR, oPC) + 1) / 2;
	
	
	// then we add the proper sneak attack feats
	if (sneakDice == 0)
		return;
	else
		FeatAdd(oPC,SNEAKATTACK1, FALSE, FALSE, FALSE);
		
	int feat = SNEAKATTACK2;
	while ((feat <= SNEAKATTACK10) && ((feat - sneakDice) <= (SNEAKATTACK2 - 2)))
	{
		FeatAdd(oPC,feat, FALSE, FALSE, FALSE);
		++feat;
	}
	
	feat = SNEAKATTACK11;
	while ((feat <= SNEAKATTACK20) && ((feat - sneakDice) <= (SNEAKATTACK11 - 11)))
	{
		FeatAdd(oPC,feat, FALSE, FALSE, FALSE);
		++feat;
	}
	PS_Wererat_SneakAdd(oPC);
	
	// Add Epic Precision
	int sTotal = sneakDice;
	sTotal += ((GetLevelByClass(CLASS_ASSASSIN, oPC) + 1) /2);
	sTotal += ((GetLevelByClass(CLASS_SLAYER_OF_DOMIEL, oPC) + 1) /2);
	sTotal += ((GetLevelByClass(CLASS_INVISIBLE_BLADE, oPC) + 1) /2);
	if (GetHasFeat(FEAT_FRANTIC_REACTIONS, oPC)) {
		sTotal += 2 ;}
	if (sTotal >= 5||GetHasFeat(DEATHATTACK5)) {
		FeatAdd(oPC, FEAT_EPIC_PRECISION, FALSE, FALSE, TRUE);}
}