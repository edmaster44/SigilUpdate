#include "ff_safevar"

const string MSGBOARD_XML = "bboard.xml";
const string MSGBOARD_XML2 = "bboard_msg.xml";
const string SCREEN_MSGBOARD = "SCREEN_BBOARD";
const string SCREEN_BOARD_MESSAGE = "SCREEN_BBOARD_MSG"; //individual message
const string MSG_TXT = "BBOARD_TXT_";
const string MSG_IMG = "BBOARD_MSG_"; 
#include "ginc_var_ops"

int HasJournalEntry(object oPC, string sJournal) {

	return PS_GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sJournal);

}

void ClearBoard(object oPC) {

	//AssignCommand(OBJECT_SELF, ActionSpeakString("Clearing board!"));
	SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+"1", -1, "");
	SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+"2", -1, "");
	SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+"3", -1, "");
	SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+"4", -1, "");
	SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+"5", -1, "");
	SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+"6", -1, "");
	
	SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+"1", TRUE);
	SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+"2", TRUE);
	SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+"3", TRUE);
	SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+"4", TRUE);
	SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+"5", TRUE);
	SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+"6", TRUE);
}

void main () {

	object oPC = GetLastUsedBy();
	
	if (GetHitDice(oPC) > 13) {
		SendMessageToPC(oPC, "There are no jobs available in your level range.");
		return;
	}
	
	DisplayGuiScreen(oPC, SCREEN_MSGBOARD, FALSE, MSGBOARD_XML);
	//DisplayGuiScreen(oPC, SCREEN_BOARD_MESSAGE, FALSE, MSGBOARD_XML2);
	ClearBoard(oPC);
	
	int nMax = PS_GetLocalInt(OBJECT_SELF, "quest_max");
	int n = 0;
	int assigned = 1;
	int nPCLevel = GetHitDice(oPC);
	
	for (n = 1; n <= nMax; n++) {
	
		if (assigned > 6)
			break;
	
		string sNum = IntToString(n);
		string sText = PS_GetLocalString(OBJECT_SELF, "quest_msg_"+sNum);
		string sTitle = PS_GetLocalString(OBJECT_SELF, "quest_title_"+sNum);
		int nLevel = PS_GetLocalInt(OBJECT_SELF, "quest_level_"+sNum);
		string sJournal = PS_GetLocalString(OBJECT_SELF, "quest_journal_"+sNum);
		
		//Don't show missions we've already found!
		if (sJournal != "" && HasJournalEntry(oPC, sJournal) > 0)
			continue;
		
		int nDiff = abs(nPCLevel-nLevel);
		
		//AssignCommand(OBJECT_SELF, ActionSpeakString("difference of "+sTitle+"'s level to PC's: "+IntToString(nDiff)));
		
		if (nDiff <= 2) { //4 level spread
			string sIndex = IntToString(assigned);
			SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+sIndex, -1, sTitle);
			string sRand = IntToString(Random(4)+1);
			SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+sIndex, FALSE);
		//	AssignCommand(OBJECT_SELF, ActionSpeakString("showing: "+MSG_IMG+sIndex));
			PS_SetLocalString(oPC, "quest_img_"+IntToString(assigned), "bboard_notelg_"+sRand+".tga");
			PS_SetLocalString(oPC, "quest_msg_"+IntToString(assigned), sText);
			PS_SetLocalString(oPC, "quest_title_"+IntToString(assigned), sTitle);
			SetGUITexture(oPC, SCREEN_MSGBOARD, MSG_IMG+sIndex, "bboard_note_"+sRand+".tga");
		/*	AssignCommand(OBJECT_SELF, ActionSpeakString("showing: bboard_note_"+sRand+".tga"));
			AssignCommand(OBJECT_SELF, ActionSpeakString("setting quest_img_"+IntToString(assigned)+" to bboard_notelg_"+sRand+".tga"));
			AssignCommand(OBJECT_SELF, ActionSpeakString("setting quest_msg_"+IntToString(assigned)+" to "+sText));
			AssignCommand(OBJECT_SELF, ActionSpeakString("setting quest_title_"+IntToString(assigned)+" to "+sTitle));
		*/	assigned++;
		}
	
	}

}