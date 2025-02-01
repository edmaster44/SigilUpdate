#include "ff_safevar"

#include "enft_startengine"
void main()
{
 	object oPC = GetEnteringObject();
	PS_DeleteLocalInt(oPC, "KadyxCount");
	PS_DeleteLocalInt(oPC, "Kadyx_Eaten");
	int nKadyxComes = Random(40)+15; //Kadyx will eat you after between 15-65 minutes
	PS_SetLocalInt(oPC, "KadyxComing", nKadyxComes);
	
	if (GetIsPC(oPC)) { 
		startEngine(oPC);
	}
}