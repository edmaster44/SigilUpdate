// v1.01
// v1.02 - adding difficulty settings

#include "nw_o2_coninclude"
#include "ps_inc_functions"

const int cMidnight = 86400;
// CSpawnWait is the default respawn timer if the trigger does not have a RESPAWN value. (5 minutes)
const int cSpawnWait = 300;

/*
int GetTime()
{
    return GetTimeSecond()+60*GetTimeMinute()+3600*GetTimeHour();
}

//returns an int in secs of time passed
// checking for the passage of midnight
int GetTimePassed(int iBegin, int iEnd)
{
   // if begin is smaller simple subtraction
   if(iBegin < iEnd)
   {
       return (iEnd - iBegin);
   }
   //only happens when midnight has passed
   if (iBegin > iEnd)
   {
       return ( (cMidnight - iBegin) + iEnd);
       //trust me it works
   }
   else
   {
       return 0;//begin == end time is zero
   }
}

//TimeStamp(object)  self explanatory no?
//the variable will be called <objecttag>_timestamp
void TimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  if (sTimeStampVariable == "") sTimeStampVariable = GetTag(oObject)+"_s";
   SetLocalInt(oObject, sTimeStampVariable, GetTime());
}

//CheckTimeStamp(object)  self explanatory no?
//returns the difference in time between NOW and the last timestamp
//the variable will be called <objecttag>_timestamp
int CheckTimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  if (sTimeStampVariable == "") sTimeStampVariable = GetTag(oObject)+"_s";
  int iOld = GetLocalInt(oObject, sTimeStampVariable);
  int iNew = GetTime();
  return GetTimePassed(iOld, iNew);
}
*/

/*
float PS_GetAvgLevel(object oPC) //Gets "pure" average level
{                
float fMembers=0.0;
int iMemberlevel=0;

object oPartyMember = GetFirstFactionMember(oPC, TRUE);

   while(GetIsObjectValid(oPartyMember) == TRUE)
   {
 iMemberlevel += GetHitDice(oPartyMember);
 fMembers += 1.0;
       oPartyMember = GetNextFactionMember(oPC, TRUE);
   }

return iMemberlevel / fMembers;
}

int PS_GetNumPC(object oPC) //find the total number of PCs in party
{
int iCount = 0;
object oPartyMember = GetFirstFactionMember(oPC, TRUE);

   while(GetIsObjectValid(oPartyMember) == TRUE)
   {
 iCount++;

       oPartyMember = GetNextFactionMember(oPC, TRUE);
   }

return iCount;
}
*/

const int DIFFLOW = 1;
const int DIFFNORM = 2;
const int DIFFHIGH = 3;
const int DIFFVERY = 4;

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

void main()
{

object oTrigger = OBJECT_SELF;
object oPC = GetEnteringObject();
if(oPC == OBJECT_INVALID)
{
	oPC = GetLastOpener();
}

//SpeakString("spawn triggered by: " + GetTag(oPC),TALKVOLUME_SHOUT);


if (!GetIsPC(oPC)) return;
int iSpawnWait = GetLocalInt(oTrigger,"RESPAWN");
if(iSpawnWait == 0)
 iSpawnWait = cSpawnWait;

// SpeakString(IntToString(iSpawnWait),TALKVOLUME_SHOUT);
// SpeakString(IntToString(CheckTimeStamp()),TALKVOLUME_SHOUT);
 
if (CheckTimeStamp(oTrigger,"TIMESTAMP")>iSpawnWait)
{
 TimeStamp(oTrigger,"TIMESTAMP");
// SpeakString("1",TALKVOLUME_SHOUT);
 
 string sWP = GetLocalString(oTrigger,"WP");
  // special rules for the monsters in lowest undersigi crypt that
 // spawn the 250xp quest item "interesting skull"
 if (sWP == "wp_us_beserkerundead" || sWP == "wp_us_accursedpriest" ||
	sWP == "wp_us_necromancerundead"){
		int nDay = (GetCalendarYear() * 360) + ((GetCalendarMonth() - 1) * 30) + GetCalendarDay();
		object oEss = PS_GetEssence(oPC);
		int nLastSpawn = GetLocalInt(oEss, "SkullBearerLastSpawn");
		if (nLastSpawn >= nDay){
			SendMessageToPC(oPC, "This tomb is empty. Try again tomorrow.");
			return;
		} else {
			SetLocalInt(oEss, "SkullBearerLastSpawn", nDay);
		}
	}
 
 object oWP = GetWaypointByTag(sWP);
 

 location lSpawnpoint = GetLocation(oWP); 
 
 object oSpawn;
  
 string m1 = GetLocalString(oTrigger,"M1");
 string b1 = GetLocalString(oTrigger,"B1");
 if(GetIsObjectValid(oWP) == TRUE && (m1 != "" || b1 != ""))
 {
//  SpeakString("2",TALKVOLUME_SHOUT);

  string m2 = GetLocalString(oTrigger,"M2");
  string b2 = GetLocalString(oTrigger,"B2");
  string b3 = GetLocalString(oTrigger,"B3");

/* will do exact check instead
  //Failsafe to exit if monster is already spawned
  object oTempMonster = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE,lSpawnpoint);
  if(oTempMonster != OBJECT_INVALID && GetTag(oTempMonster)!="")
  {
  	string sTag = GetTag(oTempMonster);

 	if(TestStringAgainstPattern(m1+"**",sTag)) {return;}
	if(TestStringAgainstPattern(m2+"**",sTag)) {return;}
 	if(TestStringAgainstPattern(b1+"**",sTag)) {return;}
 	if(TestStringAgainstPattern(b2+"**",sTag)) {return;}
  }
*/
  
//    SpeakString("4",TALKVOLUME_SHOUT);

	string elitetype="";
	string elitelevel="";
	
	int iDiff = PS_GetDifficulty(oPC);
	
  int m1c = GetLocalInt(oTrigger,"M1C");
  int m2c = GetLocalInt(oTrigger,"M2C");
  int b1c = GetLocalInt(oTrigger,"B1C");
  int b2c = GetLocalInt(oTrigger,"B2C");
  int b3c = GetLocalInt(oTrigger,"B3C");
  int i = 0;
  object oItem;
  
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

// SpeakString("5" + IntToString(nmon),TALKVOLUME_SHOUT);

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

//   SpeakString(b1+mod,TALKVOLUME_SHOUT);
//   SpeakString(b2+mod,TALKVOLUME_SHOUT);
   
  string sNearest = sNearestMonster(lSpawnpoint);
//   SpeakString("nearest: " + sNearest,TALKVOLUME_SHOUT);
  //Spawn bosses
  if(b1c<=Random(100) && b1!="" && sNearest!=b1+mod)
  {
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, b1+mod, lSpawnpoint);    
	if (oSpawn == OBJECT_INVALID)
	{
		LogSpawnFailure(oTrigger, "BOSS1:"+b1+mod);
	}
	
   if(Random(100) >= iEliteChance)
   {	   		
	   		elitetype = GetEliteType(GetRacialType(oSpawn));
			elitelevel = GetEliteLevel((GetChallengeRating(oSpawn)+avg)/2);  		
			oItem = CreateItemOnObject("ps_elite_" + elitetype + elitelevel, oSpawn, 1);
			SetDroppableFlag(oItem, FALSE);	
			SetLastName(oSpawn,"("+elitetype+")");
			ForceRest(oSpawn);					
			SetLocalString(oSpawn,"ELITE",elitelevel);	 	    
   }
   //elitetest end
  }	   
	      
  if(b2c<=Random(100) && b2!="" && sNearest!=b2+mod)
  {
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, b2+mod, lSpawnpoint);    
	if (oSpawn == OBJECT_INVALID)
	{
		LogSpawnFailure(oTrigger, "BOSS2:"+b2+mod);
	}
   
   //elitetest
   //object oItem = 
   if(Random(100) >= iEliteChance)
   {	   		
	   		elitetype = GetEliteType(GetRacialType(oSpawn));
			elitelevel = GetEliteLevel((GetChallengeRating(oSpawn)+avg)/2);  			
			oItem = CreateItemOnObject("ps_elite_" + elitetype + elitelevel, oSpawn, 1);			
			SetDroppableFlag(oItem, FALSE);	
			SetLastName(oSpawn,"("+elitetype+")");
			ForceRest(oSpawn);		
			SetLocalString(oSpawn,"ELITE",elitelevel); 	 	   
   }
   //elitetest end
  }
  
  if(b3c<=Random(100) && b3!="" && sNearest!=b3+mod)
  {
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, b3+mod, lSpawnpoint);    
	if (oSpawn == OBJECT_INVALID)
	{
		LogSpawnFailure(oTrigger, "BOSS3:"+b3+mod);
	}
   
   //elitetest
   //object oItem = 
   if(Random(100) >= iEliteChance)
   {	   		
	   		elitetype = GetEliteType(GetRacialType(oSpawn));
			elitelevel = GetEliteLevel((GetChallengeRating(oSpawn)+avg)/2);  			
			oItem = CreateItemOnObject("ps_elite_" + elitetype + elitelevel, oSpawn, 1);			
			SetDroppableFlag(oItem, FALSE);	
			SetLastName(oSpawn,"("+elitetype+")");
			ForceRest(oSpawn);		
			SetLocalString(oSpawn,"ELITE",elitelevel); 	 	   
   }
   //elitetest end
  }
   	   
  //Spawn hoard
  if(Random(100) < 5 && iDiff == DIFFNORM) //chance for more monster but less powerful
  {
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
 
//    SpeakString("6",TALKVOLUME_SHOUT);
//   SpeakString(m1+mod,TALKVOLUME_SHOUT);
//   SpeakString(m2+mod,TALKVOLUME_SHOUT);
  
  if(sNearest!=m1+mod && (sNearest!=m2+mod || m2+mod==""))
  {
	  for(i=0;i<nmon;i++)
	  {
	   if(Random(10)>3 || m2c==0 || m2=="")
	   {
	    oSpawn = CreateObject(OBJECT_TYPE_CREATURE, m1+mod, lSpawnpoint); 
		 if (oSpawn == OBJECT_INVALID)
		 {
			 LogSpawnFailure(oTrigger, "MONSTER1:"+m1+mod);
		 }
//		SpeakString("making:"+m1+mod+":",TALKVOLUME_SHOUT);   
	   }
	   else
	   {
	    oSpawn = CreateObject(OBJECT_TYPE_CREATURE, m2+mod, lSpawnpoint);  
		 if (oSpawn == OBJECT_INVALID)
		 {
			 LogSpawnFailure(oTrigger, "MONSTER2:"+m2+mod);
		 }
//		SpeakString("making:"+m2+mod+":",TALKVOLUME_SHOUT);  
	   }
	   
	   //elitetest
	   //object oItem = 
	   if(Random(100) >= iEliteChance)
	   {	//weight in favor of CR over average level 
	   		elitetype = GetEliteType(GetRacialType(oSpawn));
			elitelevel = GetEliteLevel((GetChallengeRating(oSpawn)+avg)/2);	
			oItem = CreateItemOnObject("ps_elite_" + elitetype + elitelevel, oSpawn, 1);
			SetDroppableFlag(oItem, FALSE);
			SetLastName(oSpawn,"("+elitetype+")");
			ForceRest(oSpawn);			
			SetLocalString(oSpawn,"ELITE",elitelevel);	   
	   }
	   //elitetest end
	   
	 }
  }
//  SpeakString("7",TALKVOLUME_SHOUT);

 }
}
}