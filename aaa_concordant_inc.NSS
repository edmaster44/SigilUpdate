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

effect ConcordantAbilityEffect(object oPC, int nSpell, int nAbility){

	int nMod = GetAbilityModifier(nAbility, oPC);
	int nCup = GetLevelByClass(116, oPC);
	if (nAbility > nCup) nMod = nCup;

	int nDmg;
	switch (nMod){
		case 1: nDmg = DAMAGE_BONUS_1; break;
		case 2: nDmg = DAMAGE_BONUS_2; break;
		case 3: nDmg = DAMAGE_BONUS_3; break;
		case 4: nDmg = DAMAGE_BONUS_4; break;
		case 5: nDmg = DAMAGE_BONUS_5; break;
		case 6: nDmg = DAMAGE_BONUS_6; break;
		default: nDmg = DAMAGE_BONUS_6; break;
	}
	
	effect eSacred = EffectSkillIncrease(SKILL_TUMBLE, 0);
	effect eTemp = EffectSkillIncrease(SKILL_TUMBLE, 0);
	int nAlignGE = GetAlignmentGoodEvil(oPC);
	int nAlignLC = GetAlignmentLawChaos(oPC);
	
	if (nAlignGE != ALIGNMENT_GOOD){
		eTemp = EffectDamageIncrease(nDmg, DAMAGE_TYPE_DIVINE);
		eTemp = VersusAlignmentEffect(eTemp, ALIGNMENT_ALL, ALIGNMENT_GOOD);
		eSacred = EffectLinkEffects(eTemp, eSacred);
	}
	if (nAlignGE != ALIGNMENT_EVIL){
		eTemp = EffectDamageIncrease(nDmg, DAMAGE_TYPE_DIVINE);
		eTemp = VersusAlignmentEffect(eTemp, ALIGNMENT_ALL, ALIGNMENT_EVIL);
		eSacred = EffectLinkEffects(eTemp, eSacred);
	}
	if (nAlignLC != ALIGNMENT_LAWFUL){
		eTemp = EffectDamageIncrease(nDmg, DAMAGE_TYPE_DIVINE);
		eTemp =	VersusAlignmentEffect(eTemp, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
		eSacred = EffectLinkEffects(eTemp, eSacred);
	
	}
	if (nAlignLC != ALIGNMENT_CHAOTIC){
		eTemp = EffectDamageIncrease(nDmg, DAMAGE_TYPE_DIVINE);
		eTemp =	VersusAlignmentEffect(eTemp, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
		eSacred = EffectLinkEffects(eTemp, eSacred);
	}
	
	eSacred = SetEffectSpellId(eSacred, nSpell);
	eSacred = SupernaturalEffect(eSacred);
	
	return eSacred;
}


// reworked by FlattedFifth, April 1, 2026
void PS_ConcordantPrecision(object oPC, int nSpell){

	effect eSacred = ConcordantAbilityEffect(oPC, nSpell, ABILITY_DEXTERITY);
	RemoveEffectsFromSpell(oPC, nSpell);
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
}

void PS_ConcordantProwess(object oPC, int nSpell){

	effect eSacred = ConcordantAbilityEffect(oPC, nSpell, ABILITY_STRENGTH);
	RemoveEffectsFromSpell(oPC, nSpell);
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacred, oPC);
}


/* original
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
	
	effect eSacredG = EffectSkillIncrease(SKILL_TUMBLE, 0);
	effect eSacredE = EffectSkillIncrease(SKILL_TUMBLE, 0);
	effect eSacredL = EffectSkillIncrease(SKILL_TUMBLE, 0);
	effect eSacredC = EffectSkillIncrease(SKILL_TUMBLE, 0);
	
	switch (nDex){
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
				//eSacredL			= SupernaturalEffect(eSacredL);
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
	
	
	
	RemoveEffectsFromSpell(oPC, nSpell);
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredG, oPC);
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredE, oPC);
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredL, oPC);
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredC, oPC);
	
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
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredG, oPC);
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredE, oPC);
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredL, oPC);
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSacredC, oPC);
}
*/