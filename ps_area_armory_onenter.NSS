
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("ArmoryEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("ArmoryEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_armory_spragg") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_spragg");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_spragg", lSpawnpoint);    
  }


  if(GetObjectByTag("ps_armory_falcata") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_falcata");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_armory_falcata", lSpawnpoint);    
  }
  
  SetGlobalInt("ArmoryEnterLock", 0);
 }
}