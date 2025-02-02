#include "ff_safevar"

#include "ps_inc_planarlocations"
void main() {

 	object oPC = GetEnteringObject();
	string sPlane = "Outlands";
	string sDescrip = "";
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	int iLock = PS_GetGlobalInt("OutlandsCloverbrookEnterLock");
	if ( iLock == 0 ) {
		PS_SetGlobalInt("OutlandsCloverbrookEnterLock", 1); // Only allows one clean up at a time.
		
		if(GetObjectByTag("ps_npc_dori") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_ps_npc_dori");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_dori", GetLocation(oWP));  
		}
		if(GetObjectByTag("cbvillager001") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_cbvillager001");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cbvillager001", GetLocation(oWP));  
		}
		if(GetObjectByTag("cbvillager002") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_cbvillager002");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cbvillager002", GetLocation(oWP));  
		}
		if(GetObjectByTag("cbvillager003") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_cbvillager003");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cbvillager003", GetLocation(oWP));  
		}
		if(GetObjectByTag("cbvillager004") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_cbvillager004");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cbvillager004", GetLocation(oWP));  
		}
		if(GetObjectByTag("cloverbrook_sensateguard_1") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_cloverbrook_sensateguard_1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cloverbrook_sensateguard", GetLocation(oWP), FALSE, "cloverbrook_sensateguard_1");  
		}
		if(GetObjectByTag("cloverbrook_sensateguard_2") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_cloverbrook_sensateguard_2");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cloverbrook_sensateguard", GetLocation(oWP), FALSE, "cloverbrook_sensateguard_2");  
		}
		   
		PS_SetGlobalInt("OutlandsCloverbrookEnterLock", 0);
	}
}