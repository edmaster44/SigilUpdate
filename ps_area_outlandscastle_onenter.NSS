#include "ps_inc_planarlocations"
void main() {

	object oPC = GetEnteringObject();
	string sPlane = "Outlands";
	string sDescrip = "A few miles from the portal to Sigil, you come across the ruins of a castle, newly fortified by the Factions. In the distance, you can make out the infinite height of the Spire.";
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	int iLock = GetGlobalInt("OutlandsCastleEnterLock");
	if ( iLock == 0 ) {
		SetGlobalInt("OutlandsCastleEnterLock", 1); // Only allows one clean up at a time.
		
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
			oWP = GetWaypointByTag("wp_outcamp_harmarcher6");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladyharmonium_archer", GetLocation(oWP), FALSE, "ps_outcamp_harmarcher"); 
		}
		if(GetObjectByTag("ps_outcamp_harmguard") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_harmguard1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard1", GetLocation(oWP), FALSE, "ps_outcamp_harmguard");    
			oWP = GetWaypointByTag("wp_outcamp_harmguard2");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard1", GetLocation(oWP), FALSE, "ps_outcamp_harmguard");   
			oWP = GetWaypointByTag("wp_outcamp_harmguard3");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_harmoniumyardguard1", GetLocation(oWP), FALSE, "ps_outcamp_harmguard");  
		}
		if(GetObjectByTag("ps_outcamp_harmgeneral") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_harmgeneral1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_scholarf", GetLocation(oWP), FALSE, "ps_outcamp_harmgeneral");    
			oWP = GetWaypointByTag("wp_outcamp_harmgeneral2");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_traineem", GetLocation(oWP), FALSE, "ps_outcamp_harmgeneral"); 
			ForceRest(oSpawn); 
			SetFirstName(oSpawn, "Harmonium Recruit");
			SetLastName(oSpawn, "");
		}
		if(GetObjectByTag("ps_outcamp_sensateguard") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_sensate1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_groundlevelguardf0", GetLocation(oWP), FALSE, "ps_outcamp_sensateguard");    
			oWP = GetWaypointByTag("wp_outcamp_sensate2");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_groundlevelguardf0", GetLocation(oWP), FALSE, "ps_outcamp_sensateguard");  
		}
		if(GetObjectByTag("ps_outcamp_sensategeneral") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_sensate3");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_sensatef1", GetLocation(oWP), FALSE, "ps_outcamp_sensategeneral");    
			oWP = GetWaypointByTag("wp_outcamp_sensate4");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_sensate", GetLocation(oWP), FALSE, "ps_outcamp_sensategeneral");  
		}
		if(GetObjectByTag("ps_outcamp_doomguard") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_doomguard1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "event_doomguard_footman2", GetLocation(oWP), FALSE, "ps_outcamp_doomguard");
			ChangeToStandardFaction(oSpawn, STANDARD_FACTION_DEFENDER);
			oWP = GetWaypointByTag("wp_outcamp_doomguard2");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "event_doomguard_footman2", GetLocation(oWP), FALSE, "ps_outcamp_doomguard"); 
			ChangeToStandardFaction(oSpawn, STANDARD_FACTION_DEFENDER); 
		}
		if(GetObjectByTag("ps_outcamp_doomgeneral") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_doomguard3");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "event_doomguard_pillager2", GetLocation(oWP), FALSE, "ps_outcamp_doomgeneral");    
			ChangeToStandardFaction(oSpawn, STANDARD_FACTION_DEFENDER);  
			oWP = GetWaypointByTag("wp_outcamp_doomguard4");
			oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "event_doomguard_caster2", GetLocation(oWP), FALSE, "ps_outcamp_doomgeneral");   
			ChangeToStandardFaction(oSpawn, STANDARD_FACTION_DEFENDER); 
		}
		if(GetObjectByTag("ps_outcamp_cipher") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_cipher");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gymnasiumguardf", GetLocation(oWP), FALSE, "ps_outcamp_cipher");  
		}
		if(GetObjectByTag("ps_outcamp_dustman") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_dustman");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_dustman", GetLocation(oWP), FALSE, "ps_outcamp_dustman");  
		}
		if(GetObjectByTag("ps_outcamp_harmcleric") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_harmcleric");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_harmonium_abyssguard_cleric", GetLocation(oWP), FALSE, "ps_outcamp_harmcleric");  
		}
		if(GetObjectByTag("ps_outcamp_bleaker") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_bleaker");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gh_bleakerpatrolira", GetLocation(oWP), FALSE, "ps_outcamp_bleaker");  
			SetFirstName(oSpawn, "Bleaker");
			SetLastName(oSpawn, "");
		}
		if(GetObjectByTag("ps_outcamp_mercykiller") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_mercykiller");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_ladymercykiller", GetLocation(oWP), FALSE, "ps_outcamp_mercykiller");  
		}
		if(GetObjectByTag("ps_outcamp_npc1") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_npc1");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "harmonium_traineef", GetLocation(oWP), FALSE, "ps_outcamp_npc1");  
			SetFirstName(oSpawn, "Harmonium Recruit");
			SetLastName(oSpawn, "");
			SetLocalInt(oSpawn, "X2_L_SPAWN_USE_AMBIENT", 1);
		}
		if(GetObjectByTag("ps_outcamp_npc2") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_outcamp_npc2");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "festhallnpc_groundlevelguardf", GetLocation(oWP), FALSE, "ps_outcamp_npc2");  
			SetFirstName(oSpawn, "Planeswalker");
			SetLastName(oSpawn, "");
			SetLocalInt(oSpawn, "X2_L_SPAWN_USE_AMBIENT", 1);
		}
		   
		SetGlobalInt("OutlandsCastleEnterLock", 0);
	}
}