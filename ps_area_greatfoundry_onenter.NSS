#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("GreatFoundryEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("GreatFoundryEnterLock", 1); // Only allows one clean up at a time.

  
  if(GetObjectByTag("ps_npc_gfcommoner1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("ps_wp_npc_gfcommoner1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner1", lSpawnpoint);    
  } 
  
  //Kiana
  if(GetObjectByTag("ps_npc_gfcommoner10") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("ps_wp_npc_gfcommoner10");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner10", lSpawnpoint);    
  }   
  
  //Ombidias
  if(GetObjectByTag("ps_npc_gfombidias") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfombidias");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfombidias", lSpawnpoint);    
  } 
  
  //Fire Mephit
  if(GetObjectByTag("ps_npc_gfcommoner5") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfcommoner5");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner5", lSpawnpoint);    
  }
  
  //ps_faction_npc_4_c
  if(GetObjectByTag("ps_faction_npc_4_c") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_faction_npc_4_c");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_faction_npc_4_c", lSpawnpoint);    
  }
  
  //wp_gf_cat
  if(GetObjectByTag("c_cat") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_gf_cat");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "c_cat", lSpawnpoint);    
  }
  
  //ps_npc_gfzena
  if(GetObjectByTag("ps_npc_gfzena") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfzena");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfzena", lSpawnpoint);    
  }
  
  //Basdank
  if(GetObjectByTag("ps_npc_gfbasdank") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfbasdank");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfbasdank", lSpawnpoint);    
  }
  
  //Zefran
  if(GetObjectByTag("ps_npc_gfzefran") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfzefran");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfzefran", lSpawnpoint);    
  }
  
  //Choir Director
  if(GetObjectByTag("ps_npc_gfcommoner11") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfcommoner11");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner11", lSpawnpoint);    
  }
  
  //Choir Member 1
  if(GetObjectByTag("ps_npc_gfcommoner9") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfcommoner9");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner9", lSpawnpoint);    
  }
  
  //Choir Member 2
  if(GetObjectByTag("ps_npc_gfcommoner7") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfcommoner7");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner7", lSpawnpoint);    
  }
  
  //Choir Member 3
  if(GetObjectByTag("ps_npc_gfcommoner8") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfcommoner8");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner8", lSpawnpoint);    
  }
  
  //Choir Member 4
  if(GetObjectByTag("ps_npc_gfcommoner12") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfcommoner12");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner12", lSpawnpoint);    
  }
  
  //Gemstone Shard taker
  if(GetObjectByTag("ps_npc_gflaoxim") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gflaoxim");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gflaoxim", lSpawnpoint);    
  }
  
  //Injured Hound
  if(GetObjectByTag("ps_npc_gfcommoner3") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfcommoner3");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner3", lSpawnpoint);    
  }
  
  //Male Monks
  if(GetObjectByTag("ps_npc_gfmmonk1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gfmmonk1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner2", lSpawnpoint, TRUE, "ps_npc_gfmmonk1");    
  	   oWP = GetWaypointByTag("wp_npc_gfmmonk2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner2", lSpawnpoint, FALSE, "ps_npc_gfmmonk2");    
  	   oWP = GetWaypointByTag("wp_npc_gfmmonk3");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner2", lSpawnpoint, FALSE, "ps_npc_gfmmonk3");  
  }
  
  //Female Monks
  if(GetObjectByTag("ps_npc_gffmonk1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("wp_npc_gffmonk1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner4", lSpawnpoint, TRUE, "ps_npc_gffmonk1");    
  	   oWP = GetWaypointByTag("wp_npc_gffmonk2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner4", lSpawnpoint, FALSE, "ps_npc_gffmonk2");    
  }
  
  //Guards
  if(GetObjectByTag("ps_npc_gfguard1") == OBJECT_INVALID)
  {
	   object oWP = GetWaypointByTag("ps_wp_npc_gfguard1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner6", lSpawnpoint, FALSE, "ps_npc_gfguard1");  
	   oWP = GetWaypointByTag("ps_wp_npc_gfguard2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner6", lSpawnpoint, FALSE, "ps_npc_gfguard2");    
	   oWP = GetWaypointByTag("ps_wp_npc_gfguard3");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner6", lSpawnpoint, FALSE, "ps_npc_gfguard3");   
	   oWP = GetWaypointByTag("ps_wp_npc_gfguard4");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gfcommoner6", lSpawnpoint, FALSE, "ps_npc_gfguard4"); 
  } 
  
  
  PS_SetGlobalInt("GreatFoundryEnterLock", 0);
 }
}