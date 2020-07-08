#include "x2_inc_itemprop"
#include "ps_inc_equipmentprops"
#include "aaa_constants"

//This is a list of functions that removes Weapon Properties based on their References

void RemoveMeditativeStrikes(object oPC,object oItem)
{
  if(GetHasFeat(2840,oPC, TRUE)){
itemproperty Prop = GetItemPropertyReference(oItem, "MeditativeStrikes");
if (GetIsItemPropertyValid(Prop) != FALSE) {
    SendMessageToPC(oPC, "Item Property no longer exists on the Item itself");
    return;
}

DeleteItemPropertyReference(oItem, "MeditativeStrikes");

}
}


void RemoveElementalWeapon(object oPC,object oItem)
{
  if(GetHasFeat(FEAT_ELEMWAR_WEAPON,oPC, TRUE)){
itemproperty Prop = GetItemPropertyReference(oItem, "ElementalWeapon");
if (GetIsItemPropertyValid(Prop) == TRUE) {
    SendMessageToPC(oPC, "Removing Elemental Weapon");
    return;
	
	DeleteItemPropertyReference(oItem, "ElementalWeapon");

}
}
}