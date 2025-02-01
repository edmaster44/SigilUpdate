#include "ff_safevar"

#include "ps_inc_achievements"
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("LowerwardEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("LowerwardEnterLock", 1); // Only allows one clean up at a time.
  
  if(GetObjectByTag("ps_atcorpse_01") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_01"); 
  }
  if(GetObjectByTag("ps_atcorpse_02") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_02");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_02"); 
  }
  if(GetObjectByTag("ps_atcorpse_03") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_03");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_03"); 
  }
  if(GetObjectByTag("ps_atcorpse_04") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_04");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_04"); 
  }
  if(GetObjectByTag("ps_atcorpse_05") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_05");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_05"); 
  }
  if(GetObjectByTag("ps_atcorpse_06") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_06");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_06"); 
  }
  if(GetObjectByTag("ps_atcorpse_07") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_07");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_07"); 
  }
  if(GetObjectByTag("ps_atcorpse_08") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_atcorpse_08");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_atcorpse", lSpawnpoint, FALSE, "ps_atcorpse_08"); 
  }

  if(GetObjectByTag("ps_lowerward_cambion1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_cambion1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_cambion", lSpawnpoint, FALSE, "ps_lowerward_cambion1"); 
   oWP = GetWaypointByTag("wp_lowerward_cambion2");   
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_cambion", lSpawnpoint, FALSE, "ps_lowerward_cambion2"); 
  }

  if(GetObjectByTag("ps_lowerward_harmonium_1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_harmonium_1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_harmonium", lSpawnpoint, FALSE, "ps_lowerward_harmonium_1");
   oWP = GetWaypointByTag("wp_lowerward_harmonium_2");
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_harmonium", lSpawnpoint, FALSE, "ps_lowerward_harmonium_2");    
  }
  
  if(GetObjectByTag("ps_lowerward_xaos") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_xaos");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_xaos", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_lowerward_laborer_female1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_laborer_female1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_laborer_female1", lSpawnpoint);    
  }

  if(GetObjectByTag("ps_lowerward_laborer_male1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_laborer_male1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_laborer_male1", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_lowerward_laborer_male2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_laborer_male2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_laborer_male2", lSpawnpoint);    
  }   
  
  if(GetObjectByTag("ps_lowerward_laborer_male3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_laborer_male3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_laborer_male3", lSpawnpoint);    
  }   
  
  if(GetObjectByTag("ps_lowerward_laborer_male4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_laborer_male4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_laborer_male4", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_lowerward_laborer_nimbot2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_laborer_nimbot2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_laborer_nimbot", lSpawnpoint, FALSE, "ps_lowerward_laborer_nimbot2");       
   oWP = GetWaypointByTag("wp_lowerward_laborer_nimbot4");
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_laborer_nimbot", lSpawnpoint, FALSE, "ps_lowerward_laborer_nimbot4");    
  }  
  
  if(GetObjectByTag("ps_lowerward_nabassu") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_nabassu");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_nabassu", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_lowerward_succubus") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_lowerward_succubus");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_lowerward_succubus", lSpawnpoint);    
  }    
  
  if(GetObjectByTag("ps_npc_lowercommoner2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_lowercommoner2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowercommoner2", lSpawnpoint);    
  }   
  
  if(GetObjectByTag("ps_npc_lowercommoner3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_lowercommoner3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowercommoner3", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_lowercommoner4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_lowercommoner4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowercommoner4", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_lowercommoner5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_lowercommoner5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowercommoner5", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_lowercommoner6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_lowercommoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowercommoner6", lSpawnpoint);    
  }  
  
  if(GetObjectByTag("ps_npc_lowercommoner8") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_lowercommoner8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowercommoner8", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_lowerlizard1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_npc_lowerlizard");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowerlizard", lSpawnpoint, FALSE, "ps_npc_lowerlizard1"); 
   oWP = GetWaypointByTag("wp_npc_lowerlizard2");   
   lSpawnpoint = GetLocation(oWP);  
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowerlizard", lSpawnpoint, FALSE, "ps_npc_lowerlizard2"); 
  }
  
  if(GetObjectByTag("ps_npc_lowerwardpeddler") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_npc_lowerwardpeddler");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_lowerwardpeddler", lSpawnpoint);    
  }
  
  string sID = PS_GetCharID(oPC);
  DelayCommand(6.0f, SetPermanentInt(sID, "Lower_Ward", 1));
  
  DelayCommand(7.0f, CheckToutAchievement(oPC));
  
  PS_SetGlobalInt("LowerwardEnterLock", 0);
 }
}