#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("HallSpeakersEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("HallSpeakersEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_speaker_npc1") == OBJECT_INVALID)
  {
   //Change Room Merchant; non-motile
   object oWP = GetWaypointByTag("WP_ps_speaker_npc1_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc1", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_speaker_npc2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc3") == OBJECT_INVALID)
  {
   //Non-motile NPC
   object oWP = GetWaypointByTag("wp_ps_speaker_npc3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc3", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc7") == OBJECT_INVALID)
  {
   //Change Room Merchant; non-motile
   object oWP = GetWaypointByTag("WP_ps_speaker_npc7_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc7", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc8") == OBJECT_INVALID)
  {
   //Change Room Merchant; non-motile
   object oWP = GetWaypointByTag("WP_ps_speaker_npc8_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc8", lSpawnpoint);    
  }
  
   if(GetObjectByTag("ps_speaker_npc9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc9");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc9", lSpawnpoint);    
  }
  
   if(GetObjectByTag("ps_speaker_npc10") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc10");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc10", lSpawnpoint);    
  }
  
   if(GetObjectByTag("ps_speaker_npc11") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc11");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc11", lSpawnpoint);    
  }
  
  
  
  
  
  
  
  
  PS_SetGlobalInt("HallSpeakersEnterLock", 0);
 }
}