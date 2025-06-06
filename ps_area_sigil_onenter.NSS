

#include "ps_inc_achievements"
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("SigilEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("SigilEnterLock", 1); // Only allows one clean up at a time.
   
  //************************************
  //Fishy Alex
  if(GetObjectByTag("ps_npc_sigcommoner3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fishyalex");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner3", lSpawnpoint);    
  }
  //Whisper
  if(GetObjectByTag("ps_npc_sigcommoner5") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sigilmaincommoner5");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner5", lSpawnpoint);    
  }
  //Linette
  if(GetObjectByTag("ps_npc_sigcommoner2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sigilmaincommoner2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner2", lSpawnpoint);    
  }
  //Tarion / Spellcaster
  if(GetObjectByTag("ps_npc_sigcommoner1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sigilmaincommoner1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner1", lSpawnpoint);    
  }
  //Dion / Bar person
  if(GetObjectByTag("ps_npc_khazeet") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_efreeticafesalesman");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_khazeet", lSpawnpoint);    
  }  
  //Healer Store
  if(GetObjectByTag("ps_npc_potions") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_sigil_potions");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_potions", lSpawnpoint);    
  }
  //Zharak / Gems
  if(GetObjectByTag("ps_npc_gems") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_sigil_gems");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_gems", lSpawnpoint);    
  }
  //Layla / Herbs
  if(GetObjectByTag("ps_npc_herbs") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_npc_herbs_01");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_herbs", lSpawnpoint);    
  }
  //Shale / Armorer / Weaponer
  if(GetObjectByTag("ps_npc_armor") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_sigil_armor");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_armor", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_armor2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_sigil_armor2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_armor2", lSpawnpoint);    
  }
  //Minerva
  if(GetObjectByTag("ps_npc_scrolls") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_sigil_scrolls");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_scrolls", lSpawnpoint);    
  }
  //Money Exchange
  if(GetObjectByTag("ps_npc_moneyfx") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_moneyfx");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_moneyfx", lSpawnpoint);    
  }
  //Fishy Alex
  if(GetObjectByTag("ps_npc_sigcommoner3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_fishyalex");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner3", lSpawnpoint);    
  }
  //Marroweater
  if(GetObjectByTag("ps_npc_sigcommoner6") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sigilmaincommoner6");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner6", lSpawnpoint);    
  }
  
  //***********************************
  //Esmerelda
  if(GetObjectByTag("ps_npc_esmerelda") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_esmerelda");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_esmerelda", lSpawnpoint);    
  } 
  
  //Carceri Lady
  if(GetObjectByTag("ps_porphatys_mithrii") == OBJECT_INVALID)
  {
	object oWP = GetWaypointByTag("wp_porphatys_mithrii");
	location lSpawnpoint = GetLocation(oWP);  
	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_porphatys_mithrii", lSpawnpoint);    
  }
  
  //Bria Tomay
  if(GetObjectByTag("ps_mw_briatomay") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_briatomay");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_mw_briatomay", lSpawnpoint);    
  } 
  //Beggar
  if(GetObjectByTag("ps_npc_beggar") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_beggar");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_beggar", lSpawnpoint);    
  } 
  //SIGIS Guy
  if(GetObjectByTag("npc_sigis_agent") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_sigis_agent");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "npc_sigis_agent", lSpawnpoint);    
  }
  
  //***********************************
  //Patrolers
  if(GetObjectByTag("ps_c_harmoniumpatrolguard") == OBJECT_INVALID)
  {
   	object oWP = GetWaypointByTag("wp_bazaar_harmonium3");
   	object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard", GetLocation(oWP));  
   	oWP = GetWaypointByTag("wp_bazaar_harmonium2");
   	oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard", GetLocation(oWP), FALSE, "ps_c_bazaarguard1");   
   	oWP = GetWaypointByTag("wp_bazaar_harmonium1");
   	oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard", GetLocation(oWP), FALSE, "ps_c_bazaarguard2");      
  } 
  if(GetObjectByTag("ps_npc_dabus") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_dabusspawnpoint");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_dabus", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_monodrone") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_monodronespawnpoint");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_monodrone", lSpawnpoint);    
  }
  if(GetObjectByTag("sigil_greatbazaar_trasher") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_npcwp_gelatinouscube");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "sigil_greatbazaar_trasher", lSpawnpoint);    
  }   
  
  //***********************************
  //Shezz and Grinnie
  
  if(GetObjectByTag("ps_npc_grinnie") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_grinnie");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_grinnie", lSpawnpoint);    
  }
  
  if(GetObjectByTag("ps_npc_shezz") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_shezz");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_shezz", lSpawnpoint);    
  }
  
  //*************************
  //Slaves
  if(GetObjectByTag("ps_npc_slave_1") == OBJECT_INVALID && GetObjectByTag("ps_npc_slave_2") == OBJECT_INVALID)
  {
	  if (d100() < 50) {
	   object oWP = GetWaypointByTag("ps_wp_bazaarslave1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_slave_01", lSpawnpoint, FALSE, "ps_npc_slave_1");
	   oWP = GetWaypointByTag("ps_wp_bazaarslave2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_slave_04", lSpawnpoint, FALSE, "ps_npc_slave_2");
	  }  else {
	   object oWP = GetWaypointByTag("ps_wp_bazaarslave1");
	   location lSpawnpoint = GetLocation(oWP);  
	   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_slave_02", lSpawnpoint, FALSE, "ps_npc_slave_1");
	   oWP = GetWaypointByTag("ps_wp_bazaarslave2");
	   lSpawnpoint = GetLocation(oWP);  
	   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_slave_03", lSpawnpoint, FALSE, "ps_npc_slave_2");
	  }
  }
  
  //****************************************
  //Beetles / Spiders + Goblin
  if(GetObjectByTag("ps_npc_sigcommoner4") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_sigilmaincommoner4");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_sigcommoner4", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_beetle") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_beetle1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_beetle", lSpawnpoint);   
   oWP = GetWaypointByTag("ps_wp_spider1"); 
   lSpawnpoint = GetLocation(oWP); 
   oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_spider", lSpawnpoint);     
  }
  
  //ps_npc_bazaarguard_1
  //**********************************
  //NPCs
  //Ravenwing Merc
  if(GetObjectByTag("ps_npc_bazaarguard_1") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_bazaarguard_1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_bazaarguard_1", lSpawnpoint);    
  } 
  //Guardian Golem
  if(GetObjectByTag("ps_npc_bazaarguard_2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_bazaarguard_2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_bazaarguard_2", lSpawnpoint);    
  } 
  //Cafe Bouncer
  if(GetObjectByTag("ps_npc_bazaarguard_3") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_bazaarguard_3");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_weapons", lSpawnpoint, FALSE, "ps_npc_bazaarguard_3");    
  } 
  //harlot
  if(GetObjectByTag("ps_bazaar_harlot") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_bazaarharlot");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_bazaar_harlot", lSpawnpoint);    
  } 
  //Absalom
  if(GetObjectByTag("ps_npc_absalom") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_npc_absolom");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_absalom", lSpawnpoint);    
  }
  //Nellie
  if(GetObjectByTag("ps_npc_bazaararcanaloth") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_bazaararcanaloth");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_bazaararcanaloth", lSpawnpoint);    
  }
  
  //Peddler
  if(GetObjectByTag("ps_npc_bazaarpeddler") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_npc_bazaarpeddler");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_bazaarpeddler", lSpawnpoint);    
  }
  if(GetObjectByTag("ps_npc_bazaarpeddler2") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_npc_bazaarpeddler2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_bazaarpeddler2", lSpawnpoint);    
  }
    //Herman (Tier 2 Merchant)
   if(GetObjectByTag("ps_npc_tier2gear") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_ps_npc_tier2gear");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_tier2gear", lSpawnpoint);    
  }
  
  string sID = PS_GetCharID(oPC);
  DelayCommand(6.0f, SetPermanentInt(sID, "Market_Ward", 1));
  
  DelayCommand(7.0f, CheckToutAchievement(oPC));
  
  SetGlobalInt("SigilEnterLock", 0);
 }
}