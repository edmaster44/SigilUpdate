#include "enft_startengine"
void main()
{
 	object oPC = GetEnteringObject();
 	SpeakString("entering the slags!", TALKVOLUME_SHOUT);    
	DeleteLocalInt(oPC, "KadyxCount");
	DeleteLocalInt(oPC, "Kadyx_Eaten");
	int nKadyxComes = 2; //Random(40)+15; //Kadyx will eat you after between 15-65 minutes
	SetLocalInt(oPC, "KadyxComing", nKadyxComes);
	
	if (GetIsPC(oPC)) {
 		SpeakString("starting engine", TALKVOLUME_SHOUT);   
		startEngine(oPC);
	}
}