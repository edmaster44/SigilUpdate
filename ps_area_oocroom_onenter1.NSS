#include "ff_safevar"

#include "ps_inc_casterlevel"
void main()
{
 object oPC = GetEnteringObject();
 int nLevel = GetRealCasterLevel(oPC);
	
 int iLock = PS_GetGlobalInt("OOCEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("OOCEnterLock", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("ps_npc_custom0") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ooc_tailor1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_custom0", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_oocroommerchant") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_oocroom-merchant1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_oocroommerchant", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_mimir") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_mimir1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_mimir", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_oocstyx") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_styxoarsman1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_oocstyx", lSpawnpoint);    
  }
    
    if(GetObjectByTag("ps_npc_fangooc") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_fangooc");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_fangooc", lSpawnpoint);    
  }
  
  
    if(GetObjectByTag("ps_heightadjust") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_heightadjust");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_heightadjust", lSpawnpoint);    
  }


    if(GetObjectByTag("npc_sigis_journalist_ooc") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_sigis_journalist_ooc");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_sigis_journalist_ooc", lSpawnpoint);    
  }


    if(GetObjectByTag("ps_npc_oocbarber") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ooc_barber");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_oocbarber", lSpawnpoint);    
  }

  //To re-enable Krampus, remember to change lines in ps_styx_* scripts to 
  //add all exp to your dm pool
  /*if(GetObjectByTag("ps_npc_seasonalkrampus") == OBJECT_INVALID)  {
	   object oWP = GetWaypointByTag("wp_ooc_krampus");
   	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_seasonalkrampus", lSpawnpoint);    
  } */ 
  
  if(GetObjectByTag("kemo_storage_teller") == OBJECT_INVALID)
  {
	object oWP = GetWaypointByTag("wp_kemo_storage_teller");
   	location lSpawnpoint = GetLocation(oWP);  
	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "kemo_storage_teller", lSpawnpoint);    
  }
  
  PS_SetGlobalInt("OOCEnterLock", 0);
 }
 
 
 //ExecuteScript("onenter_antimagic",OBJECT_SELF);
}