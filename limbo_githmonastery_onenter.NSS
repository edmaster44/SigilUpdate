#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Githzerai Monastery";
 	string sDescrip = "The interior of the tower is peaceful, tranquil, and unchanging. The collective will of the tower's inhabitants keeps the chaos at bay.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
 	int iLock = GetGlobalInt("Limbo_Githlock");
	if ( iLock == 0 )
	{
		  SetGlobalInt("Limbo_Githlock", 1); // Only allows one clean up at a time.
		
		  if(GetObjectByTag("ps_npc_limbogith1") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("ps_wp_limbogith1");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_limbogith1", lSpawnpoint);    
		  }
		  if(GetObjectByTag("ps_npc_limbogith2") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("ps_wp_limbogith2");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_limbogith2", lSpawnpoint);    
		  }
		  if(GetObjectByTag("ps_npc_limbogith3") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("ps_wp_limbogith3");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_limbogith3", lSpawnpoint);    
		  }
		  if(GetObjectByTag("ps_npc_limbogith4") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("ps_wp_limbogith4");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_limbogith4", lSpawnpoint);    
		  }
		  if(GetObjectByTag("ps_npc_limbogith5") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("ps_wp_limbogith5");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_limbogith5", lSpawnpoint);    
		  }
		  if(GetObjectByTag("ps_npc_limbogith6") == OBJECT_INVALID)
		  {
			   object oWP = GetWaypointByTag("ps_wp_limbogith6");
			   location lSpawnpoint = GetLocation(oWP);  
			   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_limbogith6", lSpawnpoint);    
		  }
		  
		  SetGlobalInt("Limbo_Githlock", 0);
	}
}