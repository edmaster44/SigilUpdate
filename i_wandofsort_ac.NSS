#include "ff_safevar"

// script for the wand of sorting

#include "ps_wandofsort_inc"

void main()
{
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();
	// SendMessageToPC(oPC, "Due to problems with this device it no longer functions.");
	if (GetBaseItemType(oTarget) == BASE_ITEM_LARGEBOX && GetItemPossessor(oTarget) == oPC)
	{
		PS_SetLocalObject(oPC, VAR_TEMP_OBJECT, oTarget);
		AssignCommand(oPC, ActionStartConversation(oPC, "conv_wandofsort", TRUE, FALSE, TRUE, TRUE));
	}
	else
	{
		SendMessageToPC(oPC, "<color=lime>You must target a container in your inventory for this to work.");
	}
}