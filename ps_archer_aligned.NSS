#include "ps_inc_onhit" 

void main() {

	object oCaster = OBJECT_SELF;
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	if (!GetIsObjectValid(oItem)) //reject if we don't have a weapon equipped
		oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
	if (!GetIsObjectValid(oItem)) {
		SendMessageToPC(oCaster, "You must have a weapon equipped to use this ability.");
		return;
	}
	
	int itemType = GetBaseItemType(oItem);
	if (itemType != BASE_ITEM_HEAVYCROSSBOW && //reject for not being a ranged weapon
		itemType != BASE_ITEM_LIGHTCROSSBOW &&
		itemType != BASE_ITEM_SLING &&
		itemType != BASE_ITEM_LONGBOW  &&
		itemType != BASE_ITEM_SHORTBOW) {
		SendMessageToPC(oCaster, "You must be holding a ranged weapon to activate this feat!");
		return;	
	}
	
	if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)){ //cannot be already aligned bow
		SendMessageToPC(oCaster, "You may only have one type of alignment active at a time!");
		return;	
	}
	
    SignalEvent(GetItemPossessor(oItem), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	float fDuration = 86400.0f;
	effect eCast;
		
	if (GetHasFeat(2763, oCaster, TRUE))
	{
		if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD) {
			if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_LAWFUL) {
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			else if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_CHAOTIC) {
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			else
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			eCast	= EffectVisualEffect(VFX_HIT_SPELL_HOLY);
		}
		else if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL) {
			if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_LAWFUL) {
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			else if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_CHAOTIC) {
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			else
	   			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			eCast	= EffectVisualEffect(VFX_HIT_SPELL_EVIL);
		}
		else if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_LAWFUL) {
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			eCast	= EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
		}
		else if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_CHAOTIC) {
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			eCast	= EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
		}
		else {
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1),
							  		  fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			eCast	= EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
		}
	}
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
}