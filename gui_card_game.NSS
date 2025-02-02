/*********************************************************
* Script that handles feedback from the card game screen *
* by Agony_Aunt/Loki_999                                 *
*********************************************************/

#include "ps_inc_cards"

void main(string sSelect)
{
	object oPC = OBJECT_SELF;
	object oBoard = GetLocalObject(oPC, CARD_TABLE_OBJECT);
	int iPos = CardsGetPlayerNumberFromBoard(oBoard, oPC);
	string sPos = IntToString(iPos);
	object oDeck = GetLocalObject(oBoard, CARD_PLAYER_DECK + sPos);
	int iCardNum;
	string sPreSelectedCard = GetLocalString(oBoard, SELECTED_CARD);
	
	//SendMessageToPC(oPC, "DEBUG: sSelect = " + sSelect + "and Position is: " + sPos + ". Also, preselected card is: " + sPreSelectedCard);
	
	string sSelect1 = GetStringLeft(sSelect, 1);
	int iSelect2 = StringToInt(GetSubString(sSelect, 1, 1)); // 1 because substrings start from zero... either returns player position of card or row number
	// we don't care about the third value which is either C or _
	int iSelect4 = StringToInt(GetStringRight(sSelect, 1)); // either returns player position of card or row number
	
	int iState = CardsGetGameState(oBoard);
	
	if (iState == GAME_STATE_GAME_OVER)
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Game is over, you may close the screen.");
	}
	else if (iPos > 0)
	{
		// if this isn't then nothing happens because not players turn
		if ((iPos == 1 && iState == GAME_STATE_GAME_IN_PROGRESS_TURN_P1) || (iPos == 2 && iState == GAME_STATE_GAME_IN_PROGRESS_TURN_P2))
		{
			// if selected position in hand - because hand positions always start with P
			if (sSelect1 == "P" && iSelect2 == iPos)
			{
				if (sPreSelectedCard == sSelect)
				{
					// deselect
					SetLocalString(oBoard, SELECTED_CARD, "");
					GUI_CardsSetSelected(oPC, sSelect, FALSE);
				}
				else
				{
					if (sPreSelectedCard != "")
						GUI_CardsSetSelected(oPC, sPreSelectedCard, FALSE); // deselect old selection
					
					if (CardsGetCardOnBoardOwnerFromPosition(oBoard, sSelect) != 0) // basically, check there is a card there
					{
						SetLocalString(oBoard, SELECTED_CARD, sSelect);
						GUI_CardsSetSelected(oPC, sSelect, TRUE);
					}
				}
			}
			// if selected position on board - because board positions always RnCn
			else if (sSelect1 == "R")
			{
				// no card currently selected
				if (sPreSelectedCard == "")
				{
					// do nothing, possibly message about selecting card first.
					SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You must select a card to play first.");
				}
				else if (CardsGetCardOnBoardOwnerFromPosition(oBoard, sSelect) != 0) // then card in that position
				{
					SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "There is already a card in that position, pick a free location to play your card!");
				}
				else
				{
					CardsSetLastCardPlayedOwner(oBoard, iPos);
					
					CardsChangeGameState(oBoard, GAME_STATE_GAME_IN_PROGRESS_PROCESSING_RULES);
					
					//sPreSelectedCard = GetLocalString(oBoard, SELECTED_CARD);

					// moves all values
					CardsMoveCardVariables(oBoard, sPreSelectedCard, sSelect);

					CardsGUIClearPlayedCardInPositionAllInGame(oBoard, sPreSelectedCard);
					CardsGUIDisplayPlayedCardInPositionAllInGame(oBoard, sSelect);

					CardsPlaceableRemoveCardFromPosition(oBoard, sPreSelectedCard);
					CardsPlaceableDisplayCardInPosition(oBoard, sSelect);
										
					// clear this now because it needs to be clear for next player
					SetLocalString(oBoard, SELECTED_CARD, "");
					
					
					// do rules
					if (CardsCheckParticipantsParticipatingNotifyIfGameOver(oBoard) == FALSE)
					{
						CardsDoRules(oBoard, sSelect);
						float fDelay = CardsGetTotalDelay(oBoard);
						//CardsSendMessageToPlayers(oBoard, "DEBUG: fdelay = " + FloatToString(fDelay));
						DelayCommand(fDelay, CardsSetIterationFlipsMax(oBoard, 0));

						if (CardsAllPositionsFilled(oBoard) == TRUE)
							// make a little extra delay, see if this deals with final card flip having wrong colour
							DelayCommand(fDelay + 0.5, CardsChangeGameState(oBoard, GAME_STATE_GAME_OVER, LEAVE_REASON_GAME_FINISHED));
						else 
						{
							int iNextState;
							if (iPos == 1) iNextState = GAME_STATE_GAME_IN_PROGRESS_TURN_P2;
							else iNextState = GAME_STATE_GAME_IN_PROGRESS_TURN_P1;
						
							DelayCommand(fDelay, CardsChangeGameState(oBoard, iNextState));
						}
					}
				}
			}
		}	
	}
}