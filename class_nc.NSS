#include "nwn2_inc_spells"
#include "aaa_constants"


void Armor_of_the_crocodile(object oPC, int nSpell)
{
int iNaturesWarrior = GetLevelByClass(CLASS_TYPE_NATUREWARRIOR,oPC); int nBonus;
if(iNaturesWarrior == 5) nBonus = 3;
		else if(iNaturesWarrior >= 3) nBonus = 2;
		else nBonus = 1;
		
	effect eLink = EffectLinkEffects(eLink,EffectACIncrease(nBonus,AC_DODGE_BONUS));
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC));
}



void Claws_of_the_grizzly(object oPC, int nSpell)
{

effect eSlashing = EffectDamage(3,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL,FALSE);
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlashing, oPC));



}





void Earth_Resilience(object oPC, int nSpell)
{

	if (!GetHasFeat(333,oPC))
	FeatAdd(oPC,333,FALSE,FALSE,FALSE);


		/* int nBonus = 5;
		 effect eLink;
		effect ePiercing = EffectDamageReduction(nBonus, DAMAGE_TYPE_PIERCING, 0, DR_TYPE_DMGTYPE);
		effect eSlashing = EffectDamageReduction(nBonus, DAMAGE_TYPE_SLASHING, 0, DR_TYPE_DMGTYPE);
		effect eBludgeoning = EffectDamageReduction(nBonus, DAMAGE_TYPE_BLUDGEONING, 0, DR_TYPE_DMGTYPE);
		
		eLink = EffectLinkEffects(ePiercing, eLink);
		eLink = EffectLinkEffects(eSlashing, eLink);
		eLink = EffectLinkEffects(eBludgeoning, eLink);
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC));*/

}
void Nature_Weapon(object oPC, int nSpell)
{
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


int iNaturesWarrior = GetLevelByClass(CLASS_TYPE_NATUREWARRIOR,oPC); int nBonus;

if (iNaturesWarrior = 5) nBonus =3;
else nBonus = 1;
effect eRegenerate = EffectRegenerate(nBonus,6.0f);
SupernaturalEffect(eRegenerate);
DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegenerate, oPC));

}