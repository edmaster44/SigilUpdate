


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("TharizdunLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("TharizdunLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_manifestation_tharizdun") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_tharizdunspawn");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_manifestation_tharizdun", lSpawnpoint);    
  }
 
   
  SetGlobalInt("TharizdunLock", 0);
 }
}