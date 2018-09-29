
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("MinaurosRPEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("MinaurosRPEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_rpswampmonster") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_swampmonster");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_rpswampmonster", lSpawnpoint);    
  }
    
  SetGlobalInt("MinaurosRPEnterLock", 0);
 }
}