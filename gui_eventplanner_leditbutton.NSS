#include "nwnx_sql"
#include "event_window_includes"

void main(string eventid)
{

		string title = "EVENT_WINDOW_CREATE";
		string stitle;
		string sdesc;
		string sloc;
		string smonth;
		string sday;
		string syear;
		string stime;
		string emonth;
		string eday;
		string eyear;
		string etime;
		
		CloseGUIScreen(oPC,title);	

		string sQuery = "SELECT title, description, location, Month(StartTime), Day(StartTime),"+
		"Year(StartTime), TIME_FORMAT(Time(StartTime),'%h:%i'),Month(EndTime), Day(EndTime), Year(EndTime),"+
		"TIME_FORMAT(Time(EndTime),'%h:%i') from event_planner where eventid="+eventid+";";
		
		SQLExecDirect(sQuery);
		while (SQLFetch())
		{
		stitle = SQLGetData(1);
		sdesc = SQLGetData(2);
		sloc = SQLGetData(3);
		smonth =SQLGetData(4);
		sday = SQLGetData(5);
		syear = SQLGetData(6);
		stime = SQLGetData(7);
		emonth = SQLGetData(8);
		eday  = SQLGetData(9);
		eyear =SQLGetData(10);
		etime =SQLGetData(11);

		DisplayGuiScreen(oPC,title,FALSE,"event_window_create.xml");
		SetGUIObjectHidden(oPC,title,"savebutton",TRUE);
		SetGUIObjectHidden(oPC,title,"editbutton",FALSE);

		SetGUIObjectText(oPC,title,"DESC_INPUT_TEXT",-1,sdesc);
		SetGUIObjectText(oPC,title,"TITLE_INPUT_TEXT",-1,stitle);
		SetGUIObjectText(oPC,title,"REQUIREMENTS_LISTBOX",-1,sloc);
		
		SetGUIObjectText(oPC,title,"createorsave",-1,"Edit Event");
		SetGUIObjectText(oPC,title,"eventid",-1,eventid);
		
		SetGUIObjectText(oPC,title,"FROMMONTH_INPUT_TEXT",-1,smonth);
		SetGUIObjectText(oPC,title,"FROMDAY_INPUT_TEXT",-1,sday);
		SetGUIObjectText(oPC,title,"FROMYEAR_INPUT_TEXT",-1,syear);
		
		SetGUIObjectText(oPC,title,"TOMONTH_INPUT_TEXT",-1,emonth);
		SetGUIObjectText(oPC,title,"TODAY_INPUT_TEXT",-1,eday);
		SetGUIObjectText(oPC,title,"TOYEAR_INPUT_TEXT",-1,eyear);
		
		SetGUIObjectText(oPC,title,"FROMTIME_INPUT_TEXT",-1,stime);
		SetGUIObjectText(oPC,title,"TOTIME_INPUT_TEXT",-1,etime);
	
		}

}