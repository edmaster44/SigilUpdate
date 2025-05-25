

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
	object oStoredBadge = GetLocalObject(oPC, "FactionBadgeUsed");
	int iRank = GetLocalInt(oStoredBadge, "FactionRank");
	int nFaction = GetLocalInt(oStoredBadge,"Faction");
	
	if ((nFaction == 2 || nFaction == 6 || nFaction == 7 || nFaction == 11 || nFaction == 12 || nFaction == 15) && 
	(iRank >= 2 && iRank <= 3)) //Free League / Doomguard / Dustmen / Mercykillers / Anarchists / Transcendent Order
		return TRUE;
	else if (nFaction == 3 && (iRank >= 2 && iRank <= 4)) //Athar 
		return TRUE;
	else if ((nFaction == 4 || nFaction == 5 || nFaction == 8 || nFaction == 13 || nFaction == 14 || nFaction == 16) 
	&& iRank == 2) //Believers of the Source / Bleak Cabal / Fated
		return TRUE;
	else if (nFaction == 9 && (iRank >= 2 && iRank <= 11))
		return TRUE;
	else if (nFaction == 10 && (iRank >= 7 && iRank <= 11))
		return TRUE;
		
	return FALSE;
	
}