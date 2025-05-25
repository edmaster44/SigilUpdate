

// i_ps_it_factionitem_drop_eq
/*
Created by Dedic8ed for the Sigil:City of Doors persistant world
Simply use the tag ps_it_factionitem_drop for any object which will use this script.
Set the variable "Faction" based upon the following list:

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

If the player is not a member of that faction, the item will refuse to be equipped.
*/
// Name_Date
#include "ps_inc_faction"

void main()
{
    object oPC      = GetPCItemLastEquippedBy();
    object oItem    = GetPCItemLastEquipped();
	int nObjfaction	= GetLocalInt(oItem, "Faction");
 	int nFaction = GetFaction(oPC);
	
	if(nFaction != nObjfaction) {
		AssignCommand(oPC, ActionUnequipItem(oItem));

		SetNoticeText(oPC,"The item does not seem to accept you as a user, twisting from your hand as you attempt to equip it.");
	}
	
}