/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Created for Eladrins - we can't make their weapons be good and chaotic, so we have to add damage to weapons */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"

void main()
{

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	
	object oWeap1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	object oGloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
	
	itemproperty ip1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEBONUS_1d6);
	itemproperty ip2 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEBONUS_1d6);
	
	if (GetIsObjectValid(oWeap1))
	{
		IPSafeAddItemProperty(oWeap1, ip1, 600.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		IPSafeAddItemProperty(oWeap1, ip2, 600.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		
		if (GetIsObjectValid(oWeap2))
		{
			IPSafeAddItemProperty(oWeap2, ip1, 600.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			IPSafeAddItemProperty(oWeap2, ip2, 600.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		}
	}
	else if (GetBaseItemType(oGloves) == BASE_ITEM_GLOVES)
	{
		IPSafeAddItemProperty(oGloves, ip1, 600.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		IPSafeAddItemProperty(oGloves, ip2, 600.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	}
}