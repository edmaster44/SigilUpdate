
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Smoking2EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Smoking2EnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_sage") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sage");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sage", lSpawnpoint);    
  }
  
  SetGlobalInt("Smoking2EnterLock", 0);
 }
}