/*********************************************************
* Script for Triple Triad like card game for SCoD        *
* by Agony_Aunt/Loki_999                                 *
* is an approproiate slot at the table free?             *
*********************************************************/

#include "ps_inc_cards"

// iPosition should be 1 = Player 2 = Observer, 3 = check to see in as either so give option to leave.
int StartingConditional(int iPosition)
{
	object oPC = GetPCSpeaker();
	object oBoard = OBJECT_SELF;
	int iReturn = 0;
	int iObserver = CardsGetObserverNumberFromBoard(oBoard, oPC);
	int iPlayer = CardsGetPlayerNumberFromBoard(oBoard, oPC);
	
	if (iPosition == CARD_PLAYER_TYPE_PLAYER) // 1
	{
		if (CheckGameSlotOpen(oBoard, CARD_PLAYER) > 0 && iObserver == 0 && iPlayer == 0) 
			iReturn = 1;
	}
	else if (iPosition == CARD_PLAYER_TYPE_OBSERVER)
	{
		if (CheckGameSlotOpen(oBoard, CARD_OBSERVER) > 0 && iObserver == 0 && iPlayer == 0)
			iReturn = 1;
	}
	else if (iPosition == 3)
	{
		if (iObserver > 0 || iPlayer > 0)
			iReturn = 1;
	}
	
	return iReturn;
}