
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("InnEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("InnEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_foul_kobold") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lunch");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_kobold", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_foul_drunkelf") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_drunkelf");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_drunkelf", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_bartender") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_muriel");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_bartender", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_foul_ogre") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ogre");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_ogre", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_foul_rina") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_rina");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_rina", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_npc_thoughttaker") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_thoughttaker");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_thoughttaker", lSpawnpoint);    
  }  
     
  if(GetObjectByTag("ps_npc_foul_bouncer1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc-bouncer1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_bouncer1", lSpawnpoint);    
  }    
  
  if(GetObjectByTag("ps_npc_foul_commoner1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fopicommoner1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_commoner1", lSpawnpoint);    
  }      
  
  
  if(GetObjectByTag("ps_npc_foul_commoner2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fopicommoner2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_commoner2", lSpawnpoint);    
  }      
  
  if(GetObjectByTag("ps_npc_foul_commoner3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fopicommoner3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_commoner3", lSpawnpoint);    
  }      

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
    
  SetGlobalInt("InnEnterLock", 0);
 }
}