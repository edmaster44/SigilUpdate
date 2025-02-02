
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("HiveEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("CultVillageEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_epic_elderbrainhive") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_x_elderbrainwp");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_epic_elderbrainhive", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_x_mfhive1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_x_mindflayer1wp");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_x_mfhive1", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_x_mfhive2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_x_mindflayer2wp");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_x_mfhive2", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_x_mindflayerhivecleric") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_x_mindflayerclericwp");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_x_mindflayerhivecleric", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_x_mindflayerhivethrall") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_x_thrallherdwp");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_x_mindflayerhivethrall", lSpawnpoint);    
  }  

  if(GetObjectByTag("ps_x_hivedevourer") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_x_devourerwp");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_x_hivedevourer", lSpawnpoint);    
  }  
    
  
  SetGlobalInt("HiveEnterLock", 0);
 }
}