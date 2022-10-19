//ginc_ps_itemset

/*	Script by Dedic8ed
	Created for use in the Sigil: City of Doors PW
	Thanks to the two scripters who gave me the basis to start from: Apep (Item Sets Minipack) and Mithridates (Nasher Items Fix)
	
	Inclusion script for i_ps_itemset_eq and i_ps_itemset_ue

	To add additional item sets, create "Standard" and "Enhanced" versions for each item that will be boosted by having the complete
	set. If more than one item will be boosted, note the "Sword Saint" set for examples. "Standard" versions should always begin with
	the IPRemoveAllItemProperties, to ensure that all bonuses are purged on unequip. The "Enhanced" should be called by the on equip
	script, while the "Standard" ones are called by the on unequip script.
	
	Note: the sets included here are dependent upon the updated iprp_feats.2da in use by the Sigil: City of Doors PW. Many of the granted
	feats are not among those included with the base version of this script; should this be used independently of SCoD, most of the
	granted feats will need to be altered.
*/

#include "x2_inc_itemprop"

/* ///////////////////////////////////////////////////////////////////////////////////
Sword Saint Item Set
*/

void SwordSaint1Standard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSetWeaponEnhancementBonus(oItem, 3, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(2,8), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyVampiricRegeneration(2), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void SwordSaint1Enhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(778), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(786), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(788), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSetWeaponEnhancementBonus(oItem, 5, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(1,11), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyVampiricRegeneration(4), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Celestial Glory Item Set

void CelestialGloryEnhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSafeAddItemProperty(oItem, ItemPropertyACBonus(6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(8,10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1283),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyLimitUseBySAlign(IP_CONST_ALIGNMENT_LG),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1272),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void CelestialGloryStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSafeAddItemProperty(oItem, ItemPropertyACBonus(4),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(8,6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyLimitUseBySAlign(IP_CONST_ALIGNMENT_LG),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Arboreal Archer Item Set

void ArborealArcherEnhanced(object oItem, object oPC)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		// Add weapon-specific properties
		IPSafeAddItemProperty(oItem, ItemPropertyUnlimitedAmmo(8),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyMaxRangeStrengthMod(5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(4),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);	
		SendMessageToPC(oPC, "Weapon features added.");
		// Add WF and WS
		DelayCommand(0.5, IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(420),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE));
		DelayCommand(0.6, IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(229),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE));
		DelayCommand(0.7, SendMessageToPC(oPC, "Weapon Focus and Specialization added."));
		// Add GWF and GWS
		DelayCommand(1.0, IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(318),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE));
		DelayCommand(1.1, IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(358),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE));
		DelayCommand(1.2, SendMessageToPC(oPC, "Greater Weapon Focus and Specialization added."));
		// Add Rapid Shot
		DelayCommand(2.0, IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(30),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE));
		DelayCommand(2.1, SendMessageToPC(oPC, "Rapid Shot added."));
		// Add Improved Rapid Shot
		DelayCommand(3.0, IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(184),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE));
		DelayCommand(3.1, SendMessageToPC(oPC, "Improved Rapid Shot added."));
}

void ArborealArcherStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(229),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(420),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(30),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyMaxRangeStrengthMod(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByRace(4),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Fallen Shadows Item Set

void FallenShadowsEnhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(246, 10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageReduction(4, 11),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1083),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(733),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void FallenShadowsStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(246, 8),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageReduction(2, 11),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Slaadskin Item Set

void SlaadskinEnhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByAlign(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonusVsAlign(2, 8),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(9, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(283, 8),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void SlaadskinStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByAlign(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(9, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Iggwilv Item Set

void IggwilvEnhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(0, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(3, 6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 4),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(11),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(361, IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(834),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void IggwilvVsGood(object oItem)
{
	IPSafeAddItemProperty(oItem, ItemPropertyDecreaseAbility(4, 6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);	
}

void IggwilvStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(3, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(0, 2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Brazen Item Set

void BrazenEnhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(7),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(2, 6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1171),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLight(3, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageVulnerability(7, 3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void BrazenStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(2, 3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(0),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLight(1, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Fighter-Specific Item Set

void FighterSpecEnhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL,6);
		ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PHYSICAL,10);
		ItemPropertyBonusSpellResistance(10);
		ItemPropertyCastSpell(131,8);
		ItemPropertyCastSpell(455,8);
		ItemPropertyLimitUseByClass(4);		
}

void FighterSpecStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4);
		ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PHYSICAL,5);
		ItemPropertyBonusSpellResistance(5);
		ItemPropertyLimitUseByClass(4);
}

///////////////////////////////////////////////////////////////////////////////
//Divine Champion-Specific Item Set

void ChampSpecEnhanced(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL,6);
		ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PHYSICAL,10);
		ItemPropertyBonusSpellResistance(10);
		ItemPropertyCastSpell(131,8);
		ItemPropertyCastSpell(455,8);
		ItemPropertyLimitUseByClass(4);		
}

void ChampSpecStandard(object oItem)
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4);
		ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PHYSICAL,5);
		ItemPropertyBonusSpellResistance(5);
		ItemPropertyLimitUseByClass(4);
}

///////////////////////////////////////////////////////////////////////////////