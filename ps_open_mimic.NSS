/* A script to let you spawn mimics when you open a chest. 
Put this script on onopen
Variables Required: 
CreatureToSpawn - The resref of the creature you want to spawn (for better or worse mimics / chest guards)
PercentageToSpawn - Likelihood of spawning. 10 = 10%, 20 = 20% and so on.

Created - 11/26/17 Mimi Fearthegn
*/
#include "ps_inc_functions"

void main () {

	object oPC = GetLastOpenedBy();
	string sCreate = GetLocalString(OBJECT_SELF, "CreatureToSpawn");
	int nPercen = GetLocalInt(OBJECT_SELF, "PercentageToSpawn");
	int lastDone = CheckTimeStamp();
	
	if (lastDone < 600) //checks once per 10 minutes
		return;
		
	if (Random(100) < nPercen) {
	
		location lLoc = GetLocation(OBJECT_SELF);
		CreateObject(OBJECT_TYPE_CREATURE, sCreate, lLoc, TRUE);
		
	}
		
	TimeStamp();
	
}