#include "ff_safevar"

#include "gui_kemo_scry_inc"

void main(string sOPTION)
{
	object oPC = OBJECT_SELF;
	object oESS = GetItemPossessedBy(oPC,"ps_essence");
	int nANON = PS_GetLocalInt(oPC,"KScry_Anon");
	int nOPTION = StringToInt(sOPTION);
	switch (nOPTION)
	{
		case 0: //Anonymous
			if (nANON == 1)
			{
				PS_SetLocalInt(oPC,"KScry_Anon",0);
				SetGUIObjectText(oPC,"KEMO_SCRY_PANEL","KEMO_SCRY_ANON",-1,"Go Anon");
			}
			else
			{
				PS_SetLocalInt(oPC,"KScry_Anon",1);
				SetGUIObjectText(oPC,"KEMO_SCRY_PANEL","KEMO_SCRY_ANON",-1,"Go Visible");
			}
			ExecuteScript("gui_kemo_scry_gather", oPC);
			return;
			break;
		case 1: //Open Option Panel
			DisplayGuiScreen(oPC,"KEMO_SCRY_OPTIONS",FALSE,"kemo_scry_options.xml");
			return;
			break;
		case 2: PS_SetLocalString(oPC, "KScry_Status", "LFG"); break; //Looking for group
		case 3: PS_SetLocalString(oPC, "KScry_Status", "AFK"); break; //Away from Keyboard
		case 4: PS_SetLocalString(oPC, "KScry_Status", "DND"); break; //Do Not Disturb
		case 5: PS_SetLocalString(oPC, "KScry_Status", "LFRP"); break; //Role Play
		case 6: PS_SetLocalString(oPC, "KScry_Status", "SHOP"); break; //Shop
		case 7: PS_SetLocalString(oPC, "KScry_Status", "    "); break; //Clear
		case 8: PS_SetLocalInt(oESS, "KScry_Faction", 1); break; //Faction Shown
		case 9: PS_SetLocalInt(oESS, "KScry_Faction", 0); break; //Faction Hidden
		case 10: PS_SetLocalInt(oESS, "KScry_Faction", 2); break; //Faction Seek
		case 11: PS_SetLocalInt(oESS, "KScry_Level", 1); break; //Level Shown
		case 12: PS_SetLocalInt(oESS, "KScry_Level", 0); break; //Level Hidden
		case 13: PS_SetLocalInt(oESS, "KScry_Location", 0); break; //Area Shown
		case 14: PS_SetLocalInt(oESS, "KScry_Location", 1); break; //Area Hidden
		default: return; //Something wrong happened
	}

	int nROW = 1;
	int nFOUND = 0;
	object oROW = PS_GetLocalObject(oPC, "ScryObject_"+IntToString(nROW));
	while (oROW != OBJECT_INVALID)
	{
		if (oROW == oPC) break;
		{
			nFOUND = 1;
			break;
		}
		nROW = nROW + 1;
		oROW = PS_GetLocalObject(oPC, "ScryObject_"+IntToString(nROW));
	}
	if (nFOUND == 0) return; //In case the caller is anonymous
	string sROW = "ScryRow" + IntToString(nROW);
	DelayCommand(0.0f, ChangeList(nANON, oPC, oPC, sROW, 1));
}