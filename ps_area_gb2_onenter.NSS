


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("GBEnterLock2");
 if ( iLock == 0 )
 {
  SetGlobalInt("GBEnterLock2", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_gb_milich") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_milich");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_milich", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_atarah") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_atarah");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_atarah", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_gad") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_gad");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_gad", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_gb_enoch") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_gb_enoch");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_gb_enoch", lSpawnpoint);    
  }
  
  SetGlobalInt("GBEnterLock2", 0);
 }
}