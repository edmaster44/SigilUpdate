#include "nw_i0_spells"
const int UNNERVE_FEAT_ID = 21923;
const int UNNERVE_SPELL_ID = 14710;

void main(){
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int bReapply = GetHasSpellEffect(UNNERVE_SPELL_ID, oTarget);
	int nPenalty = 0;
	string sMessage = "Attempting to Unnerve Target: ";
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oPC) ||
		GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 3){
		SendMessageToPC(oPC, sMessage + "Target Immune!");
		return;
	} else if (GetDistanceBetween(oPC, oTarget) > 5.0f){
		SendMessageToPC(oPC, sMessage + "Target out of range!");
		ResetFeatUses(oPC, UNNERVE_FEAT_ID, FALSE, TRUE);
		return;
	} else {
		// get the higher of the pc's intimidate and taunt, then roll it + their size + cha
		int nRoll = GetSkillRank(SKILL_INTIMIDATE, oPC);
		int nAlt = GetSkillRank(SKILL_TAUNT, oPC);
		if (nAlt > nRoll) nRoll = nAlt;
		int nPCroll = d20(1) + nRoll + GetCreatureSize(oPC);
		
		// get the higher of the targets concentration and will, and then roll that.
		nRoll = GetSkillRank(SKILL_CONCENTRATION, oTarget);
		nAlt = GetWillSavingThrow(oTarget);
		if (nAlt > nRoll) nRoll = nAlt;
		int nTargetRoll = d20(1) + nRoll + GetCreatureSize(oTarget);
		
		// if the pc rolled twice as high, -3 penalties to target for 3 rounds, 
		// for 2 rounds. no effect ofc if lower than or equal to
		if (nPCroll >= nTargetRoll * 2){
			sMessage = "Target Completely Unnerved!";
			nPenalty = 3;
		} else if (nPCroll > nTargetRoll){
			sMessage += "Target Unnerved!";
			nPenalty = 2;
		} else sMessage = "Unnerve Failed!";
	}
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
		if (bReapply) RemoveEffectsFromSpell(oPC, UNNERVE_SPELL_ID);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAt, oTarget, fDur);
	}
	FloatingTextStringOnCreature(sMessage, oPC);
	AssignCommand(oPC, ClearAllActions(FALSE));
	DelayCommand(0.2f,AssignCommand(oPC, ActionAttack(oTarget)));
}