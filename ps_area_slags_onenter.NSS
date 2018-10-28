#include "enft_startengine"
void main()
{
 	object oPC = GetEnteringObject();
	DeleteLocalInt(oPC, "KadyxCount");
	DeleteLocalInt(oPC, "Kadyx_Eaten");
	int nKadyxComes = Random(40)+15; //Kadyx will eat you after between 15-65 minutes
	SetLocalInt(oPC, "KadyxComing", nKadyxComes);
	
	if (GetIsPC(oPC)) { 
		startEngine(oPC);
	}
}