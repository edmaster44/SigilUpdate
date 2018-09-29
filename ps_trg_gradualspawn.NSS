//Spawns in creatures a few at a time from several different waypoints
//simulating waves of monsters, creatures portalling in, etc.
//vfx and sound effect are optional
#include "ps_inc_spawns"

void main () {
	
	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC)) return;
	
	//Respawn figures
	int iSpawnWait = GetLocalInt(OBJECT_SELF,"RESPAWN");
	if(iSpawnWait == 0)
	 	iSpawnWait = cSpawnWait;
		
	//Don't do anything if respawn time hasn't passed
	if (CheckTimeStamp(OBJECT_SELF,"TIMESTAMP") <= iSpawnWait)
		return;
		
	TimeStamp(OBJECT_SELF,"TIMESTAMP");
	
	string sFX = GetLocalString(OBJECT_SELF, "SFX");
	DelayCommand(0.3f, PlaySound(sFX));
	
	int nCycles = GetLocalInt(OBJECT_SELF, "Cycles");
	
	int nCount = 0;
	float fDelay = 1.0f;
	
	while (nCount < nCycles) {
	
		DelayCommand(fDelay, SpawnGradualEncounter(OBJECT_SELF, oPC));
		fDelay += 6.0f;
		nCount++;
		
	}
	
}