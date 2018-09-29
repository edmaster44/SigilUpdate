/*ga_enchant_damage
by Dedic8ed 5/7/11 for Sigil: City of Doors PW
Weapon enhancement action pulled from a conversation

	nDamage: The type of damage to be applied to the weapon, chosen from the following list:
		0.	Bludgeoning
		1.	Piercing
		2.	Slashing
		4.	Physical
		5.	Magical
		6.	Acid
		7.	Cold
		8.	Divine
		9.	Electrical
		10.	Fire
		11.	Negative
		12.	Positive
		13.	Sonic
	
	nBonus: The amount of the damage bonus, chosen from the following list:
		1.	+1
		2.	+2
		3.	+3
		4.	+4
		5.	+5
		6.	1d4
		7.	1d6
		8.	1d8
		9.	1d10
		14.	1d12
*/

#include "ginc_param_const"
#include "x2_inc_itemprop"
#include "ginc_crafting"

void main(int nDamage, int nBonus)

{
object oPC = GetPCSpeaker();

object oTarget;
object oItem;
oTarget = oPC;

oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

if (GetIsObjectValid(oItem) == TRUE)

	{
	itemproperty ipAdd;
	ipAdd = ItemPropertyDamageBonus(nDamage, nBonus);

IPSafeAddItemProperty(oItem, ipAdd);
ActionUnequipItem(oItem);
ActionEquipItem(oItem,INVENTORY_SLOT_RIGHTHAND);
}
}

// 