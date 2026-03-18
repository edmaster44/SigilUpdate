// vfx persist line 102


#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "aaa_constants"
#include "x2_inc_itemprop"

void DoTentacleAttack(object oEnemy, int nAB, int nBonus){
	if (d20() + nAB < GetAC(oEnemy))
		return;
	int nDamage = d8(2) + nBonus;
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	effect eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);
	effect eLink = EffectLinkEffects(eVis, eDam);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oEnemy);
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
	int nAB = GetBaseAttackBonus(oManifester);
	int nBonus = GetAbilityScore(oManifester, ABILITY_STRENGTH) / 2;
	if (nBonus < 0) nBonus = 0;
	
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
				DoTentacleAttack(oEnemy, nAB, nBonus);
				nAttacksMade++;
			}
			if (nExtraAttacks > 0){
				DoTentacleAttack(oEnemy, nAB, nBonus);
				nAttacksMade++;
				nExtraAttacks--;
			}
			
		}
		oEnemy = GetNextInPersistentObject();
	}	
}