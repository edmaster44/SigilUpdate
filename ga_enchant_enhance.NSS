/*ga_enchant_enhance
by Dedic8ed 5/7/11 for Sigil: City of Doors PW
Weapon enhancement action pulled from a conversation

	nVar1: The numeric enhancement bonus to be given, i.e. 1 for +1, 2 for +2, etc.

*/

#include "ginc_param_const"
#include "x2_inc_itemprop"
#include "ginc_crafting"

void main(int nVar1)

{
object oPC = GetPCSpeaker();

object oTarget;
object oItem;
oTarget = oPC;

oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

if (GetIsObjectValid(oItem) == TRUE)

	{
	itemproperty ipAdd;
	ipAdd = ItemPropertyEnhancementBonus(nVar1);

IPSafeAddItemProperty(oItem, ipAdd);
ActionUnequipItem(oItem);
ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND);
}
}