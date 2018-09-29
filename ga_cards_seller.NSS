/*********************************************************
* Script for Triple Triad like card game for SCoD        *
* by Agony_Aunt/Loki_999                                 *
* script to talk silently to the table/board placeable   *
*********************************************************/

#include "ps_inc_cards"

void main()
{
	object oPC = GetPCSpeaker();
	object oDeck = GetPlayerDeck(oPC);
	
	if (GetIsObjectValid(oDeck))
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You already have a deck of cards, you may only have one!");
	}
	else
	{
		oDeck = CreateItemOnObject(CARD_DECK_TAG, oPC, 1, "", FALSE);
		CardsSetUpBaseDeck(oPC, oDeck);
	}
}