#include "ginc_2da"
#include "x2_inc_switches"

void main()
{
	object oTarget = GetSpellTargetObject();
	
	if (GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
	{
		SendMessageToPC(OBJECT_SELF, "Must target a scroll.");
		ResetFeatUses(OBJECT_SELF, GetSpellId(), FALSE, TRUE);
		return;
	}
	
	int targetType = GetBaseItemType(oTarget);
	if (targetType != BASE_ITEM_SCROLL && targetType != BASE_ITEM_ENCHANTED_SCROLL && targetType != BASE_ITEM_SPELLSCROLL)
	{
		SendMessageToPC(OBJECT_SELF, "Target must be a spell scroll.");
		ResetFeatUses(OBJECT_SELF, GetSpellId(), FALSE, TRUE);
		return;
	}
	
	
	itemproperty property = GetFirstItemProperty(oTarget);
	while (GetItemPropertyType(property) != ITEM_PROPERTY_CAST_SPELL)
	{
		if (!GetIsItemPropertyValid(property))
		{
			SendMessageToPC(OBJECT_SELF, "No spells found.");
			return;
		}
		property = GetNextItemProperty(oTarget);
	}
	
	int spellProperty = GetItemPropertySubType(property);
	
	int spellID = Get2DAInt("iprp_spells", "SpellIndex", spellProperty);
	
	effect spellImmunity = SupernaturalEffect(EffectSpellImmunity(spellID));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, spellImmunity, OBJECT_SELF, HoursToSeconds(24));
}