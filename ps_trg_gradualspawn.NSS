#include "ff_safevar"

//Spawns in creatures a few at a time from several different waypoints
//simulating waves of monsters, creatures portalling in, etc.
//vfx and sound effect are optional
#include "ps_inc_spawns"

void main () {
	
	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC)) return;
	
	PS_SetLocalObject(OBJECT_SELF, "SAVED_PC", oPC);
	
	//Respawn figures
	int iSpawnWait = PS_GetLocalInt(OBJECT_SELF,"RESPAWN");
	if(iSpawnWait == 0)
	 	iSpawnWait = cSpawnWait;
		
	//Don't do anything if respawn time hasn't passed
	if (CheckTimeStamp(OBJECT_SELF,"TIMESTAMP") <= iSpawnWait)
		return;
		
	TimeStamp(OBJECT_SELF,"TIMESTAMP");
	
	string sFX = PS_GetLocalString(OBJECT_SELF, "SFX");
	DelayCommand(0.3f, PlaySound(sFX));
	
	int nCycles = PS_GetLocalInt(OBJECT_SELF, "Cycles");
	
	int nCount = 0;
	float fDelay = 1.0f;
	
	while (nCount < nCycles) {
	
		DelayCommand(fDelay, SpawnGradualEncounter(OBJECT_SELF, oPC));
		fDelay += 6.0f;
		nCount++;
		
	}
	
	//Adding an event that can fire after all the creatures are done spawning
	string sAfterSpawnScript = PS_GetLocalString(OBJECT_SELF, "AfterSpawnScript");
	//SendMessageToPC(oPC, "Spawn script: "+sAfterSpawnScript+", delay: "+FloatToString(fDelay));
	if (sAfterSpawnScript != "") {
		DelayCommand(fDelay, ExecuteScript(sAfterSpawnScript, OBJECT_SELF));
	}
	
}