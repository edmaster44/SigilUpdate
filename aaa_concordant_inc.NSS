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
	if (nAlignGE != ALIGNMENT_GOOD)
	{
		if (nDex = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
	if (nAlignGE != ALIGNMENT_EVIL)
	{
		if (nDex = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
	if (nAlignLC != ALIGNMENT_LAWFUL)
	{
		if (nDex = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
		if (nAlignLC != ALIGNMENT_CHAOTIC)
	{
		if (nDex = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nDex = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
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
	if (nAlignGE != ALIGNMENT_GOOD)
	{
		if (nStr = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_GOOD);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
	if (nAlignGE != ALIGNMENT_EVIL)
	{
		if (nStr = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_ALL, ALIGNMENT_EVIL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
	if (nAlignLC != ALIGNMENT_LAWFUL)
	{
		if (nStr = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
		if (nAlignLC != ALIGNMENT_CHAOTIC)
	{
		if (nStr = 1)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 2)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 3)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_3, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 4)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 5)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_5, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
		else if (nStr = 6)
		{
			effect eSacred		= EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_DIVINE);
				eSacred			= VersusAlignmentEffect(eSacred, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
				eSacred			= ExtraordinaryEffect(eSacred);
		    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
		    RemoveEffectsFromSpell(OBJECT_SELF, nSpell);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
		}
	}
}