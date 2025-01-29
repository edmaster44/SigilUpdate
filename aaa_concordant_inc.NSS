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
	
	switch (nDex)
	{
		case 1:
		{ 
			if (nAlignGE != ALIGNMENT_GOOD)
			{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
			}
			if (nAlignGE != ALIGNMENT_EVIL)
			{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
			}
			if (nAlignLC != ALIGNMENT_LAWFUL)
			{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
			}
			if (nAlignLC != ALIGNMENT_CHAOTIC)
			{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
			}
			break;
		}
		case 2:
		{ 
			if (nAlignGE != ALIGNMENT_GOOD)
			{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
			}
			if (nAlignGE != ALIGNMENT_EVIL)
			{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
			}
			if (nAlignLC != ALIGNMENT_LAWFUL)
			{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
			}
			if (nAlignLC != ALIGNMENT_CHAOTIC)
			{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
			}
			break;
		}
		case 3:
		{ 
			if (nAlignGE != ALIGNMENT_GOOD)
			{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
			}
			if (nAlignGE != ALIGNMENT_EVIL)
			{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
			}
			if (nAlignLC != ALIGNMENT_LAWFUL)
			{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
			}
			if (nAlignLC != ALIGNMENT_CHAOTIC)
			{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
			}
			break;
		}
		case 4:
		{ 
			if (nAlignGE != ALIGNMENT_GOOD)
			{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
			}
			if (nAlignGE != ALIGNMENT_EVIL)
			{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
			}
			if (nAlignLC != ALIGNMENT_LAWFUL)
			{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
			}
			if (nAlignLC != ALIGNMENT_CHAOTIC)
			{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
			}
			break;
		}
		case 5:
		{ 
			if (nAlignGE != ALIGNMENT_GOOD)
			{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
			}
			if (nAlignGE != ALIGNMENT_EVIL)
			{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
			}
			if (nAlignLC != ALIGNMENT_LAWFUL)
			{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
			}
			if (nAlignLC != ALIGNMENT_CHAOTIC)
			{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
			}
			break;
		}
		case 6:
		{ 
			if (nAlignGE != ALIGNMENT_GOOD)
			{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
			}
			if (nAlignGE != ALIGNMENT_EVIL)
			{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
			}
			if (nAlignLC != ALIGNMENT_LAWFUL)
			{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
			}
			if (nAlignLC != ALIGNMENT_CHAOTIC)
			{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
			}
			break;
		}
	}
	
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	RemoveEffectsFromSpell(oPC, nSpell);
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
				eSacredG			= SupernaturalEffect(eSacredG);
		}
		else if (nStr = 2)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
		}
		else if (nStr = 3)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
		}
		else if (nStr = 4)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
		}
		else if (nStr = 5)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
		}
		else if (nStr = 6)
		{
				eSacredG		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredG			= VersusAlignmentEffect(eSacredG, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacredG			= SupernaturalEffect(eSacredG);
		}
	}
	if (nAlignGE != ALIGNMENT_EVIL)
	{
		if (nStr = 1)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
		}
		else if (nStr = 2)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
		}
		else if (nStr = 3)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
		}
		else if (nStr = 4)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
		}
		else if (nStr = 5)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
		}
		else if (nStr = 6)
		{
				eSacredE		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredE			= VersusAlignmentEffect(eSacredE, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacredE			= SupernaturalEffect(eSacredE);
		}
	}
	if (nAlignLC != ALIGNMENT_LAWFUL)
	{
		if (nStr = 1)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
		}
		else if (nStr = 2)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
		}
		else if (nStr = 3)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
		}
		else if (nStr = 4)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
		}
		else if (nStr = 5)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
		}
		else if (nStr = 6)
		{
				eSacredL		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredL			= VersusAlignmentEffect(eSacredL, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacredL			= SupernaturalEffect(eSacredL);
		}
	}
	if (nAlignLC != ALIGNMENT_CHAOTIC)
	{
		if (nStr = 1)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
		}
		else if (nStr = 2)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
		}
		else if (nStr = 3)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
		}
		else if (nStr = 4)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
		}
		else if (nStr = 5)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
		}
		else if (nStr = 6)
		{
				eSacredC		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacredC			= VersusAlignmentEffect(eSacredC, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacredC			= SupernaturalEffect(eSacredC);
		}
	}
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	eSacredC = SetEffectSpellId(eSacredC, nSpell);
	eSacredE = SetEffectSpellId(eSacredE, nSpell);
	eSacredG = SetEffectSpellId(eSacredG, nSpell);
	eSacredL = SetEffectSpellId(eSacredL, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredG, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredE, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredL, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredC, oPC);
}