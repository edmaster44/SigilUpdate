
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("Mercykiller1Lock");
 if ( iLock == 0 )
 {
  SetGlobalInt("Mercykiller1Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_mkfex") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_mercykillertormentor");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mkfex", lSpawnpoint);    
  }
 
   
  SetGlobalInt("Mercykiller1Lock", 0);
 }
}