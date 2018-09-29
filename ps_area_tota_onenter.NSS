
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("TotAEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("TotAEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_tota_noshteroth") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_tota_noshteroth");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_noshteroth", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_tota_noxana") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_tota_noxana");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_noxana", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_tota_prelate") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_tota_prelate");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_prelate", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_tota_priest") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_tota_priest");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_priest", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_tota_priestess") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_tota_priestess");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_priestess", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_tota_succubus") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_tota_succubus1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_succubus", lSpawnpoint); 
   
   object oWP2 = GetWaypointByTag("wp_tota_succubus2");
   location lSpawnpoint2 = GetLocation(oWP2);  
   object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_succubus", lSpawnpoint2);   
  }  
    
  if(GetObjectByTag("ps_tota_guard") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_tota_guard1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_guard", lSpawnpoint);    
   
   object oWP2 = GetWaypointByTag("wp_tota_guard2");
   location lSpawnpoint2 = GetLocation(oWP2);  
   object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_guard", lSpawnpoint2);  
   
   object oWP3 = GetWaypointByTag("wp_tota_guard3");
   location lSpawnpoint3 = GetLocation(oWP3);  
   object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_guard", lSpawnpoint3);  
   
   object oWP4 = GetWaypointByTag("wp_tota_guard4");
   location lSpawnpoint4 = GetLocation(oWP4);  
   object oSpawn4 = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_guard", lSpawnpoint4);  
   
   object oWP5 = GetWaypointByTag("wp_tota_guard5");
   location lSpawnpoint5 = GetLocation(oWP5);  
   object oSpawn5 = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_guard", lSpawnpoint5);  
   
   object oWP6 = GetWaypointByTag("wp_tota_guard6");
   location lSpawnpoint6 = GetLocation(oWP6);  
   object oSpawn6 = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_guard", lSpawnpoint6);  
   
   object oWP7 = GetWaypointByTag("wp_tota_guard7");
   location lSpawnpoint7 = GetLocation(oWP7);  
   object oSpawn7 = CreateObject(OBJECT_TYPE_CREATURE, "ps_tota_guard", lSpawnpoint7);  
  }  
  

  SetGlobalInt("TotAEnterLock", 0);
 }
}