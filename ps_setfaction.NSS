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
19- Ring-Givers
255 - Booted/quit from faction
*/

#include "ps_inc_faction"
#include "ps_inc_achievements"

void main(int nFaction)
{
   object oPC = GetPCSpeaker();
   
   // Faction Badge granting and setup
   if (GetIsFaction(nFaction)){
   
   		JoinFaction(oPC, nFaction);
   		AddAchievement(oPC, 2);
		
   }
}