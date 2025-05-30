

#include "ps_inc_planarlocations"
void main () {

	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
		
	string sDescrip = GetLocalString(GetArea(oPC), "planar_description");
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, "Carceri", sDescrip));
	
	object oDoor = GetNearestObjectByTag("gardentemple_in");
	SetUseableFlag(oDoor, TRUE);
	
	int iLock = GetGlobalInt("ColothysEnterLock");
	if ( iLock == 0 ) {
	
	  SetGlobalInt("ColothysEnterLock", 1);
	  
	  //Portal Listener
	  /*object oListener = GetObjectByTag("c_colothys_portallistener");
	  if(oListener == OBJECT_INVALID || GetArea(oListener) != GetArea(OBJECT_SELF))
	  {
		   object oWP = GetWaypointByTag("wp_colothys_portallistener");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_colothys_portallistener", lSpawnpoint);    
		   oWP = GetWaypointByTag("wp_colothys_portallistener2");
		   lSpawnpoint = GetLocation(oWP);  
		   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_colothys_portallistener", lSpawnpoint);   
	  }*/
	  
  	  SetGlobalInt("ColothysEnterLock", 0);
	  
	}

}