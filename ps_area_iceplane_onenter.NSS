

#include "enft_startengine" 
#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

	string sPlane = "Para-Elemental Plane of Ice";
 	string sDescrip = "";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
  
 int iLock = GetGlobalInt("IceEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("IceEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_npc_etnek") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npcetnek");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_etnek", lSpawnpoint);    
  }
 
  SetGlobalInt("IceEnterLock", 0);
 }
 object oEnterer = GetEnteringObject( );
 startEngine(oEnterer);
 
}