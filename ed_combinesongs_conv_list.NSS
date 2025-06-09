#include "nwnx_sql"

void main()
{
	object oPC = GetPCSpeaker(); 
	
	int iLoop = 0;
	while(10 > iLoop)
	{
		DeleteLocalInt(oPC,"SONGLIST"+IntToString(iLoop));
		iLoop++;
	}
	
	int customid = 53053; string songname; int id; iLoop = 1; int featid;
		
	SQLExecDirect("SELECT `id`, `song_name`, `feat` FROM `bard_songslist` ORDER by `id`;");
	while (SQLFetch())
	{
		id = StringToInt(SQLGetData(1)); songname = SQLGetData(2);
		featid = StringToInt(SQLGetData(3));
		
		if(GetHasFeat(featid,oPC,TRUE))
		{
			SetLocalInt(oPC,"SONGLIST"+IntToString(iLoop),id);
			SetCustomToken(customid,songname);
			customid++; iLoop++;
		}
	}
	
}