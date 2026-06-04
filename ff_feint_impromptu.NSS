/* 
	New Feint and impromptu, by FlattedFifth, June 3, 2026
	impromptu Sneak Attack is now removed and in its place is a wrapper that gives the hardcoded og
	feat to the player, fires it, and then removes it. Why? Because this way we can do the same thing
	with a custom version of Feint (which is also hardcoded).
	
	New impromptu = simply adds the og version, fires it against target, then removes it.
	New Feint = Opposed roll, attacker 1d20 + BAB + Bluff vs defender 1d20 + BAB + the higher of Spot or Concentration. Defender gets a +3 bonus to roll for every time beyond the first that the attacker tries 
	to Feint against them. This bonus wears off after 5 minutes. If the attacker succeeds, then the attacker
	gets og impromptu, fires it, and then it's removed again.
*/

// , finish setting up 2das, make sure all are instant feats
// don't forget to replace impromptu and feint in 2das for thug, arcane trickster, and invis blade req
// also don't forget to give 30 second cooldown to new feint
// og feint = 1098, new 3371
// og impromptu = 1510, og 2 = 1511, new = 3372, new2 = 3373
// also update tlk for feint and feint mastery

#include "ps_inc_functions"

const int NEW_IMPROMPTU_SPELL_ID = 1959; 
const int NEW_IMPROMPTU_FEAT_ID_1 = 3372;
const int NEW_IMPROMPTU_FEAT_ID_2 = 3373; 
const int NEW_FEINT_SPELL_ID = 1960;
const int NEW_FEINT_FEAT_ID = 3371;
const int INVIS_BLADE_FEINT_MASTERY = 2051;
const int FEINT_ATTEMPT_MULTIPLIER = 3; // defender gets this much bonus to roll per attacker's attempt beyond 1st

void RollNewFeint(object oPC, object oTarget);
void RollNewImpromptu(object oPC, object oTarget);
void DoNewImpromptuOrFeint(object oPC, object oTarget, int bFeint = FALSE);
void RemoveFeintAttemptTracking(object oTarget, string sFeintId);

void main(){
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nId = GetSpellId();
	
	if (!PS_GetTargetInRange(oPC, oTarget)){
		SendMessageToPC(oPC, "Target out of range!");
		int nResetFeat;
		if (nId == NEW_IMPROMPTU_SPELL_ID){
			if (GetHasFeat(NEW_IMPROMPTU_FEAT_ID_2, oPC, TRUE))
				nResetFeat = NEW_IMPROMPTU_FEAT_ID_2;
			else nResetFeat = NEW_IMPROMPTU_FEAT_ID_1;
		} else nResetFeat = NEW_FEINT_FEAT_ID;
		ResetFeatUses(oPC, nResetFeat, TRUE, TRUE);
		return;
	}
	switch (nId){
		case NEW_IMPROMPTU_SPELL_ID: RollNewImpromptu(oPC, oTarget); break;
		case NEW_FEINT_SPELL_ID: RollNewFeint(oPC, oTarget); break;
	}
}

void RollNewImpromptu(object oPC, object oTarget){
	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	int nBonus = (nDex > nStr) ? nDex - nStr : 0;
	int nAtt = TouchAttackMelee(oTarget, FALSE, nBonus);
	if (nAtt == TOUCH_ATTACK_RESULT_MISS){
		SendMessageToPC(oPC, "<i>Impromptu Sneak Attack Failed!</i>");
		return;
	} else {
		SendMessageToPC(oPC, "<i>Impromptu Sneak Attack Succeeds!</i>");
		DoNewImpromptuOrFeint(oPC, oTarget);
	}
}

void RollNewFeint(object oPC, object oTarget){
	
	//set up an identifying string to use to track # of feint attempts by this specific attacker
	// vs this specific opponent
	string sFeintId = "Feint" + ObjectToString(oPC);
	
	// get the feint roll for oPC
	int nAttackerRoll = d20();
	if (GetHasFeat(INVIS_BLADE_FEINT_MASTERY, oPC) && nAttackerRoll < 5)
		nAttackerRoll = 5; // feint mastery works as usual for attacker
	nAttackerRoll += GetBaseAttackBonus(oPC) + GetSkillRank(SKILL_BLUFF, oPC);
	
	// get the roll for oTarget
	int nDefenderRoll = d20();
	if (GetHasFeat(INVIS_BLADE_FEINT_MASTERY, oTarget) && nDefenderRoll < 5)
		nDefenderRoll = 5; // note that feint mastery now affects an invis blade's attempt to resist as well
	int nConcentration = GetSkillRank(SKILL_CONCENTRATION, oTarget);
	int nSpot = GetSkillRank(SKILL_SPOT, oTarget);
	int nAbility = (nConcentration > nSpot) ? nConcentration : nSpot;
	nDefenderRoll += GetBaseAttackBonus(oTarget) + nAbility;
	int nAttempts = GetLocalInt(oTarget, sFeintId);
	nDefenderRoll += nAttempts * FEINT_ATTEMPT_MULTIPLIER;
	
	// get the results and user feedback
	string sAttackerMessage = "You rolled " + IntToString(nAttackerRoll);
	sAttackerMessage += " vs " + IntToString(nDefenderRoll);
	string sDefenderMessage = "You rolled " + IntToString(nDefenderRoll);
	sDefenderMessage += " vs " + IntToString(nAttackerRoll);
	int bAttackerPC = GetIsPC(oPC);
	int bDefenderPC = GetIsPC(oTarget);
	if (nAttackerRoll > nDefenderRoll){
		if (bAttackerPC)
			SendMessageToPC(oPC, "Feint HIT!\n" + sAttackerMessage);
		if (bDefenderPC)
			SendMessageToPC(oTarget, GetName(oPC) + " Feints!\n" + sDefenderMessage);
		DoNewImpromptuOrFeint(oPC, oTarget, TRUE);
	} else {
		if (bAttackerPC) SendMessageToPC(oPC, "Feint MISSED!\n" + sAttackerMessage);
		if (bDefenderPC) SendMessageToPC(oTarget, GetName(oPC) + " failed Feint attempt!\n" + sDefenderMessage);
	}
	
	if (oTarget != OBJECT_INVALID){
		//Set up the timer to remove attempts tracking if target still exists
		if (nAttempts < 1)
			DelayCommand(300.0f, RemoveFeintAttemptTracking(oTarget, sFeintId));
			
		// increment the # attempts if target still exists
		SetLocalInt(oTarget, sFeintId, nAttempts + 1);
	}
}

void RemoveFeintAttemptTracking(object oTarget, string sFeintId){
	if (oTarget != OBJECT_INVALID)
		DeleteLocalInt(oTarget, sFeintId);
}


void DoNewImpromptuOrFeint(object oPC, object oTarget, int bFeint = FALSE){
	
	FeatAdd(oPC, 1510, FALSE); // give og impromptu
	int nVis = (bFeint == TRUE) ? VFX_IMP_CONFUSION_S : VFX_IMP_NEGATIVE_ENERGY;
	effect eVis = EffectVisualEffect(nVis);
	ResetFeatUses(oPC, 1510, TRUE, TRUE);
	AssignCommand(oPC, ClearAllActions(TRUE));
	AssignCommand(oTarget, ClearAllActions(TRUE));
	DelayCommand(0.5f, AssignCommand(oPC, ActionUseFeat(1510, oTarget))); // use it
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	if (oPC != OBJECT_INVALID && oTarget != OBJECT_INVALID)
		AssignCommand(oPC, ActionAttack(oTarget));
	DelayCommand(3.0f,FeatRemove(oPC, 1510));// remove og impromptu
}

	
	
	
	
	
