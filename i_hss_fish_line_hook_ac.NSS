//HSS on activate item event script
#include "hss_fishing_inc"
#include "ps_sigis_inc"

void main()
{
	 object oPC = GetItemActivator();
	 object oItem = GetItemActivated();
	 
	 int nCooldown = GetLocalInt(oPC, "VAR_FISHING_COOLDOWN");
	 int nCurrentTime = GetRealTime();
	 int nDelay = 30;	//delay 
	 
	 if (nCooldown > nCurrentTime)	{
		FloatingTextStringOnCreature("YOU CANNOT USE FISHING ROD AGAIN SO SOON, YOU MUST WAIT "+IntToString(nCooldown - nCurrentTime)+" SECONDS.", oPC, FALSE);
		return;
	 }
	 else	{
		//SendMessageToPC(GetFirstPC(), "CALLING CAST");
		SetLocalInt(oPC,"VAR_FISHING_COOLDOWN",nCurrentTime + nDelay);
		HSS_DoCast(oPC, oItem);
	 }
}