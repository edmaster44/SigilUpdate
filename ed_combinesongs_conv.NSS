#include "nwnx_sql"

string GetSongName(string songid)
{
	SQLExecDirect("SELECT `song_name` FROM `bard_songslist` WHERE `id`='"+songid+"';");
	SQLFetch();
	
	return(SQLGetData(1));
}

void main()
{
	object oPC = GetPCSpeaker(); 

	string desc1 = "Inspiration 1: (Current:";
	string desc2 = "Inspiration 2: (Current:";
	
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
		
	SQLExecDirect("SELECT `song_1`,`song_2` FROM `bard_combinesongs` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();
	
	string song1 = SQLGetData(1);
	string song2 = SQLGetData(2);
	
	if(song1 != "" && StringToInt(song1) > 0) song1 = GetSongName(song1);
	if(song2 != "" && StringToInt(song2) > 0) song2 = GetSongName(song2);

	if(song1 != "" && song1 != "0") SetCustomToken(53050,desc1+" "+song1+")");
	else SetCustomToken(53050,desc1+")");
	
	if(song2 != "" && song2 != "0") SetCustomToken(53051,desc2+" "+song2+")");
	else SetCustomToken(53051,desc2+")");
}