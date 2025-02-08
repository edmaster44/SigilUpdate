#include "ff_safevar"

// This script will cycle through all non-PC creatures in the area which start with ps_monster_chess_
// and will do two things:
// Enemy peices, those which have tags/refs with enemy will get set to hostile
// Ally peices will be set to defender (i think).
// Also, all pieces will hopefully be made non-invulnerable.
// Remember to only activate if the player is standing on the right square (the empty one left for king).
// Can use SetImmortal to stop damage on spawn and unset it... but can still take damage... not good. SetPlotFlag?
// SetWeaponVisibility could be useful for Black Rooks.
// ChangeToStandardFaction to start things going.
void main()
{
object oCurrentCreature;
string sSideChosen;
object oCurrentArea;
object oEnemyKing;
object oPC;
object oEntryDoor;

oPC = GetEnteringObject();
oEntryDoor = GetObjectByTag("ps_chessboard_door_enter",0);

if (!GetIsPC(oPC))
	{
	return;
	}
else if (PS_GetLocalInt(oEntryDoor, "FightStarted") == TRUE)
	{
	//SendMessageToPC(oPC, "Fight has already begun");
	return;
	}
else
	{
	oEnemyKing = GetObjectByTag("ps_monster_chess_king_enemy", 0);
	sSideChosen = PS_GetLocalString(oEnemyKing, "sChessSideChosen");
	//SendMessageToPC(oPC, "Starting with " + sSideChosen + " as ally and enemy king tag is " + GetTag(oEnemyKing));
	//SendMessageToPC(oPC, "You are standing on " + GetTag(OBJECT_SELF));
	if ((sSideChosen == "black" && GetTag(OBJECT_SELF) == "PS_chessboard_trigger_blackally")
		||
		(sSideChosen == "white" && GetTag(OBJECT_SELF) == "PS_chessboard_trigger_whiteally"))
		{
		PS_SetLocalInt(oEntryDoor, "FightStarted", TRUE);
		oCurrentArea = GetArea(oEnemyKing);
		oCurrentCreature = GetFirstObjectInArea(oCurrentArea);
		//SendMessageToPC(oPC, "In the faction set loop");
		
		while (GetIsObjectValid(oCurrentCreature) == TRUE)
    		{
			if 	(GetObjectType(oCurrentCreature) == OBJECT_TYPE_CREATURE)
				{
				if (GetStringRight(GetTag(oCurrentCreature), 4) == "ally")
					{
					SetPlotFlag(oCurrentCreature, 0);
					ChangeToStandardFaction(oCurrentCreature, STANDARD_FACTION_DEFENDER);
					}
				else if (GetStringRight(GetTag(oCurrentCreature), 5) == "enemy")
					{
					SetPlotFlag(oCurrentCreature, 0);
					ChangeToStandardFaction(oCurrentCreature, STANDARD_FACTION_HOSTILE);
					}
				}
				oCurrentCreature = GetNextObjectInArea(oCurrentArea);
    		}
		}
	}
}