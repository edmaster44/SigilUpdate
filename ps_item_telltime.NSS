#include "ps_inc_time"
#include "ps_inc_advscript"
#include "ginc_time"

void main()
{
/*	int nHour		= GetTimeHour();
	int nMinute		= GetTimeMinute();
	string sHour	= IntToString(nHour);
	string sMinute	= IntToString(nMinute);
	string sText;
	string sFinish;
	int nRandom		= Random(6);
	
	switch(nHour)
	{	case 0:		sText = sMinute + " minutes past antipeak";	 						break;
		case 1: 	sText = "one hour and " + sMinute + " minutes past antipeak";		break;
		case 2: 	sText = "two hours and " + sMinute + " minutes past antipeak";		break;
		case 3: 	sText = "three hours and " + sMinute + " minutes past antipeak";	break;
		case 4: 	sText = "four hours and " + sMinute + " minutes past antipeak";		break;
		case 5: 	sText = "five hours and " + sMinute + " minutes past antipeak";		break;
		case 6: 	sText = "six hours and " + sMinute + " minutes past antipeak";		break;
		case 7: 	sText = "seven hours and " + sMinute + " minutes past antipeak";	break;
		case 8: 	sText = "eight hours and " + sMinute + " minutes past antipeak";	break;
		case 9: 	sText = "nine hours and " + sMinute + " minutes past antipeak";		break;
		case 10: 	sText = "ten hours and " + sMinute + " minutes past antipeak";		break;
		case 11: 	sText = "eleven hours and " + sMinute + " minutes past antipeak";	break;
		case 12: 	sText = sMinute + " minutes past peak.";							break;
		case 13: 	sText = "one hour and " + sMinute + " minutes past peak";			break;
		case 14: 	sText = "two hours and " + sMinute + " minutes past peak";			break;
		case 15: 	sText = "three hours and " + sMinute + " minutes past peak";		break;
		case 16: 	sText = "four hours and " + sMinute + " minutes past peak";			break;
		case 17: 	sText = "five hours and " + sMinute + " minutes past peak";			break;
		case 18: 	sText = "six hours and " + sMinute + " minutes past peak";			break;
		case 19: 	sText = "seven hours and " + sMinute + " minutes past peak";		break;
		case 20: 	sText = "eight hours and " + sMinute + " minutes past peak";		break;
		case 21: 	sText = "nine hours and " + sMinute + " minutes past peak";			break;
		case 22: 	sText = "ten hours and " + sMinute + " minutes past peak";			break;
		case 23: 	sText = "eleven hours and " + sMinute + " minutes past peak";		break;
	}
	
	switch(nRandom)
	{	case 0:		sFinish = ", cutter.";	break;
		case 1:		sFinish = ". Now pike off!";	break;
		case 2:		sFinish = " by the Lady's grace.";	break;
		case 3:		sFinish = ", as any barmy sod could see!";	break;
		case 4:		sFinish = ", but it's always five past peak somewhere.";	break;
		case 5:		sFinish = ", ya bleedin' berk!";	break;
		case 6:		sFinish = ", or whatever time the nearest Signer believes it is!";	break;
		case 7:		sFinish = ". Or <i>is it?</i>";		break;
		case 8:		sFinish = ". This service is brought to you by the Bottle & Jug, where the bub is cheap and always flowing!";	break;
		case 9:		sFinish = ". You realize you're talking to a skull, right?";	break;
	}
	
	SpeakString("The time is now " + sText + sFinish);*/
	SpeakString("The times on this board are based on GMT time.");
}