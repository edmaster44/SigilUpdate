/*
gc_invslot_equipped by Dedic8ed for the Sigil: City of Doors PW

Checks to see if a creature item is equipped in the right hand slot.

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
int StartingConditional()
{
   object oPC = GetPCSpeaker();

   object oItem = GetItemInSlot(4, oPC);
	if (GetIsObjectValid(oItem)==TRUE && (GetBaseItemType(oItem)==160||
			GetBaseItemType(oItem)==161 || GetBaseItemType(oItem)==162 ||
			GetBaseItemType(oItem)==163 || GetBaseItemType(oItem)==164 ||
			GetBaseItemType(oItem)==165 || GetBaseItemType(oItem)==166 ||
			GetBaseItemType(oItem)==167 || GetBaseItemType(oItem)==168 ||
			GetBaseItemType(oItem)==169 || GetBaseItemType(oItem)==170 ||
			GetBaseItemType(oItem)==171 || GetBaseItemType(oItem)==172 ||
			GetBaseItemType(oItem)==173 || GetBaseItemType(oItem)==174 ||
			GetBaseItemType(oItem)==175 || GetBaseItemType(oItem)==176 ||
			GetBaseItemType(oItem)==177 ))
   {
		return TRUE;
   }

    return FALSE;

}