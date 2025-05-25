


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("GreenhouseEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("GreenhouseEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_lowergreen_laborer1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_laborer1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_laborer1", lSpawnpoint);    
  } 
  if(GetObjectByTag("ps_lowergreen_laborer2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_laborer2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_laborer2", lSpawnpoint);    
  } 
  if(GetObjectByTag("ps_lowergreen_brownie") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_brownie");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_brownie", lSpawnpoint);    
  } 
  if(GetObjectByTag("ps_lowergreen_nymph") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_nymph");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_nymph", lSpawnpoint);    
  } 
  if(GetObjectByTag("ps_lowergreen_satyr") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_satyr");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_satyr", lSpawnpoint);    
  } 
  if(GetObjectByTag("ps_lowergreen_pixie1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_pixie1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_pixie1", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_lowergreen_pixie2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_pixie2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_pixie2", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_lowergreen_dryad") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_dryad");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_dryad", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_lowergreen_bariaur") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_bariaur");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_bariaur", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_lowergreen_woodelf") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_woodelf");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_woodelf", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_lowergreen_elf") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_elf");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_elf", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_lowergreen_baker") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_baker");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_baker", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_lowergreen_bard") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowergreen_bard");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowergreen_bard", lSpawnpoint);    
  }
   
  SetGlobalInt("GreenhouseEnterLock", 0);
 }
}