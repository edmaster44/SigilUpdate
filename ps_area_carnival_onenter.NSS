#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("CarnivalEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("CarnivalEnterLock", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("ps_npc_carnfortune") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnfortune");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_foul_fortuneteller", lSpawnpoint, FALSE, "ps_npc_carnfortune");    
  }
  
  if(GetObjectByTag("ps_npc_carnguvner") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnguvner");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnguvner", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carngodsmen") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carngodsmen");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carngodsmen", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carndoom") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carndoom");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carndoom", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carnharm") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnharm");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnharm", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carnharmguard") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnharmguard");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnharmguard", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carnfated") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnfated");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnfated", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carncipher") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carncipher");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carncipher", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carnmercyguard1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnmercyguard1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnmercyguard", lSpawnpoint, FALSE, "ps_npc_carnmercyguard1");    
  }
  
  if(GetObjectByTag("ps_npc_carnmercyguard2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnmercyguard2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnmercyguard", lSpawnpoint, FALSE, "ps_npc_carnmercyguard2");    
  }
  
  //MK arrested her this year
  /*if(GetObjectByTag("ps_npc_carnmercy") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnmercy");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnmercy", lSpawnpoint);    
  }*/
  
  if(GetObjectByTag("ps_npc_carnbleak") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnbleak");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnbleak", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carnathar") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnathar");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnathar", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carngog") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carngog");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carngog", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carndrugs") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carndrugs");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carndrugs", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_npc_carnnpc1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc1", lSpawnpoint);    
  }

    if(GetObjectByTag("ps_npc_carnnpc2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc2", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_carnnpc3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc3", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_carnnpc4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc4", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_carnnpc5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc5", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_npc_carnnpc6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc6", lSpawnpoint);    
  }
  
      if(GetObjectByTag("ps_npc_carnnpc7") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc7");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc7", lSpawnpoint);    
  }
  
      if(GetObjectByTag("ps_npc_carnnpc8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc8", lSpawnpoint);    
  }
  
  
      if(GetObjectByTag("ps_npc_carnnpc9") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc9");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc9", lSpawnpoint);    
  }
  
  
      if(GetObjectByTag("ps_npc_carnnpc10") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_carnnpc10");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc10", lSpawnpoint);    
  }
  
      if(GetObjectByTag("ps_shellgamer") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shellgamer");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_shellgamer", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_carnnpc14") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_carnnpc14");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_carnnpc14", lSpawnpoint);    
  }
 
  PS_SetGlobalInt("CarnivalEnterLock", 0);
 }
}