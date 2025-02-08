#include "ff_safevar"

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_faction"

void main(int iFunction)
{
	object oHench = OBJECT_SELF;
	object oPC = GetPCSpeaker();
	object oBadge = PS_GetLocalObject(oPC, "FactionBadgeUsed");
	
	// 1 = Equip, 2= unequip, 3 = dismiss
	switch (iFunction)
	{
		case 1:
			FactionCohortEquipWeapons(oHench);
			break;
			
		case 2:
			FactionCohortUnequipWeapons(oHench);
			break;
			
		case 3:
			ClearHenchInfo(oBadge);		
			DismissFactionCohort(oHench);
			break;
	}
}