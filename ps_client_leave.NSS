

// V1.00

#include "nwnx_sql"
#include "nwnx_srvadmin"
#include "ps_inc_time"
#include "ginc_time"

void Reboot_ShutdownNwn2server()
{
	if (GetLocalInt(GetModule(), "reboot") == 0)
		return;

	ShutdownNwn2server();
}

void Reboot_SendMessageToPC(object oPC, string sMessage)
{
	if (GetLocalInt(GetModule(), "reboot") == 0)
		return;

	SendMessageToPC(oPC, sMessage);
}

void main()
{
    object oMod = GetModule();
	
	UpdateClockForAllPlayers();

	PS_OnPCLeave(GetExitingObject());
	
	if( GetLocalInt(oMod, "reboot") == 1 )
	{
		return;
	}
	
	if (GetIsServerResetTime()) {
		SetLocalInt(oMod, "reboot", 1);
			
		DelayCommand(300.0,Reboot_ShutdownNwn2server());
		
		object oPC = GetFirstPC();
		while (GetIsObjectValid(oPC) == TRUE) {
		
			SendMessageToPC( oPC, "====== 24 hour server reset ======" );
			SendMessageToPC( oPC, "=Server will restart in 5 minutes=" );
			SendMessageToPC( oPC, "==================================" );
			DelayCommand(240.0,Reboot_SendMessageToPC( oPC, "============ 24 hour server reset ==================" ));
			DelayCommand(240.1,Reboot_SendMessageToPC( oPC, "Server will restart in 1 minute, please log off now." ));
			DelayCommand(240.2,Reboot_SendMessageToPC( oPC, "====================================================" ));
			oPC = GetNextPC();
		}
	}

}