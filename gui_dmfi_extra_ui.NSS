

//:://////////////////////////////////////////////
//:: Created By: Clangeddin
//:: Created On: 2015
//:://////////////////////////////////////////////
#include "ps_inc_time"
#include "aaa_constants"
#include "ps_inc_achievements"
const int OOC_PORTAL_TIMEOUT = 30;
	
int CheckPoly(object oPC)
{
	effect eFX = GetFirstEffect(oPC);
	int nTYPE;
	while (GetIsEffectValid(eFX)==TRUE)
	{
		nTYPE = GetEffectType(eFX);
		if (nTYPE == EFFECT_TYPE_POLYMORPH) return TRUE;
		if (nTYPE == 1657) return TRUE;
		eFX = GetNextEffect(oPC);
	}
	return FALSE;
}

void OOCRoomPortal(object oPC) {

	object oOOCWP = GetWaypointByTag("wp_ooc_portal_destination");
	if (GetLocalInt(oPC, "LAST_OOC_PORTAL") == 0) {
		PS_Timestamp_UNIX(oPC, "LAST_OOC_PORTAL");
	}
	
	int nCurrentTime = GetRealTime();
	int nLastCheck = GetLocalInt(oPC, "LAST_OOC_PORTAL");
	int nDiff = nCurrentTime-nLastCheck;
	int nMinutes = (nDiff/60);
	
	string sMessage = "";
	if (nMinutes > OOC_PORTAL_TIMEOUT) {
		sMessage = "Do you want to return to the OOC Room?";
		DisplayMessageBox(oPC, -1, sMessage, "gui_ooc_room_portal", "", TRUE, "SCREEN_MESSAGEBOX_DEFAULT", -1, "Yes", -1, "No");
		/*PS_Timestamp_UNIX(oPC, "LAST_OOC_PORTAL");
		AssignCommand(oPC, JumpToObject(oOOCWP));
		SetGUITexture(oPC, "SCREEN_DMFI_PLAYER", "OOCPORTAL", "dmfi_icon_oocportal_disabled.tga");*/
	} else {
		sMessage = "It has been "+IntToString(nMinutes)+" minutes since you last ported to the OOC room. You need to wait "+IntToString(OOC_PORTAL_TIMEOUT-nMinutes)+" minutes before you can do so again.";
		DisplayMessageBox(oPC, -1, sMessage, "", "", FALSE, "SCREEN_MESSAGEBOX_DEFAULT", -1, "Ok");
	}

}

void main(string sWINDOW)
{
	object oPC = OBJECT_SELF;
	object oASS;
	int nTYPE = 1;
	int nPSION;
	int nPSYWAR;
	int nPOLY;
	int nWINDOW = StringToInt(sWINDOW);
	
	
	int nMinutes = PS_GetTimestamp_Age_Minutes(oPC, "LAST_OOC_PORTAL");
	if (nMinutes && nMinutes > OOC_PORTAL_TIMEOUT) {
		SetGUITexture(oPC, "SCREEN_DMFI_PLAYER", "OOCPORTAL", "dmfi_icon_oocportal.tga");
	}
	
	
	switch (nWINDOW)
	{
		case 1: //UI options
 			DisplayGuiScreen(oPC,"KEMO_ANIM",FALSE,"kemo_anim.xml");
			CloseGUIScreen(oPC,"KEMO_ANIM_MIN");
			break;
		case 2: //Scry Panel
			DisplayGuiScreen(oPC,"KEMO_SCRY_PANEL", FALSE, "kemo_scry_panel.xml");
			break;
		case 3: //Retrieve Associates
			if (GetIsInCombat(oPC)==TRUE)
			{
				FloatingTextStringOnCreature("You may not retrieve your associates during combat.", oPC, FALSE);
				return;
			}
			while (nTYPE < 6)
			{
				oASS = GetAssociate(nTYPE, oPC);
				if (oASS != OBJECT_INVALID) AssignCommand(oASS, JumpToObject(oPC));
				nTYPE = nTYPE + 1;
			}
			break;
		case 4: //Auxiliary Bars
			nPSION = GetLevelByClass(90, oPC);
			nPSYWAR = GetLevelByClass(CLASS_PSYCHIC_WARRIOR,oPC);
			nPOLY = CheckPoly(oPC);
			if (nPSION > 0) DisplayGuiScreen(oPC,"SCREEN_SPIRITBAR_PSION", FALSE, "powerpointscreen.xml");
			if (nPSYWAR > 0) DisplayGuiScreen(oPC,"SCREEN_SPIRITBAR_PSION", FALSE, "powerpointscreen.xml");
			if (nPOLY==TRUE) DisplayGuiScreen(oPC,"POLYMORPH_HOTBAR", FALSE, "polybar.xml");
			if ((nPSION<=0)&&(nPSYWAR<= 0)&&(nPOLY==FALSE)) FloatingTextStringOnCreature("Auxiliary Bars are only for Psions or Polymorphed Characters.", oPC, FALSE);
			break;
		case 5: //Difficulty
			DisplayGuiScreen(oPC,"SCREEN_DIFFICULTY_SIGIL", FALSE, "difficulty_sigil.xml");
			break;	
		case 6: //OOC Room Portal
			OOCRoomPortal(oPC);
			break;	
		case 7: //Achievements
			DisplayGuiScreen(oPC,"SCOD_ACHIEVEMENTS", FALSE, "scod_achievement_window.xml");
			ListAchievements(oPC);
			break;	
	}
}