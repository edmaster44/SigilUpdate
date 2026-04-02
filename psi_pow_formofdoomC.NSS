// vfx persist line 102

#include "hench_i0_generic"
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "aaa_constants"
#include "x2_inc_itemprop"

const int FEAT_WEAP_FOC_CR = 291;
const int FEAT_WEAP_SPEC_CR = 290;
const int FEAT_GREAT_WEAP_FOC_CR = 1157;
const int FEAT_GREAT_WEAP_SPEC_CR = 1197;
const int FEAT_EPIC_WEAP_FOC_CR = 656;
const int FEAT_EPIC_WEAP_SPEC_CR = 694;


void DoTentacleAttack(object oEnemy, int nAB, int nPhysicalBonus, int nMagicalBonus){
	
	if (d20() + nAB < GetTouchAC(oEnemy))
		return;
	int nPhysDmg = d8() + nPhysicalBonus;
	int nMagDmg = d8() + nMagicalBonus;
	effect eDam = EffectDamage(nPhysDmg, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, FALSE);
	effect eMagicDam = EffectDamage(d8(), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	effect eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);
	effect eLink = EffectLinkEffects(eVis, eDam);
	eLink = EffectLinkEffects(eMagicDam, eDam);
	PS_ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oEnemy);
}

void main()
{
	object oManifester = GetAreaOfEffectCreator();
	int nTotalAttacks = 4;
	int bAugmented = FALSE;
	if (GetTag(OBJECT_SELF) == "augmented"){
		nTotalAttacks += 2;
		bAugmented = TRUE;
	}
	int nStr = GetAbilityScore(oManifester, ABILITY_STRENGTH) / 2;
	int nDex = GetAbilityScore(oManifester, ABILITY_DEXTERITY) / 2;
	int nAbBonus = (nStr > nDex) ? nStr : nDex;
	int nAB = GetBaseAttackBonus(oManifester) + nAbBonus;
	if (GetHasFeat(FEAT_EPIC_WEAP_FOC_CR, oManifester)) nAB += 4;
	else if (GetHasFeat(FEAT_GREAT_WEAP_FOC_CR, oManifester)) nAB += 2;
	else if (GetHasFeat(FEAT_WEAP_FOC_CR, oManifester)) nAB += 1;
	
	int nPhysBonus = nStr;
	if (nPhysBonus < 0) nPhysBonus = 0;
	if (GetHasFeat(FEAT_EPIC_WEAP_SPEC_CR, oManifester)) nPhysBonus += 6;
	else if (GetHasFeat(FEAT_GREAT_WEAP_SPEC_CR, oManifester)) nPhysBonus += 4;
	else if (GetHasFeat(FEAT_WEAP_SPEC_CR, oManifester)) nPhysBonus += 2;
	
	int nMagicalBonus = GetAbilityScore(oManifester, ABILITY_WISDOM) / 2;
	
	// count enemies
	int nNumEnemies = 0;
	object oEnemy = GetFirstInPersistentObject();
	while (GetIsObjectValid(oEnemy)){
		if(GetIsEnemy(oEnemy, oManifester)) nNumEnemies++;
		oEnemy = GetNextInPersistentObject();
	}
	if (nNumEnemies <= 0) return;
	
	// How many attacks per enemy, and how many will get an extra attack to fill out nTotalAttacks
	int nAttacksEach = nTotalAttacks / nNumEnemies;
	if (nAttacksEach < 1) nAttacksEach = 1;
	int nExtraAttacks = 0;
	if (nTotalAttacks > nNumEnemies) nExtraAttacks = nTotalAttacks % nNumEnemies;

	
	int nAttacksMade = 0;
	int i;
	oEnemy = GetFirstInPersistentObject();
	while (GetIsObjectValid(oEnemy) && nAttacksMade < nTotalAttacks){
		if(GetIsEnemy(oEnemy, oManifester)){
			for (i = 0; i < nAttacksEach; i++){
				DoTentacleAttack(oEnemy, nAB, nPhysBonus, nMagicalBonus);
				nAttacksMade++;
			}
			if (nExtraAttacks > 0){
				DoTentacleAttack(oEnemy, nAB, nPhysBonus, nMagicalBonus);
				nAttacksMade++;
				nExtraAttacks--;
			}
			
		}
		oEnemy = GetNextInPersistentObject();
	}	
}