//Get whether the PC is in a valid faction - same as gc_has_faction, really
#include "ps_inc_faction"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

	int nFaction = GetFaction(oPC);
	
    if ( GetIsFaction(nFaction) ) return TRUE;

    return FALSE;

}