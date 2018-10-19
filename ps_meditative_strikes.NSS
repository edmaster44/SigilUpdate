#include "x2_inc_itemprop"
//Applies Wisdom damage as magical damage on too both gloves and Flurry-ready Monk weapons
const int FEAT_EPIC_MEDITATIVE_STRIKES = 2840;
//Gets the Property from wisdom, converts into Magical Damage
void ApplyMeditativeStrikes(object oPC,object oItem)
{

int nDur = DURATION_TYPE_PERMANENT;
float fDUR = 9999.9f;
int nWis = GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);
if (nWis < 1) return;
int nDamage = IPGetDamageBonusConstantFromNumber(nWis);
itemproperty ipAdd =  ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, nWis) ; 
if(GetHasFeat(FEAT_EPIC_MEDITATIVE_STRIKES, oPC, TRUE ))

{

AddItemProperty(nDur,ipAdd,oItem,fDUR);
}
return;
}