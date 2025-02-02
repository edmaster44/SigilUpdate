#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("Gatehouse2Lock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("Gatehouse2Lock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("modelskelly") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_modelskelly");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "modelskelly", lSpawnpoint);    
  }
 
  if(GetObjectByTag("barmybleaker") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_barmybleaker");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "barmybleaker", lSpawnpoint);    
  }

  if(GetObjectByTag("gh_sruce") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gh_sruce");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gh_sruce", lSpawnpoint);    
  }
 
  if(GetObjectByTag("ghhypnomimir") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_ghhypnomimir");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ghhypnomimir", lSpawnpoint);    
  }
 

     
   
  PS_SetGlobalInt("Gatehouse2Lock", 0);
 }
}