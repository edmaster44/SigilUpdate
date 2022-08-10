//***********************************************************
//ga_modulequest_increment
//MimiFearthegn 8/9/22
//***********************************************************
//Increments module wide stati like law vs. chaos
//currently does nothing, but is a placeholder
#include "ps_inc_quests"
#include "ps_inc_functions"

void main(string sName, int numberOfPoints) {

	object oPC = GetPCSpeaker();
	//string sID = PS_GetCharID(oPC); //we will want to credit by pc later
	
	if(numberOfPoints <= 0) numberOfPoints = 1;

	IncrementModuleQuest(oPC, sName, numberOfPoints);

}