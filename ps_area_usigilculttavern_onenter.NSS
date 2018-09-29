
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("CultTavernEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("CultTavernEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_culttavern1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_culttavern1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_culttavern1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_culttavern2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_culttavern2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_culttavern2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_culttavern3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_culttavern3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_culttavern3", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_culttavern4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_culttavern4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_culttavern4", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_culttavern5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_culttavern5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_culttavern5", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_npc_culttavern6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_culttavern6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_culttavern6", lSpawnpoint);    
  }  
  
  SetGlobalInt("CultTavernEnterLock", 0);
 }
}