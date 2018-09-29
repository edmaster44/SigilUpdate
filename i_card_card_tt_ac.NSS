/************************************************************************************
* Script displays a single Triple Triad like card to either the owner or another PC *
* by Agony_Aunt/Loki_999                                                            *
************************************************************************************/

#include "ps_inc_cards"

void main()
{
	object oCard = GetItemActivated();
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	if (GetIsPC(oTarget))
	{
		CardsGUIDisplaySingleCard(oTarget, oCard);
	}
	else if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		if (GetTag(oTarget) == CARD_DECK_TAG)
		{
			CardsAddCardToDeck(oPC, oCard, oTarget);
		}
		else
		{
			SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Cards can only be used on a player character to display it, or on a card deck to add the card to the deck");
		}
	}
	else
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Cards can only be used on a player character to display it, or on a card deck to add the card to the deck");
	}
}