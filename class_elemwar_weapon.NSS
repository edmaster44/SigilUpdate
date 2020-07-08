#include "x2_inc_itemprop"
#include "ps_inc_equipmentprops"
#include "aaa_constants"

//Elemental Weapon - Applies Elemental Damage based on feat.
void ApplyElementalWeapon(object oPC, object oItem)
{	

if (GetWeaponRanged(oItem)==TRUE) 
{SendMessageToPC(oPC,"Elemental Weapon only works with Melee Weapons");
return; }

	int nLevel=GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR, oPC);
	itemproperty Prop = GetItemPropertyReference(oItem, "ElementalWeapon");
	int nDamage = IP_CONST_DAMAGEBONUS_1d6;
		if (nLevel >= 5 ) 
		{	nDamage = IP_CONST_DAMAGEBONUS_3d6;	}
	int nItemVisual;
	int DamageType;		
    itemproperty iGlow;
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR,oPC,TRUE))
	{	
		DamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
		iGlow = ItemPropertyVisualEffect(ITEM_VISUAL_ELECTRICAL);
	}
		else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH,oPC,TRUE))
	{	
		DamageType = IP_CONST_DAMAGETYPE_ACID;
		iGlow = ItemPropertyVisualEffect(ITEM_VISUAL_ACID);				
	}
		else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE,oPC,TRUE))
	{
		DamageType = IP_CONST_DAMAGETYPE_FIRE;
		iGlow = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);			
	}
		else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER,oPC,TRUE))
	{
		DamageType = IP_CONST_DAMAGETYPE_COLD;
		iGlow =  ItemPropertyVisualEffect(ITEM_VISUAL_COLD);	
	}
	Prop =ItemPropertyDamageBonus(DamageType,nDamage);
    float fDUR = 9999.9f;   
	if(GetHasFeat(FEAT_ELEMWAR_WEAPON,oPC, TRUE))
	{	if(!GetIsItemPropertyValid(Prop)){
        
            SendMessageToPC(oPC, "Itemproperty was not valid");
            return;
        }
  
	IPSafeAddItemProperty(oItem,Prop,fDUR,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	IPSafeAddItemProperty(oItem, iGlow, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	SaveItemPropertyReference(oItem, "ElementalWeapon", Prop);
    SendMessageToPC(oPC, "Elemental Damage has been added to your weapon");
}
}


