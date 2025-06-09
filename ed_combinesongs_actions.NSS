#include "nwnx_sql"

void main(int choice, int selection)
{
	object oPC = GetPCSpeaker();
	int songchoice = GetLocalInt(oPC,"SONGLIST"+IntToString(selection));
	
	if (songchoice <= 0 || choice <= 0 || selection <= 0)
	{
		SendMessageToPC(oPC,"An error occurred. Aborting!");
		return;
	}

	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("SELECT `song_1`,`song_2` FROM `bard_combinesongs` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();
	
	string song1 = SQLGetData(1); string song2 = SQLGetData(2);
		
	if(songchoice == StringToInt(song1) && choice == 2 || songchoice == StringToInt(song2) && choice == 1)
	{
		SendMessageToPC(oPC,"You cannot combine two of the same songs!");
		return;
	}
		
	string sQuery;
	
	if(choice == 1)
	{
		sQuery = "INSERT INTO `bard_combinesongs` VALUES('"+name+"','"+act+"','"+IntToString(songchoice)+"','0') "+
		"ON DUPLICATE KEY UPDATE `song_1`='"+IntToString(songchoice)+"';";
	}
	
	if(choice == 2)
	{
		sQuery = "INSERT INTO `bard_combinesongs` VALUES('"+name+"','"+act+"','0','"+IntToString(songchoice)+"') "+
		"ON DUPLICATE KEY UPDATE `song_2`='"+IntToString(songchoice)+"';";
	}
	
	SQLExecDirect(sQuery);
	
	SendMessageToPC(oPC,"Song choice selected.");		
}