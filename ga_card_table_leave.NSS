/***************************************************************
* Script for Triple Triad like card game for SCoD              *
* by Agony_Aunt/Loki_999                                       *
* From convo, leave the game                                    *
***************************************************************/

#include "ps_inc_cards"

void main()
{
	object oPC = GetPCSpeaker();
	object oBoard = OBJECT_SELF;
	
	CardsLeaveGame(oBoard, oPC);
}