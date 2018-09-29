/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_placeable_signs"

void main()
{
	object oPC = GetItemActivator();
    object oItem = GetItemActivated();
    location oTarget = GetItemActivatedTargetLocation();
	
	CreateSignPlaceable(oPC, oItem, oTarget);
	DestroyObject(oItem);
}