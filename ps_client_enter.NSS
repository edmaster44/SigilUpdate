// V1.00
/*
rapsam2003 06/20/2018: Added a call to PS_GiveSpellFeat,
	which assigns placeholder spellcasting feats.
*/

#include "ps_wandofsort_inc"
#include "ps_givespellfeat"
#include "nwnx_srvadmin"
#include "ps_inc_time"

int GetServerResetTime();

void main()
{
	object oPC = GetEnteringObject();

	//
	// If a player logs out and logs back in and their character is rehydrated
	// from saved information, the old item objects are leaked (but are still
	// marked as owned by the player which retains the same object ID).  To
	// avoid items being sorted into the leaked item objects, point the sort to
	// object IDs back to their current object values (client enter runs after
	// all items have been reconstituted on the incoming player character).
	//
	ResetSortObjectsOnPC(oPC);
	
	//GetIsServerResetTime(oPC);

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
	
}