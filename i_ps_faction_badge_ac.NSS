

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_faction"

void main()
{
	object	oPC     = GetItemActivator();
    object	oItem   = GetItemActivated();
    object	oTarget = GetItemActivatedTarget();

	if(oPC == oTarget)
	{
		// Self functions relating to the badge such as faction summons, reporting on points, etc. 
		// as cannot target anything else except self with the self use no need to check spell ID
		// and long range i think can also target self.
		
		// sture the object for retrieval by convos/scripts
		SetLocalObject(oPC, "FactionBadgeUsed", oItem);
		AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_faction_badge", TRUE, FALSE, FALSE, TRUE));
	}
	else if (GetIsPC(oTarget)) //discrete display
	{
		DiscreteShowBadge(oPC, oTarget);
	}
	else // public display
	{
		PublicShowBadge(oItem, oPC);
	}
}