//***********************************************************
//ga_set_permanent_int
//MimiFearthegn 6/17/19
//***********************************************************
//Gets a previously set permanent int, and checks whether it matches sCheck
//Info is saved in the database; for persistent quests / do once quests
//sQuestName = identifying string
//sCheck = the value to match; works like gc_local_int
#include "ps_inc_quests"
#include "ps_inc_functions"
#include "ginc_var_ops"
#include "ginc_param_const"

int StartingConditional(string sQuestName, string sCheck) {

	object oPC = GetPCSpeaker();
	string sID = PS_GetCharID(oPC);
	
	int nValue = GetPermanentInt(sID, sQuestName);
	int nComparison = CompareInts(nValue, sCheck);
	
	return nComparison;
}