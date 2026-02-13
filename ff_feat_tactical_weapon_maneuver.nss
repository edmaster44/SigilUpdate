#include "ff_feat_tactical_weapon_man_inc"


void main(){
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();	
	
	if (!GetIsObjectValid(oTarget)){
		SendMessageToPC(oPC, "Invalid Target");
		return;
	}
	object oRHAND = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oLHAND = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || !GetIsEnemy(oTarget, oPC)){
		SendMessageToPC(oPC, "Invalid target");
		return;
	}
	
	int nTacSuite = GetTacSuiteByWeaponCategory(oPC, oRHAND);
	
	if (nTacSuite == TAC_SUITE_NONE){
		SendMessageToPC(oPC, "You must have a weapon equipped to use this feat.");
		return;
	}
	
	if (!PS_GetTargetInRange(oPC, oTarget, TAC_FEAT_ID, TRUE)){
		return;
	}
	
	struct DamageStats data = GetDamageStats(oPC, oTarget, oRHAND);
	
	switch (nTacSuite){
		case TAC_SUITE_BOW: DoDisablingStrike(oPC, oTarget, data); break;
		case TAC_SUITE_CE: DoDisablingStrike(oPC, oTarget, data); break;
		case TAC_SUITE_CLEAVE: DoHewing(oPC, oTarget, data); break;
		case TAC_SUITE_DISARM: DoEntangle(oPC, oTarget, oRHAND, oLHAND, data); break;
		case TAC_SUITE_KD: DoLegSweep(oPC, oTarget, oRHAND, oLHAND, data); break;
		case TAC_SUITE_PA: DoRoundhouse(oPC, oTarget, data); break;
	}
	ClearAllActions(TRUE);
	DelayCommand(0.1f, ActionAttack(oTarget));
}
