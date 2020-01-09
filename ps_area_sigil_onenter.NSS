
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
   object oWP = GetWaypointByTag("wp_sigilmainpatrolguard1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_c_harmoniumpatrolguard", lSpawnpoint);      
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
  //Janella
  if(GetObjectByTag("ps_npc_noobstore") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("ps_wp_noobstore");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_noobstore", lSpawnpoint);    
  }
  //Peddler
  if(GetObjectByTag("ps_npc_bazaarpeddler") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("WP_ps_npc_bazaarpeddler");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_bazaarpeddler", lSpawnpoint);    
  }
  //Vernon (Spider-spider Quest)
    if(GetObjectByTag("ps_quest_spiderspider") == OBJECT_INVALID)
  {
   object oWP = GetWaypointByTag("wp_quest_littlespiders");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_quest_spiderspider", lSpawnpoint);    
  }
  
  SetGlobalInt("SigilEnterLock", 0);
 }
}