#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"
#include "nwn2_inc_spells"
#include "x2_inc_itemprop"


//TODO: CHECK AND SEE IF WE CAN DO WITHOUT SOME OF THESE INCLUDES

const int CLASS_TYPE_MAGE_SLAYER = 70;



void main()
{
	object oPC = OBJECT_SELF;
	int nSpellId = GetSpellId();
	int nDamageBonus = (GetLevelByClass(CLASS_TYPE_MAGE_SLAYER, oPC) + 1) / 3;
	int nDamageType = DAMAGE_TYPE_POSITIVE;
	if (nSpellId == 14718) nDamageType = DAMAGE_TYPE_DIVINE;
	if (nSpellId == 14719) nDamageType = DAMAGE_TYPE_MAGICAL;
	effect eDam	= EffectDamageIncrease(nDamageBonus, nDamageType);
	eDam = ExtraordinaryEffect(eDam);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oPC);
}