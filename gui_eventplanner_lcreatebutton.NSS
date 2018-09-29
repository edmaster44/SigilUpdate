#include "nwnx_sql"
#include "event_window_includes"

void main()
{
		object oPC = OBJECT_SELF;	
		string title = "EVENT_WINDOW_CREATE";
		string sday;
		string smonth;
		string syear;
		string scurtime;
		
		CloseGUIScreen(oPC,title);	
	
		SQLExecDirect("SELECT DATE_FORMAT(CURDATE(), '%m'), DATE_FORMAT(CURDATE(), '%d'), DATE_FORMAT(CURDATE(), '%Y'), DATE_FORMAT(CURRENT_TIME(), '%H:%i');");
		while (SQLFetch())
		{	
		smonth = SQLGetData(1);
		sday = SQLGetData(2);
		syear = SQLGetData(3);
		scurtime = SQLGetData(4);	

		DisplayGuiScreen(oPC,title,FALSE,"event_window_create.xml");
		
		SetGUIObjectHidden(oPC,title,"savebutton",FALSE);
		SetGUIObjectHidden(oPC,title,"editbutton",TRUE);
		
		SetGUIObjectText(oPC,title,"createorsave",-1,"Create Event");
		
		SetGUIObjectText(oPC,title,"DESC_INPUT_TEXT",-1,"");
		SetGUIObjectText(oPC,title,"TITLE_INPUT_TEXT",-1,"");
		SetGUIObjectText(oPC,title,"REQUIREMENTS_LISTBOX",-1,"");
		
		SetGUIObjectText(oPC,title,"FROMMONTH_INPUT_TEXT",-1,smonth);
		SetGUIObjectText(oPC,title,"FROMDAY_INPUT_TEXT",-1,sday);
		SetGUIObjectText(oPC,title,"FROMYEAR_INPUT_TEXT",-1,syear);
		
		SetGUIObjectText(oPC,title,"TOMONTH_INPUT_TEXT",-1,smonth);
		SetGUIObjectText(oPC,title,"TODAY_INPUT_TEXT",-1,sday);
		SetGUIObjectText(oPC,title,"TOYEAR_INPUT_TEXT",-1,syear);
		
		SetGUIObjectText(oPC,title,"FROMTIME_INPUT_TEXT",-1,scurtime);
		SetGUIObjectText(oPC,title,"TOTIME_INPUT_TEXT",-1,scurtime);
	}
}