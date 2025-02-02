#include "ff_safevar"

/*

1 - Prime
2 - Free League
3 - Athar
4 - Believers of the Source
5 - Bleak Cabal
6 - Doomguard
7 - Dustmen
8 - Fated
9 - Fraternity of Order
10- Harmonium
11- Mercykillers
12- Revolutionary League
13- Sign of One
14- Society of Sensation
15- Transcendent Order
16- Xaositects
17- None
18- Undecided
255 - Booted/quit from faction
*/

#include "ps_inc_faction"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oStoredBadge = PS_GetLocalObject(oPC, "FactionBadgeUsed");
	int iRank = PS_GetLocalInt(oStoredBadge, "FactionRank");
	int nFaction = PS_GetLocalInt(oStoredBadge,"Faction");
	
	if (nFaction == 3 && iRank >= 5) //Athar
		return TRUE;
	else if (nFaction == 6 && iRank >= 6) //Doomguard
		return TRUE;
	else if (nFaction == 7 && iRank >= 7) //Dustmen
		return TRUE;
	else if (nFaction == 9 && iRank >= 12) //Guvner
		return TRUE;
	else if (nFaction == 10 && iRank >= 12) //HArmonium
		return TRUE;
	else if (nFaction == 11 && iRank >= 4) //Mercykillers
		return TRUE;
	else if (nFaction == 12 && iRank >= 4) //Revs
		return TRUE;
	else if (nFaction == 15 && iRank >= 4) //Cipher
		return TRUE;
	else if (nFaction == 1 || nFaction == 2 || nFaction == 4 || nFaction == 5 ||
			nFaction == 8  || nFaction == 13 || nFaction == 14) {
		if (iRank >= 3)
			return TRUE;
		else
			return FALSE;
	}	
	else
		return FALSE;
	
}