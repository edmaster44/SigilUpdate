#include "ff_unarmored_ac"
#include "nwn2_inc_spells"
#include "aaa_constants"

// get the NW level of the object or of the object's master if the object is an animal companion
int GetWarriorLevel(object oPC){
	object oWarrior = oPC;
	if (GetAssociateType(oWarrior) != ASSOCIATE_TYPE_NONE) oWarrior = GetMaster(oWarrior);
	return GetLevelByClass(CLASS_TYPE_NATUREWARRIOR, oWarrior);
}

void Armor_of_the_crocodile(object oPC, int nSpell){
	
	int iNaturesWarrior = GetWarriorLevel(oPC);
	int nCrocAC = 0;
	switch (iNaturesWarrior){
		case 4: case 3: nCrocAC = 2; break;
		case 2: case 1: nCrocAC = 1; break;
		default: nCrocAC = 4; break;
	}
	nCrocAC = nCrocAC - GetUnarmoredAC(oPC); //doesn't stack with duelist, invis blade, monk, or mystic
	
	// note that this also doesn't stack with dodge AC from Gatecrasher, but in that case
	// you get this instead of the Gatecrasher AC, as scripted in the impact script for it
	if (!GetHasFeat(2936, oPC, TRUE) || nCrocAC < 1){
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_4, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_4);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_3);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_2);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_1);
	} else if (nCrocAC == 4){
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_1);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_2);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_3);
		if (!GetHasFeat(FEAT_CROC_ARMOR_AC_4, oPC, TRUE))
			FeatAdd(oPC, FEAT_CROC_ARMOR_AC_4, FALSE);
    } else if (nCrocAC == 3){
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_1);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_2);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_4, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_4);
		if (!GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatAdd(oPC, FEAT_CROC_ARMOR_AC_3, FALSE);
	} else if (nCrocAC == 2){
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_1);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_3);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_4, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_4);
		if (!GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatAdd(oPC, FEAT_CROC_ARMOR_AC_2, FALSE);
	} else {
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_2);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_3);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_4, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_4);
		if (!GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatAdd(oPC, FEAT_CROC_ARMOR_AC_1, FALSE);
	}
}



void Claws_of_the_grizzly(object oPC, int nSpell){
	int nDamage = DAMAGE_BONUS_3;
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
	effect eSlashing = EffectDamageIncrease(nDamage,DAMAGE_TYPE_SLASHING);
	eSlashing = SupernaturalEffect(eSlashing);
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlashing, oPC));
}


void Earth_Resilience(object oPC, int nSpell){

	int iNaturesWarrior = GetWarriorLevel(oPC);
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
	
	effect eDR = EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
	if(iNaturesWarrior >= 5) eDR = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN),eDR);
	eDR = SupernaturalEffect(eDR);	
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC));

}

void Nature_Weapon(object oPC, int nSpell){
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
	int iNaturesWarrior = GetWarriorLevel(oPC);
	int nBonus = 1;
	if (iNaturesWarrior >= 5) nBonus = 3;
	else if (iNaturesWarrior >= 3) nBonus = 2;
	
	effect eAB = EffectAttackIncrease(nBonus);
	eAB = SupernaturalEffect(eAB);
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, oPC));

}

void Wild_Growth(object oPC, int nSpell){
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
	int iNaturesWarrior = GetWarriorLevel(oPC);
	int nBonus = 1;
	if (iNaturesWarrior >= 5) nBonus = 3;
	else if (iNaturesWarrior >= 3) nBonus = 2;
	
	effect eRegenerate = EffectRegenerate(nBonus, 6.0f);
	SupernaturalEffect(eRegenerate);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegenerate, oPC);
}