

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_placeable_signs"

void main()
{
	object oPlaceable = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	string sOwner = GetLocalString(oPlaceable,"OWNER_NAME");
	
	if (sOwner == GetName(oPC))
	{
		// spawn convo with PC to decide what to do, rotate, destroy, etc.
		SetLocalObject(oPC, "LASTSIGNTALK", oPlaceable);
		AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_sign", TRUE, FALSE, TRUE, TRUE));
	}
	else
	{
		// scan to see if the creating player is around.
		int iPlayerFound = 0;
		object oPlayers = GetFirstPC();
		while (oPlayers != OBJECT_INVALID)
		{
			if (GetName(oPlayers) == sOwner) iPlayerFound = 1;
			oPlayers = GetNextPC();
		}
		if (iPlayerFound == 1)
		{
			if (GetHasInventory(oPlaceable) == TRUE) 
			{
				if (GetTag(oPlaceable) == "ps_usersign_display")
				{
					SendMessageToPC(oPC, "<color=red>WARNING: This container does not belong to you. Be warned, put anything in here and you can lose it! Don't take anything or you will be punished and will lose the item(s) anyway.");
					return; // then its going to open (hopefully)
				}
				else
				{
					SendMessageToPC(oPC, "<color=red>WARNING: This container does not belong to you.  The owner can destroy it at any time. Place items in it at own risk!!!");
				}
			}
			else
			{
				SendMessageToPC(oPC, "Get yer filty mitts off this sign! It belongs to " + sOwner + "!");
			}
		}
		else
		{
			SetLocalObject(oPC, "LASTSIGNTALK", oPlaceable);
			AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_sign_no", TRUE, FALSE, TRUE, TRUE));
		}
	}
}