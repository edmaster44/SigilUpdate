#include "nwnx_sql"
#include "event_window_includes"

void main(string eventid)
{
		object oPC = OBJECT_SELF;
		string name=GetName(oPC);
    	string account=GetPCPlayerName(oPC);
		
		CloseGUIScreen(oPC,"EVENT_WINDOW_CREATE");	
		CloseGUIScreen(oPC,"EVENT_WINDOW_VIEW");	
		
		SQLExecDirect("BEGIN;DELETE FROM event_planner WHERE eventid = "+eventid+
		";DELETE FROM event_planner_rsvp WHERE eventid = "+eventid+";COMMIT;");
	
		DisplayMessageBox(oPC,0,"Event deleted successfully!","","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
		WriteTimestampedLogEntry(name+"("+account+") Deleted Event #"+eventid+" successfully."); 
		UpdateEventWindow(oPC);
}