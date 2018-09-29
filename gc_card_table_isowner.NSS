/*********************************************************
* Script for Triple Triad like card game for SCoD        *
* by Agony_Aunt/Loki_999                                 *
* check to see if convo PC is owner of table             *
*********************************************************/

// also checks if owner exists, and returns true if they are missing allowing non-owner to destroy table.

#include "ps_inc_cards"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oBoard = OBJECT_SELF;
	
	return IsBoardOwner(oPC, oBoard);
}