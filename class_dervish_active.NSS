#include "nwn2_inc_spells"
#include "aaa_constants"
#include "ps_inc_equipment"


int Ceil(float numb)
{
    int cast = FloatToInt(numb);
    return numb > 0.0 ? ((numb - cast) > 0.0 ? cast + 1 : cast) : ((numb - cast) > 0.0 ? cast - 1 : cast);
}



void ApplyDervishFatigue(object oPC){
int DervishLevel = GetLevelByClass(CLASS_DERVISH, oPC);
	int iABPenalty = Ceil(5 - DervishLevel / 2.0);
	if(iABPenalty <= 0) iABPenalty = 1;
		
	int iTotalLevels = GetTotalLevels(oPC, FALSE);
	if(iTotalLevels < 15 && iABPenalty > 2) iABPenalty = 2;
	
	effect eAttack = EffectAttackDecrease(iABPenalty);
	effect MoveDecrease = EffectMovementSpeedDecrease(10);
		
	effect eLink = EffectLinkEffects(eAttack,MoveDecrease);
	eLink = ExtraordinaryEffect(eLink);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0f);
}



void Dervish_Dance(object oPC,int nSpell)
{
	// Early return if requirements to use dance are not met.
	if(DervishCanUseDance(oPC) == FALSE) return;

		RemoveEffectsFromSpell(OBJECT_SELF, SPELLABILITY_DERVISH_DANCE);

		int nLevel = GetLevelByClass(CLASS_DERVISH, oPC);
		int nBonus = (nLevel + 1) / 2;
		float fDuration = RoundsToSeconds(10);

		effect eAB = EffectAttackIncrease(nBonus);
		effect eSlash = EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING);
		effect eLink = EffectLinkEffects(eAB, eSlash);
		eLink = SupernaturalEffect(eLink);
		eLink = SetEffectSpellId(eLink, SPELLABILITY_DERVISH_DANCE);

		object oMainHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

		if (nLevel > 9)
		{
			itemproperty iBonusFeat1 = ItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE);  //Cleave
			itemproperty iBonusFeat2 = ItemPropertyBonusFeat(45);	//Great Cleave
			IPSafeAddItemProperty(oMainHand, iBonusFeat1, fDuration);
			IPSafeAddItemProperty(oMainHand, iBonusFeat2, fDuration);
		}
		else if (nLevel > 3)
		{
			itemproperty iBonusFeat1 = ItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE);  //Cleave
			IPSafeAddItemProperty(oMainHand, iBonusFeat1, fDuration);
		}

		// Apply the dance bonuses.
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration));

		if (nLevel < 9 && !GetHasFeat(FEAT_DERVISH_TIRELESS_DANCE,oPC))
		{
			// Apply fatigue at the end of the dance.
			DelayCommand(fDuration, ApplyDervishFatigue(oPC));
		}
}

//Defensive Parry.
void Dervish_Defensive_Parry(object oPC, int nSpell)
{

int nPercentage = GetSkillRank( SKILL_PARRY, oPC,FALSE);
float fDuration = 60.0f;
if (nPercentage > 50) nPercentage = 50;
effect econceal = EffectConcealment(nPercentage,MISS_CHANCE_TYPE_NORMAL);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, econceal, oPC, fDuration);
}