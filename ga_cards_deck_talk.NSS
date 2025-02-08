#include "ff_safevar"

/*********************************************************
* Script for Triple Triad like card game for SCoD        *
* by Agony_Aunt/Loki_999                                 *
* script to talk silently to the table/board placeable   *
*********************************************************/

#include "ps_inc_cards"

void main(int iFunction)
{
	object oPC = GetPCSpeaker();
	object oDeck = PS_GetLocalObject(oPC, "DECK_TALK");
	
	if (iFunction == DECK_VIEW)
	{
		CardsGUIViewCards(oPC, oDeck);
	}
	else 
	{
		CardsDeckSort(oPC, oDeck, iFunction);
	}
}