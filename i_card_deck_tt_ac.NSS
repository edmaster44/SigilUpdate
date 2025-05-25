

/********************************************************************************
* Script that handles deck activation for Triple Triad like card game for SCoD  *
* by Agony_Aunt/Loki_999                                                        *
********************************************************************************/

#include "ps_inc_cards"

// use deck on self (deck) or self (PC) - view deck
// use deck on ground - spawn gaming table and chairs and prep for game
void main()
{
	object oDeck = GetItemActivated();
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();

	if (GetIsPC(oTarget))
	{
		// allow showing other PCs your deck as well
		CardsGUIViewCards(oTarget, oDeck);
	}
	else if (oTarget == oDeck)
	{
		SetLocalObject(oPC, "DECK_TALK", oDeck);
		AssignCommand(oPC, ActionStartConversation(oPC, "conv_card_deck", TRUE, FALSE, TRUE, TRUE));
	}	
	else if (GetIsLocationValid(lTarget))
	{
		CardsCreateBoard(oPC, lTarget);
	}
	else
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You must target a valid location to spawn a playing table, or yourself or another character to view/show your cards");
	}
	
}