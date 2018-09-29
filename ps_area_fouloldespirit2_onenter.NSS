
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Inn2EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Inn2EnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_sage") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sage");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sage", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_foul_spirit") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ghost");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_spirit", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_foul_bouncer2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc-fosibouncer2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_bouncer2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_foul_fortuneteller") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc-fosifortuneteller");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_fortuneteller", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_foul_spirithunter") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc-fosishaman");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_spirithunter", lSpawnpoint);    
  }  
  
      
  SetGlobalInt("Inn2EnterLock", 0);
 }
}