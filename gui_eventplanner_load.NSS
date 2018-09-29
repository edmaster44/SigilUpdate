#include "nwnx_sql"
#include "event_window_includes"

void main()
{
		string sQuery;		
		object oPC = GetLastUsedBy();
		if (!GetIsObjectValid(oPC))	oPC = OBJECT_SELF;	
		DisplayGuiScreen(oPC,"EVENT_WINDOW_MAINGUI",FALSE,"event_window_maingui.xml");

		ClearListBox(oPC,"EVENT_WINDOW_MAINGUI","UPCOMINGEVENTS_LISTBOX");
		
		UpdateEventWindow(oPC);
}