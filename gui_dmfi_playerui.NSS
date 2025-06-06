

////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_playerui - DM Friendly Initiative - GUI script for Player UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/4/6	qk 10/07/07
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script routes or executes all Player UI input.

#include "dmfi_inc_const"
#include "dmfi_inc_tool"
#include "dmfi_inc_command"

void main(string sInput, string sInput2)
{
	object oPC = OBJECT_SELF;
	object oRename, oTest, oTarget, oRef;
	object oTool = DMFI_GetTool(oPC);
	string sText;
	
	int n=1;
	
	// RENAMING FUNCTIONS	
	if (GetStringLeft(sInput, 1)!=".")
	{  // ONLY options for players are code to run commands OR change names
	   // so if we aren't running a command, we are changing a name.
		object oRename = GetLocalObject(oTool, DMFI_TARGET);
		
		if (GetObjectType(oRename)==OBJECT_TYPE_CREATURE)
		{
			SetFirstName(oRename, sInput);
			SetLastName(oRename, sInput2);
			SendText(oPC, TXT_RENAME_OBJ_SUCCESS, TRUE, COLOR_GREEN);	
			CloseGUIScreen(OBJECT_SELF, SCREEN_DMFI_CHGNAME);
		}
		else
		{
			oRef = GetLocalObject(oRename, DMFI_INVENTORY_TARGET);
			SetFirstName(oRef, sInput);
			SetFirstName(oRename, sInput);
			SendText(oPC, TXT_RENAME_ITM_SUCCESS, TRUE, COLOR_GREEN);	
			CloseGUIScreen(OBJECT_SELF, SCREEN_DMFI_CHGITEM);
		}
	}	
	
	// ALL OTHER FUNCTIONS
	else
	{
		sInput = GetStringRight(sInput, GetStringLength(sInput)-1);
		sInput = DMFI_UnderscoreToSpace(sInput);	
		
		if (sInput==DMFI_UI_ABILITY)
		{		
			SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_ABILITY);
			DisplayGuiScreen(oPC, SCREEN_DMFI_LIST, TRUE, "dmfilist.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LISTTITLE, -1, TXT_CHOOSE_ABILITY);
			n=0;
			while (n<10)
			{
				sText = GetLocalString(oTool, LIST_PREFIX + PG_LIST_ABILITY + "." + IntToString(n));
				SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LIST + IntToString(n+1), -1, sText);
				n++;
			}		
		}	
       	else if (sInput==DMFI_UI_SKILL)
		{		
		    DisplayGuiScreen(oPC, SCREEN_DMFI_SKILLS, TRUE, "dmfiskillsui.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_SKILLS, DMFI_UI_SKILLTITLE, -1, TXT_CHOOSE_SKILL);
			n = 0;
			while (n<28)
			{
				sText = GetLocalString(oTool, LIST_PREFIX + PG_LIST_SKILL + "." + IntToString(n));
				SetGUIObjectText(oPC, SCREEN_DMFI_SKILLS, "skill"+IntToString(n+1), -1, sText);				
				n++;
			}
			
			SetGUIObjectHidden(oPC, SCREEN_DMFI_SKILLS, "btn29", TRUE);
			SetGUIObjectHidden(oPC, SCREEN_DMFI_SKILLS, "btn30", TRUE);	
		}
		else if (sInput==DMFI_UI_LANGUAGE)	
		{		
			SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_LANG);
			DeleteList(PG_LIST_LANGUAGE, oTool);
            DMFI_BuildLanguageList(oTool, oPC);
		
			DisplayGuiScreen(oPC, SCREEN_DMFI_LIST_LANG, TRUE, "dmfilist_lang.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST_LANG, DMFI_UI_LISTTITLE, -1, TXT_CHOOSE_LANGUAGE);
			n=0;
			while (n<=20)
			{
				sText = GetLocalString(oTool, LIST_PREFIX + PG_LIST_LANGUAGE + "." + IntToString(n));
				if (sText!="") 
					SetGUIObjectText(oPC, SCREEN_DMFI_LIST_LANG, DMFI_UI_LIST  +IntToString(n+1), -1, sText);
				else
					SetGUIObjectHidden(oPC, SCREEN_DMFI_LIST_LANG, "btn" +IntToString(n+1), TRUE);	
				n++;
			}		
		}
		else if (sInput==DMFI_UI_DICE)
		{
			SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_NUMBER);	
			DisplayGuiScreen(oPC, SCREEN_DMFI_LIST, TRUE, "dmfilist.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LISTTITLE, -1, TXT_CHOOSE_NUMBER);
			n=1;
			while (n<10)
			{
				SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LIST + IntToString(n), -1, IntToString(n));
				n++;
			}			
		}
		else
		{
			DMFI_UITarget(oPC, oTool);	
			DMFI_DefineStructure(oPC, sInput);
			DMFI_RunCommandCode(oTool, oPC, sInput);
		}		
	}
}			