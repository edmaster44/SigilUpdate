/*ga_enchant_creatureweap
by Dedic8ed 11/24/14 for Sigil: City of Doors PW
Creature weapon material change action pulled from a conversation

	nMat: The row from iprp_materials.2da of the material to be applied to the creature item.
		1. Adamantine
		2. Cold Iron
		3. Darksteel
		4. Iron
		5. Mithral
		6. Alchemical Silver

*/

#include "ginc_param_const"
#include "x2_inc_itemprop"
#include "ginc_crafting"

void main(int nMat)

{
object oPC = GetPCSpeaker();

object oTarget;
object oItem;
oTarget = oPC;

oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

if (GetIsObjectValid(oItem)==TRUE && (GetBaseItemType(oItem)==160||
			GetBaseItemType(oItem)==161 || GetBaseItemType(oItem)==162 ||
			GetBaseItemType(oItem)==163 || GetBaseItemType(oItem)==164 ||
			GetBaseItemType(oItem)==165 || GetBaseItemType(oItem)==166 ||
			GetBaseItemType(oItem)==167 || GetBaseItemType(oItem)==168 ||
			GetBaseItemType(oItem)==169 || GetBaseItemType(oItem)==170 ||
			GetBaseItemType(oItem)==171 || GetBaseItemType(oItem)==172 ||
			GetBaseItemType(oItem)==173 || GetBaseItemType(oItem)==174 ))
	{
SetItemBaseMaterialType(oItem, nMat);
ActionUnequipItem(oItem);
ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND);
}
}