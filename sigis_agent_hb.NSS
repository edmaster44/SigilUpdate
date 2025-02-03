// Script for SIGIS paper seller (agent) who will randomly announce latest news

#include "nw_i0_generic"
#include "ps_sigis_inc"
#include "ps_inc_time"

void main()
{
	if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
	
	//No talking more than 1x every 40 minutes (still may vary up to 50 minutes)
	if (PS_GetTimestamp_Age_Minutes(OBJECT_SELF, "LAST_TALK") < 40)
		return;

	int iRandom = d100();
	
	if (iRandom == 1)
	{
		PS_Timestamp_UNIX(OBJECT_SELF, "LAST_TALK");
		string sHeadline = GetGlobalString("LATEST_NEWS");
		if (sHeadline != "")
		{
			SpeakString("Extra! Extra! Read all about it! Hot off the presses!" + sHeadline, TALKVOLUME_TALK);
		}
		else
		{
			SpeakString("Get yer latest copy of SIGIS here! Scandals, politiks, latest flayings!", TALKVOLUME_TALK);
		}
	} 
	else if (iRandom == 2)// Set to 0 to stop him from talking until the delay is increased.
	{
		PS_Timestamp_UNIX(OBJECT_SELF, "LAST_TALK");
		string sTime = SigisDate(GetRealTime(), TRUE);
		SpeakString("The time and date, sponsored by the Guvners, is " + sTime, TALKVOLUME_TALK);
	}
	else if (iRandom > 2 && iRandom < 30)
	{
		PlayImmobileAmbientAnimations();
	}
}