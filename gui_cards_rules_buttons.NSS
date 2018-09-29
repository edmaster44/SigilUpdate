/***************************************************************
* Script for Triple Triad like card game for SCoD              *
* by Agony_Aunt/Loki_999                                       *
* Run when both players have accepted game rules               *
* Only possible when both have confirmed acceptance            *
* Either player can trigger this script                        *
***************************************************************/

#include "ps_inc_cards"

void main(string sPlayer, string sButton)
{
	object oPC = OBJECT_SELF;
	object oTable = CardsGetBoardFromPlayer(oPC);
	if (CardsCheckParticipantsParticipatingNotifyIfGameOver(oTable) == FALSE)
	{
		GUI_Cards_Rule_Screen_Change(oTable, sPlayer, sButton);
	}
}