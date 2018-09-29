/*******************************************************************
* Script for Triple Triad like card game for SCoD                  *
* by Agony_Aunt/Loki_999                                           *
* Run if someone quits - input is screen name that has been closed *
*******************************************************************/

#include "ps_inc_cards"

void main(string sScreen)
{
	object oPC = OBJECT_SELF;
	object oBoard = CardsGetBoardFromPlayer(oPC);
	//if (!GetIsObjectValid(oBoard))
	//	SendMessageToPC(oPC, "DEBUG: Quitting - Table object not found!!!");
	CardsLeaveGame(oBoard, oPC);
}