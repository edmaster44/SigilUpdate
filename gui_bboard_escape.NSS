const string MSGBOARD_XML = "bboard.xml";
const string MSGBOARD_XML2 = "bboard_msg.xml";
const string SCREEN_MSGBOARD = "SCREEN_BBOARD"; //main board
const string SCREEN_BOARD_MESSAGE = "SCREEN_BBOARD_MSG"; //individual message
const string MSG_TXT = "BBOARD_TXT_";
const string MSG_IMG = "BBOARD_MSG_"; 
#include "ginc_var_ops"

int HasJournalEntry(object oPC, string sJournal) {

	return GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sJournal);

}


void main (int N1, int N2, string sVar) {

	object oPC = OBJECT_SELF;
	
	DisplayGuiScreen(oPC,SCREEN_MSGBOARD, FALSE, MSGBOARD_XML);
	CloseGUIScreen(oPC, SCREEN_BOARD_MESSAGE);
	
	object oBoard = GetNearestObjectByTag("questboard");
	
	int nMax = GetLocalInt(oBoard, "quest_max");
	int n = 0;
	int assigned = 1;
	int nPCLevel = GetHitDice(oPC);
	
	for (n = 1; n <= nMax; n++) {
	
		if (assigned > 6)
			break;
	
		string sNum = IntToString(n);
		string sText = GetLocalString(oBoard, "quest_msg_"+sNum);
		string sTitle = GetLocalString(oBoard, "quest_title_"+sNum);
		int nLevel = GetLocalInt(oBoard, "quest_level_"+sNum);
		string sJournal = GetLocalString(oBoard, "quest_journal_"+sNum);
		
		//Don't show missions we've already found!
		if (sJournal != "" && HasJournalEntry(oPC, sJournal) > 0)
			continue;
		
		int nDiff = abs(nPCLevel-nLevel);
		
		//AssignCommand(oBoard, ActionSpeakString("difference of "+sTitle+"'s level to PC's: "+IntToString(nDiff)));
		
		if (nDiff <= 2) { //4 level spread
			string sIndex = IntToString(assigned);
			SetGUIObjectText(oPC, SCREEN_MSGBOARD, MSG_TXT+sIndex, -1, sTitle);
			SetGUIObjectHidden(oPC, SCREEN_MSGBOARD, MSG_IMG+sIndex, FALSE);
			
			//AssignCommand(oBoard, ActionSpeakString("showing: "+MSG_IMG+sIndex));
			
			string sImg = GetLocalString(oPC, "quest_img_"+IntToString(assigned));
			SetLocalString(oPC, "quest_msg_"+IntToString(assigned), sText);
			SetLocalString(oPC, "quest_title_"+IntToString(assigned), sTitle);
			if (sImg != "")
				SetGUITexture(oPC, SCREEN_MSGBOARD, MSG_IMG+sIndex, sImg);
			
			/*AssignCommand(oBoard, ActionSpeakString("showing: bboard_note_"+sRand+".tga"));
			AssignCommand(oBoard, ActionSpeakString("setting quest_img_"+IntToString(assigned)+" to bboard_notelg_"+sRand+".tga"));
			AssignCommand(oBoard, ActionSpeakString("setting quest_msg_"+IntToString(assigned)+" to "+sText));
			AssignCommand(oBoard, ActionSpeakString("setting quest_title_"+IntToString(assigned)+" to "+sTitle));*/
			
			assigned++;
		}
	
	}

	
}