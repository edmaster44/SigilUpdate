
//Meditative Strike
#include "ps_inc_equipment"

//Applies Wisdom damage as magical damage on too both gloves and Flurry-ready Monk weapons
void main ()
{ 
object oSelf =  OBJECT_SELF;
object oPC = GetPCItemLastEquippedBy();
object oWeapon = GetPCItemLastEquipped();
//Get Damage based on Wisdom Modifer
int nWisdomBounus = GetAbilityModifier(ABILITY_WISDOM, oPC);
float fDuration = 9999.9f;
 int nDUR = DURATION_TYPE_TEMPORARY;
//Comes from Wisdom
int nDamage = IPGetDamageBonusConstantFromNumber(nWisdomBounus);
//Magical Damage constant 
int nDamageType = IP_CONST_DAMAGETYPE_MAGICAL;
//Name of Property 
itemproperty ipAdd =  ItemPropertyDamageBonus(nDamageType, nDamage) ; 
//adds the property if it is correct weapon
 if(GetHasFeat(2840, oPC, TRUE ) && GetMonkWeapon(oWeapon) == TRUE)
{

AddItemProperty(DURATION_TYPE_TEMPORARY,ipAdd,oWeapon,fDuration);
}
else
//Removes the property 
{RemoveItemProperty(oWeapon,ipAdd);

}

}