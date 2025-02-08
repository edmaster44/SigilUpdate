#include "ff_safevar"

// delays reset by up to 3 hours - 1 hour per use.
// if 3 hour limit is reached, then no further delay possible

#include "nwnx_sql"
#include "nwnx_srvadmin"

void main()
{
	object oDM = GetItemActivator();
	if (GetIsDM(oDM))
	{
		object oMod = GetModule();
		int iResetCountdownStarted = PS_GetLocalInt(oMod, "reboot");
		int iBoottime = PS_GetLocalInt(oMod, "boottime");
		int iDelayCount = PS_GetLocalInt(oMod, "delaycount");
		int utc;
		
		SQLExecDirect("SELECT UNIX_TIMESTAMP()");
		while (SQLFetch() != SQL_ERROR) 
		{ 
			utc = StringToInt(SQLGetData(1));
		}
		
		if (iDelayCount >= 5) // no more than 5 delays allowed.
		{
			SendMessageToPC(oDM, "Sorry, but either you or another DM has already delayed the reset by at least 5 hours. Limit reached.");
		}
		else
		{
			iDelayCount += 1;

			PS_SetLocalInt(oMod, "delaycount", iDelayCount);
			
			int iNext = utc - iBoottime + 86400 + (iDelayCount * 60 * 60);
			SendMessageToPC(oDM, "Reset delayed " + IntToString(iDelayCount) + " times. Next scheduled reset now in " + IntToString(iNext) + " seconds.");
				
			if (iResetCountdownStarted == TRUE)
			{
				PS_SetLocalInt(oMod, "reboot", 0);
				SendMessageToPC(oDM, "<c=red><b><i>Current reset countdown aborted");
	
				// need to counter countdown 1 min warning
				object oPC = GetFirstPC();
				while (GetIsObjectValid(oPC) == TRUE)
				{
				   SendMessageToPC( oPC, "============= Reset Aborted by DM =============" );
				   SendMessageToPC( oPC, "= Reset delayed by at least 1 hour \o/        =" );
				   SendMessageToPC( oPC, "===============================================" );
				   oPC = GetNextPC();
				}
			}
		}

	}
	else
	{
		SendMessageToPC(oDM, "This is a DM only tool. You shouldn't have it! Throw it away.");
	}
}