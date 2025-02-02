// This script needs to work so that all pieces are in the correct places 
// and black/white king/queen positions are also considered.
// Will use "ps_inc_functions" to determine party level 
// so can deduct peices from the board before start.  
// Also remember to count how many party members for same reason.
// CreateObject will be used for spawning in:
// object CreateObject(int nObjectType, string sTemplate, location lLocation, int bUseAppearAnimation=FALSE, string sNewTag="");

#include "ginc_journal"
#include "ps_inc_functions"
#include "x0_i0_treasure"

//Can't believe we didn't have this, suggest integration with ps_inc_functions
int PS_GetTotalPartylevel(object oPC) //finds total level of party (with ECL)
{
	int iTotallevel = 0;
	int iMemberlevel = 0;
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
	
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		iMemberlevel = PS_GetLevel(oPartyMember);
		iTotallevel += iMemberlevel;
		oPartyMember = GetNextFactionMember(oPC, TRUE);
    }
	// fix for local play without essence - remember to remove before upload!!!
	//iTotallevel -= 30;
	return iTotallevel;
}

/* Original function
void EnemyKingReward()
{
	// wanted to call the spawn in items directly, but the GetTime function in ps_chest causes a compile
	// error saying duplicate function.  So, let the standard chest spawn script work normally
	// and just give a 1 in 10 chance for the chess set as an addition.
	int iItemChance = Random(10);
	if (iItemChance == 0)
	{
		CreateItemOnObject("ps_chessset", GetObjectByTag("ps_chess_treasure",0), 1,"",FALSE);
	}
}
*/

void CleanChest(object oChest)
{
	object oItem = GetFirstItemInInventory(oChest);
	if(GetIsObjectValid(oItem))
    {
    	while(GetIsObjectValid(oItem))
       	{
       	 	SetPlotFlag(oItem, FALSE);
       	 	DestroyObject(oItem);
       	 	oItem = GetNextItemInInventory(oChest);
        }
    }	
}

/*
void FillSpecificItem(object oChest, string sTreasure, int nType = 1)
{
	if ( sTreasure == "BOOK" )
	{
		CreateBook(oChest);
	}
	else if ( sTreasure == "JUNK" )
	{
		CreateJunk(oChest);
	}
	else if ( sTreasure == "GEM" )
	{
		CreateGem(oChest,OBJECT_INVALID,nType);
	}
	else if ( sTreasure == "ARCANE" )
	{
		CreateArcaneScroll(oChest,OBJECT_INVALID,nType * 5);
	}
	else if ( sTreasure == "AMMO" )
	{
		CreateAmmo(oChest,OBJECT_INVALID,nType * 5);
	}
	else if ( sTreasure == "KIT" )
	{
		CreateKit(oChest,OBJECT_INVALID,nType * 5);
	}
	else if ( sTreasure == "POTION" )
	{
		CreatePotion(oChest,OBJECT_INVALID,nType);
	}	
	else if ( sTreasure == "RANDOM" ) //recursion
	{
		int nRandom = Random(7)+1;
		switch (nRandom)
		{
        	case 1: FillSpecificItem(oChest,"BOOK",nType); break;
           	case 2: FillSpecificItem(oChest,"JUNK",nType); break;
            case 3: FillSpecificItem(oChest,"GEM",nType); break;
            case 4: FillSpecificItem(oChest,"ARCANE",nType); break;
            case 5: FillSpecificItem(oChest,"AMMO",nType); break;
			case 6: FillSpecificItem(oChest,"KIT",nType); break;
			case 7: FillSpecificItem(oChest,"POTION",nType); break;
        }
	}
}
*/

void EnemyKingReward()
{
	object oChest = GetObjectByTag("ps_chessboard_chest");
	
	// Clean previous contents
	CleanChest(oChest);
	
	CreateItemOnObject("ps_chessset", oChest, 1,"",FALSE);

}

void ChessPieceSpawn(string sColour, string sAllyEnemy, string sPiece, location lWaypoint)
{
	object oSpawnedPeice;
	//SendMessageToPC(GetFirstPC(FALSE), "Creating " + sColour + " " + sPiece);
	CreateObject(OBJECT_TYPE_CREATURE, "ps_monster_chess_" + sColour + sPiece, lWaypoint, FALSE, "ps_monster_chess_" + sPiece + sAllyEnemy);
}

void main()
{
string sSideChosen;
string sSideOpposing;
//int iChessQuestState;
int iNumberOfPartyMembers;
int iTotalPartyLevels;
// this one used to reduce/increase the number of spawns.  Higher the number, more allies will spawn depending on levels.
// Lower/negative numbers will cause less to appear.  Balance at moment seems to be around full spawns with 1 character of level 10 or less.
// so the number represents levels to deduct in addition to the party's total levels.
int iBalanceAdjustment = 0;
object oEnemyKing;
object oEntryDoor;
object oPC = GetEnteringObject();
//SendMessageToPC(oPC, "Stepped on trigger " + GetTag(OBJECT_SELF));

if (!GetIsPC(oPC))
	{
	return;
	}
else
	{
	//Door stuff going first to try and avoid multiple spawns if two players hit trigger
	//at almost same time... spawns will cause a little delay.
	oEntryDoor = GetObjectByTag("ps_chessboard_door_enter",0);
	if (GetLocalInt(oEntryDoor, "GameStarted") == TRUE)
		{
		return;
		}
	else
		{
		//Going to set a var on the door which will be checked in future to stop multiple spawns.
		SetLocalInt(oEntryDoor, "GameStarted", TRUE);
		
		// Make sure we don't double-spawn
		if (GetIsObjectValid(GetObjectByTag("ps_monster_chess_king_enemy")))
			return;
		
		//Open the door
		
		EnemyKingReward();
		
		DelayCommand(5.0,SetLocked(oEntryDoor, FALSE));
		DelayCommand(5.2,ActionOpenDoor(oEntryDoor));
		SendMessageToParty(oPC, "Ghostly Voice: Setting up the board, wait 5 seconds for the door to open", TRUE);
		//SendMessageToPC(oPC, "I'm a PC");
		//iChessQuestState = GetJournalQuestEntry("ps_quest_chessboard", oPC);
		//SendMessageToPC(oPC, IntToString(GetJournalQuestEntry("ps_quest_chessboard", oPC)));
		sSideChosen = GetStringLowerCase(GetLocalString(OBJECT_SELF, "sChessColour"));
		//SendMessageToPC(oPC, sSideChosen);
		if (sSideChosen=="black")
			{
			sSideOpposing = "white";
			}
		else
			{
			sSideOpposing = "black";
			}
		
		//SendMessageToPC(oPC, "You have chosen to ally with " + sSideChosen + " and oppose " + sSideOpposing);
		AddJournalQuestEntry("ps_quest_chessboard", 15, oPC, TRUE, FALSE, FALSE);
		// Let's figure out how many characters in party and their total levels
		// before we setup the board.
		iNumberOfPartyMembers = PS_GetNumPC(oPC);
		iTotalPartyLevels = PS_GetTotalPartylevel(oPC);
		//SendMessageToPC(oPC, "Number of Party Members=" + IntToString(iNumberOfPartyMembers) + 
		//" Total Party levels=" + IntToString(iTotalPartyLevels));
		// Now setup the enemy side
		DelayCommand(1.0, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn1"))));
		DelayCommand(1.5, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn2"))));
		DelayCommand(1.5, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn3"))));
		DelayCommand(1.5, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn4"))));
		DelayCommand(1.5, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn5"))));
		DelayCommand(1.5, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn6"))));
		DelayCommand(1.5, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn7"))));
		DelayCommand(1.5, ChessPieceSpawn(sSideOpposing, "enemy", "pawn", GetLocation (GetWaypointByTag ("chess_enemy_pawn8"))));
		DelayCommand(2.0, ChessPieceSpawn(sSideOpposing, "enemy", "bishop", GetLocation (GetWaypointByTag ("chess_enemy_bishop_left"))));
		DelayCommand(2.2, ChessPieceSpawn(sSideOpposing, "enemy", "bishop", GetLocation (GetWaypointByTag ("chess_enemy_bishop_right"))));
		DelayCommand(2.4, ChessPieceSpawn(sSideOpposing, "enemy", "knight", GetLocation (GetWaypointByTag ("chess_enemy_knight_left"))));
		DelayCommand(2.6, ChessPieceSpawn(sSideOpposing, "enemy", "knight", GetLocation (GetWaypointByTag ("chess_enemy_knight_right"))));
		DelayCommand(2.8, ChessPieceSpawn(sSideOpposing, "enemy", "rook", GetLocation (GetWaypointByTag ("chess_enemy_rook_left"))));
		DelayCommand(3.0, ChessPieceSpawn(sSideOpposing, "enemy", "rook", GetLocation (GetWaypointByTag ("chess_enemy_rook_right"))));
		if (sSideChosen == "black")
			{
			DelayCommand(0.5, ChessPieceSpawn(sSideOpposing, "enemy", "queen", GetLocation (GetWaypointByTag ("chess_enemy_queen"))));
			// we can't take a return command from DelayCommand, so just spawn kings instantly at time=0
			oEnemyKing = CreateObject(OBJECT_TYPE_CREATURE, "ps_monster_chess_" + sSideOpposing + "king", GetLocation (GetWaypointByTag ("chess_enemy_king")), FALSE, "ps_monster_chess_king_enemy");
			}
		else
			{
			// swap placement because kings and queens are reversed
			oEnemyKing = CreateObject(OBJECT_TYPE_CREATURE, "ps_monster_chess_" + sSideOpposing + "king", GetLocation (GetWaypointByTag ("chess_enemy_queen")), FALSE, "ps_monster_chess_king_enemy");
			DelayCommand(0.5, ChessPieceSpawn(sSideOpposing, "enemy", "queen", GetLocation (GetWaypointByTag ("chess_enemy_king"))));
			}
		SetLocalString(oEnemyKing, "sChessSideChosen", sSideChosen);

		// Now setup the ally side
		// big long chain checking size of party and total levels... could probably loop it with a function...
		// We start with pawns and work our way to the higher valued peices.  This way stronger parties
		// also get weaker allies in general based on principle that 5x1st level characters would get
		// smashed by 1x5th level character. Think this makes it more of a challenge that doing it other way around.
		// Piece values first. We set it here so easier to change if we change the creatures' templates.
		// Point values should equal creature levels.
		int iChessValueKing = 15;
		int iChessValueQueen = 10;
		int iChessValueRook = 5;
		int iChessValueKnight = 4;
		int iChessValueBishop = 5;
		int iChessValuePawn = 1;
		// Not including king because one player is the allied king.
		int iChessValueSide = iChessValueQueen + (iChessValueRook * 2) + (iChessValueKnight * 2) + (iChessValueBishop * 2) + (iChessValuePawn * 8);
		// We adjust this value down by the balance adjustment to make it harder.
		iChessValueSide += iBalanceAdjustment;
		// iNumberOfPartyMembers; iTotalPartyLevels;iBalanceAdjustment
		int iPiecesRemaining = 16;
		//SendMessageToPC(oPC, "ChessValueSide=" + IntToString(iChessValueSide) + 
		//" iPiecesRemaining=" + IntToString(iPiecesRemaining));
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			//SendMessageToPC(oPC, "trying to spawn something allied...");
			//SendMessageToPC(oPC, "Chosen side=" + sSideChosen + "trying to create: " + "ps_monster_chess_" + sSideChosen + "pawn");
			DelayCommand(3.2, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn1"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		//SendMessageToPC(oPC, "ChessValueSide=" + IntToString(iChessValueSide) + 
		//" iPiecesRemaining=" + IntToString(iPiecesRemaining));
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.4, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn2"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.4, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn3"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.4, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn4"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.4, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn5"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.4, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn6"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.4, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn7"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.4, ChessPieceSpawn(sSideChosen, "ally", "pawn", GetLocation (GetWaypointByTag ("chess_ally_pawn8"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValuePawn;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.6, ChessPieceSpawn(sSideChosen, "ally", "bishop", GetLocation (GetWaypointByTag ("chess_ally_bishop_left"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValueBishop;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(3.8, ChessPieceSpawn(sSideChosen, "ally", "bishop", GetLocation (GetWaypointByTag ("chess_ally_bishop_right"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValueBishop;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(4.0, ChessPieceSpawn(sSideChosen, "ally", "knight", GetLocation (GetWaypointByTag ("chess_ally_knight_left"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValueKnight;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(4.2, ChessPieceSpawn(sSideChosen, "ally", "knight", GetLocation (GetWaypointByTag ("chess_ally_knight_right"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValueKnight;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(4.6, ChessPieceSpawn(sSideChosen, "ally", "rook", GetLocation (GetWaypointByTag ("chess_ally_rook_left"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValueRook;
	
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			DelayCommand(4.8, ChessPieceSpawn(sSideChosen, "ally", "rook", GetLocation (GetWaypointByTag ("chess_ally_rook_right"))));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValueRook;
		
		if ((iNumberOfPartyMembers < iPiecesRemaining) && (iTotalPartyLevels < iChessValueSide))
			{
			// use correct waypoint, its reverse logic.
			location lQueensPlace;
			if (sSideChosen == "white")
				{ 
				lQueensPlace = GetLocation (GetWaypointByTag("chess_ally_king"));
				}
			else
				{
				lQueensPlace = GetLocation (GetWaypointByTag("chess_ally_queen"));
				}
			DelayCommand(5.0, ChessPieceSpawn(sSideChosen, "ally", "queen", lQueensPlace));
			}
		iPiecesRemaining--;
		iChessValueSide -= iChessValueQueen;
		}
	}	
//Just check the local var has been set
//SendMessageToPC(oPC, "Variable set on king was: " + GetLocalString(oEnemyKing, "sChessSideChosen"));
}