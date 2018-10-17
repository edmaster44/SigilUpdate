#include "nw_o2_coninclude"
#include "ps_inc_functions"

const int DIFFLOW = 1;
const int DIFFNORM = 2;
const int DIFFHIGH = 3;
const int DIFFVERY = 4;

const int cMidnight = 86400;
const int cSpawnWait = 300;

int PS_GetDifficulty(object oPC)
{
	//diff 1 = low
	//diff 2 = normal (0 defaults to this)
	//diff 3 = high
	//diff 4 = extra high
	int iDiff=GetLocalInt(oPC,"DIFF");
	if (iDiff==0)
		iDiff=2;
	int tempDiff=0;
	
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);

    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		tempDiff = GetLocalInt(oPartyMember,"DIFF");
		if (tempDiff==0)
			tempDiff=2;
			
		if (iDiff != tempDiff)
			return DIFFNORM;
		oPartyMember = GetNextFactionMember(oPC, TRUE);
	}
	
	return iDiff;
}

string sNearestMonster(location lSpawnpoint)
{
  object oTempMonster = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE,lSpawnpoint);
  if(oTempMonster != OBJECT_INVALID && GetTag(oTempMonster)!="")
  	return GetTag(oTempMonster);
	
  return "";
}

void LogSpawnFailure(object oTrigger, string sTemplate)
{
	string sWPName = GetLocalString(oTrigger, "WP");
	object oWP = GetWaypointByTag(sWPName);
	string sText = "Spawn failure! Waypoint:" + sWPName;
	if (oWP == OBJECT_INVALID)
	{
		sText += " (WAYPOINT DOES NOT EXIST)";
	}

	sText += " attempted to spawn " + sTemplate;

	WriteTimestampedLogEntry(sText);
}

void SpawnMonsterAtLocation(object oTrigger, string toSpawn, location lSpawnpoint, float avg, int iEliteChance, string mod) {
		
	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, toSpawn+mod, lSpawnpoint); 
	if (oSpawn == OBJECT_INVALID)
		LogSpawnFailure(oTrigger, "Gradual Spawn Failure:"+toSpawn+mod);
	
	if(Random(100) >= iEliteChance)
   	{	   		
	   	string elitetype = GetEliteType(GetRacialType(oSpawn));
		string elitelevel = GetEliteLevel((GetChallengeRating(oSpawn)+avg)/2);  		
		object oItem = CreateItemOnObject("ps_elite_" + elitetype + elitelevel, oSpawn, 1);
		SetDroppableFlag(oItem, FALSE);	
		SetLastName(oSpawn,"("+elitetype+")");
		ForceRest(oSpawn);					
		SetLocalString(oSpawn,"ELITE",elitelevel);	 	    
   	} 
	
}

void SpawnMonster(object oTrigger, string toSpawn, object oWP, float avg, int iEliteChance, string mod) {
	SpawnMonsterAtLocation(oTrigger, toSpawn, GetLocation(oWP), avg, iEliteChance, mod);
}

void PlayVFX(object oTrigger, object oWP) {

	string vfx = GetLocalString(oTrigger, "VFX");
	
	if (vfx != "") {
		effect eEffect = EffectNWN2SpecialEffectFile(vfx);
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, GetLocation(oWP), 1.0f);
	}
	
}

void SpawnGradualEncounter(object oTrigger, object oPC) {
	string sMonster1 = GetLocalString(oTrigger, "M1");
	string sMonster2 = GetLocalString(oTrigger, "M2");
	string sMonster3 = GetLocalString(oTrigger, "M3");
	
	string elitetype="";
	string elitelevel="";
	
	int iDiff = PS_GetDifficulty(oPC);
	
	float low = IntToFloat(GetLocalInt(oTrigger,"LOW"));
  	float high = IntToFloat(GetLocalInt(oTrigger,"HIGH"));
	
	string mod = "";
 
  	float avg = PS_GetAvgPartylevel(oPC,PS_GetMaxPartylevel(oPC));
  	int nmon = 0;
  	int num = PS_GetNumPC(oPC);
  
  	switch (num) {
  		case 1: 
			nmon = num + Random(2);
			break;
		case 2:
		case 3:
			nmon = num + Random(3) - 1;
		case 4:
		case 5:
			nmon = num + Random(3);
			break;
		default:
			nmon = Random(3) + 6;	
			break;		
 	 }
  
  	if (iDiff == DIFFVERY)
    	nmon += 1;
		
	if(low==0.0 || high==0.0 || iDiff == DIFFLOW)
	   mod="";
	else if(avg>low && avg<high && iDiff == DIFFNORM)
	   mod="2";
	else if(avg>=high || iDiff == DIFFHIGH || iDiff == DIFFVERY)
	   mod="3";
	
	int iEliteChance = 97;
	if (iDiff == DIFFHIGH)
	    iEliteChance = 95;
	else if (iDiff == DIFFVERY)
	    iEliteChance = 90;
		
	string toSpawn = "";
	int nRand = Random(3)+1;
	switch(nRand) {
		case 1: toSpawn = sMonster1;
		case 2: toSpawn = sMonster2;
		case 3: toSpawn = sMonster3;
		default: toSpawn = sMonster1;
	}
	
	string sWP = GetLocalString(oTrigger, "WP1");
	object oWP;
	float fDelay = 0.0f; 
	if (sWP != "") {
		oWP = GetWaypointByTag(sWP);
		SpawnMonster(oTrigger, toSpawn, oWP, avg, iEliteChance, mod);
		PlayVFX(oTrigger, oWP);
	}
	
	nRand = Random(3)+1;
	switch(nRand) {
		case 1: toSpawn = sMonster1;
		case 2: toSpawn = sMonster2;
		case 3: toSpawn = sMonster3;
		default: toSpawn = sMonster1;
	}
	sWP = GetLocalString(oTrigger, "WP2");
   	if (sWP != "") {
		oWP = GetWaypointByTag(sWP);
		fDelay = IntToFloat(Random(8))/2.5f;
		DelayCommand(fDelay, SpawnMonster(oTrigger, toSpawn, oWP, avg, iEliteChance, mod));
		DelayCommand(fDelay, PlayVFX(oTrigger, oWP));
	}
	
	nRand = Random(3)+1;
	switch(nRand) {
		case 1: toSpawn = sMonster1;
		case 2: toSpawn = sMonster2;
		case 3: toSpawn = sMonster3;
		default: toSpawn = sMonster1;
	}
	sWP = GetLocalString(oTrigger, "WP3");
   	if (sWP != "") {
		oWP = GetWaypointByTag(sWP);
		fDelay = IntToFloat(Random(8))/2.5f;
		DelayCommand(fDelay, SpawnMonster(oTrigger, toSpawn, oWP, avg, iEliteChance, mod));
		DelayCommand(fDelay, PlayVFX(oTrigger, oWP));
	}
	
	nRand = Random(3)+1;
	switch(nRand) {
		case 1: toSpawn = sMonster1;
		case 2: toSpawn = sMonster2;
		case 3: toSpawn = sMonster3;
		default: toSpawn = sMonster1;
	}
	sWP = GetLocalString(oTrigger, "WP4");
   	if (sWP != "") {
		oWP = GetWaypointByTag(sWP);
		fDelay = IntToFloat(Random(8))/2.5f;
		DelayCommand(fDelay, SpawnMonster(oTrigger, toSpawn, oWP, avg, iEliteChance, mod));
		DelayCommand(fDelay, PlayVFX(oTrigger, oWP));
	}
}