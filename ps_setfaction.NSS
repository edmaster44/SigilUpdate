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
#include "ps_inc_achievements"

void main(int nFaction)
{
   object oPC = GetPCSpeaker();
   
   object oItem = GetItemPossessedBy(oPC,"ps_essence");
   if(GetIsObjectValid(oItem))
   {
		SetLocalInt(oItem,"Faction",nFaction);
   }
   
   // Faction Badge granting and setup
   if ((nFaction > 1) & (nFaction < 17))
   {
   		object oBadge = CreateItemOnObject("ps_faction_badge", oPC);
		
		if (GetIsObjectValid(oBadge))
		{
			SetBadgeFaction(oBadge, nFaction);
			AddAchievement(oPC, 2);
		}
		else
		{
			SendMessageToPC(oPC, FACTION_MESSAGE_TEXT_COLOUR + "ERROR: No badge created");
		}	
   }
}