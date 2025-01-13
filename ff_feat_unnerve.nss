#include "nw_i0_spells"
#include "ps_inc_functions"

const int UNNERVE_FEAT_ID = 21923;
const int UNNERVE_SPELL_ID = 14710;

void UnnerveTarget(object oTarget, object oPC, int nRoll){
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC) ||
		GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 3)
			return;
	
	// get the higher of the targets concentration and will, and then roll that and size.
	int nMod = GetSkillRank(SKILL_CONCENTRATION, oTarget);
	int nAlt = GetWillSavingThrow(oTarget);
	if (nAlt > nMod) nMod = nAlt;
	nMod += GetCreatureSize(oTarget);
	int nTargetRoll = d20(1);
	int nAdvantage = 0;
	
	// if the target has this feat also they get advantage on their roll to resist
	if (GetHasFeat(UNNERVE_FEAT_ID, oTarget, TRUE)){
		nAdvantage = d20(1);
		if (nAdvantage > nTargetRoll) nTargetRoll = nAdvantage;
	}
	
	nTargetRoll += nMod;
	
	// if the pc rolled twice as high, -3 penalties to target for 3 rounds, 
	// if success -2 penalties for 2 rounds. no effect ofc if lower than or equal to
	int nPenalty = 0;
	if (nRoll >= nTargetRoll * 2) nPenalty = 3;
	else if (nRoll > nTargetRoll) nPenalty = 2;
	
	if (nPenalty > 0){
		effect eAt = EffectAttackDecrease(nPenalty);
		effect eDam = EffectDamageDecrease(nPenalty);
		effect eAc = EffectACDecrease(nPenalty);
		effect eSav = EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty);
		eAt = EffectLinkEffects(eDam, eAt);
		eAt = EffectLinkEffects(eAc, eAt);
		eAt = EffectLinkEffects(eSav, eAt);
		eAt = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE), eAt);
		eAt = SetEffectSpellId(eAt, UNNERVE_SPELL_ID);
		float fDur = IntToFloat(6 * nPenalty);
		RemoveEffectsFromSpell(oPC, UNNERVE_SPELL_ID);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAt, oTarget, fDur);
	}
}

void main(){
	object oPC = OBJECT_SELF;
	location lLoc = GetLocation(oPC);
	
	// get the higher of the pc's intimidate and taunt, then roll it + their size
	int nRoll = GetSkillRank(SKILL_INTIMIDATE, oPC);
	int nAlt = GetSkillRank(SKILL_TAUNT, oPC);
	if (nAlt > nRoll) nRoll = nAlt;
	nRoll += d20(1) + GetCreatureSize(oPC); 
	
	float fDist;
	
	int bValidTarget = FALSE;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 15.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget)){
		fDist = PS_GetDistanceBetween(oPC, oTarget);
		if (GetIsEnemy(oTarget, oPC) && fDist <= 5.0f && fDist > -1.0f){
			if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC) &&
				GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3){
					bValidTarget = TRUE;
					UnnerveTarget(oTarget, oPC, nRoll);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 15.0f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	if (!bValidTarget) ResetFeatUses(oPC, UNNERVE_FEAT_ID, TRUE, TRUE);
}