#include "aaa_constants"
#include "ff_combat_mods"
#include "ps_adjust_knight"
#include "ff_adjust_classes"
#include "ff_update_feats_sneak"


void ApplyGatecrasherAC(object oPC);
void ApplyTurnResist(object oPC);
void fFixAlertness(object oPC);
void SituationalAwareness(object oPC);
void ImprovedDefense(object oPC);
void AdjustAbilityScore(object oPC, int nAbility, int nAmount);
void PS_ManageImbueItem(object oPC);
void FF_WingFix(object oPC);
void ManageAppearance(object oPC);
void GrantArmorOptByBAB(object oPC);

	//grant bite attack to lycans who do not have it, remove old bestial power Feats
void UpdateLycanWithoutRemake(object oPC){
	if (GetLevelByClass(CLASS_TYPE_LYCAN_PRC, oPC) < 4)
		return;
	FeatAdd(oPC, 3118, FALSE, FALSE, FALSE);
	FeatRemove(oPC, 2589);
	FeatRemove(oPC, 2590);
	FeatRemove(oPC, 2591);	
}

// To avoid a "feat tax" situation, we're now granting armor optimization
// feats once the character reaches a certain level of martial skill measured
// by base attack bonus
void GrantArmorOptByBAB(object oPC){
	if (GetBaseAttackBonus(oPC) >= 6 && !GetHasFeat(2836, oPC) && 
		!GetHasFeat(2837, oPC) && !GetHasFeat(2838, oPC))
			FeatAdd(oPC, 2836, FALSE, FALSE, TRUE);
	if (GetBaseAttackBonus(oPC) >= 16 && 
		!GetHasFeat(2837, oPC) && !GetHasFeat(2838, oPC))
			FeatAdd(oPC, 2837, FALSE, FALSE, TRUE);
	if (GetBaseAttackBonus(oPC) >= 26 && !GetHasFeat(2838, oPC))
			FeatAdd(oPC, 2838, FALSE, FALSE, TRUE);
}

// adds Otherworldly Appendages persistent feat that keeps wings and tails from vanishing
void ManageAppearance(object oPC){
	object oEss	= GetItemPossessedBy(oPC,"ps_essence");	
	if (GetLocalInt(oEss, "TempChange")) return;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	if (app.TailVariation != 0 || GetHasFeat(2120, oPC, TRUE)){
		if (!GetHasFeat(21905, oPC, TRUE))
			FeatAdd(oPC, 21905, FALSE, FALSE, TRUE); // appearance persistance
	}
}

//give vampires two versions of dom gaze, one that targets friendly pcs for rp purposes and
// one that targets hostile npcs
void UpdateDominatingGaze(object oPC){
	if (GetHasFeat(2474, oPC) && !GetHasFeat(3106, oPC))
		FeatAdd(oPC, 3106, FALSE);
		
	if (GetHasFeat(2473, oPC) && !GetHasFeat(3105, oPC))
		FeatAdd(oPC, 3105, FALSE);
}

void FF_WingFix(object oPC){
	if (!GetHasFeat(2120, oPC)){ // if we dont have the default nwn wing feat that gives move rate..
		//..and we have wings..
		if (GetHasFeat(288, oPC) || GetHasFeat(2179, oPC) || GetHasFeat(3024, oPC) || GetHasFeat(2781, oPC) || 
			GetHasFeat(3021, oPC) || GetHasFeat(3022, oPC) || GetHasFeat(3023, oPC) || GetHasFeat(3008, oPC)) 
				FeatAdd(oPC, 2120, FALSE, FALSE, TRUE); //..then give the default wing feat
	}
	//if we DO have the wings feat but don't have my new appearance persistor, give it
	if (GetHasFeat(2120, oPC, TRUE) && !GetHasFeat(21905, oPC, TRUE))
		FeatAdd(oPC, 21905, FALSE, FALSE, TRUE);
}

//manually give creature weapon proficiency to any race or class that is meant to have it
//but does not so they don't have to rebuild to get it from 2da. Only tanaari at the time 
//of this function's creation
void GiveCreatureWeaponProf(object oPC){
	if (GetHasFeat(289, oPC)) return;
	
	if (GetSubRace(oPC) == 194) //tanaari
		FeatAdd(oPC, 289, FALSE);
}

// manually give gc the new dodge ac feat so that existing gc do not have to rebuild
// As per discussion with Jelkia this is changed from lvl 2 to lvl 3
void ApplyGatecrasherAC(object oPC){
	int bHasGCAC = GetHasFeat(21904, oPC);
	int bQualifies = (GetLevelByClass(63, oPC) >= 3);
	if (bHasGCAC && !bQualifies)
		FeatRemove(oPC, 21904);
	else if (!bHasGCAC && bQualifies)
		FeatAdd(oPC, 21904, FALSE);
}

// in DnD 3.5 vampires are supposed to get the same +4 vs turning as liches
// so this function applies it at max vampire level for the vamp templates.
// This has been added to the 2da but doing it here also will negate the need
// for existing vampires to rebuild.
void ApplyTurnResist(object oPC){
	if (GetHasFeat(2697, oPC)) return; // skip if they already have turn resist
	int nVampClass = 105; //draco
	int nVampLevel = GetLevelByClass(nVampClass, oPC);
	if (nVampLevel < 1){
		nVampClass = 78; //lupus
		nVampLevel = GetLevelByClass(nVampClass, oPC);
	}
	if (nVampLevel < 1){
		nVampClass = 106; //maleficus
		nVampLevel = GetLevelByClass(nVampClass, oPC);
	}
	if (nVampLevel < 1) return;

	int nMax = StringToInt(Get2DAString("classes", "MaxLevel", nVampClass));
	if (nVampLevel >= nMax){
		if (!GetHasFeat(2697, oPC))
			FeatAdd(oPC, 2697, FALSE);
	}
}

// Give Imbue Item to Psi if they have caster level 6 or higher. Remove it from 
// deleveled pcs who no longer qualify. Give imbue item to warlock if their 
// warlock base class >= 12 or total warlock CL >= 15. -FlattedFifth, July 27, 2025
void PS_ManageImbueItem(object oPC)
{
	int nPsiCaster = GetPsyOrPsiCasterLevel(oPC);
	int nWarlockClass = GetLevelByClass(CLASS_TYPE_WARLOCK, oPC);
	int nWarlockCaster = PS_GetCasterLevel(oPC, CLASS_TYPE_WARLOCK);

	int bQualifies = (nPsiCaster >= 6 || nWarlockClass >= 12 || nWarlockCaster >= 15);
	int bHasInbue = GetHasFeat(1430, oPC);
	
	if (bHasInbue && !bQualifies) FeatRemove(oPC, 1430);
	else if (!bHasInbue && bQualifies) FeatAdd(oPC, 1430, FALSE);
}

void fFixAlertness(object oPC){

	if (GetHasFeat(FEAT_ALERTNESS_NEW, oPC, TRUE)){
		FeatRemove(oPC, FEAT_ALERTNESS_NEW);
		// we cannot check if they already have this because if they
		// have it as a bonus feat on equipment we will get a false positive
		FeatAdd(oPC, FEAT_ALERTNESS, FALSE);
	}
}

void SituationalAwareness(object oPC){
	// Add situational awareness feat
	if (GRANT_SITUATIONAL_AWARENESS){
		int nLvlAC = (PS_GetLevel(oPC) + 3) / 10;
		int nTumbleAC = GetSkillRank(SKILL_TUMBLE, oPC, TRUE) / 10;
		int nAC = nLvlAC - nTumbleAC;
		switch (nAC){
			case 3: {
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_1_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_1_AC);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_2_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_2_AC);
				if (!GetHasFeat(FEAT_SITUATIONAL_AWARENESS_3_AC, oPC, TRUE))
					FeatAdd(oPC, FEAT_SITUATIONAL_AWARENESS_3_AC, FALSE);
				break;
			}
			case 2:{
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_1_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_1_AC);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_3_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_3_AC);
				if (!GetHasFeat(FEAT_SITUATIONAL_AWARENESS_2_AC, oPC, TRUE))
					FeatAdd(oPC, FEAT_SITUATIONAL_AWARENESS_2_AC, FALSE);
				break;
			}
			case 1:{
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_3_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_3_AC);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_2_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_2_AC);
				if (!GetHasFeat(FEAT_SITUATIONAL_AWARENESS_1_AC, oPC, TRUE))
					FeatAdd(oPC, FEAT_SITUATIONAL_AWARENESS_1_AC, FALSE);
				break;
			}
			default: {
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_1_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_1_AC);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_2_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_2_AC);
				if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_3_AC, oPC, TRUE))
					FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_3_AC);
				if (!GetHasFeat(FEAT_SITUATIONAL_AWARENESS, oPC, TRUE))
					FeatAdd(oPC, FEAT_SITUATIONAL_AWARENESS, FALSE);
				break;
			}
		}
	} else {
		if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_1_AC, oPC, TRUE))
			FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_1_AC);
		if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_2_AC, oPC, TRUE))
			FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_2_AC);
		if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS_3_AC, oPC, TRUE))
			FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS_3_AC);
		if (GetHasFeat(FEAT_SITUATIONAL_AWARENESS, oPC, TRUE))
			FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS);
	}	
}

void ImprovedDefense(object oPC){

	// remove old dodge ac Stalwart Defender feats
	if (GetHasFeat(1572, oPC, TRUE))
		FeatRemove(oPC, 1572);
	if (GetHasFeat(1573, oPC, TRUE))
		FeatRemove(oPC, 1573);
	if (GetHasFeat(1574, oPC, TRUE))
		FeatRemove(oPC, 1574);
	if (GetHasFeat(1575, oPC, TRUE))
		FeatRemove(oPC, 1575);
		
	int nStalwartLevel = GetLevelByClass(CLASS_STALWART_DEFENDER, oPC);
	int nAC = 0;
	if (nStalwartLevel >= 10) nAC = 4;
	else if (nStalwartLevel >= 7) nAC = 3;
	else if (nStalwartLevel >= 3) nAC = 2;
	else if (nStalwartLevel >= 1) nAC = 1;
	
	switch (nAC){
		case 4: {
			if (GetHasFeat(FEAT_STAL_DEF_AC_1, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_1);
			if (GetHasFeat(FEAT_STAL_DEF_AC_2, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_2);
			if (GetHasFeat(FEAT_STAL_DEF_AC_3, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_3);
			if (!GetHasFeat(FEAT_STAL_DEF_AC_4, oPC, TRUE))
				FeatAdd(oPC, FEAT_STAL_DEF_AC_4, FALSE);
			break;
		}
		case 3:{
			if (GetHasFeat(FEAT_STAL_DEF_AC_1, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_1);
			if (GetHasFeat(FEAT_STAL_DEF_AC_2, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_2);
			if (GetHasFeat(FEAT_STAL_DEF_AC_4, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_4);
			if (!GetHasFeat(FEAT_STAL_DEF_AC_3, oPC, TRUE))
				FeatAdd(oPC, FEAT_STAL_DEF_AC_3, FALSE);
			break;
		}
		case 2:{
			if (GetHasFeat(FEAT_STAL_DEF_AC_1, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_1);
			if (GetHasFeat(FEAT_STAL_DEF_AC_3, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_3);
			if (GetHasFeat(FEAT_STAL_DEF_AC_4, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_4);
			if (!GetHasFeat(FEAT_STAL_DEF_AC_2, oPC, TRUE))
				FeatAdd(oPC, FEAT_STAL_DEF_AC_2, FALSE);
			break;
		}
		case 1:{
			if (GetHasFeat(FEAT_STAL_DEF_AC_2, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_2);
			if (GetHasFeat(FEAT_STAL_DEF_AC_3, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_3);
			if (GetHasFeat(FEAT_STAL_DEF_AC_4, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_4);
			if (!GetHasFeat(FEAT_STAL_DEF_AC_1, oPC, TRUE))
				FeatAdd(oPC, FEAT_STAL_DEF_AC_1, FALSE);
			break;
		}
		default:{
			if (GetHasFeat(FEAT_STAL_DEF_AC_1, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_1);
			if (GetHasFeat(FEAT_STAL_DEF_AC_2, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_2);
			if (GetHasFeat(FEAT_STAL_DEF_AC_3, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_3);
			if (GetHasFeat(FEAT_STAL_DEF_AC_4, oPC, TRUE))
				FeatRemove(oPC, FEAT_STAL_DEF_AC_4);
			break;
		}
	}
}