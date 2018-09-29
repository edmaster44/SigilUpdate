// Stops the Barbarian from unequipping the ancestor axe while raging

void main()
{
	object oWeapon = GetPCItemLastUnequipped();
	object oPC = GetPCItemLastUnequippedBy();
	AssignCommand(oPC, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
}