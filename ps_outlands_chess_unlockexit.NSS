// Script to check if the enemy king is dead allowing exit from the area.
// you don't have to kill all enemies to get out, just the king.
// could be taken advantage of, but should be bigger reward for killing all from
// drops and XP than quest XP.

#include "ginc_journal"

void main()
{
object oExitDoor;
object oPC = GetEnteringObject();
//SendMessageToPC(oPC, "Stepped on trigger " + GetTag(OBJECT_SELF));

if (!GetIsPC(oPC))
	{
	return;
	}
else
	{
	oExitDoor = GetObjectByTag("ps_chessboard_door_exit",0);
	// must be a more elegant way of determining if the king is still alive.
	if (GetTag(GetObjectByTag("ps_monster_chess_king_enemy",0)) == "ps_monster_chess_king_enemy")
		{
		SendMessageToPC(oPC, "The enemy king is not yet dead, you must finish him off before you leave");
		return;
		}
	else
		{
		//Open the door
		SetLocked(oExitDoor, FALSE);
		ActionOpenDoor(oExitDoor);
		AddJournalQuestEntry("ps_quest_chessboard", 30, oPC, TRUE, FALSE, FALSE);
		//SendMessageToPC(oPC, IntToString(GetJournalQuestEntry("ps_quest_chessboard", oPC)));
		}
	}
}