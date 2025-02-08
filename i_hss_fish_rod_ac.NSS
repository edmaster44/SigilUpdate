#include "ff_safevar"

//HSS on activate item event script
#include "hss_fishing_inc"
#include "ps_sigis_inc"

void main()
{
	 object oPC = GetItemActivator();
	 object oItem = GetItemActivated();
	 
	 int nCooldown = PS_GetLocalInt(oPC, "VAR_FISHING_COOLDOWN");
	 int nCurrentTime = GetRealTime();
	 int nDelay = 30;	//delay 
	 
	 if (nCooldown > nCurrentTime)	{
		FloatingTextStringOnCreature("YOU CANNOT USE FISHING ROD AGAIN SO SOON, YOU MUST WAIT "+IntToString(nCooldown - nCurrentTime)+" SECONDS.", oPC, FALSE);
		return;
	 }
	 else	{
		SendMessageToPC(oPC, "CALLING CAST");
		PS_SetLocalInt(oPC,"VAR_FISHING_COOLDOWN",nCurrentTime + nDelay);
		HSS_DoCast(oPC, oItem);
	 }
}