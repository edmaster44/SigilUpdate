//***********************************************************
//ga_set_permanent_int
//MimiFearthegn 6/17/19
//***********************************************************
//Sets a permanent int that will persist post-reset
//Info is saved in the database; for persistent quests / do once quests
//sQuestName = identifying string
//nStatus = the value to set
#include "ps_inc_quests"
#include "ps_inc_functions"

void main(string sQuestName, int nStatus) {

	object oPC = GetPCSpeaker();
	string sID = PS_GetCharID(oPC);
	SetPermanentInt(sID, sQuestName, nStatus);
}