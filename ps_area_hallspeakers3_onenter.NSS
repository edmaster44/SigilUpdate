#include "ff_safevar"

void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("HallSpeakers3EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("HallSpeakers3EnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_speaker_npc13") == OBJECT_INVALID)
  {
  
   object oWP = GetWaypointByTag("WP_ps_speaker_npc13_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc13", lSpawnpoint);    
  }
 
   if(GetObjectByTag("ps_speaker_npc14") == OBJECT_INVALID)
  {
  
   object oWP = GetWaypointByTag("WP_ps_speaker_npc14_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc14", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc15") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_speaker_npc15_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc15", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc16") == OBJECT_INVALID)
  {
   
   object oWP = GetWaypointByTag("WP_ps_speaker_npc16_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc16", lSpawnpoint);    
  }
  
   
  
  PS_SetGlobalInt("HallSpeakers3EnterLock", 0);
 }
}