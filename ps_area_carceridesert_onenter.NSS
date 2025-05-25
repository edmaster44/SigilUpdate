

#include "ps_inc_planarlocations"
void main() {

 	object oPC = GetEnteringObject();
 
 	if (!GetIsPC(oPC) && !GetIsDM(oPC))
  		return;
 
	string sPlane = "Carceri";
	string sDescrip = "";
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
  
 	int iLock = GetGlobalInt("MinethysDesertLock");
	if ( iLock == 0 ) {
	
	  	SetGlobalInt("MinethysDesertLock", 1);
	  
	  	if(GetObjectByTag("ps_minethys_ana") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_ana");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_ana", lSpawnpoint);    
	  	}
	  
	  	if(GetObjectByTag("ps_minethys_danai") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_danai");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_danai", lSpawnpoint);    
	  	}
	  
	  	if(GetObjectByTag("ps_minethys_petitioner1") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_petitioner1a");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_petitioner1", lSpawnpoint);   
	   		oWP = GetWaypointByTag("wp_minethys_petitioner1b");
	   		lSpawnpoint = GetLocation(oWP);  
	   		oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_petitioner1", lSpawnpoint);   
	  	}
	  
	  	if(GetObjectByTag("ps_minethys_petitioner2") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_petitioner2");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_petitioner2", lSpawnpoint);    
	  	}
	  
	  	if(GetObjectByTag("ps_minethys_petitioner3") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_petitioner3");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_petitioner3", lSpawnpoint);    
	  	}
	  
	  	if(GetObjectByTag("ps_minethys_sandstorm") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_sandstorm");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_sandstorm", lSpawnpoint);    
	  	}
	  
	  	if(GetObjectByTag("ps_minethys_mortal") == OBJECT_INVALID)
	  	{
	   		object oWP = GetWaypointByTag("wp_minethys_mortal");
	   		location lSpawnpoint = GetLocation(oWP);  
	   		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_mortal", lSpawnpoint);    
	  	}
		
		if(GetObjectByTag("c_minethys_portallistener") == OBJECT_INVALID) {
			   object oWP = GetWaypointByTag("wp_minethys_portallistener");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_colothys_portallistener", lSpawnpoint, FALSE, "c_minethys_portallistener");    
	    }
		
	  	SetGlobalInt("MinethysDesertLock", 0);
	}
}