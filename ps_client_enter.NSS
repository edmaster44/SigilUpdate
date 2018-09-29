// V1.00

#include "ps_wandofsort_inc"

void main()
{
	object oPC = GetEnteringObject();

	//WriteTimestampedLogEntry("ps_client_enter: oPC=" + GetName(oPC) + " (" + ObjectToString(oPC) + ")");

	//
	// If a player logs out and logs back in and their character is rehydrated
	// from saved information, the old item objects are leaked (but are still
	// marked as owned by the player which retains the same object ID).  To
	// avoid items being sorted into the leaked item objects, point the sort to
	// object IDs back to their current object values (client enter runs after
	// all items have been reconstituted on the incoming player character).
	//

	ResetSortObjectsOnPC(oPC);

	//
	// Send a warning to a player that logs in when a reset is pending so that
	// they know what's going on.
	//

	if (GetLocalInt(GetModule(), "reboot") != 0)
	{
		DelayCommand(20.0f, SendMessageToPC(oPC, "=========== 24 hour server reset ==========="));
		DelayCommand(20.1f, SendMessageToPC(oPC, "=Server will restart in less than 5 minutes="));
		DelayCommand(20.2f, SendMessageToPC(oPC, "============================================"));
	}
	
	//Applies invis on login.
    /*if (GetIsPC(oPC))
    {
        effect eLogin = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
        location lLocation = GetLocation(oPC);
        DelayCommand(6.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLogin, oPC, 40.0f));
	    DelayCommand(6.5f, SendMessageToPC(oPC, "<C=#d4afff>~~Log-in Invisibility applied for 40 seconds~~</C>"));
	    DelayCommand(36.5f, SendMessageToPC(oPC, "<C=#d4afff>~~Log-in Invisibility runs out in 10 seconds~~</C>"));
     }*/
}