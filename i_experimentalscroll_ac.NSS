#include "ff_safevar"

#include "ps_inc_experimentaleffects"
const int EXPERIMENTAL_SPELLTYPE_SINGLE = 1;
const int EXPERIMENTAL_SPELLTYPE_AOE = 2;
const int EXPERIMENTAL_SPELLTYPE_LINKED = 3;
const int EXPERIMENTAL_SPELLTYPE_SINISTER_LINKED = 4;

void main () {

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	location lTargetLocation = GetItemActivatedTargetLocation();
	
	SendMessageToPC(oPC, "You read from the unorthodox scroll. . .");
	
	int nLevel = PS_GetLocalInt(oItem, "Item_Level");
	int nType = PS_GetLocalInt(oItem, "Item_Effect_Type");
	int nHelpful = PS_GetLocalInt(oItem, "Item_Effect_Helpful");
	int nHarmful = PS_GetLocalInt(oItem, "Item_Effect_Harmful");
	float fRadius = 5.0f*nLevel;
	
	//If no saved information. . .
	if (nLevel <= 0) nLevel = d3(); //setting to random level
	if (nType <= 0) nType = d2(); //setting to random level
	if (nHelpful <= 0) nHelpful = -1; //setting to random effect
	if (nHarmful <= 0) nHarmful = -1; //setting to random effect
	
	if (nType == EXPERIMENTAL_SPELLTYPE_SINGLE) {
		string sEffect = "sp_magic_hit";
		effect eVFX = EffectNWN2SpecialEffectFile(sEffect);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
		
		ApplyExperimentalSpellEffectGood(oTarget, nLevel, nHelpful);
		ApplyExperimentalSpellEffectBad(oTarget, nLevel, nHarmful);
	} else if (nType == EXPERIMENTAL_SPELLTYPE_AOE) {
		string sEffect = "sp_magic_aoe";
		effect eVFX = EffectNWN2SpecialEffectFile(sEffect);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTargetLocation);
			
		object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTargetLocation, TRUE);
		while (GetIsObjectValid(oCreature)) {
			string sEffect = "sp_magic_hit";
			effect eVFX = EffectNWN2SpecialEffectFile(sEffect);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
		
			ApplyExperimentalSpellEffectGood(oCreature, nLevel, nHelpful);
			ApplyExperimentalSpellEffectBad(oCreature, nLevel, nHarmful);
			oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTargetLocation, TRUE);
		}
	} else if (nType == EXPERIMENTAL_SPELLTYPE_LINKED) {
		if (oTarget == oPC) {
			SendMessageToPC(oPC, "Target must be different from the caster.");
			return;
		}
	
		string sEffect = "sp_magic_hit";
		effect eVFX = EffectNWN2SpecialEffectFile(sEffect);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);
		
		ApplyExperimentalSpellEffectGood(oTarget, nLevel, nHelpful);
		ApplyExperimentalSpellEffectBad(oPC, nLevel, nHarmful);
		
		float fDuration = 6.0f*(d3(nLevel));
		effect eEffect = EffectShareDamage(oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
	} else if (nType == EXPERIMENTAL_SPELLTYPE_SINISTER_LINKED) {
		if (oTarget == oPC) {
			SendMessageToPC(oPC, "Target must be different from the caster.");
			return;
		}
	
		string sEffect = "sp_magic_hit";
		effect eVFX = EffectNWN2SpecialEffectFile(sEffect);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);
		
		ApplyExperimentalSpellEffectGood(oPC, nLevel, nHelpful);
		ApplyExperimentalSpellEffectBad(oTarget, nLevel, nHarmful);
		
		float fDuration = 6.0f*(nLevel*3);
		effect eEffect = EffectShareDamage(oTarget);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, fDuration);
	}
}