/***********************************************************
* Created by Loki_999/Agony_Aunt for SCoD persistent world *
*                                                          *
* i_psitemrestrict_eq - items can be given a tag of        *
* psitemrestrict which will cause this script to make item *
* property restrictions non-breakable by UMD.              *
* Should they equip, the script will unequip               *
***********************************************************/

#include "ps_itemrestrict_inc"

void main()
{
    object oItem = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();
	
	RestrictItemUse(oItem, oPC);
}