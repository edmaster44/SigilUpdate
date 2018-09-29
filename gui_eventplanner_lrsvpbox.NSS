#include "event_window_includes"

void main(string message, string eventid, string yesnomaybe)
{
		object oPC = OBJECT_SELF;
		string name=GetName(oPC);
    	string account=GetPCPlayerName(oPC);		

		string syes;
		string sno;
		string smaybe;

		if (yesnomaybe == "yes")
		{
		syes = "1";
		sno = "0";
		smaybe = "0";
		}

		if (yesnomaybe == "no")
		{
		syes = "0";
		sno = "1";
		smaybe = "0";
		}

		if (yesnomaybe == "maybe")
		{
		syes = "0";
		sno = "0";
		smaybe = "1";
		}

		string sQuery = "BEGIN;DELETE FROM event_planner_rsvp WHERE eventid = '" + eventid + "' and accountname='" + SQLEncodeSpecialChars(account) + "' and charname='"+SQLEncodeSpecialChars(name)+"'"+
		";INSERT INTO event_planner_rsvp values ('"+SQLEncodeSpecialChars(account)+"','"+SQLEncodeSpecialChars(name)+"','"+eventid+"','"+syes+"','"+sno+"','"+smaybe+"','"+SQLEncodeSpecialChars(message)+"');COMMIT;";
			
		SQLExecDirect(sQuery);
		RsvpUpdate(eventid);
		UpdateEventWindow(oPC);
}