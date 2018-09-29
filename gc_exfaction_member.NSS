/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/


// nFaction = 255 means quit quit/booted from faction.

#include "ps_inc_faction"

int GetFaction(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();

	int nFaction = GetFaction(oPC);
	
    if (nFaction == 255)
	{
		// They were kicked out, never to return to any faction.
		return TRUE;
	}
	else
	{
    	return FALSE;
	}

}