// v1.01

#include "nw_o2_coninclude"
#include "ps_inc_functions"

const int cMidnight = 86400;
const int cSpawnWait = 300;

string sNearestMonster(location lSpawnpoint)
{
  object oTempMonster = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE,lSpawnpoint);
  if(oTempMonster != OBJECT_INVALID && GetTag(oTempMonster)!="")
  	return GetTag(oTempMonster);
	
  return "";
}

void main()
{

object oTrigger = OBJECT_SELF;
object oPC = GetEnteringObject();
if(oPC == OBJECT_INVALID)
{
	oPC = GetLastOpener();
}


if (!GetIsPC(oPC)) return;
int iSpawnWait = GetLocalInt(oTrigger,"RESPAWN");
if(iSpawnWait == 0)
 iSpawnWait = cSpawnWait;
 
object oStairs1 = GetNearestObjectByTag("limbo_stairs_1");
if (GetIsObjectValid(oStairs1))
 	DestroyObject(oStairs1);
object oStairs2 = GetNearestObjectByTag("limbo_stairs_2");
if (GetIsObjectValid(oStairs2))
 	DestroyObject(oStairs2);
object oStairs3 = GetNearestObjectByTag("limbo_stairs_3");
if (GetIsObjectValid(oStairs3))
 	DestroyObject(oStairs3);
object oStairs4 = GetNearestObjectByTag("limbo_stairs_4");
if (GetIsObjectValid(oStairs4))
 	DestroyObject(oStairs4);
 
if (CheckTimeStamp(oTrigger,"TIMESTAMP")>iSpawnWait)
{
 TimeStamp(oTrigger,"TIMESTAMP");
 
 object oWP1 = GetWaypointByTag(GetLocalString(oTrigger,"WP1"));
 location lSpawnpoint1 = GetLocation(oWP1); 
  object oWP2 = GetWaypointByTag(GetLocalString(oTrigger,"WP2"));
 location lSpawnpoint2 = GetLocation(oWP2); 
  object oWP3 = GetWaypointByTag(GetLocalString(oTrigger,"WP3"));
 location lSpawnpoint3 = GetLocation(oWP3); 
  object oWP4 = GetWaypointByTag(GetLocalString(oTrigger,"WP4"));
 location lSpawnpoint4 = GetLocation(oWP4); 
 
 object oSpawn;
  
 string m1 = GetLocalString(oTrigger,"M1");
 string m2 = GetLocalString(oTrigger,"M2");
 string b1 = GetLocalString(oTrigger,"B1");
 string b2 = GetLocalString(oTrigger,"B2");
  
  string elitetype="";
  string elitelevel="";
  int i = 0;
  object oItem;
  
  float low = IntToFloat(GetLocalInt(oTrigger,"LOW"));
  float high = IntToFloat(GetLocalInt(oTrigger,"HIGH"));
   
  string mod = "";
 
  float avg = PS_GetAvgPartylevel(oPC,PS_GetMaxPartylevel(oPC));

  if(low==0.0 || high==0.0)
   mod="";
  else if(avg>low && avg<high)
   mod="2";
  else if(avg>=high)
   mod="3";
   
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, m1+mod, lSpawnpoint1);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, m2+mod, lSpawnpoint2);   
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, b1+mod, lSpawnpoint3);   
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, b2+mod, lSpawnpoint4);     

   if(Random(100) >= 97)
   {	   		
	   		elitetype = GetEliteType(GetRacialType(oSpawn));
			elitelevel = GetEliteLevel((GetChallengeRating(oSpawn)+avg)/2);  		
			oItem = CreateItemOnObject("ps_elite_" + elitetype + elitelevel, oSpawn, 1);
			SetDroppableFlag(oItem, FALSE);	
			SetLastName(oSpawn,"("+elitetype+")");
			ForceRest(oSpawn);					
			SetLocalString(oSpawn,"ELITE",elitelevel);	 	    
   }
}
}