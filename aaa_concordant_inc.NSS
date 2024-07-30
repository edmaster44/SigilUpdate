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

void PS_ConcordantPrecision(object oPC, int nSpell)
{
	int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	int nCup = GetLevelByClass(116, oPC);
	if (nDex > nCup)
	{
		nDex = nCup;
	}
	int nAlignGE = GetAlignmentGoodEvil(oPC);
	int nAlignLC = GetAlignmentLawChaos(oPC);
	
	effect eSacredG;
	effect eSacredE;
	effect eSacredL;
	effect eSacredC;
	
	if (nAlignGE != ALIGNMENT_GOOD)
	{
		if (nDex = 1)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nDex = 2)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nDex = 3)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nDex = 4)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nDex = 5)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nDex = 6)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
	}
	if (nAlignGE != ALIGNMENT_EVIL)
	{
		if (nDex = 1)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nDex = 2)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nDex = 3)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nDex = 4)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nDex = 5)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nDex = 6)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
	}
	if (nAlignLC != ALIGNMENT_LAWFUL)
	{
		if (nDex = 1)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nDex = 2)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nDex = 3)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nDex = 4)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nDex = 5)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nDex = 6)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
	}
	if (nAlignLC != ALIGNMENT_CHAOTIC)
	{
		if (nDex = 1)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nDex = 2)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nDex = 3)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nDex = 4)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nDex = 5)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nDex = 6)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
	}
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredG, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredE, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredL, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredC, oPC);
}
void PS_ConcordantProwess(object oPC, int nSpell)
{
	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nCup = GetLevelByClass(116, oPC);
	if (nStr > nCup)
	{
		nStr = nCup;
	}
	int nAlignGE = GetAlignmentGoodEvil(oPC);
	int nAlignLC = GetAlignmentLawChaos(oPC);
	
	effect eSacredG;
	effect eSacredE;
	effect eSacredL;
	effect eSacredC;
	
	if (nAlignGE != ALIGNMENT_GOOD)
	{
		if (nStr = 1)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nStr = 2)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nStr = 3)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nStr = 4)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nStr = 5)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
		else if (nStr = 6)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= ExtraordinaryEffect(eSacredG);
		}
	}
	if (nAlignGE != ALIGNMENT_EVIL)
	{
		if (nStr = 1)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nStr = 2)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nStr = 3)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nStr = 4)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nStr = 5)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
		else if (nStr = 6)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= ExtraordinaryEffect(eSacredE);
		}
	}
	if (nAlignLC != ALIGNMENT_LAWFUL)
	{
		if (nStr = 1)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nStr = 2)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nStr = 3)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nStr = 4)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nStr = 5)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
		else if (nStr = 6)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= ExtraordinaryEffect(eSacredL);
		}
	}
	if (nAlignLC != ALIGNMENT_CHAOTIC)
	{
		if (nStr = 1)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nStr = 2)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nStr = 3)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nStr = 4)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nStr = 5)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
		else if (nStr = 6)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= ExtraordinaryEffect(eSacredC);
		}
	}
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredG, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredE, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredL, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredC, oPC);
}