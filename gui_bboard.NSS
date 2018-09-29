const string MSGBOARD_XML = "bboard.xml";
const string MSGBOARD_XML2 = "bboard_msg.xml";
const string SCREEN_MSGBOARD = "SCREEN_BBOARD"; //main board
const string SCREEN_BOARD_MESSAGE = "SCREEN_BBOARD_MSG"; //individual message
const string MSG_TXT = "BBOARD_TXT_";
const string MSG_IMG = "BBOARD_MSG_"; 

void main (int N1, int N2, string sVar) {

	CloseGUIScreen(OBJECT_SELF, SCREEN_MSGBOARD);
	DisplayGuiScreen(OBJECT_SELF,SCREEN_BOARD_MESSAGE, FALSE, MSGBOARD_XML2);
	
	//SpeakString("showing "+IntToString(N1)+", "+IntToString(N2)+", "+sVar, TALKVOLUME_SHOUT);
	string sNum = IntToString(N1);
	
	string sImg = GetLocalString(OBJECT_SELF, "quest_img_"+sNum);
	string sText = GetLocalString(OBJECT_SELF, "quest_msg_"+sNum);
	string sTitle = GetLocalString(OBJECT_SELF, "quest_title_"+sNum);
	
	//SpeakString("showing title: "+sTitle+", img: "+sImg+", text: "+sText, TALKVOLUME_SHOUT);
	
	SetGUITexture(OBJECT_SELF, SCREEN_BOARD_MESSAGE, "MESSAGE_BACKGROUND", sImg);
	SetGUIObjectText(OBJECT_SELF, SCREEN_BOARD_MESSAGE, "BBOARD_MESSAGE_TITLE", -1, sTitle);
	SetGUIObjectText(OBJECT_SELF, SCREEN_BOARD_MESSAGE, "BBOARD_MESSAGE", -1, sText);
	
}