

/*********************************************************
* Include file for Triple Triad like card game for SCoD  *
* by Agony_Aunt/Loki_999                                 *
* all GUI and game logic here                            *
*********************************************************/

// Templates have category SCOD GUI|Triple Triad regardless of type.

#include "ps_def_cards"
#include "ps_inc_achievements"
#include "dethia_shop_sys"

// prototypes where needed
void CardsChangeGameState(object oBoard, int iNewGameState, int iExitCode=0);
void CardsDoRules(object oBoard, string sCardPlayed, int iIteration=1);
void CardsGUIFillDeckListBox(object oPC, object oDeck, string sScreen);
void CardsPlaceableRemoveCardFromPosition(object oBoard, string sCardPos);


// Basic functions

void CardsSetLastCardPlayedOwner(object oBoard, int iPlayer)
{
	SetLocalInt(oBoard, "LAST_CARD_PLAYED", iPlayer);
}

int CardsGetLastCardPlayedOwner(object oBoard)
{
	return GetLocalInt(oBoard, "LAST_CARD_PLAYED");
}

void CardsSetBoardOnPlayer(object oPC, object oBoard)
{
	SetLocalObject(oPC, CARD_TABLE_OBJECT, oBoard);
}
object CardsGetBoardFromPlayer(object oPC)
{
	return GetLocalObject(oPC, CARD_TABLE_OBJECT);
}

void CardsSetPlayer(object oBoard, int iPlayer, object oPC)
{
	SetLocalObject(oBoard, CARD_PLAYER + IntToString(iPlayer), oPC);
}
object CardsGetPlayer(object oBoard, int iPlayer)
{
	return GetLocalObject(oBoard, CARD_PLAYER + IntToString(iPlayer));
}

string CardsGetObserverName(object oBoard, int iObserver)
{
	return GetLocalString(oBoard, CARD_OBSERVER_NAME + IntToString(iObserver));
}

void CardsSetObserverName(object oBoard, int iObserver, object oPC)
{
	SetLocalString(oBoard, CARD_OBSERVER_NAME + IntToString(iObserver), GetName(oPC));
}

object CardsGetObserver(object oBoard, int iObserver)
{
	return GetLocalObject(oBoard, CARD_OBSERVER + IntToString(iObserver));
}

void CardsSetObserver(object oBoard, int iObserver, object oPC)
{
	SetLocalObject(oBoard, CARD_OBSERVER + IntToString(iObserver), oPC);
}

string CardsGetPlayerNameFromBoard(object oBoard, int iPlayer)
{
	return GetLocalString(oBoard, CARD_PLAYER + IntToString(iPlayer) + CARD_PLAYER_NAME);
}

void CardsSetPlayerNameOnBoard(object oBoard, int iPlayer, object oPC)
{
	SetLocalString(oBoard, CARD_PLAYER + IntToString(iPlayer) + CARD_PLAYER_NAME, GetName(oPC));
}

// Sends a message to all participants specificed
void CardsSendMessageToPlayers(object oBoard, string sMessage, int iPlayers=TRUE, int iObservers=TRUE)
{
	object oPC;
	int iCount;
	string sCount;
	sMessage = CARD_GAME_FEEDBACK_COLOUR + sMessage;
	
	if (iPlayers==TRUE)
	{
		oPC = CardsGetPlayer(oBoard, 1);
		if (GetIsObjectValid(oPC))
			SendMessageToPC(oPC, sMessage);
		oPC = CardsGetPlayer(oBoard, 2);
		if (GetIsObjectValid(oPC))
			SendMessageToPC(oPC, sMessage);
	}
	if (iObservers==TRUE)
	{
		for (iCount=1; iCount <=10; iCount++)
		{
			sCount = IntToString(iCount);
			oPC = CardsGetObserver(oBoard, iCount);
			if (GetIsObjectValid(oPC))
				SendMessageToPC(oPC, sMessage);
		}
	}
}


// clears all vars stored on PCs after they have left the game.  Could also perhaps use when someone joins to double check
void CardsClearVarsOnPC(object oPC)
{
	DeleteLocalObject(oPC, CARD_TABLE_OBJECT);
	DeleteLocalString(oPC, CARD_TABLE_POSITION);
}

void CardsClearVarsOnBoard(object oBoard)
{
	int iCount;
	int x;
	int y;
	string sX;
	string sY;
	string sPos;
	
	DeleteLocalObject(oBoard, CARD_PLAYER1);
	DeleteLocalString(oBoard, CARD_PLAYER1 + CARD_PLAYER_NAME);
	DeleteLocalInt(oBoard, SCORE_PLAYER1);
	DeleteLocalObject(oBoard, CARD_PLAYER2);
	DeleteLocalString(oBoard, CARD_PLAYER2 + CARD_PLAYER_NAME);
	DeleteLocalInt(oBoard, SCORE_PLAYER2);
	DeleteLocalString(oBoard, SELECTED_CARD);

	for(iCount = 1; iCount <= CARD_MAX_OBSERVERS; iCount++)
	{
		DeleteLocalObject(oBoard, CARD_OBSERVER + IntToString(iCount));
		DeleteLocalObject(oBoard, CARD_OBSERVER_NAME + IntToString(iCount));
	}
	
	for (y=1; y<=3; y++)
	{
		for (x=1; x<=3; x++)
		{
			sX = IntToString(x);
			sY = IntToString(y);
			sPos = BOARD_ROW + sX + BOARD_COL + sY;
			DeleteLocalInt(oBoard, sPos);
			DeleteLocalInt(oBoard, sPos + CARD_OWNER);
			//DeleteLocalObject(oBoard, sPos + PLACEABLE);
			DeleteLocalString(oBoard, sPos + CARD_NAME);
			DeleteLocalString(oBoard, sPos + CARD_PICTURE);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_UP);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_DOWN);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_LEFT);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_RIGHT);
		}
	}
	
	for (y=1; y<=2; y++)
	{
		for (x=1; x<=5; x++)
		{
			sX = IntToString(x);
			sY = IntToString(y);
			sPos = CARD_P + sY + _HAND_ + sX;
			DeleteLocalInt(oBoard, sPos);
			DeleteLocalInt(oBoard, sPos + CARD_OWNER);
			//DeleteLocalObject(oBoard, sPos + PLACEABLE);
			DeleteLocalString(oBoard, sPos + CARD_NAME);
			DeleteLocalString(oBoard, sPos + CARD_PICTURE);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_UP);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_DOWN);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_LEFT);
			DeleteLocalInt(oBoard, sPos + CARD_VALUE_RIGHT);
		}
	}	
	
	// delete rules
	DeleteLocalInt(oBoard, CARD_PLAYER1 + RULE_OPEN);
	DeleteLocalInt(oBoard, CARD_PLAYER1 + RULE_RANDOM);
	DeleteLocalInt(oBoard, CARD_PLAYER1 + RULE_SAME);
	DeleteLocalInt(oBoard, CARD_PLAYER1 + RULE_PLUS);
	DeleteLocalInt(oBoard, CARD_PLAYER1 + RULE_WALL);
	DeleteLocalInt(oBoard, CARD_PLAYER1 + RULE_READY);
	DeleteLocalInt(oBoard, CARD_PLAYER2 + RULE_OPEN);
	DeleteLocalInt(oBoard, CARD_PLAYER2 + RULE_RANDOM);
	DeleteLocalInt(oBoard, CARD_PLAYER2 + RULE_SAME);
	DeleteLocalInt(oBoard, CARD_PLAYER2 + RULE_PLUS);
	DeleteLocalInt(oBoard, CARD_PLAYER2 + RULE_WALL);
	DeleteLocalInt(oBoard, CARD_PLAYER2 + RULE_READY);
	
	// delete selected cards
	
}

void CardsClearVarsOnAllPlayers(object oBoard)
{
	object oPC;
	int iCount;
	oPC = CardsGetPlayer(oBoard, 1);
	if (oPC != OBJECT_INVALID)
		CardsClearVarsOnPC(oPC);
	
	oPC = CardsGetPlayer(oBoard, 2);
	if (oPC != OBJECT_INVALID)
		CardsClearVarsOnPC(oPC);
		
	for (iCount=1; iCount <= CARD_MAX_OBSERVERS; iCount++)
	{
		oPC = CardsGetObserver(oBoard, iCount);
		if (oPC != OBJECT_INVALID)
			CardsClearVarsOnPC(oPC);
	}
}

int CardsGetObserverNumberFromBoard(object oBoard, object oPC)
{
	int n;
	int iRet;
	
	for (n=1; n<=CARD_MAX_OBSERVERS; n++)
	{
		if (GetLocalObject(oBoard, CARD_OBSERVER + IntToString(n)) == oPC)
		iRet = n;
	}
	
	return iRet;
}

// returns 0 if not a player, 1 if player1 and 2 if player 2
int CardsGetPlayerNumberFromBoard(object oBoard, object oPC)
{
	if (CardsGetPlayer(oBoard, 1) == oPC)
	{
		return 1;
	}
	else if (CardsGetPlayer(oBoard, 2) == oPC)
	{
		return 2;
	}
	else
	{
		return 0;
	}
}

// remove all placeable cards from board
void CardsClearTablePlaceableOfCards(object oBoard)
{
	int x;
	int y;
	string sX;
	string sY;
	string sPos;
	object oCard;
	
	//CardsSendMessageToPlayers(oBoard, "DEBUG: Trying to clear the table of cards");
	
	for (y=1; y<=3; y++)
	{
		for (x=1; x<=3; x++)
		{
			sX = IntToString(x);
			sY = IntToString(y);
			sPos = BOARD_ROW + sX + BOARD_COL + sY;
			CardsPlaceableRemoveCardFromPosition(oBoard, sPos);
		}
	}
	
	for (y=1; y<=2; y++)
	{
		for (x=1; x<=5; x++)
		{
			sX = IntToString(x);
			sY = IntToString(y);
			sPos = CARD_P + sY + _HAND_ + sX;
			CardsPlaceableRemoveCardFromPosition(oBoard, sPos);
		}
	}	
}

// returns the player's deck.  If they have more than one, then it will return first found.
object GetPlayerDeck(object oPC)
{
	return GetItemPossessedBy(oPC, CARD_DECK_TAG);
}

// returns the current size of the deck
int CardsGetDeckSize(object oDeck)
{
	return GetLocalInt(oDeck, CARD_DECK_SIZE);
}

void CardsSetDeckSize(object oDeck, int iSize)
{
	SetLocalInt(oDeck, CARD_DECK_SIZE, iSize);
}

int CardsGetGameState(object oBoard)
{
	return GetLocalInt(oBoard, GAME_STATE);
}

void CardsSetGameState(object oBoard, int iState)
{
	SetLocalInt(oBoard, GAME_STATE, iState);
}


// returns 0 if no position free, otherwise returns the first free position
// as the storted value in the position is the number of the card from the 
// player's deck.
int CardsGetFirstFreeCardSlotInHand(object oBoard, int iPos)
{
	int iCardPos = 0;
	// use local vars stored with format like this - const string CARD_P1_HAND_1 = "P1_1";
	string sVarLeft = "P" + IntToString(iPos) + _HAND_;
	// new feature, basic var of hand variables (without values or textures) states whether
	// card is in hand - this will come useful for quick checks, especially later
	if (GetLocalInt(oBoard, sVarLeft + "1") == 0) iCardPos = 1;
	else if (GetLocalInt(oBoard, sVarLeft + "2") == 0) iCardPos = 2;
	else if (GetLocalInt(oBoard, sVarLeft + "3") == 0) iCardPos = 3;
	else if (GetLocalInt(oBoard, sVarLeft + "4") == 0) iCardPos = 4;
	else if (GetLocalInt(oBoard, sVarLeft + "5") == 0) iCardPos = 5;
	
	return iCardPos;
}

// returns true if card is already selected, false if not
// only of use on card selection screen
int CardsIsCardSelectedForHand(object oBoard, int iCardNum, string sPos)
{
	if (GetLocalInt(oBoard, "P" + sPos + "_1") == iCardNum || 
		GetLocalInt(oBoard, "P" + sPos + "_2") == iCardNum || 
		GetLocalInt(oBoard, "P" + sPos + "_3") == iCardNum || 
		GetLocalInt(oBoard, "P" + sPos + "_4") == iCardNum || 
		GetLocalInt(oBoard, "P" + sPos + "_5") == iCardNum)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

// use this function to set GUI text - things like score updates, game over messages, etc
// also functionality in current waiting text function to use this instead.
// can use this for things like sending to all players whose turn it is as well.
void CardsSetGUITextPlayers(object oBoard, string sGUI, string sXMLObject, string sText, int iPlayer1=TRUE, int iPlayer2=TRUE, int iObservers=TRUE)
{
	object oPC;
	int iCount;
	string sCount;
	
	if (iPlayer1 == TRUE)
	{
		oPC = CardsGetPlayer(oBoard, 1);
		if (GetIsObjectValid(oPC))
			SetGUIObjectText(oPC, sGUI, sXMLObject, -1, sText);
	}

	if (iPlayer2 == TRUE)
	{
		oPC = CardsGetPlayer(oBoard, 2);
		if (GetIsObjectValid(oPC))
			SetGUIObjectText(oPC, sGUI, sXMLObject, -1, sText);
	}
	
	if (iObservers == TRUE)
	{
		for (iCount=1; iCount <=10; iCount++)
		{
			sCount = IntToString(iCount);
			oPC = CardsGetObserver(oBoard, iCount);
			if (GetIsObjectValid(oPC))
				SetGUIObjectText(oPC, sGUI, sXMLObject, -1, sText);
		}
	}
}

// used to set the game title uses above function just shortcuts all values requried.
void CardsGUISetGameBoardTitleAllPlayers(object oBoard, string sStatus)
{
	CardsSetGUITextPlayers(oBoard, CARD_SCREEN_GAME_SCENE, "GAME_STATUS", CARD_GAME_NAME + ": " + sStatus);
}

// may as well pass both scores at once as when one changes both do.
void CardsGUISetPlayerScoresAllPlayers(object oBoard, int iScorePlayer1, int iScorePlayer2)
{
	CardsSetGUITextPlayers(oBoard, CARD_SCREEN_GAME_SCENE, SCORE_PLAYER1, IntToString(iScorePlayer1));
	CardsSetGUITextPlayers(oBoard, CARD_SCREEN_GAME_SCENE, SCORE_PLAYER2, IntToString(iScorePlayer2));
}

void CardsGUISetPlayerNamesAllPlayers(object oBoard, string sNameP1, string sNameP2)
{
	CardsSetGUITextPlayers(oBoard, CARD_SCREEN_GAME_SCENE, "P1_NAME", sNameP1);
	CardsSetGUITextPlayers(oBoard, CARD_SCREEN_GAME_SCENE, "P2_NAME", sNameP2);
}

void CardsSetPlayerScores(object oBoard, int iScorePlayer1, int iScorePlayer2)
{
	SetLocalInt(oBoard, SCORE_PLAYER1, iScorePlayer1);
	SetLocalInt(oBoard, SCORE_PLAYER2, iScorePlayer2);
}

int CardsGetPlayerScore(object oBoard, int iPlayer)
{
	int iRet;
	
	if (iPlayer == 1)
		iRet = GetLocalInt(oBoard, SCORE_PLAYER1);
	else if (iPlayer == 2)
		iRet = GetLocalInt(oBoard, SCORE_PLAYER2);
	else
		iRet = 0; // error
	
	return iRet;
}

// check other routines that could take advantage of this new function
void CardsCloseGUIPlayers(object oBoard, string sGUI, int iPlayer1=TRUE, int iPlayer2=TRUE, int iObservers=TRUE)
{
	object oPC;
	int iCount;
	
	if (iPlayer1 == TRUE)
	{
		oPC = CardsGetPlayer(oBoard, 1);
		if (GetIsObjectValid(oPC))
			CloseGUIScreen(oPC, sGUI);
	}

	if (iPlayer2 == TRUE)
	{
		oPC = CardsGetPlayer(oBoard, 2);
		if (GetIsObjectValid(oPC))
			CloseGUIScreen(oPC, sGUI);
	}
	
	if (iObservers == TRUE)
	{
		for (iCount=1; iCount <=10; iCount++)
		{
			oPC = CardsGetObserver(oBoard, iCount);
			if (GetIsObjectValid(oPC))
				CloseGUIScreen(oPC, sGUI);
		}
	}
}

// from the board determines who has most cards - basically just get and compare both players scores.
int CardsDetermineWinner(object oBoard)
{
	int iScore1 = CardsGetPlayerScore(oBoard, 1);
	int iScore2 = CardsGetPlayerScore(oBoard, 2);
	int iRet;
	
	if (iScore1 == iScore2) iRet = 0; // draw
	else if (iScore1 > iScore2) iRet = 1; // player 1 wins
	else iRet = 2; // player 2 wins
	
	return iRet;
}

void CardsDestroyBoard(object oBoard)
{
	// handled by game over function which calls this function anyway  - CardsClearTablePlaceableOfCards(oBoard);
	CardsClearTablePlaceableOfCards(oBoard);
	DestroyObject(GetLocalObject(oBoard, CARD_CHAIR_BLUE), 0.0, FALSE);
	DestroyObject(GetLocalObject(oBoard, CARD_CHAIR_RED), 0.0, FALSE);
	DestroyObject(oBoard, 0.0, FALSE);
}

// consider letting observers stay in game when game over, just revert them to waiting screen
// if game is finished, let people keep their UIs open to see the game result
// when both involved players have closed end of game UI then it should prompt both (UI) whether they wish to play again.
// only then will it clear vars and go back to 2 player state.
// probably need to place make some way of tracking when one player has and the other hasn't yet answered so it doesn't jump into rules selection before both are ready.
void CardsGameOver(object oBoard, int iExitCode)
{
	//CardsSendMessageToPlayers(oBoard, "DEBUG: GAME OVER ROUTINE RUNNING!");
	// double check all relevant screens are being closed
	object oPC1 = CardsGetPlayer(oBoard, CARD_PLAYER_1);
	object oPC2 = CardsGetPlayer(oBoard, CARD_PLAYER_2);
	int iState = CardsGetGameState(oBoard);
	string sExitReason = "Game Over! ";
	
	// do messages first, then close GUIs depending on state.
	if (iExitCode == LEAVE_REASON_TOO_FAR_PLAYER1) sExitReason += LEAVE_STRING_P1_TOO_FAR;
	else if (iExitCode == LEAVE_REASON_TOO_FAR_PLAYER2) sExitReason += LEAVE_STRING_P2_TOO_FAR;
	else if (iExitCode == LEAVE_REASON_NOT_FOUND_PLAYER1) sExitReason += LEAVE_STRING_P1_QUIT_CLIENT;
	else if (iExitCode == LEAVE_REASON_NOT_FOUND_PLAYER2) sExitReason += LEAVE_STRING_P2_QUIT_CLIENT;
	else if (iExitCode == LEAVE_REASON_PLAYER1_QUIT) sExitReason += LEAVE_STRING_P1_QUIT_GAME;
	else if (iExitCode == LEAVE_REASON_PLAYER2_QUIT) sExitReason += LEAVE_STRING_P2_QUIT_GAME;
	else if (iExitCode == LEAVE_REASON_GAME_BOARD_DESTROYED) sExitReason += LEAVE_STRING_BOARD_DESTROYED;
	else if (iExitCode == LEAVE_REASON_GAME_FINISHED) sExitReason += LEAVE_STRING_GAME_FINISHED;
	else sExitReason += "ERROR: Game over for unknown reason";
	
	CardsSendMessageToPlayers(oBoard, sExitReason, TRUE, TRUE);
	
	if (iState < GAME_STATE_GAME_STARTING)
	{
		// game not even started, close GUIs on all players
		//CardsSendMessageToPlayers(oBoard, "One or more players have quit the table or the board has been destroyed.");
		CardsCloseGUIPlayers(oBoard, CARD_SCREEN_WAITING_SCENE);
		
		if (iState == GAME_STATE_RULES_SELECTION)
		{
		CloseGUIScreen(oPC1, CARD_SCREEN_RULES_SCENE);
		CloseGUIScreen(oPC2, CARD_SCREEN_RULES_SCENE);
		}
		else
		{
		CloseGUIScreen(oPC1, CARD_SCREEN_SELECTION_SCENE);
		CloseGUIScreen(oPC2, CARD_SCREEN_SELECTION_SCENE);
		}
	}
	else if (iState < GAME_STATE_GAME_OVER)
	{
		// game started but ended prematurely (player quit?).  Keep board screen open but allow no further actions.  Set gamestate to game over.  Print game aborted
		CardsGUISetGameBoardTitleAllPlayers(oBoard, GAME_BOARD_STATUS_PLAYER_QUIT);
	}
	else
	{
		// keep board screens open, print game over and who won.
		int iWinner = CardsDetermineWinner(oBoard);
		string sTitle;
		string sMessage;
		string sName;
		
		AddAchievement(oPC1, 28);
		AddAchievement(oPC2, 28);
		
		if (iWinner == 0) // its a draw
		{
			// sudden death option? Or that would activate under the gui script?
			sMessage = GAME_BOARD_STATUS_GAME_OVER + GAME_BOARD_STATUS_DRAW;
		}
		else
		{
			if (iWinner == 1) {
				sName = GetFirstName(oPC1);
				IncrementAchievement(oPC1, 63);
			}
			else {
				sName = GetFirstName(oPC2);
				IncrementAchievement(oPC2, 63);
			}
			
			if (sName == "") sName = "ERROR GETTING PLAYER NAME - PLEASE REPORT";
			
			sMessage = GAME_BOARD_STATUS_GAME_OVER + sName + GAME_BOARD_STATUS_PLAYER_WINS;
		}
		
		CardsSendMessageToPlayers(oBoard, sMessage);
		CardsGUISetGameBoardTitleAllPlayers(oBoard, sMessage);
	}
	// one thing needs doing is clearing all vars on the board for next game
	// CardsClearVarsOnAllPlayers(oBoard);
	// CardsClearTablePlaceableOfCards(oBoard);
	
	//CardsSendMessageToPlayers(oBoard, "DEBUG: Finalizing Game Over... (should be follow up message unless board destroyed)");
	if (iExitCode == LEAVE_REASON_GAME_BOARD_DESTROYED)
	{
		CardsDestroyBoard(oBoard);
	}
	else
	{
		//CardsSendMessageToPlayers(oBoard, "DEBUG: ...About to clear vars on board...");
		CardsClearVarsOnBoard(oBoard);
	}
}

// returns 0 (FALSE) if player out of range or no longer logged in
int CardsParticipantInRange(object oPC, object oBoard, int iPlayerType)
{
	float fDistance = GetDistanceBetween(oPC, oBoard);
	float fMaxDistance;
	
	if (!GetIsObjectValid(oPC))
	{
		// dropped from game
		return FALSE;
	}
	else
	{
		if (iPlayerType == CARD_PLAYER_TYPE_PLAYER) fMaxDistance = MAX_PLAYER_DISTANCE_FROM_BOARD;
		else fMaxDistance = MAX_OBSERVER_DISTANCE_FROM_BOARD;
		
		if (fDistance > fMaxDistance)
			return FALSE;
		else
			return TRUE;
	}
}

// function updates the observer list on all player/observer screens with the observers name
void CardsGUIUpdateObserverList(object oBoard)
{
	string sObservers = "OBSERVING: ";
	int iCount;
	string sCount;
	object oPC;
	
	for (iCount=1; iCount <=10; iCount++)
	{
		sCount = IntToString(iCount);
		oPC = CardsGetObserver(oBoard, iCount);
		if (GetIsObjectValid(oPC))
			sObservers += GetName(oPC) + "  ";
	}

	CardsSetGUITextPlayers(oBoard, CARD_SCREEN_GAME_SCENE, "OBSERVER_LIST", sObservers);
}

void CardsCheckObservers(object oBoard)
{
	object oPC;
	int iCount;
	string sObserverName;
	string sCount;
	for (iCount=1; iCount <=10; iCount++)
	{
		sCount = IntToString(iCount);
		oPC = CardsGetObserver(oBoard, iCount);
		sObserverName = GetLocalString(oBoard, CARD_OBSERVER_NAME + sCount);
		if (!GetIsObjectValid(oPC))
		{
			//CardsSendMessageToPlayers(oBoard, sObserverName + " has stopped observing the game.");
			DeleteLocalObject(oBoard, CARD_OBSERVER + sCount);
			DeleteLocalString(oBoard, CARD_OBSERVER_NAME + sCount);
			CardsGUIUpdateObserverList(oBoard);
		}
		else if (CardsParticipantInRange(oPC, oBoard, CARD_PLAYER_TYPE_OBSERVER) == FALSE)
		{
			SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You are too far from the board to see what is happening!");
			DeleteLocalObject(oBoard, CARD_OBSERVER + sCount);
			DeleteLocalString(oBoard, CARD_OBSERVER_NAME + sCount);
			CardsGUIUpdateObserverList(oBoard);
		}
	}
}

// returns true if one or both players are missing (assuming game state has reached the point of requiring two players)
int CardsCheckParticipantsParticipatingNotifyIfGameOver(object oBoard)
{
	object oPC1;
	object oPC2;
	object oObserver;
	int iGameState = CardsGetGameState(oBoard);
	int bInRange;
	int bGameOver = FALSE;
	int iGameOverReason;
	int bPlayer1OK=TRUE;
	int bPlayer2OK=TRUE;
	
	oPC1 = CardsGetPlayer(oBoard, 1);
	oPC2 = CardsGetPlayer(oBoard, 2);
	
	if (!GetIsObjectValid(oPC1)) bPlayer1OK = FALSE;
	if (!GetIsObjectValid(oPC2)) bPlayer2OK = FALSE;
	
	if (iGameState < GAME_STATE_RULES_SELECTION) // only 1 player required, don't finish game in only 1
	{
		if (bPlayer1OK == FALSE && bPlayer2OK == FALSE)
		{
			if (CardsGetPlayerNameFromBoard(oBoard, 1) != "")
				iGameOverReason = LEAVE_REASON_NOT_FOUND_PLAYER1;
			else
				iGameOverReason = LEAVE_REASON_NOT_FOUND_PLAYER2;
			
			bGameOver = TRUE;	
		}
		else
		{
			if (bPlayer1OK == TRUE)
			{
				bInRange = CardsParticipantInRange(oPC1, oBoard, CARD_PLAYER_TYPE_PLAYER);
				if (bInRange == FALSE)
				{
					SendMessageToPC(oPC1, CARD_GAME_FEEDBACK_COLOUR + "You are too far from the board to play!");	
					iGameOverReason = LEAVE_REASON_TOO_FAR_PLAYER1;
					bGameOver=TRUE;
				}
			}
			else
			{
				bInRange = CardsParticipantInRange(oPC2, oBoard, CARD_PLAYER_TYPE_PLAYER);
				if (bInRange == FALSE)
				{
					SendMessageToPC(oPC2, CARD_GAME_FEEDBACK_COLOUR + "You are too far from the board to play!");
					iGameOverReason = LEAVE_REASON_TOO_FAR_PLAYER2;
					bGameOver=TRUE;
				}
			}	
		}
	}
	else
	{
		if (bPlayer1OK == FALSE || bPlayer2OK == FALSE)
		{
			if (bPlayer1OK == FALSE)
			{
				iGameOverReason = LEAVE_REASON_NOT_FOUND_PLAYER1;
			}
			else
			{
				iGameOverReason = LEAVE_REASON_NOT_FOUND_PLAYER2;
			}
			
			bGameOver=TRUE;
		}
		else
		{
			// check distances
			bInRange = CardsParticipantInRange(oPC1, oBoard, CARD_PLAYER_TYPE_PLAYER);
			if (bInRange == FALSE) 
			{
				iGameOverReason = LEAVE_REASON_TOO_FAR_PLAYER1;
				bGameOver=TRUE;
			}
			else // no need to check for second player if first player already too far
			{
				bInRange = CardsParticipantInRange(oPC2, oBoard, CARD_PLAYER_TYPE_PLAYER);
				if (bInRange == FALSE)
				{
					iGameOverReason = LEAVE_REASON_TOO_FAR_PLAYER2;
					bGameOver=TRUE;
				}
			}
		}
	}
		
	if (bGameOver == FALSE && iGameState > GAME_STATE_GAME_STARTING) CardsCheckObservers(oBoard);
	
	if (bGameOver == TRUE) CardsGameOver(oBoard, iGameOverReason);

	return bGameOver;
}

// Set the text on the Waiting GUI screen depending on situation on all waiting participants.
void CardsGUISetWaitingText(object oBoard)
{
	int iGameState = CardsGetGameState(oBoard);
	object oPC;
	string sWaitText;
	int iCount;
	string sCount;
	
	switch(iGameState)
	{
		case GAME_STATE_NO_PLAYERS: sWaitText = GAME_STATE_NO_PLAYERS_TEXT; break;
		case GAME_STATE_1_PLAYER: sWaitText = GAME_STATE_1_PLAYER_TEXT; break;
		case GAME_STATE_RULES_SELECTION: sWaitText = GAME_STATE_RULES_SELECTION_TEXT; break;
		case GAME_STATE_CARD_SELECTION_1:
		case GAME_STATE_CARD_SELECTION_2: 
			sWaitText = GAME_STATE_CARD_SELECTION_TEXT; break;
		default: sWaitText = "ERROR! Game state not recognized. Wait, hope, and pray!"; break;
	}

	oPC = CardsGetPlayer(oBoard, 1);
	if (GetIsObjectValid(oPC))
		SetGUIObjectText(oPC, CARD_SCREEN_WAITING_SCENE, "WAITING_TEXT", -1, sWaitText);

	oPC = CardsGetPlayer(oBoard, 2);
	if (GetIsObjectValid(oPC))
		SetGUIObjectText(oPC, CARD_SCREEN_WAITING_SCENE, "WAITING_TEXT", -1, sWaitText);
	
	for (iCount=1; iCount <=10; iCount++)
	{
		sCount = IntToString(iCount);
		oPC = CardsGetObserver(oBoard, iCount);
		if (GetIsObjectValid(oPC))
			SetGUIObjectText(oPC, CARD_SCREEN_WAITING_SCENE, "WAITING_TEXT", -1, sWaitText);
	}
}

// iPlayerPos is the position of the player oPC. It will then disable controls on the other side from their viewpoint.
void GUI_Display_Card_Game_Rule_Selection_Player(object oBoard, int iPlayerPos)
{
	string sDisable;
	
	object oPC = CardsGetPlayer(oBoard, iPlayerPos);

	DisplayGuiScreen(oPC, CARD_SCREEN_RULES_SCENE, FALSE, CARD_SCREEN_RULES_XML);
	
	if (iPlayerPos == 1) sDisable = "2";
	else sDisable = "1";
	
	SetGUIObjectDisabled(oPC, CARD_SCREEN_RULES_SCENE, RULE_BUTTON + sDisable + "_" + RULE_OPEN, TRUE);
	SetGUIObjectDisabled(oPC, CARD_SCREEN_RULES_SCENE, RULE_BUTTON + sDisable + "_" + RULE_RANDOM, TRUE);
	SetGUIObjectDisabled(oPC, CARD_SCREEN_RULES_SCENE, RULE_BUTTON + sDisable + "_" + RULE_SAME, TRUE);
	SetGUIObjectDisabled(oPC, CARD_SCREEN_RULES_SCENE, RULE_BUTTON + sDisable + "_" + RULE_PLUS, TRUE);
	SetGUIObjectDisabled(oPC, CARD_SCREEN_RULES_SCENE, RULE_BUTTON + "1" + "_" + RULE_WALL, TRUE); // wall disabled on both sides anyway
	SetGUIObjectDisabled(oPC, CARD_SCREEN_RULES_SCENE, RULE_BUTTON + "2" + "_" + RULE_WALL, TRUE); // wall disabled on both sides anyway
	SetGUIObjectDisabled(oPC, CARD_SCREEN_RULES_SCENE, RULE_BUTTON + sDisable + "_" + RULE_READY, TRUE);
}

// displays the GUI for selecting/agreeing on game rules before the board is displayed.
void GUI_Display_Card_Game_Rule_Selection(object oBoard)
{
	GUI_Display_Card_Game_Rule_Selection_Player(oBoard, 1);
	GUI_Display_Card_Game_Rule_Selection_Player(oBoard, 2);
}

void CardsSetRule(object oBoard, string sRule, int iValue, string sPlayer="1")
{
	SetLocalInt(oBoard, CARD_PLAYER + sPlayer + sRule, iValue);
}

// sPlayer is used from the rule screen to allow quick checking of rules for both players
// once game has started we simply use default sPlayer value to get the rule.
int CardsGetRule(object oBoard, string sRule, string sPlayer="1")
{
	// doesn't matter whether we modify the string with "1" or "2" as both sets of rules should be equal at this stage
	return GetLocalInt(oBoard, CARD_PLAYER + sPlayer + sRule);
}

// displayed to observers or players when waiting for players to join and select rules.
void GUI_Display_Card_Board_Waiting(object oBoard, object oPC)
{
	DisplayGuiScreen(oPC, CARD_SCREEN_WAITING_SCENE, FALSE, CARD_SCREEN_WAITING_XML);
	CardsGUISetWaitingText(oBoard); // just make sure everyone is refreshed
}

// sOld will always be from hand, sNew will always be a place on the board in-play
void CardsMoveCardVariables(object oBoard, string sOld, string sNew)
{
	SetLocalInt(oBoard, sNew, GetLocalInt(oBoard, sOld)); // remember, the base variable without extension is the card number.
	SetLocalInt(oBoard, sOld, 0);
	
	SetLocalInt(oBoard, sNew + CARD_ID, GetLocalInt(oBoard, sOld + CARD_ID));
	SetLocalInt(oBoard, sOld + CARD_ID, 0);
	
	SetLocalInt(oBoard, sNew + CARD_OWNER, GetLocalInt(oBoard, sOld + CARD_OWNER));
	SetLocalInt(oBoard, sOld + CARD_OWNER, 0);
	
	SetLocalString(oBoard, sNew + CARD_NAME, GetLocalString(oBoard, sOld + CARD_NAME));
	SetLocalString(oBoard, sOld + CARD_NAME, "");

	SetLocalString(oBoard, sNew + CARD_PICTURE, GetLocalString(oBoard, sOld + CARD_PICTURE));
	SetLocalString(oBoard, sOld + CARD_PICTURE, "");

	SetLocalInt(oBoard, sNew + CARD_VALUE_UP, GetLocalInt(oBoard, sOld + CARD_VALUE_UP));
	SetLocalInt(oBoard, sOld + CARD_VALUE_UP, 0);
	
	SetLocalInt(oBoard, sNew + CARD_VALUE_DOWN, GetLocalInt(oBoard, sOld + CARD_VALUE_DOWN));
	SetLocalInt(oBoard, sOld + CARD_VALUE_DOWN, 0);
	
	SetLocalInt(oBoard, sNew + CARD_VALUE_LEFT, GetLocalInt(oBoard, sOld + CARD_VALUE_LEFT));
	SetLocalInt(oBoard, sOld + CARD_VALUE_LEFT, 0);
	
	SetLocalInt(oBoard, sNew + CARD_VALUE_RIGHT, GetLocalInt(oBoard, sOld + CARD_VALUE_RIGHT));
	SetLocalInt(oBoard, sOld + CARD_VALUE_RIGHT, 0);
}

// iPosition is the position of the card in the hand (ie: 1-5), return value is the number of the card
// from the players deck
/*int CardsGetSelectedCardFromBoard(object oBoard, int iPosition, int iPlayer)
{
	string sPosition = IntToString(iPosition);
	string sPlayer = IntToString(iPlayer);
	
	return GetLocalInt(oBoard, "P" + sPlayer + "_" + sPosition);
}*/

// iPosition is the position of the card in the hand (ie: 1-5), iCard is the selected card from CardsSelectRandomCardsForPlayer() or selection screen
void CardsStoreSelectedCardOnBoard(object oBoard, object oDeck, int iCard, int iPosition, int iPlayer)
{
	string sPosition = CARD_P + IntToString(iPlayer) + _HAND_ + IntToString(iPosition);
	string sCard = IntToString(iCard);
	
	SetLocalInt(oBoard, sPosition + CARD_ID, GetLocalInt(oDeck, CARD_ID + sCard));
	SetLocalInt(oBoard, sPosition, iCard);
	SetLocalString(oBoard, sPosition + CARD_NAME, GetLocalString(oDeck, CARD_NAME + sCard));
	SetLocalString(oBoard, sPosition + CARD_PICTURE, GetLocalString(oDeck, CARD_PICTURE + sCard));
	SetLocalInt(oBoard, sPosition + CARD_VALUE_UP, GetLocalInt(oDeck, CARD_VALUE_UP + sCard));
	SetLocalInt(oBoard, sPosition + CARD_VALUE_DOWN, GetLocalInt(oDeck, CARD_VALUE_DOWN + sCard));
	SetLocalInt(oBoard, sPosition + CARD_VALUE_LEFT, GetLocalInt(oDeck, CARD_VALUE_LEFT + sCard));
	SetLocalInt(oBoard, sPosition + CARD_VALUE_RIGHT, GetLocalInt(oDeck, CARD_VALUE_RIGHT + sCard));
	SetLocalInt(oBoard, sPosition + CARD_OWNER, iPlayer);
}

void CardsSelectRandomCardsForPlayer(object oBoard, int iPlayer)
{
	object oDeck = GetLocalObject(oBoard, CARD_PLAYER_DECK + IntToString(iPlayer));
	int iDeckSize = CardsGetDeckSize(oDeck);
	int iCard1; int iCard2; int iCard3; int iCard4; int iCard5;
	int iCount;
	int iResult;
	object oPC = CardsGetPlayer(oBoard, iPlayer);
	int iMatch;
	
	for (iCount=1; iCount <=5; iCount++)
	{
		// theory is, all vars are 0 to start with and cards cannot be zero, so it will look until it gets a non-matching number that isn't zero.
		//SendMessageToPC(oPC, "DEBUG: Curent count = " + IntToString(iCount));
		iMatch = FALSE;
		
		do
		{
			// this is horrible.
			iResult = Random(iDeckSize) + 1;
			if (iCount == 1) iMatch = TRUE; // because first pass it must be unique.
			else if (iCount == 2 && iResult != iCard1) iMatch = TRUE;
			else if (iCount == 3 && iResult != iCard1 && iResult != iCard2) iMatch = TRUE;
			else if (iCount == 4 && iResult != iCard1 && iResult != iCard2 && iResult != iCard3) iMatch = TRUE;
			else if (iCount == 5 && iResult != iCard1 && iResult != iCard2 && iResult != iCard3 && iResult != iCard4) iMatch = TRUE;
			//else iMatch = TRUE; // just a failsafe
		}
		while (iMatch != TRUE);
		
		switch (iCount)
		{
			case 1: iCard1 = iResult; break;
			case 2: iCard2 = iResult; break;
			case 3: iCard3 = iResult; break;
			case 4: iCard4 = iResult; break;
			case 5: iCard5 = iResult; break;
		}
		//SendMessageToPC(oPC, "DEBUG: Storing a card.");
		CardsStoreSelectedCardOnBoard(oBoard, oDeck, iResult, iCount, iPlayer);
	}
}

// randomly selects the cards from both players decks and stores on oBoard as variables for retrieval by game.
void CardsSelectRandomCards(object oBoard)
{
	// how to ensure only unique cards are selected? Reduce the random selection size each time by one and then push up the result if greater than previous....
	CardsSelectRandomCardsForPlayer(oBoard, CARD_PLAYER_1);
	CardsSelectRandomCardsForPlayer(oBoard, CARD_PLAYER_2);
}

// GUI functions - to be called from either items or scripts called from GUI scripts
// Note to self, stop putting functionality in individual scripts, pull as much as possible into the include

// didn't define file extension on texture constants? No worries, just call this.
void SetGUITextureAddExtension(object oPlayer, string sScreenName, string sUIObjectName, string sTexture)
{
	SetGUITexture(oPlayer, sScreenName, sUIObjectName, sTexture + ".tga");
}

// sPosition is the XML name of the field.
// iSelected - either 1 selected or 0 not selected
// works only on game screen for the moment.
void GUI_CardsSetSelected(object oPC, string sPosition, int iSelected)
{
	if (iSelected == TRUE)
		SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sPosition + CARD_BORDER, CARD_BORDER_SELECTED);
	else
		SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sPosition + CARD_BORDER, CARD_BORDER_UNSELECTED);
}

// sPosition is XML position of the base object (auto appends the background string - as long as i've been consistent with naming)
// iPlayer - if 0 then blank background, if 1 then player 1s or 2 does player 2s.
// only works on game screen for the moment
void GUI_CardsSetBackgroundColour(object oPC, string sPosition, int iPlayer=0)
{
	string sBGColour;
	
	if (iPlayer == 1) sBGColour = CARD_BG_PLAYER1;
	else if (iPlayer == 2) sBGColour = CARD_BG_PLAYER2;
	else sBGColour = CARD_BG_PLAYER0;
	
	SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sPosition + CARD_BACKGROUND, sBGColour);
}

void GUI_CardsSetBackgroundColourAllPlayers(object oBoard, string sPosition, int iPlayer=0)
{
	string sBGColour;
	int iCount;
	object oPC;
	
	if (iPlayer == 1) sBGColour = CARD_BG_PLAYER1;
	else if (iPlayer == 2) sBGColour = CARD_BG_PLAYER2;
	else sBGColour = CARD_BG_PLAYER0;
	
	oPC = CardsGetPlayer(oBoard, CARD_PLAYER_1);
	GUI_CardsSetBackgroundColour(oPC, sPosition, iPlayer);
	oPC = CardsGetPlayer(oBoard, CARD_PLAYER_2);
	GUI_CardsSetBackgroundColour(oPC, sPosition, iPlayer);
	
	for (iCount=1; iCount <=10; iCount++)
	{
		oPC = CardsGetObserver(oBoard, iCount);
		if (GetIsObjectValid(oPC))
			GUI_CardsSetBackgroundColour(oPC, sPosition, iPlayer);
	}
}


// creates a placeable of the required type in the position specified
void CardsPlaceableDisplayCardInPosition(object oBoard, string sCardPos)
{
	int iOwner = GetLocalInt(oBoard, sCardPos + CARD_OWNER);
	string sTemplate;
	
	float x;
	float y;
	float z;
	object oCard;
	
	if (iOwner == 1) sTemplate = CARD_PLACEABLE_BLUE;
	else if (iOwner == 2) sTemplate = CARD_PLACEABLE_RED;
	else sTemplate = CARD_PLACEABLE_BACK;
	
	// this could all be made shorter by just deconstructing the string.
	if (sCardPos == CARD_P1_HAND_1) {x = CARDS_BLUE_ROW_X; y = CARDS_PLAYER_HAND_1_Y;}
	else if (sCardPos == CARD_P1_HAND_2) {x = CARDS_BLUE_ROW_X; y = CARDS_PLAYER_HAND_2_Y;}
	else if (sCardPos == CARD_P1_HAND_3) {x = CARDS_BLUE_ROW_X; y = CARDS_PLAYER_HAND_3_Y;}
	else if (sCardPos == CARD_P1_HAND_4) {x = CARDS_BLUE_ROW_X; y = CARDS_PLAYER_HAND_4_Y;}
	else if (sCardPos == CARD_P1_HAND_5) {x = CARDS_BLUE_ROW_X; y = CARDS_PLAYER_HAND_5_Y;}
	
	else if (sCardPos == CARD_P2_HAND_1) {x = CARDS_RED_ROW_X; y = CARDS_PLAYER_HAND_1_Y;}
	else if (sCardPos == CARD_P2_HAND_2) {x = CARDS_RED_ROW_X; y = CARDS_PLAYER_HAND_2_Y;}
	else if (sCardPos == CARD_P2_HAND_3) {x = CARDS_RED_ROW_X; y = CARDS_PLAYER_HAND_3_Y;}
	else if (sCardPos == CARD_P2_HAND_4) {x = CARDS_RED_ROW_X; y = CARDS_PLAYER_HAND_4_Y;}
	else if (sCardPos == CARD_P2_HAND_5) {x = CARDS_RED_ROW_X; y = CARDS_PLAYER_HAND_5_Y;}
	
	else if (sCardPos == BOARD_R1_C1) {x = CARDS_ROW1_X; y = CARDS_COL1_Y;}
	else if (sCardPos == BOARD_R1_C2) {x = CARDS_ROW1_X; y = CARDS_COL2_Y;}
	else if (sCardPos == BOARD_R1_C3) {x = CARDS_ROW1_X; y = CARDS_COL3_Y;}
	else if (sCardPos == BOARD_R2_C1) {x = CARDS_ROW2_X; y = CARDS_COL1_Y;}
	else if (sCardPos == BOARD_R2_C2) {x = CARDS_ROW2_X; y = CARDS_COL2_Y;}
	else if (sCardPos == BOARD_R2_C3) {x = CARDS_ROW2_X; y = CARDS_COL3_Y;}
	else if (sCardPos == BOARD_R3_C1) {x = CARDS_ROW3_X; y = CARDS_COL1_Y;}
	else if (sCardPos == BOARD_R3_C2) {x = CARDS_ROW3_X; y = CARDS_COL2_Y;}
	else if (sCardPos == BOARD_R3_C3) {x = CARDS_ROW3_X; y = CARDS_COL3_Y;}
	
	vector vTable = GetPosition(oBoard);
	
	x += vTable.x;
	y += vTable.y;
	z = vTable.z + CARDS_HEIGHT_Z;
	
	oCard = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, Location(GetArea(oBoard), Vector(x, y, z), CARDS_ROTATION), FALSE);
	SetLocalObject(oBoard, sCardPos + PLACEABLE, oCard);
}

// removes the specified placeable from its position
void CardsPlaceableRemoveCardFromPosition(object oBoard, string sCardPos)
{
	DestroyObject(GetLocalObject(oBoard, sCardPos + PLACEABLE), 0.0, FALSE);
	DeleteLocalObject(oBoard, sCardPos + PLACEABLE);
}

// oTarget is the PC whose screen needs modifying
// sScreen is the screen it is to be displayed on, and sPosPrefix/sPosSuffix are the string
// prefixes suffixes that may be being used in the XML beyond the base CARD_UP, CARD_DOWN etc
void CardsGUIClearCardInPosition(object oTarget, string sScreen, string sPosPrefix)
{
	SetGUITexture(oTarget, sScreen, sPosPrefix + CARD_BORDER, CARD_BLANK);
	SetGUITexture(oTarget, sScreen, sPosPrefix + CARD_BACKGROUND, CARD_BLANK);
	SetGUITexture(oTarget, sScreen, sPosPrefix + CARD_PICTURE, CARD_BLANK);

	SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_NAME, -1, "");
	SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_UP, -1, "");
	SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_DOWN, -1, "");
	SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_LEFT, -1, "");
	SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_RIGHT, -1, "");
}

// like the specific function but cycles through all in game including observers
void CardsGUIClearPlayedCardInPositionAllInGame(object oBoard, string sPosition)
{
	object oPC;
	int iCount;
	
	oPC = CardsGetPlayer(oBoard, 1);
	CardsGUIClearCardInPosition(oPC, CARD_SCREEN_GAME_SCENE, sPosition);
	oPC = CardsGetPlayer(oBoard, 2);
	CardsGUIClearCardInPosition(oPC, CARD_SCREEN_GAME_SCENE, sPosition);
	
	for (iCount=1; iCount <= CARD_MAX_OBSERVERS; iCount++)
	{
		oPC = CardsGetObserver(oBoard, iCount);
		CardsGUIClearCardInPosition(oPC, CARD_SCREEN_GAME_SCENE, sPosition);
	}
}

// Deck is the deck being used, iCardNum is the card from that deck
// sScreen is the screen it is to be displayed on, and sPosPrefix/sPosSuffix are the string
// prefixes suffixes that may be being used in the XML beyond the base CARD_UP, CARD_DOWN etc
// sFrame equals either - CARD_BG_PLAYER0 CARD_BG_PLAYER1 CARD_BG_PLAYER2
// depending on whether you want neutral background or tinted to show ownership.
// bhidden is used to hide the card from players
void CardsGUIDisplayCardInPositionFromDeck(object oTarget, object oDeck, int iCardNum, string sScreen, string sPosPrefix, int bHidden=FALSE, string sFrame=CARD_BG_PLAYER0)
{
	string sCardNum = IntToString(iCardNum);
	
	string sCardName = GetLocalString(oDeck, CARD_NAME + sCardNum);
	
	//SendMessageToPC(oTarget, "DEBUG: Selected card was named: " + sCardName);
	
	string sCardImage = GetLocalString(oDeck, CARD_PICTURE + sCardNum);
	string sUp = IntToString(GetLocalInt(oDeck, CARD_VALUE_UP + sCardNum));
	string sDown = IntToString(GetLocalInt(oDeck, CARD_VALUE_DOWN + sCardNum));
	string sLeft = IntToString(GetLocalInt(oDeck, CARD_VALUE_LEFT + sCardNum));
	string sRight = IntToString(GetLocalInt(oDeck, CARD_VALUE_RIGHT + sCardNum));
	
	SetGUITexture(oTarget, sScreen, sPosPrefix + CARD_BORDER, CARD_BORDER_UNSELECTED);
	SetGUITexture(oTarget, sScreen, sPosPrefix + CARD_BACKGROUND, sFrame);
	
	if (bHidden == TRUE)
		SetGUITexture(oTarget, sScreen, sPosPrefix + CARD_PICTURE, CARD_HIDDEN);
	else
	{
		SetGUITexture(oTarget, sScreen, sPosPrefix + CARD_PICTURE, sCardImage + ".tga");
		SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_NAME, -1, sCardName);
		SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_UP, -1, sUp);
		SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_DOWN, -1, sDown);
		SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_LEFT, -1, sLeft);
		SetGUIObjectText(oTarget, sScreen, sPosPrefix + CARD_VALUE_RIGHT, -1, sRight);
	}
}

// only works on game in progress screen
void CardsGUIDisplayCardInPositionFromBoard(object oPC, object oBoard, string sCardPosition, int bHidden=FALSE)
{
	string sFrame;
	
	int iCardNo = GetLocalInt(oBoard, sCardPosition);
	string sCardName = GetLocalString(oBoard, sCardPosition + CARD_NAME);
	string sCardImage = GetLocalString(oBoard, sCardPosition + CARD_PICTURE);
	string sUp = IntToString(GetLocalInt(oBoard, sCardPosition + CARD_VALUE_UP));
	string sDown = IntToString(GetLocalInt(oBoard, sCardPosition + CARD_VALUE_DOWN));
	string sLeft = IntToString(GetLocalInt(oBoard, sCardPosition + CARD_VALUE_LEFT));
	string sRight = IntToString(GetLocalInt(oBoard, sCardPosition + CARD_VALUE_RIGHT));
	
	int iOwner = GetLocalInt(oBoard, sCardPosition + CARD_OWNER);
	int iPos = CardsGetPlayerNumberFromBoard(oBoard, oPC);
	string sLocation = GetStringLeft(sCardPosition, 1); // gives us P if player hand or R if on board (due to RnCn format)
	
	if (iOwner == 1) sFrame = CARD_BG_PLAYER1;
	else if (iOwner == 2) sFrame = CARD_BG_PLAYER2;
	else sFrame = CARD_BG_PLAYER0;
	
	if (iCardNo > 0) // no card, don't display anything
	{
		if (sLocation == "R" || iOwner == iPos || bHidden == FALSE) // if on board, or owner of the card is the current player we are working on screen for, or if open rule is in effect
		{
			SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_BORDER, CARD_BORDER_UNSELECTED);
			SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_BACKGROUND, sFrame);
			SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_PICTURE, sCardImage + ".tga");
			SetGUIObjectText(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_NAME, -1, sCardName);
			SetGUIObjectText(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_VALUE_UP, -1, sUp);
			SetGUIObjectText(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_VALUE_DOWN, -1, sDown);
			SetGUIObjectText(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_VALUE_LEFT, -1, sLeft);
			SetGUIObjectText(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_VALUE_RIGHT, -1, sRight);
		}
		else // we make the card hidden
		{
			SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_BORDER, CARD_BORDER_UNSELECTED);
			SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sCardPosition + CARD_PICTURE, CARD_HIDDEN);
		}
	}
}

// like the specific function but cycles through all in game including observers
// however, we do not use the deck, we used stored values stored within the board object
// only used for the game screen
// bVisibleToAll will show all players the card face (for example, if open rule is being used and we are displaying a card in the hand
// otherwise it will only show the onwer of the card the face.
// this only will display cards as they are played anyway because the below function will display initial state...
// so we can take shortcuts, for example, no need to consider visibility
void CardsGUIDisplayPlayedCardInPositionAllInGame(object oBoard, string sPosition)
{
	object oPC;
	int iCount;
	
	oPC = CardsGetPlayer(oBoard, 1);
	CardsGUIDisplayCardInPositionFromBoard(oPC, oBoard, sPosition);
	oPC = CardsGetPlayer(oBoard, 2);
	CardsGUIDisplayCardInPositionFromBoard(oPC, oBoard, sPosition);
	
	for (iCount=1; iCount <= CARD_MAX_OBSERVERS; iCount++)
	{
		oPC = CardsGetObserver(oBoard, iCount);
		CardsGUIDisplayCardInPositionFromBoard(oPC, oBoard, sPosition);
	}
}

string CardsMakeRuleString(object oBoard)
{
	string sRules = "Rules Selected: ";
	if (CardsGetRule(oBoard, RULE_OPEN) == TRUE) sRules=sRules + "O";
	if (CardsGetRule(oBoard, RULE_RANDOM) == TRUE) sRules=sRules + "R";
	if (CardsGetRule(oBoard, RULE_SAME) == TRUE) sRules=sRules + "S";
	if (CardsGetRule(oBoard, RULE_PLUS) == TRUE) sRules=sRules + "P";
	if (CardsGetRule(oBoard, RULE_WALL) == TRUE) sRules=sRules + "W";
	
	if (sRules == "Rules Selected: ") sRules=sRules+ "None";
	return sRules;
}

// used to display the board to people as they join, also at start of game
// once viewing game, then only updates are shown
// we do not disable on this, we let script handle people clicking on things because later we may want to introduce things like sleight of hand checks
// this routine displays to a specific PC (observer) who may just be joining to watch midgame).
void GUI_Display_Card_Board_In_CurrentState(object oBoard, object oPC)
{
	// we need to know if we should display cards in hand as shown or not shown to all
	int iRuleOpen = CardsGetRule(oBoard, RULE_OPEN);
	// we also need to know who oPC is... are they a player or observer?
	// if 1, player 1, if 2, player 2, if 0 an observer
	int iPlayerType = CardsGetPlayerNumberFromBoard(oBoard, oPC);
	int bHidden;
	string sCardPos;
	int iPlayer; int iHandPos; int iRow; int iCol; // all used to construct the card positions
	
	DisplayGuiScreen(oPC, CARD_SCREEN_GAME_SCENE, FALSE, CARD_SCREEN_GAME_XML);
	
	for (iPlayer=1; iPlayer<=2; iPlayer++)
	{
		for (iHandPos=1; iHandPos<=5; iHandPos++)
		{
			if (iRuleOpen == TRUE)
				bHidden = FALSE;
			else
			{
				if (iPlayer == iPlayerType)
					bHidden = FALSE;
				else
					bHidden = TRUE;
			}
			sCardPos = CARD_P + IntToString(iPlayer) + "_" + IntToString(iHandPos);
			CardsGUIDisplayCardInPositionFromBoard(oPC, oBoard, sCardPos, bHidden);
		}
	}

	for (iCol=1; iCol<=3; iCol++)
	{
		for (iRow=1; iRow<=3; iRow++)
		{
			sCardPos = BOARD_ROW + IntToString(iRow) + BOARD_COL + IntToString(iCol);
			CardsGUIDisplayCardInPositionFromBoard(oPC, oBoard, sCardPos, FALSE);
		}
	}
	
	SetGUIObjectText(oPC, CARD_SCREEN_GAME_SCENE, "GAME_RULES", -1, CardsMakeRuleString(oBoard));
}


// shouldn't this just call the above function except with small change that opens screens to relevant players?
// maybe then just separate functions when new players join calling above function?
void GUI_Display_Initial_Card_Board_To_All(object oBoard)
{
	object oObserver;
	object oPC1;
	object oPC2;
	int iCount;
	string sCount;

	oPC1 = CardsGetPlayer(oBoard, 1);
	CloseGUIScreen(oPC1, CARD_SCREEN_SELECTION_SCENE);
	GUI_Display_Card_Board_In_CurrentState(oBoard, oPC1);
	oPC2 = CardsGetPlayer(oBoard, 2);
	CloseGUIScreen(oPC2, CARD_SCREEN_SELECTION_SCENE);
	GUI_Display_Card_Board_In_CurrentState(oBoard, oPC2);
	
	for (iCount=1;iCount<=10;iCount++)
	{
		oObserver = GetLocalObject(oBoard, CARD_OBSERVER + IntToString(iCount));
		CloseGUIScreen(oObserver, CARD_SCREEN_WAITING_SCENE);
		GUI_Display_Card_Board_In_CurrentState(oBoard, oObserver);
	}
	
	CardsGUISetPlayerNamesAllPlayers(oBoard, GetName(oPC1), GetName(oPC2));
	CardsGUIUpdateObserverList(oBoard);
	
	// display initial cards now...
	for (iCount=1; iCount<=5; iCount++)
	{
		sCount = IntToString(iCount);
		CardsPlaceableDisplayCardInPosition(oBoard, "P1_" + sCount);
		CardsPlaceableDisplayCardInPosition(oBoard, "P2_" + sCount);
	}
	
	
	// Randomize who goes first...
	if (d2() == 1)
		CardsChangeGameState(oBoard, GAME_STATE_GAME_IN_PROGRESS_TURN_P1);
	else
		CardsChangeGameState(oBoard, GAME_STATE_GAME_IN_PROGRESS_TURN_P2);
}

void CardsSelectionSetScrollOffset(object oPC, int iOffset)
{
	SetLocalInt(oPC, "CARDSGUIOFFSET", iOffset);
}

int CardsSelectionGetScrollOffset(object oPC)
{
	return GetLocalInt(oPC, "CARDSGUIOFFSET");
}

// used to calculate current "scroll" of deck and determine which buttons need disabling and enabling
// offset is the position of the first card
void CardsSelectionDisableScrollButtons(object oPC, object oDeck)
{
	int iOffset = CardsSelectionGetScrollOffset(oPC);
	int iDeckSize = CardsGetDeckSize(oDeck);
	
	if (iOffset < 2)
	{
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_LEFT1", TRUE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_LEFT2", TRUE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_LEFT3", TRUE);
	}
	else 
	{
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_LEFT1", FALSE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_LEFT2", FALSE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_LEFT3", FALSE);
	}
	
	if (iOffset > iDeckSize - 5)
	{
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_RIGHT1", TRUE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_RIGHT2", TRUE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_RIGHT3", TRUE);
	}
	else
	{
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_RIGHT1", FALSE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_RIGHT2", FALSE);
		SetGUIObjectDisabled(oPC, CARD_SCREEN_SELECTION_SCENE, "TT_BUTTON_RIGHT3", FALSE);
	}
}

void CardsSelectionDisplayDeckFromOffset(object oPC, object oDeck)
{
	int iCount;
	int iOffset = CardsSelectionGetScrollOffset(oPC);
	
	for (iCount=1; iCount<=5; iCount++)
	{
			CardsGUIDisplayCardInPositionFromDeck(oPC, oDeck, iOffset+iCount-1, CARD_SCREEN_SELECTION_SCENE, DECK + IntToString(iCount));
	}
}
void CardsDisplayCardSelectionScreen(object oBoard, object oPC, int iPos)
{
	DisplayGuiScreen(oPC, CARD_SCREEN_SELECTION_SCENE, FALSE, CARD_SCREEN_SELECTION_XML);
	object oDeck = GetPlayerDeck(oPC);
	//CardsGUIFillDeckListBox(oPC, oDeck, CARD_SCREEN_SELECTION_SCENE);
	// new functionality required to populate first 5 card positions...
	CardsSelectionSetScrollOffset(oPC, 1); // reset the counter
	CardsSelectionDisplayDeckFromOffset(oPC, oDeck);
	CardsSelectionDisableScrollButtons(oPC, oDeck);
}

// change from old version. Now takes new game state as parameter.
void CardsChangeGameState(object oBoard, int iNewGameState, int iExitCode=0)
{
	int iCurrentGameState = CardsGetGameState(oBoard);
	CardsSetGameState(oBoard, iNewGameState);
	
	//SendMessageToPC(GetFirstPC(), "DEBUG: Changing game state to " + IntToString(iNewGameState));
	// use these to check if game state matches
	object oPC1 = CardsGetPlayer(oBoard, 1);
	object oPC2 = CardsGetPlayer(oBoard, 2);
	string sPCName1 = CardsGetPlayerNameFromBoard(oBoard, 1);
	string sPCName2 = CardsGetPlayerNameFromBoard(oBoard, 2);
	int iPC1 = GetIsObjectValid(oPC1);
	int iPC2 = GetIsObjectValid(oPC2);
	object oReadyPC;
		
	if (iExitCode !=0)
	{
		CardsGameOver(oBoard, iExitCode);
	}
	
	// we need to add the checks for participants being too far here and against game state, see if
	// someone dropped without closing GUI or some other reason.
	
	else
	{
		switch(iNewGameState)
		{
			case GAME_STATE_NO_PLAYERS:
				// generally speaking, should never be set to this, but if we want to implement
				// a restart option this could be used to show observers waiting screen
				break;
			case GAME_STATE_1_PLAYER:
				// One player has joined, show them the waiting screen, also update any waiting observers to notify them that one player has joined
				{
					if (iPC1 == TRUE)
					{
						GUI_Display_Card_Board_Waiting(oBoard, oPC1);
					}
					if (iPC2 == TRUE) // this was an else condition... but something not working, so removing the else may highlight an issue
					{
						GUI_Display_Card_Board_Waiting(oBoard, oPC2);
					}
					
					CardsGUISetWaitingText(oBoard); // routine checks current state and updates accordingly.
			
					break;
				}
			case GAME_STATE_RULES_SELECTION:
				{
					// Second player has joined, notify observers that two players are in and selecting rules. Bring up rules selection screen for both players.
					CardsGUISetWaitingText(oBoard);
					// no idea which is the second player, but closing a screen that doesn't exist shouldn't matter anyway, but i think it will briefly display as they join.
					CloseGUIScreen(oPC1, CARD_SCREEN_WAITING_SCENE);
					CloseGUIScreen(oPC2, CARD_SCREEN_WAITING_SCENE);
					GUI_Display_Card_Game_Rule_Selection(oBoard);
					break;
				}
				// may need to adjust this
			case GAME_STATE_CARD_SELECTION_1:
				// Notify observers waiting. Bring up card selection screen IF random rule is not in use.  This state will never occur if random rule is selected
				// as it is bypassed by the rules selection screen function.
				{
					// no idea which is the second player, but closing a screen that doesn't exist shouldn't matter anyway, but i think it will briefly display as they join.
					CloseGUIScreen(oPC1, CARD_SCREEN_RULES_SCENE);
					CloseGUIScreen(oPC2, CARD_SCREEN_RULES_SCENE);
					CardsDisplayCardSelectionScreen(oBoard, oPC1, 1);
					CardsDisplayCardSelectionScreen(oBoard, oPC2, 2);
					CardsGUISetWaitingText(oBoard);
					break;
				}
			case GAME_STATE_CARD_SELECTION_2:
				{
					// find which player has completed their hand and show them waiting screen...

					if (GetLocalInt(oBoard, LAST_PLAYER_CARDS_SELECTED) == 1)
					{
						oReadyPC = oPC1;
					}
					else
					{
						oReadyPC = oPC2;
					}
					
					CloseGUIScreen(oReadyPC, CARD_SCREEN_SELECTION_SCENE);
					DisplayGuiScreen(oReadyPC, CARD_SCREEN_WAITING_SCENE, FALSE, CARD_SCREEN_WAITING_XML);
					CardsGUISetWaitingText(oBoard);
					break;
				}
			case GAME_STATE_GAME_STARTING:
				{
					// show game board to all players and observers
					// close all waiting screens and/or rules selection/card selection screens.
					if (CardsGetRule(oBoard, RULE_RANDOM) == TRUE)
					{
						CloseGUIScreen(oPC1, CARD_SCREEN_RULES_SCENE);
						CloseGUIScreen(oPC2, CARD_SCREEN_RULES_SCENE);
						CardsSelectRandomCards(oBoard);
					}
					else
					{
						CloseGUIScreen(oPC1, CARD_SCREEN_WAITING_SCENE);
						CloseGUIScreen(oPC2, CARD_SCREEN_WAITING_SCENE);
					}
					
					GUI_Display_Initial_Card_Board_To_All(oBoard);
					SetLocalInt(oBoard, SCORE_PLAYER1, 5);
					SetLocalInt(oBoard, SCORE_PLAYER2, 5);
					break;
				}
			
			case GAME_STATE_GAME_IN_PROGRESS_TURN_P1:
				CardsGUISetGameBoardTitleAllPlayers(oBoard, GetFirstName(oPC1) + GAME_BOARD_STATUS_PLAYERS_TURN);
				break;
			case GAME_STATE_GAME_IN_PROGRESS_TURN_P2:
				CardsGUISetGameBoardTitleAllPlayers(oBoard, GetFirstName(oPC2) + GAME_BOARD_STATUS_PLAYERS_TURN);
				break;
			case GAME_STATE_GAME_IN_PROGRESS_PROCESSING_RULES:
				CardsGUISetGameBoardTitleAllPlayers(oBoard, GAME_BOARD_STATUS_PROCESSING_RULES);
				break;
				
			case GAME_STATE_GAME_OVER: // and actually duplicating the game over functionality here... complete mess, i should do something about it.
				// Change status of game board to show game over, winner, final result.
				// possibly we do nothing here, expect for wait for players/observers to close their previous game screens.
				// certainly some sort of message or on screen notification to all as to who has won.
				CardsGameOver(oBoard, LEAVE_REASON_GAME_FINISHED);
				break;
			default:
				// problem if this occurs
				break;
		}
	}
}

void CardsGUIDisplaySingleCard(object oTarget, object oCard)
{
	string sCardName = GetLocalString(oCard, CARD_NAME);
	string sCardImage = GetLocalString(oCard, CARD_PICTURE);
	int iUp = GetLocalInt(oCard, CARD_VALUE_UP);
	int iDown = GetLocalInt(oCard, CARD_VALUE_DOWN);
	int iLeft = GetLocalInt(oCard, CARD_VALUE_LEFT);
	int iRight = GetLocalInt(oCard, CARD_VALUE_RIGHT);
	
	DisplayGuiScreen(oTarget, "TT_GUI_SINGLE_CARD", FALSE, "cardssingle.xml");

	SetGUITexture(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_BORDER, CARD_BORDER_UNSELECTED);
	SetGUITexture(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_BACKGROUND, CARD_BG_PLAYER0);
	SetGUITexture(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_PICTURE, sCardImage + ".tga");

	SetGUIObjectText(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_NAME, -1, sCardName);
	SetGUIObjectText(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_VALUE_UP, -1, IntToString(iUp));
	SetGUIObjectText(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_VALUE_DOWN, -1, IntToString(iDown));
	SetGUIObjectText(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_VALUE_LEFT, -1, IntToString(iLeft));
	SetGUIObjectText(oTarget, "TT_GUI_SINGLE_CARD", "CARD" + CARD_VALUE_RIGHT, -1, IntToString(iRight));
}

void CardsGUIFillDeckListBox(object oPC, object oDeck, string sScreen)
{
	int iDeckSize = CardsGetDeckSize(oDeck);
	int iCount;
	
	string sCardName;
	string sCardImage;
	string sUp;
	string sDown;
	string sLeft;
	string sRight;
	string sCount;
	
	for (iCount = 1; iCount <= iDeckSize; iCount++)
	{
		sCount = IntToString(iCount);
		sCardName = GetLocalString(oDeck, CARD_NAME + sCount);
		sCardImage = GetLocalString(oDeck, CARD_PICTURE + sCount);
		sUp = IntToString(GetLocalInt(oDeck, CARD_VALUE_UP + sCount));
		sDown = IntToString(GetLocalInt(oDeck, CARD_VALUE_DOWN + sCount));
		sLeft = IntToString(GetLocalInt(oDeck, CARD_VALUE_LEFT + sCount));
		sRight = IntToString(GetLocalInt(oDeck, CARD_VALUE_RIGHT + sCount));
	
		AddListBoxRow(oPC, sScreen, "TT_LIST_BOX", sCount, 
		"CARD" + CARD_NAME + "=" + sCardName + 
		";CARD" + CARD_VALUE_UP + "=" + sUp +
		";CARD" + CARD_VALUE_DOWN + "=" + sDown +
		";CARD" + CARD_VALUE_LEFT + "=" + sLeft +
		";CARD" + CARD_VALUE_RIGHT + "=" + sRight,
		"CARD" + CARD_BORDER + "=" + CARD_BORDER_UNSELECTED +
		";CARD" + CARD_BACKGROUND + "=" + CARD_BG_PLAYER0 +
		";CARD" + CARD_PICTURE + "=" + sCardImage + ".tga","", "");
	}
}

// GUI for viewing cards.
void CardsGUIViewCards(object oPC, object oDeck)
{
	int iDeckSize = CardsGetDeckSize(oDeck);
	
	if (iDeckSize < 1)
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "The deck has no cards in it!");
		return;
	}
	// display GUI then fill list box with card entries.
	DisplayGuiScreen(oPC, CARD_SCREEN_DECK_SCENE, FALSE, "cardsviewdeck.xml");
	
	CardsGUIFillDeckListBox(oPC, oDeck, CARD_SCREEN_DECK_SCENE);
}

// sValue is CARD_VALUE_UP etc
int CardsGetCardOnBoardValueFromPosition(object oBoard, string sPosition, string sValue)
{
	return GetLocalInt(oBoard, sPosition + sValue);
}

int CardsGetCardOnBoardOwnerFromPosition(object oBoard, string sPosition)
{
	return GetLocalInt(oBoard, sPosition + CARD_OWNER); // if sPosition is not for a valid var then it will return 0. Possibly inefficient as GetLocalInt will have to search through all vars.
}

void CardsToggleCardOwner(object oBoard, string sPosition)
{
	int iOwner = GetLocalInt(oBoard, sPosition + CARD_OWNER);
	if (iOwner == 1) iOwner = 2;
	else iOwner = 1;
	
	//CardsSendMessageToPlayers(oBoard, "DEBUG: Setting owner of card in position " + sPosition + " to " + IntToString(iOwner));
	SetLocalInt(oBoard, sPosition + CARD_OWNER, iOwner);
}

int CardsGetIterationFlipsMax(object oBoard)
{
	return GetLocalInt(oBoard, "ITERATIONFLIPSMAX");
}

void CardsResetIterationFlipsMax(object oBoard)
{
	SetLocalInt(oBoard, "ITERATIONFLIPSMAX", 0);
}

void CardsSetIterationFlipsMax(object oBoard, int iIteration)
{
	//CardsSendMessageToPlayers(oBoard, "DEBUG: Setting iterations to " + IntToString(iIteration));
	if (iIteration > CardsGetIterationFlipsMax(oBoard))
		SetLocalInt(oBoard, "ITERATIONFLIPSMAX", iIteration);
}

// iIterations is the level you want to go down to.
float CardsGetTotalDelay(object oBoard)
{	
	//CardsSendMessageToPlayers(oBoard, "DEBUG: Returning delay of iterations...");
	return IntToFloat(CardsGetIterationFlipsMax(oBoard)) * CARD_BG_FLIP_TOTAL_TIME;
}

void CardsUpdateScores(object oBoard)
{
	int iRow;
	int iCol;
	int iCount;
	int iTotalP1;
	int iTotalP2;
	string sTemp;
	int iTemp;
	
	for (iCount=1; iCount <= 5; iCount++)
	{
		sTemp = IntToString(iCount);
		if (GetLocalInt(oBoard, "P1_" + sTemp) > 0) iTotalP1++;
		if (GetLocalInt(oBoard, "P2_" + sTemp) > 0) iTotalP2++;
	}
	
	for (iCol=1; iCol<=3; iCol++)
	{
		for (iRow=1; iRow<=3; iRow++)
		{
			iTemp = GetLocalInt(oBoard, "R" + IntToString(iRow) + "C" + IntToString(iCol) + CARD_OWNER);
			if (iTemp == 1) iTotalP1++;
			else if (iTemp == 2) iTotalP2++;
			// otherwise its 0 and no card there.
		}
	}
	
	CardsSetPlayerScores(oBoard, iTotalP1, iTotalP2);
	CardsGUISetPlayerScoresAllPlayers(oBoard, iTotalP1, iTotalP2);
}

// we don't need to worry about local object vars, the functions called handle those.
void CardsFlipPlaceableCard(object oBoard, string sPosition)
{
	CardsPlaceableRemoveCardFromPosition(oBoard, sPosition);
	CardsPlaceableDisplayCardInPosition(oBoard, sPosition);
}
// up to 4 cards can be flipped with a single placement, pass "" for that card to not be touched
// the values are their positions.
// return value is the time taken for the flipping (flashing background)
// we do this simultaneously on each pass so that we do not add extra time flipping each card separately if they should be done at same time.
void CardsFlipCards(object oBoard, string sCardUp, string sCardDown, string sCardLeft, string sCardRight, int iIteration)
{
	// set vars, flip backgrounds, etc
	float fDelayTotal;
	float fDelayFlip;
	
	int iPlayer;
	int iCount;
	int bFlipHappens = FALSE;
	
	iPlayer = CardsGetLastCardPlayedOwner(oBoard);

	if (sCardUp != "")
	{
		CardsToggleCardOwner(oBoard, sCardUp);
		bFlipHappens = TRUE;
	}
	if (sCardDown != "")
	{
		CardsToggleCardOwner(oBoard, sCardDown);
		bFlipHappens = TRUE;
	}
	if (sCardLeft != "")
	{
		CardsToggleCardOwner(oBoard, sCardLeft);
		bFlipHappens = TRUE;
	}	
	if (sCardRight != "")
	{
		CardsToggleCardOwner(oBoard, sCardRight);
		bFlipHappens = TRUE;
	}
	//CardsSendMessageToPlayers(oBoard, "DEBUG: Flipping cards - shouldn't be doing this if no cards to be turned");
	if (bFlipHappens == TRUE) // we now have a new iteration
	{
		//CardsSendMessageToPlayers(oBoard, "DEBUG: Flipping cards - Thinks a card has been flipped");

		CardsSetIterationFlipsMax(oBoard, iIteration);
		fDelayTotal = IntToFloat(iIteration-1) * CARD_BG_FLIP_TOTAL_TIME; // -1 so that on first iteration there is no delay to the start of the flip, and if second iteration then starts after the first flip is complete
	
		for(iCount = 1; iCount <= CARD_BG_FLIP_NUMBER; iCount++)
		{
			fDelayFlip = fDelayTotal + CARD_BG_FLIP_TIME * IntToFloat(iCount);
			
			if (sCardUp != "") 
			{
				DelayCommand(fDelayFlip, GUI_CardsSetBackgroundColourAllPlayers(oBoard, sCardUp, iPlayer));
			}
			if (sCardDown != "") 
			{
				DelayCommand(fDelayFlip, GUI_CardsSetBackgroundColourAllPlayers(oBoard, sCardDown, iPlayer));
			}
			if (sCardLeft != "") 
			{
				DelayCommand(fDelayFlip, GUI_CardsSetBackgroundColourAllPlayers(oBoard, sCardLeft, iPlayer));
			}
			if (sCardRight != "") 
			{
				DelayCommand(fDelayFlip, GUI_CardsSetBackgroundColourAllPlayers(oBoard, sCardRight, iPlayer));
			}
			if (iPlayer == 1) iPlayer = 2; else iPlayer = 1; // so just toggle between the two. Done after so first pass changes correctly
		}
	
		// fDelayFlip should be full delay time of the flip by this point for the iteration.
		if (sCardUp != "") 
		{
			DelayCommand(fDelayFlip, CardsFlipPlaceableCard(oBoard, sCardUp));
		}
		if (sCardDown != "") 
		{
			DelayCommand(fDelayFlip, CardsFlipPlaceableCard(oBoard, sCardDown));
		}
		if (sCardLeft != "") 
		{
			DelayCommand(fDelayFlip, CardsFlipPlaceableCard(oBoard, sCardLeft));
		}
		if (sCardRight != "") 
		{
			DelayCommand(fDelayFlip, CardsFlipPlaceableCard(oBoard, sCardRight));
		}
		
		DelayCommand(fDelayFlip, CardsUpdateScores(oBoard));
	}
}

// returns TRUE if the card should be flipped, otherwise FALSE
// iCardOwner if the owner of the played card.
// note this function does not check ownership of the target, if that is required, do it before calling this.
int CardsDetermineIfCardPlayedBeatsTarget(object oBoard, int iCardOwner, string sCardPlayed, string sCardPlayedValue, string sCardTarget, string sCardTargetValue)
{
	int iRet = FALSE;
	
	if (sCardTarget != "")
	{
		if (CardsGetCardOnBoardValueFromPosition(oBoard, sCardPlayed, sCardPlayedValue) > CardsGetCardOnBoardValueFromPosition(oBoard, sCardTarget, sCardTargetValue))
		{
			iRet = TRUE;
		}
	}
	return iRet;
}

// sPosition can be LEFT RIGHT or CENTER - this is to allow both PLUS and SAME to display activating at same time... rarely going to happen, but possible.
void CardsGUIDisplayRuleInEffectTextToAllPlayers(object oBoard, string sRule, string sGUIPosition="CENTER")
{
	string sText;
	object oPC;
	int iCount;
	
	sGUIPosition = "RULE_ACTIVATE_" + sGUIPosition;
	
	if (sRule == RULE_PLUS) sText = CARDS_TEXT_PLUS;
	else if (sRule == RULE_SAME) sText = CARDS_TEXT_SAME;
	else if (sRule == RULE_COMBO) sText = CARDS_TEXT_COMBO;
	else if (sRule == RULE_WALL) sText = CARDS_TEXT_WALL;
	
	oPC = CardsGetPlayer(oBoard, 1);
	SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sGUIPosition, sText);
	DelayCommand(CARD_RULE_DISPLAY_TIME, SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sGUIPosition, CARDS_TEXT_BLANK));
	
	oPC = CardsGetPlayer(oBoard, 2);
	SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sGUIPosition, sText);
	DelayCommand(CARD_RULE_DISPLAY_TIME, SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sGUIPosition, CARDS_TEXT_BLANK));
	
	for (iCount=1; iCount <= CARD_MAX_OBSERVERS; iCount++)
	{
		oPC = CardsGetObserver(oBoard, iCount);
		if (GetIsObjectValid(oPC))
		{
			SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sGUIPosition, sText);
			DelayCommand(CARD_RULE_DISPLAY_TIME, SetGUITexture(oPC, CARD_SCREEN_GAME_SCENE, sGUIPosition, CARDS_TEXT_BLANK));
		}
	}
}

void CardsDoRules(object oBoard, string sCardPlayed, int iIteration=1)
{
	int iWallRule;
	int iSameRule;
	int iPlusRule;
	int iCardOwner = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardPlayed);
	int iCardOpponent;
	
	if (iCardOwner == 1) iCardOpponent=2;
	else iCardOpponent = 1; // reverse because flipping starts by going to the other players colour
	
	float fDelay; // cumulative delay from processing rules.
	string sCardUpPos;
	string sCardDownPos;
	string sCardLeftPos;
	string sCardRightPos;
	string sCardPlayedRow = GetSubString(sCardPlayed, 1, 1);
	string sCardPlayedCol = GetSubString(sCardPlayed, 3, 1);
	int iCardPlayedRow = StringToInt(sCardPlayedRow);
	int iCardPlayedCol = StringToInt(sCardPlayedCol);
	
	int iValueLeft;
	int iValueRight;
	int iValueUp;
	int iValueDown;
	int iOwnerLeft;
	int iOwnerRight;
	int iOwnerUp;
	int iOwnerDown;
	
	int iRulePlusActivated;
	int iRuleSameActivated;
	int iRulePlusWallActivated;
	int iRuleSameWallActivated;
	
	if (iIteration == 1)
	{
		iWallRule = CardsGetRule(oBoard, RULE_WALL);
		iSameRule = CardsGetRule(oBoard, RULE_SAME);
		iPlusRule = CardsGetRule(oBoard, RULE_PLUS);
	}
	
	// gets the positions of neghbouting cards, otherwise they will remain as ""
	if (iCardPlayedRow != 1) sCardUpPos = BOARD_ROW + IntToString(iCardPlayedRow - 1) + BOARD_COL + sCardPlayedCol;
	if (iCardPlayedRow != 3) sCardDownPos = BOARD_ROW + IntToString(iCardPlayedRow + 1) + BOARD_COL + sCardPlayedCol;
	if (iCardPlayedCol != 1) sCardLeftPos = BOARD_ROW + sCardPlayedRow + BOARD_COL + IntToString(iCardPlayedCol - 1);
	if (iCardPlayedCol != 3) sCardRightPos = BOARD_ROW + sCardPlayedRow + BOARD_COL + IntToString(iCardPlayedCol + 1);

	int iCardPlayedValueUp = CardsGetCardOnBoardValueFromPosition(oBoard, sCardPlayed, CARD_VALUE_UP);
	int iCardPlayedValueDown = CardsGetCardOnBoardValueFromPosition(oBoard, sCardPlayed, CARD_VALUE_DOWN);
	int iCardPlayedValueLeft = CardsGetCardOnBoardValueFromPosition(oBoard, sCardPlayed, CARD_VALUE_LEFT);
	int iCardPlayedValueRight = CardsGetCardOnBoardValueFromPosition(oBoard, sCardPlayed, CARD_VALUE_RIGHT);
	
	//CardsSendMessageToPlayers(oBoard, "DEBUG: Iteration="+IntToString(iIteration)+" RuleSame="+IntToString(iSameRule), TRUE, TRUE);
	
	// first thing is, see if combos are possible, and then allow recursion after combo moves (same, plus).
	if (iIteration == 1 && (iSameRule == TRUE || iPlusRule == TRUE)) // only for wall, same, plus anyway
	{
		// do same and plus rules - remember they can occur in parralel
		// any cards they flip need to invoke cardsdorules with delay for the current iteration added
		// remember, wall = 10 check for walls
		// same works when values on two or more touching cards equal played card
		// plus works when values on two or more touching cards add up to the same, by this it means the sum of a value on your card with the touching card equals that on other card
		// in all cases, 1 card must be an opponent card for it to work, but additional cards do not need to be, but as they do not turn, they do not spawn combos.
		// remember graphic/text for same/plus/combo activation, big text, in the center. Make sure people understand why it happening.
		
		// consider implementing sudden death, instead of game finishing, place all cards held by the player back to hand... this could result in players using opponents cards for
		// until the match is played out.
		
		// first up, let's see which sides actually have cards touching, and store their touching values and ownership.
		
		// temp values for holding positions and stuff
		string sTempLeft;
		string sTempRight;
		string sTempUp;
		string sTempDown;
		int iCountMatches;
		int iCountOpponentMatches;
		
		if (iSameRule == TRUE)
		{
			//CardsSendMessageToPlayers(oBoard, "Processing Same Rule");
			// Get the left value if exists - otherwise it will be zero.
			if (iCardPlayedCol == 1 && iWallRule == TRUE)
			{
				iValueLeft = 10; // because wall is always 10.
				iOwnerLeft = iCardOwner;
			}
			else if (iCardPlayedCol != 1)
			{
				iValueLeft = CardsGetCardOnBoardValueFromPosition(oBoard, sCardLeftPos, CARD_VALUE_RIGHT);
				iOwnerLeft = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardLeftPos);
			}
			// get right
			if (iCardPlayedCol == 3 && iWallRule == TRUE)
			{
				iValueRight = 10; // because wall is always 10.
				iOwnerRight = iCardOwner;
			}
			else if (iCardPlayedCol != 3)
			{
				iValueRight = CardsGetCardOnBoardValueFromPosition(oBoard, sCardRightPos, CARD_VALUE_LEFT);
				iOwnerRight = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardRightPos);
			}
			// get up
			if (iCardPlayedRow == 1 && iWallRule == TRUE)
			{
				iValueUp = 10; // because wall is always 10.
				iOwnerUp = iCardOwner;
			}
			else if (iCardPlayedRow != 1)
			{
				iValueUp = CardsGetCardOnBoardValueFromPosition(oBoard, sCardUpPos, CARD_VALUE_DOWN);
				iOwnerUp = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardUpPos);
			}
			// get down
			if (iCardPlayedRow == 3 && iWallRule == TRUE)
			{
				iValueDown = 10; // because wall is always 10.
				iOwnerDown = iCardOwner;
			}
			else if (iCardPlayedRow != 3)
			{
				iValueDown = CardsGetCardOnBoardValueFromPosition(oBoard, sCardDownPos, CARD_VALUE_UP);
				iOwnerDown = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardDownPos);
			}
		
			// now let's look for two or more matching values
			if (iCardPlayedValueUp == iValueUp && iValueUp != 0) // to also be sure there is a card there
			{
				iCountMatches++;
				if (iCardPlayedRow == 1) iRuleSameWallActivated = TRUE; // possibly, Same still has to activate
				if (iOwnerUp == iCardOpponent) 
				{
					iCountOpponentMatches++;
					sTempUp = sCardUpPos; // because this card may be passed to the flip routine for flipping, otherwise "" will be passed, providing the same rule should activate.
				}
			}
			if (iCardPlayedValueDown == iValueDown && iValueDown != 0)
			{
				iCountMatches++;
				if (iCardPlayedRow == 3) iRuleSameWallActivated = TRUE;
				if (iOwnerDown == iCardOpponent) 
				{
					iCountOpponentMatches++;
					sTempDown = sCardDownPos; // because this card may be passed to the flip routine for flipping, otherwise "" will be passed, providing the same rule should activate.
				}
			}
			if (iCardPlayedValueLeft == iValueLeft && iValueLeft != 0)
			{
				iCountMatches++;
				if (iCardPlayedCol == 1) iRuleSameWallActivated = TRUE;
				if (iOwnerLeft == iCardOpponent) 
				{
					iCountOpponentMatches++;
					sTempLeft = sCardLeftPos; // because this card may be passed to the flip routine for flipping, otherwise "" will be passed, providing the same rule should activate.
				}
			}
			if (iCardPlayedValueRight == iValueRight && iValueRight != 0)
			{
				iCountMatches++;
				if (iCardPlayedCol == 3) iRuleSameWallActivated = TRUE;
				if (iOwnerRight == iCardOpponent) 
				{
					iCountOpponentMatches++;
					sTempRight = sCardRightPos; // because this card may be passed to the flip routine for flipping, otherwise "" will be passed, providing the same rule should activate.
				}
			}
			//CardsSendMessageToPlayers(oBoard, "DEBUG: Up=" + sTempUp + " Down="+sTempDown+ " Left=" + sTempLeft+" Right="+sTempRight+ "Matches="+IntToString(iCountMatches)+" Opponent Matches="+IntToString(iCountOpponentMatches));
			//CardsSendMessageToPlayers(oBoard, "DEBUG: iOwnerUp=" + IntToString(iOwnerUp) + " iOwnerDown="+IntToString(iOwnerDown)+ " iOwnerLeft=" + IntToString(iOwnerLeft)+" iOwnerRight="+IntToString(iOwnerRight));
			
			if (iCountMatches > 1 && iCountOpponentMatches > 0) iRuleSameActivated = TRUE;
			
			if (iRuleSameActivated == TRUE)
			{
				//CardsSendMessageToPlayers(oBoard, "DEBUG: Flipping cards thanks to same rule...");
				CardsFlipCards(oBoard, sTempUp, sTempDown, sTempLeft, sTempRight, iIteration);
			}
		}
		
		// reset the temp vars!
		sTempLeft="";
		sTempRight="";
		sTempUp="";
		sTempDown="";
		iCountMatches=0;
		iCountOpponentMatches=0;
		iValueUp=0;
		iValueDown=0;
		iValueLeft=0;
		iValueRight=0;
		iOwnerUp=0;
		iOwnerDown=0;
		iOwnerLeft=0;
		iOwnerRight=0;
		
		if (iPlusRule == TRUE)
		{
			//CardsSendMessageToPlayers(oBoard, "DEBUG: Processing PLUS rule!");
			
			// got to get the owner again because it might have changed if same rule already ran...
			// Get the left value if exists - otherwise it will be zero.
			if (iCardPlayedCol == 1 && iWallRule == TRUE)
			{
				iOwnerLeft = iCardOwner;
				iValueLeft = 10;
			}
			else
			{
				iOwnerLeft = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardLeftPos);
				iValueLeft = CardsGetCardOnBoardValueFromPosition(oBoard, sCardLeftPos, CARD_VALUE_RIGHT);
			}
			// get right
			if (iCardPlayedCol == 3 && iWallRule == TRUE)
			{
				iOwnerRight = iCardOwner;
				iValueRight = 10;
			}
			else
			{
				iOwnerRight = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardRightPos);
				iValueRight = CardsGetCardOnBoardValueFromPosition(oBoard, sCardRightPos, CARD_VALUE_LEFT);
			}
			// get up
			if (iCardPlayedRow == 1 && iWallRule == TRUE)
			{
				iOwnerUp = iCardOwner;
				iValueUp = 10;
			}
			else
			{
				iOwnerUp = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardUpPos);
				iValueUp = CardsGetCardOnBoardValueFromPosition(oBoard, sCardUpPos, CARD_VALUE_DOWN);
			}
			// get down
			if (iCardPlayedRow == 3 && iWallRule == TRUE)
			{
				iOwnerDown = iCardOwner;
				iValueDown = 10;
			}
			else
			{
				iOwnerDown = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardDownPos);
				iValueDown = CardsGetCardOnBoardValueFromPosition(oBoard, sCardDownPos, CARD_VALUE_UP);
			}

			// now figure out if Plus should activate... a little trickier since we need to check every side against every side, although we can shortcut on sides with no cards.
			iValueUp += iCardPlayedValueUp;
			iValueDown += iCardPlayedValueDown;
			iValueLeft += iCardPlayedValueLeft;
			iValueRight += iCardPlayedValueRight;
			//CardsSendMessageToPlayers(oBoard, "DEBUG: iValueUp=" + IntToString(iValueUp) + " iValueDown="+IntToString(iValueDown)+ " iValueLeft=" + IntToString(iValueLeft)+" iValueRight="+IntToString(iValueRight));
			// so now we have 4 totals for each side... do any of them match? And remember that we could have multiple matches and rare case, two sets of matches. 6 possible combinations.
			
			if (iValueUp == iValueDown && (iOwnerUp == iCardOpponent || iOwnerDown == iCardOpponent))
			{
				if (iOwnerUp == iCardOpponent) sTempUp = sCardUpPos;
				if (iOwnerDown == iCardOpponent) sTempDown = sCardDownPos;
				iRulePlusActivated = TRUE;
				if (iCardPlayedRow == 1 || iCardPlayedRow == 3) iRulePlusWallActivated = TRUE;
			}
			if (iValueUp == iValueLeft && (iOwnerUp == iCardOpponent || iOwnerLeft == iCardOpponent))
			{
				if (iOwnerUp == iCardOpponent) sTempUp = sCardUpPos;
				if (iOwnerLeft == iCardOpponent) sTempLeft = sCardLeftPos;
				iRulePlusActivated = TRUE;
				if (iCardPlayedRow == 1 || iCardPlayedCol == 1) iRulePlusWallActivated = TRUE;
			}
			if (iValueUp == iValueRight && (iOwnerUp == iCardOpponent || iOwnerRight == iCardOpponent))
			{
				if (iOwnerUp == iCardOpponent) sTempUp = sCardUpPos;
				if (iOwnerRight == iCardOpponent) sTempRight = sCardRightPos;
				iRulePlusActivated = TRUE;
				if (iCardPlayedRow == 1 || iCardPlayedCol == 3) iRulePlusWallActivated = TRUE;
			}
			if (iValueLeft == iValueRight && (iOwnerLeft == iCardOpponent || iOwnerRight == iCardOpponent))
			{
				if (iOwnerLeft == iCardOpponent) sTempLeft = sCardLeftPos;
				if (iOwnerRight == iCardOpponent) sTempRight = sCardRightPos;
				iRulePlusActivated = TRUE;
				if (iCardPlayedCol == 1 || iCardPlayedCol == 3) iRulePlusWallActivated = TRUE;
			}
			if (iValueLeft == iValueDown && (iOwnerLeft == iCardOpponent || iOwnerDown == iCardOpponent))
			{
				if (iOwnerLeft == iCardOpponent) sTempLeft = sCardLeftPos;
				if (iOwnerDown == iCardOpponent) sTempDown = sCardDownPos;
				iRulePlusActivated = TRUE;
				if (iCardPlayedCol == 1 || iCardPlayedRow == 3) iRulePlusWallActivated = TRUE;
			}
			if (iValueRight == iValueDown && (iOwnerRight == iCardOpponent || iOwnerDown == iCardOpponent))
			{
				if (iOwnerRight == iCardOpponent) sTempRight = sCardRightPos;
				if (iOwnerDown == iCardOpponent) sTempDown = sCardDownPos;
				iRulePlusActivated = TRUE;
				if (iCardPlayedRow == 3 || iCardPlayedCol == 3) iRulePlusWallActivated = TRUE;
			}
			
			//CardsSendMessageToPlayers(oBoard, "DEBUG: Up=" + sTempUp + " Down="+sTempDown+ " Left=" + sTempLeft+" Right="+sTempRight+ "Plus Activated?="+IntToString(iRulePlusActivated));
			//CardsSendMessageToPlayers(oBoard, "DEBUG: iOwnerUp=" + IntToString(iOwnerUp) + " iOwnerDown="+IntToString(iOwnerDown)+ " iOwnerLeft=" + IntToString(iOwnerLeft)+" iOwnerRight="+IntToString(iOwnerRight));
						
			if (iRulePlusActivated == TRUE) 
			{
				CardsFlipCards(oBoard, sTempUp, sTempDown, sTempLeft, sTempRight, iIteration);
			}
		}
		
		if (iRulePlusActivated == TRUE && iRuleSameActivated == TRUE && 
			(iRulePlusWallActivated == TRUE || iRuleSameWallActivated == TRUE))
		{
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_PLUS, "LEFT");
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_SAME, "CENTER");
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_WALL, "RIGHT");
		}
		else if (iRulePlusActivated == TRUE && iRuleSameActivated == TRUE)
		{
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_PLUS, "LEFT");
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_SAME, "RIGHT");
		}
		else if (iRulePlusActivated == TRUE && iRulePlusWallActivated == TRUE)
		{
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_PLUS, "LEFT");
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_WALL, "RIGHT");
		}
		else if (iRulePlusActivated == TRUE)
		{
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_PLUS, "CENTER");
		}
		else if (iRuleSameActivated == TRUE && iRuleSameWallActivated == TRUE)
		{
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_SAME, "LEFT");
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_WALL, "RIGHT");
		}
		else if (iRuleSameActivated == TRUE)
		{
			CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_SAME, "CENTER");
		}
	}
	
	// and now process any touching cards in regular way
	// we check the card exists and that it doesn't belong to the owner of the current card.
	
	// this now would happen after returning from any same or plus processing of dorules as well as on first iteration....
	// we would want to do this last, after any same or plus processing... and it all needs to be delayed by whatever delay we already have.... or we do it at the same time as the plus/same
	
	// for the moment, let's keep it simple - even if plus/same activates, we also flip any additional cards that should be flipped, it will still be processed after the plus/same so
	// no worries about effect - as we are not delaying any ownership transfer during the plus same - only texture flipping is delayed.
	
	// third check on ownership, since in principle it could have changed if same or plus rule ran.
	iOwnerUp = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardUpPos);
	iOwnerDown = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardDownPos);
	iOwnerLeft = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardLeftPos);
	iOwnerRight = CardsGetCardOnBoardOwnerFromPosition(oBoard, sCardRightPos);
	
	object oPC = CardsGetPlayer(oBoard, iCardOwner);
	
	//SendMessageToPC(oPC, "<c=green>DEBUG: Cards Pos before determination: Up = [" + sCardUpPos + "] Down = [" + sCardDownPos + "] Left = [" + sCardLeftPos + "] Right = [" + sCardRightPos + "]");
	//CardsSendMessageToPlayers(oBoard, "<c=red>DEBUG: iOwnerUp="+IntToString(iOwnerUp)+" iOwnerDown="+IntToString(iOwnerDown)+" iOwnerLeft="+IntToString(iOwnerLeft)+" iOwnerRight="+IntToString(iOwnerRight), TRUE, TRUE);

	if (iOwnerUp == iCardOpponent)
	{
		if (!CardsDetermineIfCardPlayedBeatsTarget(oBoard, iCardOwner, sCardPlayed, CARD_VALUE_UP, sCardUpPos, CARD_VALUE_DOWN))
			sCardUpPos = "";
	}
	else
	{
		sCardUpPos = "";
	}
	if (iOwnerDown == iCardOpponent)
	{
		if (!CardsDetermineIfCardPlayedBeatsTarget(oBoard, iCardOwner, sCardPlayed, CARD_VALUE_DOWN, sCardDownPos, CARD_VALUE_UP))
			sCardDownPos = "";
	}
	else
	{
		sCardDownPos = "";
	}
	if (iOwnerLeft == iCardOpponent)
	{
		if (!CardsDetermineIfCardPlayedBeatsTarget(oBoard, iCardOwner, sCardPlayed, CARD_VALUE_LEFT, sCardLeftPos, CARD_VALUE_RIGHT))
			sCardLeftPos = "";
	}
	else
	{
		sCardLeftPos = "";
	}
	if (iOwnerRight == iCardOpponent)
	{
		if (!CardsDetermineIfCardPlayedBeatsTarget(oBoard, iCardOwner, sCardPlayed, CARD_VALUE_RIGHT, sCardRightPos, CARD_VALUE_LEFT))
			sCardRightPos = "";
	}
	else
	{
		sCardRightPos = "";
	}
	
	//SendMessageToPC(oPC, "<c=green>DEBUG: Cards Pos after determination: Up = [" + sCardUpPos + "] Down = [" + sCardDownPos + "] Left = [" + sCardLeftPos + "] Right = [" + sCardRightPos + "]");
	
	if (sCardUpPos != "" || sCardDownPos != "" || sCardLeftPos != "" || sCardRightPos != "")
		CardsFlipCards(oBoard, sCardUpPos, sCardDownPos, sCardLeftPos, sCardRightPos, iIteration);
	
	// handle combos
	if (iIteration > 1) // must be a combo occuring like on third iteration? As same or plus routine from first iteration will spawn second iteration check itself...
	{
		if (sCardUpPos != "") CardsDoRules(oBoard, sCardUpPos, iIteration+1);
		if (sCardDownPos != "") CardsDoRules(oBoard, sCardDownPos, iIteration+1); 
		if (sCardLeftPos != "") CardsDoRules(oBoard, sCardLeftPos, iIteration+1);
		if (sCardRightPos != "") CardsDoRules(oBoard, sCardRightPos, iIteration+1);
		fDelay = IntToFloat(iIteration) * CARD_BG_FLIP_TOTAL_TIME;
		DelayCommand(fDelay, CardsGUIDisplayRuleInEffectTextToAllPlayers(oBoard, RULE_COMBO));
		// my worry here is what happens if we  get two cards trying to affect same opponent card at same time... rare perhaps, but possible.
		// perhaps slight delay difference between each of the positions to make sure it doesn't happen?
	}
}

void GUI_Cards_Rule_Screen_Change(object oBoard, string sPlayer, string sButton)
{
	int iPlayer = StringToInt(sPlayer);
	// get existing value
	int iVarState = CardsGetRule(oBoard, sButton, sPlayer);
	string sStringState;
	object oPC1;
	object oPC2;
	
	int iRuleOpen1;
	int iRuleOpen2;
	int iRuleRandom1;
	int iRuleRandom2;
	int iRuleSame1;
	int iRuleSame2;
	int iRulePlus1;
	int iRulePlus2;
	int iRuleWall1;
	int iRuleWall2;
	int iRuleReady1;
	int iRuleReady2;
	
	oPC1 = CardsGetPlayer(oBoard, 1);
	oPC2 = CardsGetPlayer(oBoard, 2);
		
	if (iVarState == 0)
	{
		iVarState = 1;
		sStringState = "YES";
	}
	else
	{
		iVarState = 0;
		sStringState = "NO";
	}
	
	CardsSetRule(oBoard, sButton, iVarState, sPlayer);
	SetGUIObjectText(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P" + sPlayer + "_" + sButton, -1, sStringState);
	SetGUIObjectText(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P" + sPlayer + "_" + sButton, -1, sStringState);
	
	// one of these may just have changed....
	iRuleOpen1 = CardsGetRule(oBoard, RULE_OPEN, "1");
	iRuleOpen2 = CardsGetRule(oBoard, RULE_OPEN, "2");
	iRuleRandom1 = CardsGetRule(oBoard, RULE_RANDOM, "1");
	iRuleRandom2 = CardsGetRule(oBoard, RULE_RANDOM, "2");
	iRuleSame1 = CardsGetRule(oBoard, RULE_SAME, "1");
	iRuleSame2 = CardsGetRule(oBoard, RULE_SAME, "2");
	iRulePlus1 = CardsGetRule(oBoard, RULE_PLUS, "1");
	iRulePlus2 = CardsGetRule(oBoard, RULE_PLUS, "2");
	iRuleWall1 = CardsGetRule(oBoard, RULE_WALL, "1");
	iRuleWall2 = CardsGetRule(oBoard, RULE_WALL, "2");
	iRuleReady1 = CardsGetRule(oBoard, RULE_READY, "1");
	iRuleReady2 = CardsGetRule(oBoard, RULE_READY, "2");
	
	// check status of wall and plus rules on player side to disable/enable wall rule button and reset if necessary.
	if (iPlayer==1)
	{
		if (iRulePlus1 == 1 || iRuleSame1 == 1)
		{
			SetGUIObjectDisabled(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_" + RULE_WALL, FALSE);
			//SetGUIObjectDisabled(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_" + RULE_WALL, FALSE);		
		}
		else if (iRulePlus1 == 0 && iRuleSame1 == 0)
		{
			SetGUIObjectText(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_" + RULE_WALL, -1, "NO");
			SetGUIObjectText(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_" + RULE_WALL, -1, "NO");
			CardsSetRule(oBoard, RULE_WALL, 0, "1");
			iRuleWall1 = 0;
			
			SetGUIObjectDisabled(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_" + RULE_WALL, TRUE);
			//SetGUIObjectDisabled(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_" + RULE_WALL, TRUE);
		}
	}
	
	if (iPlayer==2)
	{
		if (iRulePlus2 == 1 || iRuleSame2 == 1)
		{
			//SetGUIObjectDisabled(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_" + RULE_WALL, FALSE);
			SetGUIObjectDisabled(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_" + RULE_WALL, FALSE);		
		}
		else if (iRulePlus2 == 0 && iRuleSame2 == 0)
		{
			SetGUIObjectText(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_" + RULE_WALL, -1, "NO");
			SetGUIObjectText(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_" + RULE_WALL, -1, "NO");
			CardsSetRule(oBoard, RULE_WALL, 0, "2");
			iRuleWall2 = 0;
			
			//SetGUIObjectDisabled(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_" + RULE_WALL, TRUE);
			SetGUIObjectDisabled(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_" + RULE_WALL, TRUE);
		}
	}
	
	// now check all values are equal on both sides!
	if (iRuleOpen1 != iRuleOpen2 || iRuleRandom1 != iRuleRandom2 || iRuleSame1 != iRuleSame2
		|| iRulePlus1 != iRulePlus2 || iRuleWall1 != iRuleWall2)
	{
			SetGUIObjectDisabled(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_READY", TRUE);
			SetGUIObjectText(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_READY", -1, "NO");
			SetGUIObjectText(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_READY", -1, "NO");
			CardsSetRule(oBoard, RULE_READY, 0, "1");
			iRuleReady1 = 0;
	
			SetGUIObjectDisabled(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_READY", TRUE);
			SetGUIObjectText(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_READY", -1, "NO");
			SetGUIObjectText(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_READY", -1, "NO");
			CardsSetRule(oBoard, RULE_READY, 0, "2");
			iRuleReady2 = 0;		
	}
	else
	{
		SetGUIObjectDisabled(oPC1, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P1_READY", FALSE);
		SetGUIObjectDisabled(oPC2, CARD_SCREEN_RULES_SCENE, "RULE_BUTTON_P2_READY", FALSE);
	} 
	
	//SendMessageToPC(oPC1, "DEBUG: iRuleReady1 = " + IntToString(iRuleReady1) + " and iRuleReady2 = " +IntToString(iRuleReady2));
	//SendMessageToPC(oPC2, "DEBUG: iRuleReady1 = " + IntToString(iRuleReady1) + " and iRuleReady2 = " +IntToString(iRuleReady2));
	
	if (iRuleReady1 == 1 && iRuleReady2 == 1)
	{
		if (CardsGetRule(oBoard, RULE_RANDOM)) // as rules are equal on both sides, then it doesn't matter from where we take the rules.
			CardsChangeGameState(oBoard, GAME_STATE_GAME_STARTING); // did i check for rule random at this stage to determine cards?
		else
			CardsChangeGameState(oBoard, GAME_STATE_CARD_SELECTION_1);
	}
}


// could be that a player tries to start the board convo when already playing
int CheckPlayerAlreadyIn(object oBoard, object oPC)
{
	int iFound = FALSE;
	int iCount;
	
	if (GetLocalObject(oBoard, CARD_PLAYER + "1") == oPC) iFound = TRUE;
	if (GetLocalObject(oBoard, CARD_PLAYER + "2") == oPC) iFound = TRUE;
	
	for(iCount=1;iCount<=10;iCount++)
	{
		if (GetLocalObject(oBoard, CARD_OBSERVER + IntToString(iCount)) == oPC) iFound = TRUE;
	}
	
	return iFound;
}

// valid values are either "PLAYER" or "OBSERVER"
// if no slots of specified type are open will return FALSE, if available slot, returns the position of the available slot.
int CheckGameSlotOpen(object oBoard, string sPlayerPos)
{
	if (sPlayerPos == CARD_PLAYER)
	{
		if (GetLocalObject(oBoard, CARD_PLAYER + "1") == OBJECT_INVALID)
			return 1;
		else if (GetLocalObject(oBoard, CARD_PLAYER + "2") == OBJECT_INVALID)
			return 2;
		else
			return 0;
	}
	else if (sPlayerPos == CARD_OBSERVER)
	{
		// yeah, lazy, but also lazy anyway setting max observers to 10 and hardcoded.  Shoot me.
		if (GetLocalObject(oBoard, CARD_OBSERVER + "1") == OBJECT_INVALID)
			return 1;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "2") == OBJECT_INVALID)
			return 2;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "3") == OBJECT_INVALID)
			return 3;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "4") == OBJECT_INVALID)
			return 4;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "5") == OBJECT_INVALID)
			return 5;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "6") == OBJECT_INVALID)
			return 6;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "7") == OBJECT_INVALID)
			return 7;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "8") == OBJECT_INVALID)
			return 8;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "9") == OBJECT_INVALID)
			return 9;
		else if (GetLocalObject(oBoard, CARD_OBSERVER + "10") == OBJECT_INVALID)
			return 10;
		else
			return 0;

	}
	else
	{
		// houston, we have a problem
	}

	if (GetLocalObject(oBoard, sPlayerPos) == OBJECT_INVALID)
		return TRUE;
	else
		return FALSE;
}

void CardsLeaveGame(object oBoard, object oPC)
{
	int iPlayerNo = CardsGetPlayerNumberFromBoard(oBoard, oPC); // its 0 if observer, 1 for P1, 2 for P2
	int iGameState = CardsGetGameState(oBoard);
	
	int iPosition; // could be player or observer
	
	//SendMessageToPC(oPC, "DEBUG: Running screen quit routine");
	
	//SendMessageToPC(oPC, "DEBUG: Thinks you are player number: " + IntToString(iPlayerNo));
	//SendMessageToPC(oPC, "If above was not zero, should be another message...");
	
	if (iPlayerNo == 0)
	{
		iPosition = CardsGetObserverNumberFromBoard(oBoard, oPC);
		CardsSetObserver(oBoard, iPosition, OBJECT_INVALID);
		CardsSetObserverName(oBoard, iPosition, OBJECT_INVALID);
		CardsClearVarsOnPC(oPC);
		
		if (iGameState >= GAME_STATE_GAME_STARTING)
		{
			CardsGUIUpdateObserverList(oBoard);
			CloseGUIScreen(oPC, CARD_SCREEN_GAME_SCENE);
		}
		else
		{
			CloseGUIScreen(oPC, CARD_SCREEN_WAITING_SCENE);
		}
	}
	else
	{
		if (iGameState >= GAME_STATE_GAME_STARTING)
			CardsClearTablePlaceableOfCards(oBoard);
			
		//SendMessageToPC(oPC, "Checking player number and calling game over routine after quitting GUI");
		if (iPlayerNo == 1)
		{
			CardsGameOver(oBoard, LEAVE_REASON_PLAYER1_QUIT);
		}
		else
		{
			CardsGameOver(oBoard, LEAVE_REASON_PLAYER2_QUIT);
		}
		CardsClearVarsOnPC(oPC);
	}
}

// Adds the character to the available position
// a check is made in convo to see if this slot is available, but secondary check needed here just in case someone else takes while player is thinking.
// if game is already running, convo will only list observer as an option
// iPlayerType = 1 for player, 2 for observer
void JoinPlayerToGame(object oBoard, int iPlayerType, object oPC)
{
	int iPos;
	string sPos;
	object oDeck;
	
	CloseGUIScreen(oPC, CARD_SCREEN_GAME_SCENE); // just in case
	
	if (CheckPlayerAlreadyIn(oBoard, oPC) == TRUE)
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You cannot join a game you are already involved in as either a player or observer");
	}
	else if (iPlayerType == CARD_PLAYER_TYPE_PLAYER) // player
	{
		 iPos = CheckGameSlotOpen(oBoard, CARD_PLAYER);
		 sPos = IntToString(iPos);
		 
		 //SendMessageToPC(oPC, "DEBUG: Should be about to clear the table of cards if iPos is 1.... iPos="+IntToString(iPos));
		 if (iPos == 1) 
		 {
		 	CardsClearTablePlaceableOfCards(oBoard); // doesn't need to run twice and in theory it should be clear, but just make sure.
		 }
	
		 if (iPos > 0)
		 {
		 	oDeck = GetPlayerDeck(oPC);
				
			if (oDeck != OBJECT_INVALID)
			{
				//SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "DEBUG: Joining game as Player " + sPos + " <c=red>There should be a 1 or 2 here, if not, bug!");
				CardsSetPlayer(oBoard, iPos, oPC);
				SetLocalObject(oBoard, CARD_PLAYER_DECK + sPos, oDeck);
				CardsSetBoardOnPlayer(oPC, oBoard);
				CardsSetPlayer(oBoard, iPos, oPC);
				CardsSetPlayerNameOnBoard(oBoard, iPos, oPC);
				
				if (CardsGetPlayer(oBoard, 1)!=OBJECT_INVALID && CardsGetPlayer(oBoard, 2) != OBJECT_INVALID)
					CardsChangeGameState(oBoard, GAME_STATE_RULES_SELECTION);
				else
					CardsChangeGameState(oBoard, GAME_STATE_1_PLAYER);
			}
			else
			{
				SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You can't play a game without your own deck of cards!");
			}
		 }
		 else
		 {
		 	SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Sorry, all player slots are currently taken.");
		 }
	}
	else if (iPlayerType == CARD_PLAYER_TYPE_OBSERVER) // observer
	{
		iPos = CheckGameSlotOpen(oBoard, CARD_OBSERVER);
		
		if (iPos > 0)
		{
			SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Joining game as an observer.");
			sPos = IntToString(iPos);
			SetLocalObject(oBoard, CARD_OBSERVER + sPos, oPC);
			SetLocalObject(oPC, CARD_TABLE_OBJECT, oBoard);
			SetLocalString(oPC, CARD_TABLE_POSITION, CARD_OBSERVER + sPos);
			SetLocalString(oBoard, CARD_OBSERVER_NAME + sPos, GetName(oPC));
			//GUI_DisplayNewJoinGUIBasedOnType(oPC, oBoard, CARD_OBSERVER, sPos);
			
			int iState = CardsGetGameState(oBoard);
			
			if (iState < GAME_STATE_GAME_STARTING)
			{
				GUI_Display_Card_Board_Waiting(oBoard, oPC);
			}
			else
			{
				GUI_Display_Card_Board_In_CurrentState(oBoard, oPC);
				CardsGUIUpdateObserverList(oBoard);
			}
		}
		else
		{
			SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Sorry, all places near the table to observe are currently taken");
		}
	}
	else
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Error in script joining to game, please inform staff");
	}
}

int IsBoardOwner(object oPC, object oBoard)
{
	string sStoredPCName = GetLocalString(oBoard, GAME_OWNER_NAME);
	object oStoredPCObject = GetLocalObject(oBoard, GAME_OWNER_OBJECT);
	
	if (GetName(oPC) == sStoredPCName)
	{
		return TRUE;
	}
	else if (!GetIsObjectValid(oPC))
	{
		return TRUE; // owner no longer exists, so let anyone destroy table
	}
	else
	{
		return FALSE;
	}
}

// Creates the table for play.  Note: the creator does not have to be involved in play.  As with all user placeables, if the creator is not logged on, the table can be destroyed by anyone.
// May make this a board - search for objects which it could rest on (can we target tables? Sometimes i think, usually not), 
// but find nearest placeable, if it matches a known model type (tag/resref?) we try and match height?  Otherwise place on ground?
// going to be tricky and risky... but allows placing anywhere kind of.... GetNearestObject of type Placeable?
void CardsCreateBoard(object oPC, location lTarget)
{
	// just set facing to zero
	lTarget = Location(GetAreaFromLocation(lTarget), GetPositionFromLocation(lTarget), 0.0);
	
	object oTable = CreateObject(OBJECT_TYPE_PLACEABLE, CARD_TABLE_TAG, lTarget);
	
	vector vTable = GetPositionFromLocation(lTarget);
	vector vChair1 = Vector(vTable.x + CARDS_BLUE_CHAIR_X, vTable.y, vTable.z);
	vector vChair2 = Vector(vTable.x + CARDS_RED_CHAIR_X, vTable.y, vTable.z);
	
	object oChair1 = CreateObject(OBJECT_TYPE_PLACEABLE, CARD_CHAIR_BLUE, Location(GetArea(oPC), vChair1, CARDS_BLUE_CHAIR_ORIENT), FALSE);
	object oChair2 = CreateObject(OBJECT_TYPE_PLACEABLE, CARD_CHAIR_RED, Location(GetArea(oPC), vChair2, CARDS_RED_CHAIR_ORIENT), FALSE);

	SetLocalInt(oTable, GAME_STATE, GAME_STATE_NO_PLAYERS);
	SetLocalString(oTable, GAME_OWNER_NAME, GetName(oPC));
	SetLocalObject(oTable, GAME_OWNER_OBJECT, oPC);

	SetLocalObject(oTable, CARD_CHAIR_BLUE, oChair1);
	SetLocalObject(oTable, CARD_CHAIR_RED, oChair2);
}

// Destroys the card table. Notifies players. Closes GUIs (possible, or just goes to end game by calling end of game function).
// goes through all the possible objects (table, chairs, cards in positions) and destroys them).
void DestroyCardTable(object oBoard)
{
	CardsChangeGameState(oBoard, GAME_STATE_GAME_OVER, LEAVE_REASON_GAME_BOARD_DESTROYED);
	// destroy table, chairs, and any cards on the table - handled by game over routine.
}

// returns true if card already exists in deck
int CardsCardExistsInDeck(object oDeck, object oCard)
{
	int iMaxCount = CardsGetDeckSize(oDeck);
	int iCount;
	int iFound = FALSE;
	
	int iID = GetLocalInt(oCard, CARD_ID);
	int iCardInDeckID;
	
	if (iMaxCount == 0)
		return iFound; // shouldn't ever happen, deck should always have the base cards in it
	else
	{
		for (iCount = 1; iCount <= iMaxCount; iCount++)
		{
			iCardInDeckID = GetLocalInt(oDeck, CARD_ID + IntToString(iCount));
			
			if (iCardInDeckID == iID)
				iFound = TRUE;
		}
		
		return iFound;
	}
}

void CardsStoreCardInDeck(object oPC, object oCard, object oDeck)
{
	string sCardName = GetLocalString(oCard, CARD_NAME);
	string sCardImage = GetLocalString(oCard, CARD_PICTURE);
	int iUp = GetLocalInt(oCard, CARD_VALUE_UP);
	int iDown = GetLocalInt(oCard, CARD_VALUE_DOWN);
	int iLeft = GetLocalInt(oCard, CARD_VALUE_LEFT);
	int iRight = GetLocalInt(oCard, CARD_VALUE_RIGHT);
	int iID = GetLocalInt(oCard, CARD_ID);

	int iDeckSize = CardsGetDeckSize(oDeck);
	string sCardPos = IntToString(iDeckSize + 1);
	CardsSetDeckSize(oDeck, iDeckSize + 1);
	
	SetLocalInt(oDeck, CARD_VALUE_UP + sCardPos, iUp);
	SetLocalInt(oDeck, CARD_VALUE_DOWN + sCardPos, iDown);
	SetLocalInt(oDeck, CARD_VALUE_LEFT + sCardPos, iLeft);
	SetLocalInt(oDeck, CARD_VALUE_RIGHT + sCardPos, iRight);
	SetLocalString(oDeck, CARD_NAME + sCardPos, sCardName);
	SetLocalString(oDeck, CARD_PICTURE + sCardPos, sCardImage);
	SetLocalInt(oDeck, CARD_ID + sCardPos, iID);
		
	DestroyObject(oCard, 0.0, FALSE);
	
	SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "The " + sCardName + " card has been added to your deck.");
}

// Function checks the existing deck to see if card is not already stored, and if not, then adds that card to the deck.
// otherwise card will not be added and player informed.
void CardsAddCardToDeck(object oPC, object oCard, object oDeck)
{
	// first check to see if the card being added is already present
	// if not, then it can be added, otherwise inform player
	if (CardsCardExistsInDeck(oDeck, oCard) == TRUE)
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "You already have this card in your deck. You can only have 1 card of any given type in your deck.");
	}
	else
	{
		CardsStoreCardInDeck(oPC, oCard, oDeck);
	}
}

string CardsStripUnderscore(string sInput)
{
	string sOutput;
	int iCurrent = 0;
	int iMax = GetStringLength(sInput)-1;
	string sCurrent;
	
	for (iCurrent=0; iCurrent <= iMax; iCurrent++)
	{
		sCurrent = GetSubString(sInput, iCurrent, 1);
		
		if (sCurrent=="_")
			sOutput = sOutput+" ";
		else
			sOutput = sOutput+sCurrent;
	}
	return sOutput;
}

object CardsCreateCard(object oTarget, int i2daRow)
{
	object oCard = CreateItemOnObject(CARD_CARD_RESREF, oTarget, 1, "", FALSE);
	string sName;
	
	if (GetIsObjectValid(oCard))
	{
		sName = CardsStripUnderscore(Get2DAString(CARD_2DA, CARD_2DA_COL_NAME, i2daRow));
		SetFirstName(oCard, "<c=gold>Card: " + sName);
		SetLocalString(oCard, CARD_NAME, sName);
		SetLocalString(oCard, CARD_PICTURE, Get2DAString(CARD_2DA, CARD_2DA_COL_IMAGE, i2daRow));
		SetLocalInt(oCard, CARD_VALUE_UP, StringToInt(Get2DAString(CARD_2DA, CARD_2DA_COL_UP, i2daRow)));
		SetLocalInt(oCard, CARD_VALUE_DOWN, StringToInt(Get2DAString(CARD_2DA, CARD_2DA_COL_DOWN, i2daRow)));
		SetLocalInt(oCard, CARD_VALUE_LEFT, StringToInt(Get2DAString(CARD_2DA, CARD_2DA_COL_LEFT, i2daRow)));
		SetLocalInt(oCard, CARD_VALUE_RIGHT, StringToInt(Get2DAString(CARD_2DA, CARD_2DA_COL_RIGHT, i2daRow)));
		SetLocalInt(oCard, CARD_ID, i2daRow);
		SetItemCostVariables(oCard);
	}
	
	return oCard;
}

// used to add base cards to deck when initially purchased
void CardsSetUpBaseDeck(object oPC, object oDeck)
{
	int iCount;
	object oCard;

	for (iCount=1; iCount <= CARD_TYPE_BASE_MAX; iCount++)
	{
		oCard = CardsCreateCard(oPC, iCount); // 2da rows 1 to base max.
		CardsStoreCardInDeck(oPC, oCard, oDeck);
	}
}

// chance of whether card will spawn in chest or on monster handled by ps_chest->FillItems() (for chests) or nw_c2_default9 (for monsters).
// this function is then called to determine which card and which level. Chests use default values, monster drop changes are modified by CR of monster
// giving greater chance of better cards with higher CR.
void CardsCreateCardOnSpawnOrChest(object oTarget, object oPC = OBJECT_INVALID)
{
	int iMod=1;
	int iCR;
	int iRes;
	int iType;
	int iMax;
	int iSelected;
	
	if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	{
		iCR = FloatToInt(GetChallengeRating(oTarget));
	}
	else
	{
		iCR = Random(31) + 1; // chests are just random but low chance of being treated like a boss.
	}
	
	if (iCR < 11) iMod = iCR;
	else if (iCR < 21) iMod = iCR*2; // max 40
	else if (iCR < 31) iMod = iCR*3; // max 90
	else iMod = 100 + iCR; // big boss mod. So a 99CR monster would be 199.
	
	iRes = Random(1000) + iMod;
	
	if (iRes < 600) // for most monsters roughly 50/50 chance of getting a low IF a card spawns
	{
		iType = CARD_ITEM_TYPE_LOW;
		iMax = CARD_TYPE_LOW_MAX;
	}
	else if (iRes < 900) // about 30-40% chance of getting a med depending on monster CR
	{
		iType = CARD_ITEM_TYPE_MED;
		iMax = CARD_TYPE_MED_MAX;
	}
	else if (iRes < 1100) // With bosses, perhaps a 20% chance, with a CR 20 monster would be Random 1000 + 40 against 900-1140, so around 10% chance.
	{
		iType = CARD_ITEM_TYPE_HIGH;
		iMax = CARD_TYPE_HIGH_MAX;
	}
	else // Ultra card will only ever drop from a creature with CR > 30 and then rarely. Something like 0.1% chance for every point of CR over 30.
	{
		iType = CARD_ITEM_TYPE_ULTRA;
		iMax = CARD_TYPE_ULTRA_MAX;
	}

	if (iMax !=0) // just check to make sure we don't try and spawn an object that doesn't exist, although by time this is finished there will be always at least one card of each type
	{
		iSelected = Random(iMax) + 1 + (iType * CARD_ITEM_TYPE_2DA_OFFSET);
		object oCard = CardsCreateCard(oTarget, iSelected);
		
		if (GetIsObjectValid(oPC)) {
			SendMessageToPC(oPC, "Debug: creating card ID "+IntToString(iSelected));
			SendMessageToPC(oPC, "Debug: found card "+GetName(oCard));
		}
	}
}

// used by CardsSwapCardsInDeckPositions to transfer via temp var
void CardsSwapCardValuesWithStrings(object oDeck, string sSource, string sDest)
{
	SetLocalInt(oDeck, CARD_VALUE_UP + sDest, GetLocalInt(oDeck, CARD_VALUE_UP + sSource));
	SetLocalInt(oDeck, CARD_VALUE_DOWN + sDest, GetLocalInt(oDeck, CARD_VALUE_DOWN + sSource));
	SetLocalInt(oDeck, CARD_VALUE_LEFT + sDest, GetLocalInt(oDeck, CARD_VALUE_LEFT + sSource));
	SetLocalInt(oDeck, CARD_VALUE_RIGHT + sDest, GetLocalInt(oDeck, CARD_VALUE_RIGHT + sSource));
	SetLocalString(oDeck, CARD_NAME + sDest, GetLocalString(oDeck, CARD_NAME + sSource));
	SetLocalString(oDeck, CARD_PICTURE + sDest, GetLocalString(oDeck, CARD_PICTURE + sSource));
	SetLocalInt(oDeck, CARD_ID + sDest, GetLocalInt(oDeck, CARD_ID + sSource));
}

// swaps all the variables of the cards in the two positions specified, storing in a set of temp variables.
void CardsSwapCardsInDeckPositions(object oDeck, int iFirst, int iSecond)
{
	string sFirst = IntToString(iFirst);
	string sSecond = IntToString(iSecond);
	
	CardsSwapCardValuesWithStrings(oDeck, sFirst, "SWAP_TEMP");
	CardsSwapCardValuesWithStrings(oDeck, sSecond, sFirst);
	CardsSwapCardValuesWithStrings(oDeck, "SWAP_TEMP", sSecond);
}

// compares the names of the two cards in the positions specified.
// returns 1 (TRUE) if first is bigger (higher Alpha) than second, else FALSE
int CardsCompareAlpha(object oDeck, int iFirst, int iSecond)
{
	string sFirst = GetLocalString(oDeck, CARD_NAME + IntToString(iFirst));
	string sSecond = GetLocalString(oDeck, CARD_NAME + IntToString(iSecond));

	if (StringCompare(sFirst, sSecond) > 0)
	{
		//SendMessageToPC(GetItemPossessor(oDeck), "DEBUG: First is bigger than second");
	
		return TRUE;
	}
	else 
	{
		//SendMessageToPC(GetItemPossessor(oDeck), "DEBUG: Second is bigger than first");
	
		return FALSE;
	}
}

int CardsCalcTotalValue(object oDeck, int iCard)
{
	string sCardPos = IntToString(iCard);
	int iTotal = GetLocalInt(oDeck, CARD_VALUE_UP + sCardPos) + GetLocalInt(oDeck, CARD_VALUE_DOWN + sCardPos) + GetLocalInt(oDeck, CARD_VALUE_LEFT + sCardPos) + GetLocalInt(oDeck, CARD_VALUE_RIGHT + sCardPos);
	//SendMessageToPC(GetItemPossessor(oDeck), "DEBUG: Total Value of card being compared = " + IntToString(iTotal));
	return iTotal;
}

// compares the names of the two cards in the positions specified.
// returns 1 (TRUE) if first is bigger (higher total value) than second, else FALSE, in case of a tie, returns FALSE.
int CardsComparePower(object oDeck, int iFirst, int iSecond)
{
	if (CardsCalcTotalValue(oDeck, iFirst) > CardsCalcTotalValue(oDeck, iSecond))
	{	
		//SendMessageToPC(GetItemPossessor(oDeck), "DEBUG: Compare Power returning TRUE");
		return TRUE;
	}
	else
	{
		//SendMessageToPC(GetItemPossessor(oDeck), "DEBUG: Compare Power returning FALSE");
		
		return FALSE;
	}
}

void CardsDeckSort(object oPC, object oDeck, int iSortType)
{
	int iPos = 2; // start from second card.
	int iDeckSize = CardsGetDeckSize(oDeck);
	int iLast = 1;
	int iResult;
	
	if (iDeckSize < 2) // just a general catch
	{
		SendMessageToPC(oPC, CARD_GAME_FEEDBACK_COLOUR + "Deck size is too small to sort");
		return;
	}
	
	while (iPos <= iDeckSize)
	{
		iResult = FALSE;
		//SendMessageToPC(oPC, "DEBUG: Comparing Cards with iPos=" + IntToString(iPos) + " (iLast=" + IntToString(iLast) + ") Cards are: " + GetLocalString(oDeck, CARD_NAME + IntToString(iPos)) + " and " + GetLocalString(oDeck, CARD_NAME + IntToString(iPos-1)));
		switch (iSortType)
		{
			case DECK_SORT_ALPHA: if (CardsCompareAlpha(oDeck, iPos, iPos - 1) == TRUE) iResult = TRUE; break;
			case DECK_SORT_POWER_INCREASE: if (CardsComparePower(oDeck, iPos, iPos - 1) == TRUE) iResult = TRUE; break;
			case DECK_SORT_POWER_DECREASE: if (CardsComparePower(oDeck, iPos, iPos - 1) == FALSE) iResult = TRUE; break;
		}
		
		//SendMessageToPC(oPC, "DEBUG: Cards Sorted? " + IntToString(iResult));
		
		if (iResult == TRUE) // its sorted
		{
			if (iLast != 1)
			{
				iPos = iLast;
				iLast = 1;
			}
			iPos += 1;
		}
		else
		{
			CardsSwapCardsInDeckPositions(oDeck, iPos, iPos - 1);
			if (iPos > 2)
			{
				if (iLast == 1)
				{
					iLast = iPos;
				}
				iPos -= 1;
			}
			else
			{
				iPos += 1;
			}
		}
	}    
}

int CardsAllPositionsFilled(object oDeck)
{
	int x;
	int y;
	int iFound = TRUE; // we assume true, until we find otherwise
	
	for (y=1; y<=3; y++)
	{
		for (x=1; x<=3; x++)
		{
			if (GetLocalInt(oDeck, "R" + IntToString(x) + "C" + IntToString(y)) == 0)
				iFound = FALSE; // and so we have found an empty slot
		}
	}
	
	return iFound;
}