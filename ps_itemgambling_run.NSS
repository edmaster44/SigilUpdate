

#include "ps_randomlootgenerator"

const int increasePerLevel = 175;
// must cost this much at least, to avoid exploit where you buy for less than it sells
const int minimumPrice = 350;

void main(int nType)
{
	object oPC = ((GetPCSpeaker() == OBJECT_INVALID) ? OBJECT_SELF : GetPCSpeaker());
	int itemPrice = GetLocalInt(oPC, "SRLG_PRICE");
	string convoFeedback = "";
	if(itemPrice == 0) {
		int pcLevel = GetTotalLevels(oPC, 0);
		switch(nType) {
			case SRLG_ITEMTYPE_CLOTHING:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_PADDEDARMOR:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_LEATHERARMOR:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_STUDDEDLEATHERARMOR:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_CHAINSHIRT:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_HIDEARMOR:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SCALEMAIL:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_CHAINMAIL:	itemPrice = 150 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_BREASTPLATE:	itemPrice = 200 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SPLINTMAIL:	itemPrice = 200 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_BANDEDMAIL:	itemPrice = 250 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_HALFPLATE:	itemPrice = 600 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_FULLPLATE:	itemPrice = 1500 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_LIGHTSHIELD:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_HEAVYSHIELD:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_TOWERSHIELD:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_DAGGER:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SICKLE:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_HANDAXE:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_KUKRI:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SHORTSWORD:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_KAMA:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_BATTLEAXE:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_LONGSWORD:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_RAPIER:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SCIMITAR:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_BASTARDSWORD:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_DWARVENWARAXE:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_KATANA:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_FALCHION:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_GREATAXE:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_GREATSWORD:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_MACE:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_LIGHTHAMMER:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_CLUB:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_MORNINGSTAR: itemPrice = 0 + pcLevel * increasePerLevel;	 break;
			case SRLG_ITEMTYPE_WARHAMMER:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_FLAIL:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_WARMACE:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_HALBERD:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SCYTHE:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_QUARTERSTAFF:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SPEAR:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_LONGBOW:	itemPrice = 200 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SHORTBOW:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_HEAVYCROSSBOW:	itemPrice = 100 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_LIGHTCROSSBOW:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_SLING:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_BOOTS:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_CLOAK:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_GLOVES:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_BELT:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_HAT:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_RING:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_AMULET:	itemPrice = 0 + pcLevel * increasePerLevel; break;
			case SRLG_ITEMTYPE_BRACERS:	itemPrice = 0 + pcLevel * increasePerLevel; break;
		}
		itemPrice = itemPrice + Random(50);
		if(itemPrice < minimumPrice)
			itemPrice = minimumPrice;
		SetLocalInt(oPC, "SRLG_PRICE", itemPrice);
		convoFeedback = "Alright basher, my price is " + IntToString(itemPrice) + " jink. Take it or leave it, no refunds, and you got to decide right now. You want it?";
	}
	else {
		convoFeedback = "Alright, I will take your lottery ticket for it. You want it?";
	}

	SetCustomToken(12345, convoFeedback);
	SetLocalInt(oPC, "SRLG_TYPE", nType);
}