#include "ff_safevar"

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_placeable_signs"

void main()
{
	object oPC = GetItemActivator();
    //object oItem = GetItemActivated();
    object oPlaceable = GetItemActivatedTarget();
	string sOwner = PS_GetLocalString(oPlaceable,"OWNER_NAME");
	
	if (sOwner == GetName(oPC))
	{
		// spawn convo with PC to decide what to do, rotate, destroy, etc.
		PS_SetLocalObject(oPC, "LASTSIGNTALK", oPlaceable);
		AssignCommand(oPC, ActionStartConversation(oPlaceable, "ps_conv_sign", TRUE, FALSE, TRUE, TRUE));
	}
	else
	{
		// scan to see if the creating player is around.
		int iPlayerFound = 0;
		object oPlayers = GetFirstPC();
		while (oPlayers != OBJECT_INVALID)
		{
			if (GetName(oPlayers) == sOwner &&
				GetArea(oPlayers) == GetArea(oPC)) {
				iPlayerFound = 1;
			}
			
			oPlayers = GetNextPC();
		}
		if (iPlayerFound == 1)
		{
			if (GetHasInventory(oPlaceable) == TRUE)
			{
				if (GetTag(oPlaceable) == "ps_usersign_display")
				{
					SendMessageToPC(oPC, "<color=red>This container does not belong to you. Be warned, put anything in here and you can lose it! Don't take anything or you will be punished and will lose the item(s) anyway.");
					return;
				}
				else
				{
					SendMessageToPC(oPC, "<color=red>This container does not belong to you. Be warned, put anything in here and you can lose it if the owner destroys it!");
					return; // then its going to open (hopefully)
				}
			}
			else
			{
				SendMessageToPC(oPC, "You can't manipulate this object. It belongs to " + sOwner + "!");
			}
		}
		else if (GetStringLeft(GetResRef(oPlaceable), 11) == "ps_usersign")
		{
			PS_SetLocalObject(oPC, "LASTSIGNTALK", oPlaceable);
			AssignCommand(oPC, ActionStartConversation(oPlaceable, "ps_conv_sign_no", TRUE, FALSE, TRUE, TRUE));
		}
		else
		{
			SendMessageToPC(oPC, "This is not a user placeable and cannot be manipulated with this tool.");
		}
	}
}