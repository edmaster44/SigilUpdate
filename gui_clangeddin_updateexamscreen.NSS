//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2015
//:://////////////////////////////////////////////

void main(string sCLASS)
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oNPC = GetPlayerCreatureExamineTarget(oPC);
	object oARMOR = GetItemInSlot(INVENTORY_SLOT_CHEST, oNPC);
	string sARMOR = "Armor: " + GetName(oARMOR);
	SetGUIObjectText(oPC, "SCREEN_CREATUREEXAMINE", "ARMOR_TEXT", -1, sARMOR);
}