#include "ps_inc_achievements"
void main(string sPQuest, int numToIncrement) {

	object oPC = GetPCSpeaker();
	
	string sID = PS_GetCharID(oPC);
	IncrementPermanentInt(sID, sPQuest, 1);

}