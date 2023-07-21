#include "ps_inc_treasuregeneration"
//***********************************************************************
//Creates an item on the PC as a quest reward
//Uses standard item generation on TREASURE_LOW-TREASURE_EPIC
//Picks from the Epic level reward pools for TREASURE_QUEST_LOW+
//***********************************************************************
//nTreasurePool - the treasure pool to draw from
//	1 = TREASURE_LOW		(<10)
//	2 = TREASURE_MEDIUM		(10+)
//	3 = TREASURE_HIGH		(20+)
//	4 = TREASURE_EPIC 		(25+)
//	5 = TREASURE_QUEST_LOW 	(special 25+ level pool)
//	6 = TREASURE_QUEST_MED 	(special 25+ level pool)
//	7 = TREASURE_QUEST_HIGH (special 25+ level pool)
//allowRandom - only matters for TREASURE_QUEST_* levels
//	0 = no random items, only pulled from the epic pools
//	1 = randomized items allowed 50/50 chance
//***********************************************************************
void main (int nTreasurePool , int allowRandom) {

	GenerateQuestRewardOnTarget(GetPCSpeaker(), nTreasurePool, allowRandom);

}