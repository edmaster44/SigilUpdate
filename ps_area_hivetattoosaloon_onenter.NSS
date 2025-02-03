
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("TattooSaloonEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("TattooSaloonEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_lervakkhin") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_spawnpoint_lervakkhin");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lervakkhin", lSpawnpoint);    
  }
    
  SetGlobalInt("TattooSaloonEnterLock", 0);
 }
}