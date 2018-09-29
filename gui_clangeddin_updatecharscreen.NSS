//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2015
//:://////////////////////////////////////////////

void main(string sCLASS)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oARMOR = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	string sARMOR = "Armor: " + GetName(oARMOR);
	SetGUIObjectText(oPC, "SCREEN_CHARACTER", "ARMOR_TEXT", -1, sARMOR);
}