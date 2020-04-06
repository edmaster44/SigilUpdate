#include "x2_inc_itemprop"
#include "aaa_constants"

void main()
{
	object oPC = OBJECT_SELF;
	int nLevel=GetLevelByClass(CLASS_TYPE_ELEMENTAL_WARRIOR, oPC);
	int nItemVisual;
	int DamageType;		
	itemproperty iGlow = ItemPropertyVisualEffect(nItemVisual);
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR))
	{	
		DamageType = DAMAGE_TYPE_ELECTRICAL;
		nItemVisual = ITEM_VISUAL_ELECTRICAL;
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH))
	{	
		DamageType = DAMAGE_TYPE_ACID;
		nItemVisual = ITEM_VISUAL_ACID;				
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE))
	{
		DamageType = DAMAGE_TYPE_FIRE;
		nItemVisual = ITEM_VISUAL_FIRE;			
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER))
	{
		DamageType = DAMAGE_TYPE_COLD;
		nItemVisual = ITEM_VISUAL_COLD;	
	}
	int nDamageConstant = DAMAGE_BONUS_1d6;
				if (nLevel >= 5 ) 
		{	nDamageConstant 	= DAMAGE_BONUS_1d6 * 3;	}
	itemproperty ipAdd =ItemPropertyDamageBonus(DamageType,nDamageConstant);
    float fDUR = 9999.9f;   
	object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	if (GetIsObjectValid(oWeapon1))
	    { 
		IPSafeAddItemProperty(oWeapon1,ipAdd,fDUR,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		IPSafeAddItemProperty(oWeapon1, iGlow, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
	object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
	if (GetIsObjectValid(oWeapon2))
	{
	if (IPGetIsMeleeWeapon(oWeapon2))
			{
			IPSafeAddItemProperty(oWeapon2,ipAdd,fDUR,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			IPSafeAddItemProperty(oWeapon2, iGlow, fDUR, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
			}
	
    }
}