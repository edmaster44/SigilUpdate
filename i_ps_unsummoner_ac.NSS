// i_ps_unsummoner_ac
/*	Script created by Dedic8ed for use in the Sigil: City of Doors PW
	   
This script is designed to unsummon the cohort created by i_ps_summoner_ac.

*/  

// Modification by Agony_Aunt to store repawning of hench in event of server crash within time specified in function
// AllowRespawnHench in ps_inc_faction
#include "ps_inc_faction"

void main()
{
	object oPC		= GetItemActivator();
	object oItem	= GetItemActivated();

	object oOldHench= GetHenchman(oPC);
	
	//then we lost it because of a crash or something
	if (oOldHench == OBJECT_INVALID) {
	
		if (AllowRespawnHench(oItem) == TRUE)
		{
			SendMessageToPC(oPC, "Recalling lost cohort to serve you once again.");
			FindOrReplaceHenchman(oItem);
		}
		else
		{
			SendMessageToPC(oPC, "Too much time has passed since you first called for your cohort, it will not server you again");
			DestroyObject(oItem);
		}
		
	} else {
	
		SendMessageToPC(oPC, "Found cohort: "+GetName(oOldHench));
		
		DestroyObject(oOldHench);
		DestroyObject(oItem);
		SendMessageToPC(oPC,"A cohort has been released from your service.");
		
	}
}