#include "ps_inc_faction"
#include "ps_inc_randomitems"
#include "ps_inc_training"
#include "ps_inc_dynamicencounters"
/**********************************************************
* Summons a Harmonium to pursue the PC					  *
* sCause should be the reason why the guard was summoned  *
* Guard can be evaded with stealth                        *
**********************************************************/
//Valid sCause values
//sCause = Pickpocket
/*********************************************************/

void main(string sCause) {

	object oPC = GetPCSpeaker();
	
	//The CR of this "encounter"
	int nCR = GetChallengeRatingOfTarget(OBJECT_SELF);

	//Summon the Harmonium
	object oGuard = CreateObject(OBJECT_TYPE_CREATURE, "ps_harmonium_paladin2", FindHenchSpawnPoint(oPC));
	SetConversation(oGuard, "conv_harmoniumarrest");
	
	AssignCommand(oGuard, ActionSpeakString("Guard created!", TALKVOLUME_SHOUT));

	//Set the appropriate variables
	SetLocalInt(oPC, "HARMONIUM_PURSUIT", 0);
	SetLocalObject(oPC, "HARMONIUM", oGuard);
	SetLocalObject(oGuard, "CRIMINAL", oPC);
	SetLocalString(oGuard, "CRIME", sCause);
	SetLocalInt(oGuard, "QUEST_CR", nCR); //pass CR to guard npc
	SetLocalInt(oGuard, "HAS_APPREHENDED", 0);
	
	//Move to the PC
	DelayCommand(0.1f, SetImmortal(oGuard, TRUE));
	DelayCommand(0.2f, AssignCommand(oGuard, ActionMoveToLocation(GetLocation(oPC), TRUE)));
	
	//Now apprehending!
	DelayCommand(1.0f, ExecuteScript("ps_harmonium_apprehend", oPC));
	DestroyObject(OBJECT_SELF, 30.0f);
	
}