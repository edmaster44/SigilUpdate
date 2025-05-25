


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("HallSpeakers2EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("HallSpeakers2EnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_speaker_npc4") == OBJECT_INVALID)
  {
  
   object oWP = GetWaypointByTag("wp_ps_speaker_npc4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc4", lSpawnpoint);    
  }
 
   if(GetObjectByTag("ps_speaker_npc5") == OBJECT_INVALID)
  {
  
   object oWP = GetWaypointByTag("WP_ps_speaker_npc5_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc5", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc6", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc17") == OBJECT_INVALID)
  {
   
   object oWP = GetWaypointByTag("WP_ps_speaker_npc17_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc17", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc18") == OBJECT_INVALID)
  {
  
   object oWP = GetWaypointByTag("wp_ps_speaker_npc18");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc18", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_speaker_npc19") == OBJECT_INVALID)
  {
 
   object oWP = GetWaypointByTag("wp_ps_speaker_npc19");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc19", lSpawnpoint);    
  }
  
   if(GetObjectByTag("ps_speaker_npc20") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc20");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc20", lSpawnpoint);    
  }
  
   if(GetObjectByTag("ps_speaker_npc21") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc21");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc21", lSpawnpoint);    
  }
  
   if(GetObjectByTag("ps_speaker_npc22") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_speaker_npc22");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_speaker_npc22", lSpawnpoint);    
  }
  
  
  
  
  
  
  
  
  SetGlobalInt("HallSpeakers2EnterLock", 0);
 }
}