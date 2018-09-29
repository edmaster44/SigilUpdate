// Script for SIGIS paper seller (agent) who will randomly announce latest news

#include "nw_i0_generic"
#include "ps_sigis_inc"

void main()
{
	if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

	int iRandom = d100();
	
	if (iRandom > 50) 
		iRandom = d100(); 
	else
		iRandom = 100; // basically halve the chattiness of the agent after people complained about it talking too much.
	
	if (iRandom == 1)
	{
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
	else if (iRandom == 2)
	{
		string sTime = SigisDate(GetRealTime(), TRUE);
		SpeakString("The time and date, sponsored by the Guvners, is " + sTime, TALKVOLUME_TALK);
	}
	else if (iRandom > 2 && iRandom < 30)
	{
		PlayImmobileAmbientAnimations();
	}
}