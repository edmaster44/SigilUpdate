#include "ff_safevar"

#include "ps_inc_planarlocations"
#include "ps_inc_dynamicencounters"
void main() {

	object oPC = GetEnteringObject();
	string sPlane = "Outlands";
	string sDescrip = "The portal leads you to a castle, fortified by the Harmonium. In the distance, you can make out the infinite height of the Spire.";
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	int iLock = PS_GetGlobalInt("OutlandsCastleEnterLock");
	if ( iLock == 0 ) {
		PS_SetGlobalInt("OutlandsCastleEnterLock", 1); // Only allows one clean up at a time.
		
		if(GetObjectByTag("ps_outcamp_harmarcher") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_harmarcher1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium_archer", GetLocation(oWP), FALSE, "ps_outcamp_harmarcher");    
			oWP = GetWaypointByTag("wp_outcamp_harmarcher2");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium_archer", GetLocation(oWP), FALSE, "ps_outcamp_harmarcher");   
			oWP = GetWaypointByTag("wp_outcamp_harmarcher3");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium_archer", GetLocation(oWP), FALSE, "ps_outcamp_harmarcher"); 
			oWP = GetWaypointByTag("wp_outcamp_harmarcher4");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium_archer", GetLocation(oWP), FALSE, "ps_outcamp_harmarcher"); 
			oWP = GetWaypointByTag("wp_outcamp_harmarcher5");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium_archer", GetLocation(oWP), FALSE, "ps_outcamp_harmarcher"); 
		}
		if(GetObjectByTag("ps_outcamp_harmguard") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_harmguard1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard1", GetLocation(oWP), FALSE, "ps_outcamp_harmguard");    
			oWP = GetWaypointByTag("wp_outcamp_harmguard2");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard1", GetLocation(oWP), FALSE, "ps_outcamp_harmguard");   
		}
		if(GetObjectByTag("ps_outcamp_harmcleric") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_harmcleric");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_harmonium_abyssguard_cleric", GetLocation(oWP), FALSE, "ps_outcamp_harmcleric");  
		}
		if(GetObjectByTag("ps_npc_notary_brint") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_npc_notary_brint");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_notary_brint", GetLocation(oWP));  
		}
		   
		PS_SetGlobalInt("OutlandsCastleEnterLock", 0);
	}
}