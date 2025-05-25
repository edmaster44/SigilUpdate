

#include "ps_inc_planarlocations"
void main() {

 	object oPC = GetEnteringObject();
 
 	if (!GetIsPC(oPC) && !GetIsDM(oPC))
  		return;
 
	string sPlane = "Carceri";
	string sDescrip = "";
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
 	int iLock = GetGlobalInt("MinethysCityLock");
	if ( iLock == 0 ) {
	
	  	SetGlobalInt("MinethysCityLock", 1);
	  
	  	if(GetObjectByTag("ps_minethys_king") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_king");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_king", lSpawnpoint);    
	  	}
		
	  	SetGlobalInt("MinethysCityLock", 0);
	}
}