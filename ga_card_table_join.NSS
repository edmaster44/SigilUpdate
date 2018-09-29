/***************************************************************
* Script for Triple Triad like card game for SCoD              *
* by Agony_Aunt/Loki_999                                       *
* From convo, join the game                                    *
***************************************************************/

// iPosition should be 1 = Player 2 = Observer
#include "ps_inc_cards"

void main(int iPosition)
{
	object oPC = GetPCSpeaker();
	object oBoard = OBJECT_SELF;
	
	JoinPlayerToGame(oBoard, iPosition, oPC);
}