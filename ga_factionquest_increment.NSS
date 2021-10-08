//***********************************************************
//ga_factionquest_increment
//MimiFearthegn 3/8/20
//***********************************************************
//Increments the faction 'status' in the city
//at present, this has 0 effect, but its a nice placeholder
//for future things.
//only call this in parts of a conversation where we know the PC is of a faction
#include "ps_inc_quests"
#include "ps_inc_functions"

int GetFaction(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}

void main(int numberOfPoints) {

	object oPC = GetPCSpeaker();
	int nFaction = GetFaction(oPC);
	//string sID = PS_GetCharID(oPC); //we will want to credit by pc later
	
	if(numberOfPoints <= 0) numberOfPoints = 1;

	IncrementModuleFactionQuest(oPC, nFaction, numberOfPoints);
}