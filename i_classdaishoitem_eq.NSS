// Only samurai can equip these weapons
// basically to stop someone creating a samurai, deleveling or recreating and still using the weapons

#include "ps_class_inc"

void main()
{
	object oPC = GetPCItemLastEquippedBy();
	object oItem = GetPCItemLastEquipped();
	int iLevel = GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
	
	if (iLevel == 0)
	{
		SendMessageToPC(oPC, "Only Samurai should possess this weapon and have the honour to wield it!");
		AssignCommand(oPC, ActionUnequipItem(oItem));
	}
}