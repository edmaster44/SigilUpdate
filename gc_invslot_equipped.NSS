/*
gc_invslot_equipped by Dedic8ed for the Sigil: City of Doors PW

Checks to see if an item is equipped in the selected slot. If the slot has no item, FALSE is returned.

The slots are as follows:
	0.	Head
	1.	Chest
	2.	Boots
	3.	Arms
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
	14.	Creature Weapon - Left
	15.	Creature Weapon - Right
	16.	Creature Weapon - Bite
	17.	Creature Armor
*/
int StartingConditional(int iSlot)
{
   object oPC = GetPCSpeaker();

   object oItem = GetItemInSlot(iSlot, oPC);
   while(GetIsObjectValid(oItem))
   {
		return TRUE;
   }

    return FALSE;

}