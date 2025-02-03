/********************************************************
* Script that handles feedback from card selection gui  *
* by Agony_Aunt/Loki_999                                *
********************************************************/

#include "ps_inc_cards"

void main(string sSelect)
{
	object oPC = OBJECT_SELF;
	object oBoard = CardsGetBoardFromPlayer(oPC);
	int iPos = CardsGetPlayerNumberFromBoard(oBoard, oPC);
	string sPos = IntToString(iPos);
	object oDeck = GetPlayerDeck(oPC);
	int iDeckSize = CardsGetDeckSize(oDeck);
	int iGameState;
	int iSelect = StringToInt(GetStringRight(sSelect, 1));
	string sFunction = GetStringLeft(sSelect, 4);
	int iOffset = CardsSelectionGetScrollOffset(oPC);
	
	if (sFunction == "LEFT")
	{
		if (iSelect == 1) iOffset--;
		else if (iSelect == 2)
		{
			if (iOffset < 6) iOffset = 1; 
			else iOffset -= 5; 
		}
		else if (iSelect == 3) iOffset = 1;
		
		CardsSelectionSetScrollOffset(oPC, iOffset);
		CardsSelectionDisplayDeckFromOffset(oPC, oDeck);
		CardsSelectionDisableScrollButtons(oPC, oDeck);
	}
	else if (sFunction == "RIGH")
	{
		if (iSelect == 1) iOffset++;
		else if (iSelect == 2)
		{
			if (iOffset > iDeckSize - 9) iOffset = iDeckSize - 4;
			else iOffset += 5;
		}
		else if (iSelect == 3) iOffset = iDeckSize - 4;
		
		CardsSelectionSetScrollOffset(oPC, iOffset);
		CardsSelectionDisplayDeckFromOffset(oPC, oDeck);
		CardsSelectionDisableScrollButtons(oPC, oDeck);
	}
	else if (sFunction == "HAND")
	{
		SetLocalInt(oBoard, "P" + sPos + "_" + IntToString(iSelect), 0);
		CardsGUIClearCardInPosition(oPC, CARD_SCREEN_SELECTION_SCENE, CARD + IntToString(iSelect));
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_DONE", TRUE); // because we definitely have less than 5 cards now
	}
	else if (sFunction == "DECK")
	{
		int iNextSlot = CardsGetFirstFreeCardSlotInHand(oBoard, iPos);
		//SendMessageToPC(oPC, "Next free slot is: " + IntToString(iNextSlot));
		int iCard = iOffset+iSelect-1;
		if (iNextSlot == 0)
		{
			SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You already have 5 cards selected. To add a different one you must remove one");
		}
		else if (CardsIsCardSelectedForHand(oBoard, iCard, sPos))
		{
			SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You have already selected this card, please select a different one.");
		}
		else
		{
		// add card to selected cards, both on local var and gui
			iSelect = StringToInt(sSelect);
			CardsStoreSelectedCardOnBoard(oBoard, oDeck, iCard, iNextSlot, iPos);
			CardsGUIDisplayCardInPositionFromDeck(oPC, oDeck, iCard, CARD_SCREEN_SELECTION_SCENE, CARD + IntToString(iNextSlot));
			
			if (GetLocalInt(oBoard, "P" + sPos + "_" + "1") != 0 &&
				GetLocalInt(oBoard, "P" + sPos + "_" + "2") != 0 &&
				GetLocalInt(oBoard, "P" + sPos + "_" + "3") != 0 &&
				GetLocalInt(oBoard, "P" + sPos + "_" + "4") != 0 &&
				GetLocalInt(oBoard, "P" + sPos + "_" + "5") != 0)
			{
				SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_DONE", FALSE);
			}
		}
	}
	else if (sFunction == "DONE")
	{
		if (CardsCheckParticipantsParticipatingNotifyIfGameOver(oBoard) == FALSE)
		{
			iGameState = CardsGetGameState(oBoard);
			
			if (iGameState == GAME_STATE_CARD_SELECTION_1)
			{
				SetLocalInt(oBoard, LAST_PLAYER_CARDS_SELECTED, iPos);
				CardsChangeGameState(oBoard, GAME_STATE_CARD_SELECTION_2);
			}
			else if (iGameState == GAME_STATE_CARD_SELECTION_2)
			{
				SetLocalInt(oBoard, LAST_PLAYER_CARDS_SELECTED, iPos);
				CloseGUIScreen(oPC, CARD_SCREEN_WAITING_SCENE); // saves determining whose screen should be closed next
				CardsChangeGameState(oBoard, GAME_STATE_GAME_STARTING);
			}
		}
	}
}