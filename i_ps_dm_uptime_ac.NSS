#include "ff_safevar"

// Created by Loki_999/Agony_Aunt for SCOD server
// Tells how much time before next reset

#include "nwnx_sql"
#include "nwnx_srvadmin"

void main()
{
	object oDM = GetItemActivator();
    
	if (GetIsDM(oDM))
	{
		object oMod = GetModule();
		int nBootTime = PS_GetLocalInt(oMod, "boottime");
    	int nCurrentTime;
		int iDelayCount = PS_GetLocalInt(oMod, "delaycount");
		
		SQLExecDirect("SELECT UNIX_TIMESTAMP()");
	
		while (SQLFetch() != SQL_ERROR)
		{ 
			nCurrentTime = StringToInt(SQLGetData(1));
		}
		
		//24 hours = 86400 (24*60*60). 1 hour = 3600 (60*60)
		int nUpTime = nCurrentTime - nBootTime;
		int nDownTime = 86400 - nUpTime + (iDelayCount * 60 * 60);
		float fUpTime = IntToFloat(nUpTime);
		float fDownTime = IntToFloat(nDownTime);
		int nUpHours = FloatToInt(fUpTime / 3600);
		int nUpMins = FloatToInt((fUpTime - IntToFloat(nUpHours * 3600)) / 60);
		int nDownHours = FloatToInt(fDownTime / 3600);
		int nDownMins = FloatToInt((fDownTime - IntToFloat(nDownHours * 3600)) / 60);
		
		string sUpTime = "The server has been up " + IntToString(nUpHours) + " hours and " + IntToString(nUpMins) + ".";
		string sDownTime = "The next scheduled reboot is in " + IntToString(nDownHours) + " hours and " + IntToString(nDownMins) + ".";
		SendMessageToPC(oDM, sUpTime);
		if (iDelayCount > 0)
		{
			SendMessageToPC(oDM, "Server reset has been delayed " + IntToString(iDelayCount) + " times.");
		}
		SendMessageToPC(oDM, sDownTime);		
	}
	else
	{
		SendMessageToPC(oDM, "You shouldn't have this! Throw it in the trash!");
	}
}