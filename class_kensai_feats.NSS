// Power surge feat for kensei
//new version by Flatted Fifth, Jan 31 2026


#include "ps_class_inc"
#include "ps_adjust_kensei"
#include "x2_inc_spellhook"

const int KENSEI_SURGE = 1408;
const int KENSEI_WITHSTAND = 1410;
const string NOT_SIG = "<c=yellow>You can only use this ability with your signature weapon</c>";


int GetHasSignatureWeapon(object oPC);
void MonitorSignatureWeapon(object oPC, int iSpell, int iIteration = 0);
void ApplyKenseiSurge(object oPC, int iSpell, int iCon, float fDur);
void ApplyKenseiWithstand(object oPC, int iSpell, int iCon, float fDur);

void main(){
	object oPC = OBJECT_SELF;
	
	//first check if their signature weapon is equipped
	if (!GetHasSignatureWeapon(oPC)){
		SendMessageToPC(oPC, NOT_SIG);
		return;
	}
	
	int iCon = GetSkillRank(SKILL_CONCENTRATION, oPC);
	if (iCon < 1){
		SendMessageToPC(oPC, "<c=yellow>You lack the necessary focus to perform this feat</c>");
		return;
	} 
	
	int iSpell = GetSpellId();

	float fDur = IntToFloat(GetLevelByClass(CLASS_TYPE_KENSAI, oPC));
	fDur *= 60.0;
	
	if (iSpell == KENSEI_SURGE) ApplyKenseiSurge(oPC, iSpell, iCon, fDur);
	else if (iSpell == KENSEI_WITHSTAND) ApplyKenseiWithstand(oPC, iSpell, iCon, fDur);
	else SendMessageToPC(oPC, "<c=yellow>Unknown Spell ID, contact admin</c>");
}

void ApplyKenseiWithstand(object oPC, int iSpell, int iCon, float fDur){
	int iDR = iCon / 5;
	if (iDR > 10) iDR = 10; // max DR is 10
	
	effect eDR = EffectDamageReduction(iDR, GMATERIAL_METAL_ALCHEMICAL_SILVER, iCon * 10, DR_TYPE_GMATERIAL);
	eDR = ExtraordinaryEffect(eDR);
	eDR = SetEffectSpellId(eDR, iSpell);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, fDur);
	MonitorSignatureWeapon(oPC, iSpell);
}

void ApplyKenseiSurge(object oPC, int iSpell, int iCon, float fDur){
	iCon = iCon / 5;
	if (iCon > 4) iCon = 4; // max ab and damage bonus 4
	
	effect eAB = EffectAttackIncrease(iCon);
	effect eDam = EffectDamageIncrease(iCon);
	effect eSurge = EffectLinkEffects(eAB, eDam);
	eSurge = ExtraordinaryEffect(eSurge);
	eSurge = SetEffectSpellId(eSurge, iSpell);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSurge, oPC, fDur);
	MonitorSignatureWeapon(oPC, iSpell);
}

void MonitorSignatureWeapon(object oPC, int iSpell, int iIteration = 0){
	iIteration += 1; //failsafe counter to make infinite recursion impossible
	
	//bail if we checked 70 times, or the pc is not valid, or the pc doesnt have the effect
	if (iIteration >= 70 || !GetIsObjectValid(oPC) || !GetHasSpellEffect(iSpell, oPC))
		return;
		
	//cancel the spell and exit if the pc switched to a non-signature weapon
	if (!GetHasSignatureWeapon(oPC)){
		PS_RemoveEffects(oPC, iSpell);
		SendMessageToPC(oPC, NOT_SIG);
		return;
	}
	// check again next round
	DelayCommand(RoundsToSeconds(1), MonitorSignatureWeapon(oPC, iSpell, iIteration));	
}

int GetHasSignatureWeapon(object oPC){

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int iBase = GetBaseItemType(oWeapon);
	if (iBase == BASE_ITEM_INVALID) return FALSE;
	
	// get the weapon focus feat id for the equipped main hand weapon
	string sFocus = Get2DAString("baseitems", "FEATWpnFocus", iBase);
	if (sFocus == "****") return FALSE;
	int iFocus = StringToInt(sFocus);
	int iSigFocus = -1;
	
	//now find the proper match for weapon focus to signature weapon
	if (GetHasFeat(SW_HALBERD, oPC, TRUE)){
		iSigFocus = 112;
	} else if (GetHasFeat(SW_KAMA, oPC, TRUE)){
		iSigFocus = 117;
	} else if (GetHasFeat(SW_KATANA, oPC, TRUE)){
		iSigFocus = 122;	
	} else if (GetHasFeat(SW_NINJATO, oPC, TRUE)){
		iSigFocus = 3249;	
	} else if (GetHasFeat(SW_ODACHI, oPC, TRUE)){
		iSigFocus = 3239;
	} else if (GetHasFeat(SW_SPEAR, oPC, TRUE)){
		iSigFocus = 97;
	} else if (GetHasFeat(SW_STAFF, oPC, TRUE)){
		iSigFocus = 96;
	} else if (GetHasFeat(SW_DAGGER, oPC, TRUE)){
		iSigFocus = 90;
	} else if (GetHasFeat(SW_FLAIL, oPC, TRUE)){
		iSigFocus = 114;
	} else if (GetHasFeat(SW_MACE, oPC, TRUE)){
		iSigFocus = 94;
	} else if (GetHasFeat(SW_WARMACE, oPC, TRUE)){
		iSigFocus = 1826;
	} else return FALSE; 
	
	if (iFocus == iSigFocus) return TRUE;
	return FALSE;
}

// old version
/*
void main()
{
	object oPC = OBJECT_SELF;
	
	int iCheck = GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, 15, TRUE);
	
	if (iCheck == TRUE)
	{
		effect eSTR = ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 8));
		int iDur = GetLevelByClass(CLASS_TYPE_KENSAI, oPC);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSTR, oPC, RoundsToSeconds(iDur));
	}
	else
	{
		SendMessageToPC(oPC, "<color=yellow>You failed to focus your energies");
	}
}
*/