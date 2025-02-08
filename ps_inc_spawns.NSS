#include "ps_inc_functions"

//Difficulty levels
const int DIFFLOW = 1;
const int DIFFNORM = 2;
const int DIFFHIGH = 3;
const int DIFFVERY = 4;

//time constants
const int cMidnight = 86400;
const int cSpawnWait = 300;

//Get the difficulty constant this pc / party
//is playing on.
int PS_GetDifficulty(object oPC)
{
	//diff 1 = low
	//diff 2 = normal (0 defaults to this)
	//diff 3 = high
	//diff 4 = extra high
	int iDiff=PS_GetLocalInt(oPC,"DIFF");
	if (iDiff==0)
		iDiff=2;
	int tempDiff=0;
	
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);

    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		tempDiff = PS_GetLocalInt(oPartyMember,"DIFF");
		if (tempDiff==0)
			tempDiff=2;
			
		if (iDiff != tempDiff)
			return DIFFNORM;
		oPartyMember = GetNextFactionMember(oPC, TRUE);
	}
	
	return iDiff;
}

//Get the tag of the nearest monster
//for double checking whether we should spawn a new thing
string sNearestMonster(location lSpawnpoint)
{
  object oTempMonster = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE,lSpawnpoint);
  if(oTempMonster != OBJECT_INVALID && GetTag(oTempMonster)!="")
  	return GetTag(oTempMonster);
	
  return "";
}

//Log the spawn failure to the server logs
void LogSpawnFailure(object oTrigger, string sTemplate)
{
	string sWPName = PS_GetLocalString(oTrigger, "WP");
	object oWP = GetWaypointByTag(sWPName);
	string sText = "Spawn failure! Waypoint:" + sWPName;
	if (oWP == OBJECT_INVALID)
	{
		sText += " (WAYPOINT DOES NOT EXIST)";
	}

	sText += " attempted to spawn " + sTemplate;

	WriteTimestampedLogEntry(sText);
}

//Create monster of correct mod at location
//includes chance to make monster elite
void SpawnMonsterAtLocation(object oTrigger, string toSpawn, location lSpawnpoint, float avg, int iEliteChance, string mod) {
		
	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, toSpawn+mod, lSpawnpoint); 
	if (oSpawn == OBJECT_INVALID)
		LogSpawnFailure(oTrigger, "Spawn Failure:"+toSpawn+mod);
	
	if(Random(100) >= iEliteChance)
   	{	   		
	   	string elitetype = GetEliteType(GetRacialType(oSpawn));
		string elitelevel = GetEliteLevel((GetChallengeRating(oSpawn)+avg)/2);  		
		object oItem = CreateItemOnObject("ps_elite_" + elitetype + elitelevel, oSpawn, 1);
		SetDroppableFlag(oItem, FALSE);	
		SetLastName(oSpawn,"("+elitetype+")");
		ForceRest(oSpawn);					
		PS_SetLocalString(oSpawn,"ELITE",elitelevel);	 	    
   	} 
	
}

void SpawnMonster(object oTrigger, string toSpawn, object oWP, float avg, int iEliteChance, string mod) {
	SpawnMonsterAtLocation(oTrigger, toSpawn, GetLocation(oWP), avg, iEliteChance, mod);
}

void PlayVFX(object oTrigger, object oWP) {

	string vfx = PS_GetLocalString(oTrigger, "VFX");
	
	if (vfx != "") {
		effect eEffect = EffectNWN2SpecialEffectFile(vfx);
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, GetLocation(oWP), 1.0f);
	}
	
}

//Spawn a creature with proper difficulty 
void SpawnEncounterCreature(object oTrigger, object oPC, location lSpawn, string sCreature) {

	string elitetype="";
	string elitelevel="";
		
	int iDiff = PS_GetDifficulty(oPC);
	float avg = PS_GetAvgPartylevel(oPC, PS_GetMaxPartylevel(oPC));
	
	float low = IntToFloat(PS_GetLocalInt(oTrigger,"LOW"));
	float high = IntToFloat(PS_GetLocalInt(oTrigger,"HIGH"));
	string mod = "";
	
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
		
	SpawnMonsterAtLocation(oTrigger, sCreature, lSpawn, avg, iEliteChance, mod);

}

void SpawnEncounter(object oTrigger, object oPC) {
	int iSpawnWait = PS_GetLocalInt(oTrigger,"RESPAWN");
	if(iSpawnWait == 0)
	 iSpawnWait = cSpawnWait;
	
	 
	if (CheckTimeStamp(oTrigger,"TIMESTAMP")<=iSpawnWait)
		return;
		
	 TimeStamp(oTrigger,"TIMESTAMP");
	 
	 object oWP = GetWaypointByTag(PS_GetLocalString(oTrigger,"WP"));
	 location lSpawnpoint = GetLocation(oWP); 
	 
	 object oSpawn;
	  
	 string m1 = PS_GetLocalString(oTrigger,"M1");
	 string b1 = PS_GetLocalString(oTrigger,"B1");
	 
	 if(GetIsObjectValid(oWP) == TRUE && (m1 != "" || b1 != "")) {
	 
	 	PlayVFX(oTrigger, oWP);
	
	 	string m2 = PS_GetLocalString(oTrigger,"M2");
	 	string b2 = PS_GetLocalString(oTrigger,"B2");
	  	string b3 = PS_GetLocalString(oTrigger,"B3");
	
		string elitetype="";
		string elitelevel="";
		
		int iDiff = PS_GetDifficulty(oPC);
		
	  	int m1c = PS_GetLocalInt(oTrigger,"M1C");
	  	int m2c = PS_GetLocalInt(oTrigger,"M2C");
	  	int b1c = PS_GetLocalInt(oTrigger,"B1C");
	  	int b2c = PS_GetLocalInt(oTrigger,"B2C");
	  	int b3c = PS_GetLocalInt(oTrigger,"B3C");
	  	int i = 0;
	  	object oItem;
	  
	  	float low = IntToFloat(PS_GetLocalInt(oTrigger,"LOW"));
	  	float high = IntToFloat(PS_GetLocalInt(oTrigger,"HIGH"));
	   
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
	   
	  string sNearest = sNearestMonster(lSpawnpoint);
	  
	  if(b1c<=Random(100) && b1!="" && sNearest!=b1+mod) {
	  		SpawnMonsterAtLocation(oTrigger, b1, lSpawnpoint, avg, iEliteChance, mod);
	  }	   
		      
	  if(b2c<=Random(100) && b2!="" && sNearest!=b2+mod) {
	  		SpawnMonsterAtLocation(oTrigger, b2, lSpawnpoint, avg, iEliteChance, mod);
	  }
	  
	  if(b3c<=Random(100) && b3!="" && sNearest!=b3+mod) {
	  		SpawnMonsterAtLocation(oTrigger, b3, lSpawnpoint, avg, iEliteChance, mod);
	  }
	   	   
	  //Spawn hoard
	  if(Random(100) < 5 && iDiff == DIFFNORM) { //chance for more monster but less powerful
		 nmon += Random(num);
		 if(mod=="2")
		    mod="";
		 else if(mod=="3")
		    mod="2";
	  }
	 
	  if(m1c<=Random(100))
	   	m1c = 1;
	  else
	   	m1c = 0;
	   
	  if(m2c<=Random(100))
	   m2c = 1;
	  else
	   m2c = 0;
	  
	  if(sNearest!=m1+mod && (sNearest!=m2+mod || m2+mod=="")) {
		  for(i=0;i<nmon;i++) {
			   if(Random(10)>3 || m2c==0 || m2=="") {
			    	SpawnMonsterAtLocation(oTrigger, m1, lSpawnpoint, avg, iEliteChance, mod);
			   } else {
			    	SpawnMonsterAtLocation(oTrigger, m2, lSpawnpoint, avg, iEliteChance, mod);
			   }
	  	  }
	 }
   }
}

void SpawnGradualEncounter(object oTrigger, object oPC) {
	string sMonster1 = PS_GetLocalString(oTrigger, "M1");
	string sMonster2 = PS_GetLocalString(oTrigger, "M2");
	string sMonster3 = PS_GetLocalString(oTrigger, "M3");
	
	string elitetype="";
	string elitelevel="";
	
	int iDiff = PS_GetDifficulty(oPC);
	
	float low = IntToFloat(PS_GetLocalInt(oTrigger,"LOW"));
  	float high = IntToFloat(PS_GetLocalInt(oTrigger,"HIGH"));
	
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
	
	string sWP = PS_GetLocalString(oTrigger, "WP1");
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
	sWP = PS_GetLocalString(oTrigger, "WP2");
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
	sWP = PS_GetLocalString(oTrigger, "WP3");
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
	sWP = PS_GetLocalString(oTrigger, "WP4");
   	if (sWP != "") {
		oWP = GetWaypointByTag(sWP);
		fDelay = IntToFloat(Random(8))/2.5f;
		DelayCommand(fDelay, SpawnMonster(oTrigger, toSpawn, oWP, avg, iEliteChance, mod));
		DelayCommand(fDelay, PlayVFX(oTrigger, oWP));
	}
}