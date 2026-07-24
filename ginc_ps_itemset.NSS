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

// -FlatteFifth, Jan 30, 2026. Gave 5 dodge AC to all sets that include boots with no AC, boosted
// set properties that are lower than crafted max to be equal to crafted max (5 ability score instead of 4, etc)
// -FlatteFifth, July 23, 2026. Sometimes items, particularly if they've been in bags, get their resource reference
// truncated to 16 characters instead of 32. Added function GetIsSetItem() to determine whether an item belongs
// to a particular set even if the res refs are shortened.  We don't actually need to get the full resref
// because we can check by item slot and/or base item type. It's not like anyone can equip a bracer on their head.
 
#include "x2_inc_itemprop"

const int SET_DODGE_EFFECT_ID = 8675309; //Jenny's number
const int SET_SWORD_SAINT 	=	1;
const int SET_CELESTIAL		= 	2;
const int SET_ARBOREAL		= 	3;
const int SET_FALLEN_SHADOW	=	4;
const int SET_SLAAD			= 	5;
const int SET_IGGY			= 	6;
const int SET_BRAZEN		= 	7;
const int SET_FIGHTER		=	8;


void ApplySetBootsAC(object oItem, int nBonus);
void RemoveSetBootsAC(object oItem);
int GetIsSetItem(object oItem, int nSet);

//this function determines if the item is the item that gets the enchantments.
// This is used in i_ps_enchantmentfocus_ac.nss to prevent players from wasting
// coin and materials enchanting set items that have their item properties reset
int GetIsItemSetKey(object oItem){
	int nItem = GetBaseItemType(oItem);
	int nSet = GetLocalInt(oItem,"vSetID");
	switch (nSet){
		case SET_SWORD_SAINT: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_KATANA) return TRUE;
		case SET_CELESTIAL: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_AMULET) return TRUE;
		case SET_ARBOREAL: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_LONGBOW) return TRUE;
		case SET_FALLEN_SHADOW: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_ARMOR) return TRUE;
		case SET_SLAAD: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_CLOAK) return TRUE;
		case SET_IGGY: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_CLOAK) return TRUE;
		case SET_BRAZEN: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_ARMOR) return TRUE;
		case SET_FIGHTER: if (GetIsSetItem(oItem, nSet) && nItem == BASE_ITEM_BRACER) return TRUE;
	}
	return FALSE;
}

// This function determines if the item belongs to the given set. I've noticed that
// somehow items resource references are sometimes getting truncated to 16 characters
// so we will test against the first 16 characters and the item's name
int GetIsSetItem(object oItem, int nSet){
	
	string sRef = GetResRef(oItem);
	// first 11 will always be "ps_itemset_"
	if (GetStringLeft(sRef, 11) != "ps_itemset_")
		return FALSE;
	//get the first 16 characters of the resource reference
	sRef = GetStringLeft(sRef, 16);
	//now remove the first 11 since we already established what they are
	sRef = GetStringRight(sRef, 5);
	string sPattern;
	switch (nSet){
		case SET_SWORD_SAINT: sPattern = "sword"; break;
		case SET_CELESTIAL: sPattern = "celgl"; break;
		case SET_ARBOREAL: sPattern = "aarch"; break;
		case SET_FALLEN_SHADOW: sPattern = "falls"; break;
		case SET_SLAAD: sPattern = "slaad"; break;
		case SET_IGGY: sPattern = "iggwi"; break;
		case SET_BRAZEN: sPattern = "braze"; break;
		case SET_FIGHTER: sPattern = "fight"; break;
	}
	if (sRef == sPattern) return TRUE;
	return FALSE;
}


/* ///////////////////////////////////////////////////////////////////////////////////
Sword Saint Item Set
*/

void SwordSaint1Standard(object oItem) //applies to sword
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSetWeaponEnhancementBonus(oItem, 3, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(2,8), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyVampiricRegeneration(2), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void SwordSaint1Enhanced(object oItem)//applies to sword
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(778), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(786), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(788), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSetWeaponEnhancementBonus(oItem, 5, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(1,11), 0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyVampiricRegeneration(4), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Celestial Glory Item Set

void CelestialGloryEnhanced(object oItem) //amulet
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSafeAddItemProperty(oItem, ItemPropertyACBonus(6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(8,10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1283),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyLimitUseBySAlign(IP_CONST_ALIGNMENT_LG),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1272),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(ABILITY_CHARISMA, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void CelestialGloryStandard(object oItem) //amulet
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
	IPSafeAddItemProperty(oItem, ItemPropertyACBonus(4),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(8,6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
	IPSafeAddItemProperty(oItem, ItemPropertyLimitUseBySAlign(IP_CONST_ALIGNMENT_LG),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Arboreal Archer Item Set

void ArborealArcherEnhanced(object oItem, object oPC) // bow
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
		IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void ArborealArcherStandard(object oItem) //bow
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

void FallenShadowsEnhanced(object oItem) //armor
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(246, 10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageReduction(4, 11),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1083),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(733),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertySkillBonus(SKILL_HIDE, 20),0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertySkillBonus(SKILL_MOVE_SILENTLY, 20),0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		
	ApplySetBootsAC(oItem, 5);
}

void FallenShadowsStandard(object oItem) //armor
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(246, 8),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageReduction(2, 11),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		
	RemoveSetBootsAC(oItem);
}

///////////////////////////////////////////////////////////////////////////////
//Slaadskin Item Set

void SlaadskinEnhanced(object oItem) //cloak
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByAlign(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonusVsAlign(2, 8),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(9, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(283, 8),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		
		ApplySetBootsAC(oItem, 5);
}

void SlaadskinStandard(object oItem) //cloak
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyLimitUseByAlign(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(9, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 1),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		
		RemoveSetBootsAC(oItem);
}

///////////////////////////////////////////////////////////////////////////////
//Iggwilv Item Set

void IggwilvEnhanced(object oItem) //cloak
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(0, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(3, 6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 4),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(11),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyCastSpell(361, IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(834),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

void IggwilvVsGood(object oItem) //cloak
{
	IPSafeAddItemProperty(oItem, ItemPropertyDecreaseAbility(4, 6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);	
}

void IggwilvStandard(object oItem) //cloak
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(3, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSavingThrowVsX(0, 2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
}

///////////////////////////////////////////////////////////////////////////////
//Brazen Item Set

void BrazenEnhanced(object oItem) //armor
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(7),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(2, 6),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageResistance(10, 10),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusFeat(1171),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLight(3, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyDamageVulnerability(7, 3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyRegeneration(2),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		
		ApplySetBootsAC(oItem, 2);
}

void BrazenStandard(object oItem) // armor
{
	IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT);
		IPSafeAddItemProperty(oItem, ItemPropertyACBonus(3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyAbilityBonus(2, 3),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyBonusSpellResistance(0),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		IPSafeAddItemProperty(oItem, ItemPropertyLight(1, 5),0.0f,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
		
		RemoveSetBootsAC(oItem);
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

/* this set does not seem to exist any more -FlattedFifth
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
*/


//apply dodge ac to make up for lack of it on set boots
void ApplySetBootsAC(object oItem, int nBonus){
	object oOwner = GetItemPossessor(oItem);
	if (!GetIsObjectValid(oOwner)) return;
	effect eDodge = EffectACIncrease(nBonus);
	eDodge = SupernaturalEffect(eDodge);
	eDodge = SetEffectSpellId(eDodge, SET_DODGE_EFFECT_ID); 
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDodge, oOwner);
}

//remove dodge ac from set boots
void RemoveSetBootsAC(object oItem){
	object oOwner = GetItemPossessor(oItem);
	if (!GetIsObjectValid(oOwner)) return;
	
	effect eFX = GetFirstEffect(oOwner);
    while (GetIsEffectValid(eFX)) {
        if (GetEffectSpellId(eFX) == SET_DODGE_EFFECT_ID) {
            RemoveEffect(oOwner, eFX);
			return;
        }
        eFX = GetNextEffect(oOwner);
    }
}
///////////////////////////////////////////////////////////////////////////////