#include "nwn2_inc_spells"
#include "aaa_constants"

int iNaturesWarrior = GetLevelByClass(CLASS_TYPE_NATUREWARRIOR,OBJECT_SELF);
int nBonus;
effect eLink;

void Armor_of_the_crocodile(object oPC, int nSpell){

	if (!GetHasFeat(2936, oPC, TRUE)){
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_3);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_2);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_1);
	} else if (iNaturesWarrior >= 5){
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_1);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_2);
		if (!GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatAdd(oPC, FEAT_CROC_ARMOR_AC_3, FALSE);
    } else if (iNaturesWarrior >= 3){
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_1);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_3);
		if (!GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatAdd(oPC, FEAT_CROC_ARMOR_AC_2, FALSE);
	} else {
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_3, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_3);
		if (GetHasFeat(FEAT_CROC_ARMOR_AC_2, oPC, TRUE))
			FeatRemove(oPC, FEAT_CROC_ARMOR_AC_2);
		if (!GetHasFeat(FEAT_CROC_ARMOR_AC_1, oPC, TRUE))
			FeatAdd(oPC, FEAT_CROC_ARMOR_AC_1, FALSE);
	}
		

	/*
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);

	if(iNaturesWarrior == 5) nBonus = 3;
	else if(iNaturesWarrior >= 3) nBonus = 2;
		else nBonus = 1;
		
	effect eArmor = EffectACIncrease(nBonus,AC_DODGE_BONUS);
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArmor, oPC));
	*/
}



void Claws_of_the_grizzly(object oPC, int nSpell)
{

	int nDamage = DAMAGE_BONUS_3;
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
	effect eSlashing = EffectDamageIncrease(nDamage,DAMAGE_TYPE_SLASHING);
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlashing, oPC));
}


void Earth_Resilience(object oPC, int nSpell)
{

	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);

/*	if (!GetHasFeat(493,oPC))
	FeatAdd(oPC,493,FALSE,FALSE,FALSE);*/
	
		nBonus = 10; 
		effect eDR = EffectDamageReduction(nBonus, DAMAGE_TYPE_ALL, 0, DR_TYPE_DMGTYPE);
		
		
		eLink = EffectLinkEffects(eDR, eLink);
	
		if(iNaturesWarrior == 5) eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN),eLink);
		
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC));

}
void Nature_Weapon(object oPC, int nSpell)
{
if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
effect eLink;
int iNaturesWarrior = GetLevelByClass(CLASS_TYPE_NATUREWARRIOR,oPC); int nBonus;
if(iNaturesWarrior == 5) nBonus = 3;
else if (iNaturesWarrior == 3) nBonus = 2;
else nBonus = 1;
eLink = EffectLinkEffects(EffectAttackIncrease(nBonus),eLink);
DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC));

}

void Wild_Growth(object oPC, int nSpell)
{

	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
int iNaturesWarrior = GetLevelByClass(CLASS_TYPE_NATUREWARRIOR,oPC); int nBonus;

if (iNaturesWarrior = 5) nBonus =3;
else nBonus = 1;
effect eRegenerate = EffectRegenerate(nBonus,6.0f);
SupernaturalEffect(eRegenerate);
 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegenerate, oPC);

}