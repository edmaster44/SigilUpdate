#include "ff_safevar"

/* v1.00 Checks faction on the Essence object

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

*/

void main()
{
	object oPC = OBJECT_SELF;
	
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
		int nFaction = PS_GetLocalInt(oItem,"Faction");
		string sFaction = "";
		
		switch(nFaction)
		{
			case 0: 
				sFaction = "not decided yet";
				break;
			case 1:
				sFaction = "Prime";
				break;
			case 2:
				sFaction = "Free League";
				break;
			case 3:
				sFaction = "Athar";
				break;
			case 4:
				sFaction = "Believers of the Source";
				break;
			case 5:
				sFaction = "Bleak Cabal";
				break;
			case 6:
				sFaction = "Doomguard";
				break;
			case 7:
				sFaction = "Dustmen";
				break;
			case 8:
				sFaction = "Fated";
				break;
			case 9:
				sFaction = "Fraternity of Order";
				break;
			case 10:
				sFaction = "Harmonium"; 
				break;
			case 11:
				sFaction = "Mercykillers";
				break;
			case 12:
				sFaction = "Revolutionary League";
				break;
			case 13:
				sFaction = "Sign of One";
				break;
			case 14:
				sFaction = "Society of Sensation";
				break;
			case 15:
				sFaction = "Transcendent Order";
				break;
			case 16:
				sFaction = "Xaositects";
				break;
			case 17:
				sFaction = "None";
				break;
			case 18:
				sFaction = "undecided";
				break;
		}
		
		SendMessageToPC(oPC,"Your faction is " + sFaction);
		
		return;
    }
}