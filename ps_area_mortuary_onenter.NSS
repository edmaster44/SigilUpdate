
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("MortuaryEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("MortuaryEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_commoner_mortuary1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary1", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ps_commoner_mortuary2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_commoner_mortuary3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary3", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_commoner_mortuary4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary4", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_commoner_mortuary5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary5", lSpawnpoint);    
  }  
 
  if(GetObjectByTag("ps_commoner_mortuary6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary6", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_mortuary7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary7", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_mortuary8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary8", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_mortuary9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner9");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary9", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_mortuary10") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner10");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary10", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_mortuary11") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_commoner11");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_mortuary11", lSpawnpoint);    
  } 
  
  if(GetObjectByTag("ps_commoner_deathport") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("mortuarywp_arcanist");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_commoner_deathport", lSpawnpoint);    
  }
    
  SetGlobalInt("MortuaryEnterLock", 0);
 }
}