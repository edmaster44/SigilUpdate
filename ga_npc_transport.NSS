

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "x0_i0_position"
//#include "ginc_item"

void main()
{
    object oPC 		= GetItemActivator();
	object oSummon 	= GetLocalObject(oPC, "RCTag");
	location lPC	= GetLocation(oPC) ;

	if (GetIsInCombat(oSummon) == FALSE)
	{
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oSummon, ActionJumpToLocation(lPC));	
	}
	else
	{
		SetNoticeText(oPC,"This item cannot be used on a henchman engaged in combat.");
	}	
}