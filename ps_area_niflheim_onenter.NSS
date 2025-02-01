#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("NiflheimLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("NiflheimLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_doi_bugbear") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_bugbear");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_bugbear", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_felltroll") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_felltroll");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_felltroll", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_doi_ghost") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_ghost");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_ghost", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_ghoul") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_ghoul");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_ghoul", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_gnoll") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_gnoll");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_gnoll", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_doi_human3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_human3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_human3", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_human6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_human6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_human6", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_doi_lizardfolk") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_lizardfolk");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_lizardfolk", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_kobold") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_kobold");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_kobold", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_human4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_human4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_human4", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_doi_human2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_human2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_human2", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_human1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_human1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_human1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_doi_human5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_human5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_human5", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_merchant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_merchant");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_merchant", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_orc") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_orc");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_orc", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_doi_skeletalhorse") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_skeletalhorse");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_skeletalhorse", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_skeleton") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_skeleton");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_skeleton", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_doi_zombie") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_zombie");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_zombie", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_kobold2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_kobold2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_kobold2", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_doi_goblin") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_goblin");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_goblin", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_goblin2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_goblin2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_goblin2", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_doi_goblin3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_doi_goblin3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_doi_goblin3", lSpawnpoint);    
  }
     
   
  PS_SetGlobalInt("NiflheimLock", 0);
 }
}