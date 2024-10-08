/* Checks character for membership in specified faction, returns TRUE or FALSE

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
19- Ring-Givers

*/

#include "ginc_misc"
#include "ps_inc_faction"

int StartingConditional(int iFaction)
{
	object oPC = GetPCSpeaker();

	int nFaction = GetFaction(oPC);

	return (nFaction == iFaction);
}