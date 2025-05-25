


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Gatehouse1Lock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Gatehouse1Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("gh_tessali") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gh_tessali");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gh_tessali", lSpawnpoint);    
  }
 
  if(GetObjectByTag("gh_bleakerpatrolira") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gh_bleakerpatrolira");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gh_bleakerpatrolira", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_tollysalmon") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_tollysalmon");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_tollysalmon", lSpawnpoint);    
  }
 
  if(GetObjectByTag("gh_bleakerpatrol") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gh_bleakerpatrol");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gh_bleakerpatrol", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_npc_garzatherabid") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_garzatherabid");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_garzatherabid", lSpawnpoint);    
  }
 
     
   
  SetGlobalInt("Gatehouse1Lock", 0);
 }
}