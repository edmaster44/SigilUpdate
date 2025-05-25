

#include "enft_startengine"
#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Celestia";
 	string sDescrip = "";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
  
 int iLock = GetGlobalInt("MercShrineEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("MercShrineEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("ps_mercuria_radangel") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_mercshrine_npc");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mercuria_radangel", lSpawnpoint);    
  }

  SetGlobalInt("MercShrineEnterLock", 0);
 }
}