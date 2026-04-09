// Contains all the code nessessary for Shattering blows to function. This ability
// lets monks who hit a target twice in one roun with their fists to negate that
// target's DR.

// Included in x2_s3_onhitcast, x2_mod_def_equ, x2_mod_def_unequ

// By Michel Remillard/Electrohydra
// michel.remillard1@gmail.com
// Created : 12/30/2017
// Last Edit : 12/30/2017

#include "x2_inc_itemprop"
#include "ps_inc_onhit"

const int FEAT_SHATTERING_BLOWS = 2839;
const int SPELL_SHATTERING_BLOWS = 1837;

// Adds the property needed to register the hits
void SetGlovesOnHitProperty(object oPC)
{
	if (GetHasFeat(FEAT_SHATTERING_BLOWS, oPC, TRUE))
	{
		itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
		IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), ip, 999999.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
}

// Apply Shattering Fist
void ApplyShatteringBlows(object oPC, object oTarget)
{
	if (GetHasFeat(FEAT_SHATTERING_BLOWS, oPC, TRUE) && GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == OBJECT_INVALID)
	{
		if (!GetHasSpellEffect(SPELL_SHATTERING_BLOWS, oTarget))
		{
			effect eFirstBlow = ExtraordinaryEffect(EffectVisualEffect(-1, FALSE));
			eFirstBlow = SetEffectSpellId(eFirstBlow, SPELL_SHATTERING_BLOWS);
		
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFirstBlow, oTarget, 6.0f);
		}
		else
		{
			effect eDRNegation = ExtraordinaryEffect(EffectDamageReductionNegated());
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDRNegation, oTarget, 18.0f);
		}
	}
}