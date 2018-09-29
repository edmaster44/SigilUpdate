void main(string ownerchar, string owneraccount)
{
	object oPC = OBJECT_SELF;
	string name=GetName(oPC);
	string account=GetPCPlayerName(oPC);
	
	if ((ownerchar==name && owneraccount==account) || GetIsDM(oPC) == TRUE)
	{
	SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","editbutton",FALSE);
	SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","viewbutton",FALSE);
	SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","deletebutton",FALSE);
	}
	else
	{
	SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","viewbutton",FALSE);
	SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","editbutton",TRUE);
	SetGUIObjectHidden(oPC,"EVENT_WINDOW_MAINGUI","deletebutton",TRUE);	
	}
	}