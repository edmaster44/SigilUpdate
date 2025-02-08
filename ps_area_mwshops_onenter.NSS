#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("MWShopsLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("MWShopsLock", 1); // Only allows one clean up at a time.
  
  //Fat Candle
  if(GetObjectByTag("ps_npc_fatcandle1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_fatcandle1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_fatcandle1", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_fatcandle2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_fatcandle2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_fatcandle2", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_fatcandle3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_fatcandle3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_fatcandle3", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_fatcandle4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_fatcandle4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_fatcandle4", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_fatcandle5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_fatcandle5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_fatcandle5", lSpawnpoint);    
  }
  
  //Music Shop
  if(GetObjectByTag("ps_tc_tatya") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_tc_tatya", GetLocation(GetWaypointByTag("wp_tc_tatya")));  
  }
  if(GetObjectByTag("ps_tc_musicplayer") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_tc_musicplayer", GetLocation(GetWaypointByTag("wp_tc_musicplayer")));  
  }
  
  //Flame Pits
  if(GetObjectByTag("ps_mw_larilzasskos") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_mw_larilzasskos");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mw_larilzasskos", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_mw_masseuse") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_mw_masseuse");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mw_masseuse", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_mw_orfeobarber") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_mw_orfeobarber");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mw_orfeobarber", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_mw_prissyvampire") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_mw_prissyvampire");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mw_prissyvampire", lSpawnpoint);    
  }
  
  //Vermin Control
  if(GetObjectByTag("ps_vermin_kaiyetan") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_vermin_kaiyetan");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_vermin_kaiyetan", lSpawnpoint);    
  }
  
  //Zakk's Corpse Curing
  if(GetObjectByTag("ps_npc_zakk") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_zakk");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_zakk", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_zakkcorpse1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_zakkcorpse1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_zakkcorpse1", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_zakkcorpse2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_zakkcorpse2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_zakkcorpse2", lSpawnpoint);    
  }
   
  PS_SetGlobalInt("MWShopsLock", 0);
 }
}