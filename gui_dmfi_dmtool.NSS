#include "ff_safevar"

////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_dmtool - DM Friendly Initiative - GUI script for running "tool" level commands
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/28/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "dmfi_inc_command"

void main(string sInput)
{
	object oPC = OBJECT_SELF;
	object oTool = DMFI_GetTool(oPC);
	object oPossess, oTarget;
	string sTest;
	string sCommand;
	string sList;
	string sTitle;
	string sScreen;
	int n;
	
	// COMMANDS RUN VIA THIS CODE - INDEPENDENT OF UI		
	if (GetStringLeft(sInput, 1)==".")
	{
		sInput = GetStringRight(sInput, GetStringLength(sInput)-1);
		sInput = DMFI_UnderscoreToSpace(sInput);
			
		oPC = DMFI_UITarget(oPC, oTool);
		DMFI_DefineStructure(oPC, sInput);
		DMFI_RunCommandCode(oTool, oPC, sInput);
	}	
	
	// A few special commands so that the context UI can share this script.
	else if (sInput=="context_time")
	{
		DMFI_ClearUIData(oPC);
		PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_TIME + PRM_);
		PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_24);
		PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_TIME);
		DMFI_ShowDMListUI(oPC);
	}
	else if (sInput=="context_grant")
	{
		DMFI_ClearUIData(oPC);
		PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_GRANT + PRM_);
		PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_DMLANGUAGE);
		PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_GRANT);
		DMFI_ShowDMListUI(oPC);
	}
	else if (sInput=="context_remove")
	{
		DMFI_ClearUIData(oPC);
		DeleteList(PG_LIST_LANGUAGE, oTool);
		PS_SetLocalObject(oTool, "DLG_HOLDER", oTool);  // Required for new CTDS functions
		DMFI_UITarget(oPC, oTool);
		oTarget = PS_GetLocalObject(oTool, DMFI_TARGET);
		DMFI_BuildLanguageList(oTool, oTarget);
		
		PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_REMOVE + PRM_ + PRM_LANGUAGE + PRM_);
		PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_LANGUAGE);
		PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_REMOVE);
		DMFI_ShowDMListUI(oPC);	
	}
	else if (sInput=="context_effects")
	{
		DMFI_ClearUIData(oPC);
		DeleteList(PG_TARGET_EFFECT, oTool);
		PS_SetLocalObject(oTool, "DLG_HOLDER", oTool);  // Required for new CTDS functions
		DMFI_UITarget(oPC, oTool);
		oTarget = PS_GetLocalObject(oTool, DMFI_TARGET);
		DMFI_BuildEffectList(oTool, oTarget);
		
		PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_REMOVE + PRM_ + PRM_EFFECT + PRM_);
		PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_TARGET_EFFECT);
		PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_EFFECTS);
		PS_SetLocalInt(oPC, DMFI_REQ_INT, 2);
		DMFI_ShowDMListUI(oPC);	
	}
	else if (sInput=="context_scale")
	{
		DMFI_ClearUIData(oPC);
		PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_SCALE + PRM_);
		PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_300);
		PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_SCALE);
		DMFI_ShowDMListUI(oPC);
	}
	else if (sInput=="context_appearance")
	{
		DMFI_ClearUIData(oPC);
		PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_APPEARANCE + PRM_);
		PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_APPEARANCE);
		PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_APPEARANCE);
		PS_SetLocalInt(oPC, DMFI_REQ_INT, 1);
		DMFI_ShowDMListUI(oPC);
	}	
	
		
	
	// UPDATE NUMBER COMMANDS - Custom Page and Header Info
	else if (FindSubString(sInput,"update_")!=-1)
	{
		DMFI_ClearUIData(oPC);
		PS_SetLocalString(oPC, DMFI_LAST_UI_COM, sInput);
		
		if (FindSubString(sInput, "dc")!=-1)
		{
			sList = PG_LIST_50;
			sTitle = CV_PROMPT_DC;
		}
		else if (FindSubString(sInput, "delay")!=-1)
		{
			sList = PG_LIST_50;
			sTitle = CV_PROMPT_DELAY;
		}	
		else if (FindSubString(sInput, "dur")!=-1)
		{
			sList = PG_LIST_DURATIONS;
			sTitle = CV_PROMPT_DURATION;
		}	
		else if (FindSubString(sInput, "vol")!=-1)
		{
			sList = PG_LIST_100;
			sTitle = CV_PROMPT_VOLUME;
		}	
							
		PS_SetLocalString(oPC, DMFI_UI_PAGE, sList);
		PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, sTitle);
		DMFI_ShowDMListUI(oPC);
	}	
		
	else if (FindSubString(sInput,"toggle_")!=-1)
	{
		sScreen = PS_GetLocalString(oPC, "DMFI_UI_USE");
		sScreen = SCREEN_DMFI + sScreen;	
		
		sCommand = GetStringRight(sInput, GetStringLength(sInput)-7);
		sTest = DMFI_TogglePreferences(oTool, sCommand);
		SetGUIObjectText(oPC, sScreen, "toggle_"+sCommand, -1, DMFI_CapitalizeWord(sTest));
	
		if (sCommand == "musictime")
		{
			// Special exception code to add the music type to the prompt for the list.
			sTest = DMFI_CapitalizeWord(PS_GetLocalString(oTool, DMFI_MUSIC_TIME));
			sTest = ColorText("Music " + sTest, COLOR_CYAN);
			SetGUIObjectText(oPC, SCREEN_DMFI_DMLIST, "DMListTitle", -1, sTest + CV_PROMPT_MS_TRACK);
		}	
	}
	
	else
	{
		sScreen = PS_GetLocalString(oPC, "DMFI_UI_USE");
		sScreen = SCREEN_DMFI + sScreen;	
	
		if (sInput=="close")
		{
			CloseGUIScreen(oPC, sScreen);
			CloseGUIScreen(oPC, SCREEN_DMFI_DMLIST);
			return;
		}
		else if (FindSubString(sInput, "sub")!=-1)
		{	
			DMFI_ClearUIData(oPC);
			
			if (sScreen==SCREEN_DMFI_DICETOOL)
			{
				if (sInput=="sub1")
				{
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_ABILITY);
					sTest = CV_PROMPT_ABILITY;
				}	
				else if (sInput=="sub2")
				{
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_SKILL);
					sTest = CV_PROMPT_SV;
				}	
				else if (sInput=="sub3")
				{
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_10);
					sTest = CV_PROMPT_DICE;
				}
				PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_ROLL + PRM_);
			}
			else if (sScreen==SCREEN_DMFI_MUSICTOOL)
			{		
				if (sInput=="sub1")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_MUSIC_NWN2);
				else if (sInput=="sub2")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_MUSIC_NWN1);
				else if (sInput=="sub3")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_MUSIC_XP);
				else if (sInput=="sub4")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_MUSIC_BATTLE);
				else if (sInput=="sub5")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_MUSIC_MOTB);	
				
				sTest = DMFI_CapitalizeWord(PS_GetLocalString(oTool, DMFI_MUSIC_TIME));
				sTest = ColorText("Music " + sTest, COLOR_CYAN);
				sTest = sTest + CV_PROMPT_MS_TRACK;
				PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_SET + PRM_ + PRM_MUSIC + PRM_); 
				PS_SetLocalInt(oPC, DMFI_REQ_INT, 1);
			}
			else if (sScreen==SCREEN_DMFI_VFXTOOL)
			{
				if (sInput=="sub1")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_VFX_SPELL);
				else if (sInput=="sub2")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_VFX_IMP);
				else if (sInput=="sub3")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_VFX_DUR);
				else if (sInput=="sub4")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_VFX_MISC);
				else if (sInput=="sub5")
				{//Special code to build the list dynamically
					DeleteList(PG_LIST_VFX_RECENT, oTool);
					PS_SetLocalObject(oTool, "DLG_HOLDER", oTool);  // Required for new CTDS functions
					DMFI_BuildRecentVFXList(oTool);
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_VFX_RECENT);
				}
				sTest = CV_PROMPT_VFX;
				PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_VFX + PRM_);
				PS_SetLocalInt(oPC, DMFI_REQ_INT, 1);
			}	
			else if (sScreen==SCREEN_DMFI_AMBTOOL)
			{
				if (sInput=="sub1")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_AMBIENT_CAVE);
				else if (sInput=="sub2")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_AMBIENT_MAGIC);
				else if (sInput=="sub3")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_AMBIENT_PEOPLE);
				else if (sInput=="sub4")
					PS_SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_AMBIENT_MISC);
				
				sTest =  CV_PROMPT_VOLUME;
				PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_SET + PRM_ + PRM_AMBIENT + PRM_); 
				PS_SetLocalInt(oPC, DMFI_REQ_INT, 1);
			}
			else if (sScreen==SCREEN_DMFI_SNDTOOL)
			{
				if (sInput=="sub1")
				{
					PS_SetLocalString(oPC, DMFI_UI_PAGE, "DISPLAY" + PG_LIST_SOUND_CITY);
					sCommand = PRM_CITY;
				}	
				else if (sInput=="sub2")
				{
					PS_SetLocalString(oPC, DMFI_UI_PAGE, "DISPLAY" + PG_LIST_SOUND_MAGICAL);
					sCommand = PRM_MAGICAL;
				}	
				else if (sInput=="sub3")
				{
					PS_SetLocalString(oPC, DMFI_UI_PAGE, "DISPLAY" + PG_LIST_SOUND_NATURE);
					sCommand = PRM_NATURE;
				}
				else if (sInput=="sub4")
				{
					PS_SetLocalString(oPC, DMFI_UI_PAGE, "DISPLAY" + PG_LIST_SOUND_PEOPLE);
					sCommand = PRM_PEOPLE;
				}	
				sTest = CV_PROMPT_SOUND;
				PS_SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_SOUND + PRM_ + sCommand + PRM_); 
				PS_SetLocalInt(oPC, DMFI_REQ_INT, 2);  // 2 use THE actual selction - not ref int - not string
			}		
			
			PS_SetLocalString(oPC, DMFI_UI_LIST_TITLE, sTest);
			DMFI_ShowDMListUI(oPC);	
		}
	}	
}				