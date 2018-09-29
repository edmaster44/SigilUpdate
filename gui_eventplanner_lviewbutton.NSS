#include "nwnx_sql"
#include "event_window_includes"

void main(string eventid)
{
		string sQuery;
		string title = "EVENT_WINDOW_VIEW";		
		object oPC = OBJECT_SELF;
    	string name=GetName(oPC);
    	string account=GetPCPlayerName(oPC);
		int n;
		
		SetGUIObjectDisabled(oPC,"EVENT_WINDOW_MAINGUI","viewbutton",TRUE);
		
		DelayCommand (5.0, SetGUIObjectDisabled(oPC,"EVENT_WINDOW_MAINGUI","viewbutton",FALSE));
				
		string stitle;
		string sdesc;
		string slocation;
		string sownerchar;
		string sowneraccount;
		string starttime;
		string howlong;
		string endtime;
		string beginorend;
		
		CloseGUIScreen(oPC,title);	
		DisplayGuiScreen(oPC,title,FALSE,"event_window_view.xml");
		ClearListBox(oPC,"EVENT_WINDOW_VIEW","RSVP_BOX");
		
		sQuery = "SELECT title,description,DATE_FORMAT(event_planner.StartTime,'%a %b, %D %Y @ %h:%i %p (%H:%i) Server Time (PST)') as StartTime,"+
			     "CASE WHEN (SELECT StartTime from event_planner where eventid="+eventid+") > NOW() then (SELECT CONCAT(FLOOR(HOUR(TIMEDIFF(NOW(),"+
 				 "(SELECT StartTime from event_planner where eventid="+eventid+"))) / 24), ' days ',MOD(HOUR(TIMEDIFF(NOW(),"+
 				 "(SELECT StartTime from event_planner where eventid="+eventid+"))), 24), ' hours ',MINUTE(TIMEDIFF(NOW(),"+
 				 "(SELECT StartTime from event_planner where eventid="+eventid+"))), ' minutes.')) end as HowLong,"+
				 "CASE WHEN (SELECT EndTime from event_planner where eventid="+eventid+") > NOW() then (SELECT CONCAT(FLOOR(HOUR(TIMEDIFF(NOW(),"+
 				 "(SELECT StartTime from event_planner where eventid="+eventid+"))) / 24), ' days ',"+
				 "MOD(HOUR(TIMEDIFF((SELECT EndTime from event_planner where eventid="+eventid+"),"+
 				 "(SELECT StartTime from event_planner where eventid="+eventid+"))), 24), ' hours ',MINUTE(TIMEDIFF((SELECT EndTime from event_planner where eventid="+eventid+"),"+
 				 "(SELECT StartTime from event_planner where eventid="+eventid+"))), ' minutes.')) end as EndTime,"+
				 "location,OwnerChar,OwnerAccount from event_planner where eventid="+eventid+";";
		
		SQLExecDirect(sQuery);
		while (SQLFetch())
		{	
		stitle = SQLGetData(1);
		sdesc = SQLGetData(2);
		starttime = SQLGetData(3);
		howlong = SQLGetData(4);
		endtime = SQLGetData(5);
		slocation = SQLGetData(6);
		sownerchar = SQLGetData(7);
		sowneraccount = SQLGetData(8);
		
		beginorend = "Event begins in "+howlong+"";
		
		if (howlong == "")
		{
		beginorend = "Event has started and ends in "+endtime+"";
		}
		
		if ((howlong) == "" && (endtime == ""))
		{
		beginorend = "Event has concluded.";
		}
		}
		
		SetGUIObjectText(oPC,title,"eventname",-1,stitle);
		SetGUIObjectText(oPC,title,"hostedby",-1,"Hosted By: "+sownerchar+" ("+sowneraccount+")");
					
		SetGUIObjectText(oPC,title,"dateandtime",-1,starttime);
		SetGUIObjectText(oPC,title,"starttime",-1,beginorend);
		
		SetGUIObjectText(oPC,title,"description",-1,sdesc);
		SetGUIObjectText(oPC,title,"location",-1,slocation);

		RsvpUpdate(eventid);

}