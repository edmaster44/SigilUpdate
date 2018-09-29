
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("USigilEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("USigilEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_mniitvak") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnpoint_mniitvak");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mniitvak", lSpawnpoint);    
  }
    
  SetGlobalInt("USigilEnterLock", 0);
 }
}