/*ga_enchant_ability
by Dedic8ed 5/8/11 for Sigil: City of Doors PW
Ability enchantment action pulled from a conversation

	nSlot: The inventory slot to be affected by the AC bonus. Note that different item types handle AC bonuses
		in different ways, such as amulets having natural AC, bracers having armor AC, and boots having dodge AC.
		The slots are as follows:
			0.	Head
			1.	Chest
			2.	Boots
			3.	Arms (glove)
			4.	Right Hand
			5.	Left Hand
			6.	Cloak
			7.	Left Ring
			8.	Right Ring
			9.	Neck
			10.	Belt
			11.	Arrows
			12.	Bullets
			13.	Bolts
			14.	Creature Weapon Left
			15.	Creature Weapon Right
			16.	Creature Bite
			17.	Creature Armor
	nAbility: The ability to be increased as per the following:
		0.	Strength
		1.	Dexterity
		2.	Constitution
		3.	Intelligence
		4.	Wisdom
		5.	Charisma
	nBonus: The numeric AC bonus to be given, i.e. 1 for +1, 2 for +2, etc.
*/

#include "ginc_param_const"
#include "x2_inc_itemprop"
#include "ginc_crafting"

void main(int nSlot, int nAbility, int nBonus)

{
object oPC = GetPCSpeaker();

object oTarget;
object oItem;
oTarget = oPC;

oItem = GetItemInSlot(nSlot, oTarget);

if (GetIsObjectValid(oItem) == TRUE)

	{
	itemproperty ipAdd;
	ipAdd = ItemPropertyAbilityBonus(nAbility, nBonus);

IPSafeAddItemProperty(oItem, ipAdd);
ActionUnequipItem(oItem);
ActionEquipItem(oItem, nSlot);
}
}