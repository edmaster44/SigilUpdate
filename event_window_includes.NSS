#include "nwnx_sql"

		object oPC = OBJECT_SELF;
    	string name=GetName(oPC);
    	string account=GetPCPlayerName(oPC);

void UpdateEventWindow(object oPC)
{
		string sQuery;		
		string syes;
		string sno;
		string smaybe;
		string seventid;
		string seventname;
		string starttime;
		string endtime;
		string sownerchar;
		string sowneraccount;
		int n;
			
		ClearListBox(oPC,"EVENT_WINDOW_MAINGUI","UPCOMINGEVENTS_LISTBOX");
		
		SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","viewbutton",TRUE);
		SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","editbutton",TRUE);
		SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","deletebutton",TRUE);
		
		//Selects the first fields
		
		sQuery = "SELECT event_planner.eventid, LEFT(event_planner.title,25), DATE_FORMAT(event_planner.StartTime,'%m-%d%-%Y %H:%i')"+
		"as StartTime, DATE_FORMAT(event_planner.EndTime,'%m-%d%-%Y %H:%i') as EndTime, event_planner.ownerchar, event_planner.owneraccount,"+
		"COALESCE (sum(event_planner_rsvp.yes),0), COALESCE (sum(event_planner_rsvp. NO), 0), COALESCE (sum(event_planner_rsvp.maybe),0)"+
		"FROM event_planner LEFT JOIN event_planner_rsvp ON event_planner.eventid = event_planner_rsvp.eventid "+
		"WHERE StartTime >= CURDATE() GROUP BY eventid ORDER BY StartTime ASC;";
		
		SQLExecDirect(sQuery);
		while (SQLFetch())
		{	
		seventid = SQLGetData(1);
		seventname = SQLGetData(2);
	    starttime = SQLGetData(3);
		endtime = SQLGetData(4);
		sownerchar = SQLGetData(5);
		sowneraccount = SQLGetData(6);
		syes = SQLGetData(7);
		sno = SQLGetData(8);
		smaybe = SQLGetData(9);
		
		string inputtext = "event="+seventname+";start_time="+starttime+
		";yattendance="+syes+" - yes;mattendance="+smaybe+
		" - maybe;nattendance="+sno+" - no";
		
		string svariable = "1="+seventid+";2="+sownerchar+";3="+sowneraccount;
		
		AddListBoxRow(oPC, "EVENT_WINDOW_MAINGUI", "UPCOMINGEVENTS_LISTBOX", "Row" + IntToString(++n),""+inputtext+"", "", ""+svariable+"", "");
		}
	}
	
		void RsvpUpdate(string eventid)
		{
		string title = "EVENT_WINDOW_VIEW";	
		string rsvpcharname;
		string rsvpaccountname;
		string rsvpyes;
		string rsvpno;
		string rsvpmaybe;
		string rsvpmessage;
		string yesnomaybe;
		
		SetGUIObjectDisabled(oPC,title,"yesbutton",FALSE);
		SetGUIObjectDisabled(oPC,title,"nobutton",FALSE);
		SetGUIObjectDisabled(oPC,title,"maybebutton",FALSE);
		SetGUIObjectText(oPC,title,"RSVP_INPUT_TEXTBOX",-1,"");
		SetGUIObjectText(oPC,title,"eventid",-1,eventid);
		
		ClearListBox(oPC,title,"RSVP_BOX");
		
		SQLExecDirect("SELECT accountname,LEFT(charname, 15),yes,no,maybe,message FROM event_planner_rsvp where eventid="+eventid+";");
		
		while (SQLFetch())
		{
		
		rsvpaccountname = SQLGetData(1);
		rsvpcharname = SQLGetData(2);
		rsvpyes = SQLGetData(3);
		rsvpno = SQLGetData(4);
		rsvpmaybe = SQLGetData(5);
		rsvpmessage = SQLGetData(6);
		
		if (rsvpyes=="1"){ yesnomaybe = "Accept!";}
		if (rsvpno=="1"){ yesnomaybe = "Can't make it.";}
		if (rsvpmaybe=="1"){ yesnomaybe = "Maybe.";}
						
		if (rsvpcharname == name && account == rsvpaccountname)
		{
		SetGUIObjectText(oPC,title,"RSVP_INPUT_TEXTBOX",-1,rsvpmessage);
		
		if (rsvpyes=="1")
		{
		SetGUIObjectDisabled(oPC,title,"yesbutton",TRUE);
		SetGUIObjectDisabled(oPC,title,"nobutton",FALSE);
		SetGUIObjectDisabled(oPC,title,"maybebutton",FALSE);
		}
		
		if (rsvpmaybe=="1")
		{
		SetGUIObjectDisabled(oPC,title,"yesbutton",FALSE);
		SetGUIObjectDisabled(oPC,title,"nobutton",FALSE);
		SetGUIObjectDisabled(oPC,title,"maybebutton",TRUE);
		}
		
		if (rsvpno=="1")
		{
		SetGUIObjectDisabled(oPC,title,"yesbutton",FALSE);
		SetGUIObjectDisabled(oPC,title,"nobutton",TRUE);
		SetGUIObjectDisabled(oPC,title,"maybebutton",FALSE);
		}
	}
		
		string rsvpinput = "namelb="+rsvpcharname+";rsvplb="+yesnomaybe+";messagelb="+rsvpmessage;
		AddListBoxRow(oPC, title, "RSVP_BOX", "",""+rsvpinput+"", "", "", "");
	}
}