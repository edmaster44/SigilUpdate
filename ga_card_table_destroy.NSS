/***************************************************************
* Script for Triple Triad like card game for SCoD              *
* by Agony_Aunt/Loki_999                                       *
* From convo, destroy the table                                *
***************************************************************/

#include "ps_inc_cards"

// function
void main()
{
	object oBoard = OBJECT_SELF; // erm, will this be the board or the player?
	// CardsClearVarsOnAllPlayers(oBoard); - handled by game over routine.
	DestroyCardTable(oBoard);
}