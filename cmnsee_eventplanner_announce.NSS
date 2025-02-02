#include "ff_safevar"

#include "nwnx_sql"
#include "nwnx_srvadmin"

void AnnounceEvent(string title, string time)
{
	if (title == "") return;
	
	if (time == "59" || time == "30")
	{
	BroadcastServerMessage("EVENT PLANNER: Event "+title+" to begin in "+time+" minutes. Check the event planner for more details.");
	}	
}

void main()
{	
	if (GetCustomHeartbeat(OBJECT_SELF) == 6000)
	{
		SetCustomHeartbeat(OBJECT_SELF,60000); // 1 minute
	}
	
	if(PS_GetLocalInt(OBJECT_SELF,"NOHB") == 1) return;
	PS_SetLocalInt(OBJECT_SELF,"NOHB",1);
	DelayCommand(60.0f, PS_DeleteLocalInt(OBJECT_SELF,"NOHB"));

	SQLExecDirect("SELECT `title`, MINUTE(TIMEDIFF(`starttime`,NOW())) from event_planner where `starttime`"+
	" <= date_add(NOW(), interval 1 hour) and `starttime` >= date_sub(NOW(), interval 1 hour);");
	
	while (SQLFetch() == SQL_SUCCESS)
	{
	AnnounceEvent(SQLGetData(1),SQLGetData(2));
	}
	
	return;
}