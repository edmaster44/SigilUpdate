#include "ff_safevar"

// Mind Blade unequip script.
// By Electrohydra
// Last Edited 21/08/2015

#include "class_soulknife_global"

void main()
{
	object oWeapon = GetPCItemLastUnequipped();
	object oPC = GetPCItemLastUnequippedBy();
	DestroyObject(oWeapon);
	
	// Check if the player has another mind blade in hand and if so, delete it
	if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == MINDBLADE_TAG)
		DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
	if (GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) == MINDBLADE_TAG)
		DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
		
	// Remove active Mind Shield
	if(!GetUsingMindblade(oPC))
	{
		effect mindShield = GetFirstEffect(oPC);
		int amount = PS_GetLocalInt(oPC, VAR_MIND_SHIELD);
		while (GetIsEffectValid(mindShield))
		{
			int SpellID = GetEffectSpellId(mindShield);
		
			if (SpellID == FORM_MINDBLADE_TWO_HANDED
				|| SpellID == FORM_MINDBLADE_SINGLE
				|| SpellID == FORM_MINDBLADE_TWIN)
			{
				RemoveEffect(oPC, mindShield);
			}
			mindShield = GetNextEffect(oPC);
		}
	}
}