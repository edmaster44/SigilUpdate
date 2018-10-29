#include "x2_inc_itemprop"
#include "ps_inc_equipment"
//Applies Wisdom damage as magical damage on too both gloves and Flurry-ready Monk weapons
const int FEAT_EPIC_MEDITATIVE_STRIKES = 2840;
//Gets the Property from wisdom, converts into Magical Damage, and applies it on correct weapons
void main()
{
object oPC = OBJECT_SELF;



int nDur = DURATION_TYPE_PERMANENT;
float fDUR = 9999.9f;
int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
int nDamage = IPGetDamageBonusConstantFromNumber(nWis);
effect eDamage = EffectDamageIncrease(nDamage,DAMAGE_TYPE_MAGICAL);
if(GetHasFeat(FEAT_EPIC_MEDITATIVE_STRIKES,oPC))
ApplyEffectToObject(nDur,eDamage,oPC);
//(nDur,ipAdd,oItem,fDUR);

}