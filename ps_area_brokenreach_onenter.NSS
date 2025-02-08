#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Abyss";
 string sDescrip = "Broken Reach is one of the most popular gathering places of the Abyss. It consists of several crumbling towers surrounded by outwork of trenches, walls and spikey barricades as most important precincts are underground. Contrary to the whole Abyss, mortal adventurers are unlikely to be devoured by demons within the walls of Broken Reach.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = PS_GetGlobalInt("BrokenreachEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("BrokenreachEnterLock", 1); // Only allows one clean up at a time.

   if(GetObjectByTag("ps_broken_guard1") == OBJECT_INVALID)  // Hezrou Guards
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard1", GetLocation(GetWaypointByTag("ps_wp_broken_outside_guard1"))); 
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard1", GetLocation(GetWaypointByTag("ps_wp_broken_outside_guard2")));  
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard1", GetLocation(GetWaypointByTag("ps_wp_broken_castle_guard1"))); 
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard1", GetLocation(GetWaypointByTag("ps_wp_broken_castle_guard2")));  
 	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard1", GetLocation(GetWaypointByTag("ps_wp_broken_street_guard1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard1", GetLocation(GetWaypointByTag("ps_wp_broken_street_guard2")));
  }

   if(GetObjectByTag("ps_broken_guard2") == OBJECT_INVALID) // Nabassu Guards
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard2", GetLocation(GetWaypointByTag("ps_wp_broken_wall_guard1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard2", GetLocation(GetWaypointByTag("ps_wp_broken_wall_guard2")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard2", GetLocation(GetWaypointByTag("ps_wp_broken_wall_guard3")));
  } 															

   if(GetObjectByTag("ps_broken_guard5") == OBJECT_INVALID) // Entry Guards
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard5", GetLocation(GetWaypointByTag("ps_wp_broken_warlord"))); 
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard4", GetLocation(GetWaypointByTag("ps_wp_broken_warlord_guard1")));  
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard4", GetLocation(GetWaypointByTag("ps_wp_broken_warlord_guard2"))); 
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard4", GetLocation(GetWaypointByTag("ps_wp_broken_warlord_guard3")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_goro", GetLocation(GetWaypointByTag("ps_wp_broken_goro")));  
  } 
    
   if(GetObjectByTag("ps_broken_guard3") == OBJECT_INVALID) // Warlock Guards
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard3", GetLocation(GetWaypointByTag("ps_wp_broken_tiefling_guard1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard3", GetLocation(GetWaypointByTag("ps_wp_broken_tiefling_guard2")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard3", GetLocation(GetWaypointByTag("ps_wp_broken_tiefling_guard3")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard3", GetLocation(GetWaypointByTag("ps_wp_broken_tiefling_guard4")));
  }  
  
   if(GetObjectByTag("ps_broken_watts") == OBJECT_INVALID) // Blacksmiths at the lava sea
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_watts", GetLocation(GetWaypointByTag("ps_wp_broken_watts")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_smith", GetLocation(GetWaypointByTag("ps_wp_broken_smith1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_smith", GetLocation(GetWaypointByTag("ps_wp_broken_smith2")));
  } 
   if(GetObjectByTag("ps_broken_manticore") == OBJECT_INVALID)
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_manticore", GetLocation(GetWaypointByTag("ps_wp_broken_manticore")));
  }
     
   if(GetObjectByTag("ps_broken_slave2") == OBJECT_INVALID) // The slaves near the three succubi
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_slave2", GetLocation(GetWaypointByTag("ps_wp_broken_slave2")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_slave1", GetLocation(GetWaypointByTag("ps_wp_broken_slave1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_slave3", GetLocation(GetWaypointByTag("ps_wp_broken_slave3")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_slave4", GetLocation(GetWaypointByTag("ps_wp_broken_slave4")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_slave5", GetLocation(GetWaypointByTag("ps_wp_broken_slave5")));
  } 
   
   if(GetObjectByTag("ps_broken_sana") == OBJECT_INVALID) // The three succubi
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_sana", GetLocation(GetWaypointByTag("ps_wp_broken_sana")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_marishka", GetLocation(GetWaypointByTag("ps_wp_broken_marishka")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_kylora", GetLocation(GetWaypointByTag("ps_wp_broken_kylora")));
  }

   if(GetObjectByTag("ps_broken_priestess") == OBJECT_INVALID) // Red Shroud Associates
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_priestess", GetLocation(GetWaypointByTag("ps_wp_broken_priestess")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_spider", GetLocation(GetWaypointByTag("ps_wp_broken_spider")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_agent", GetLocation(GetWaypointByTag("ps_wp_broken_agent")));
  }      

   if(GetObjectByTag("ps_broken_katt") == OBJECT_INVALID)
  {
    CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_katt", GetLocation(GetWaypointByTag("ps_wp_broken_katt")));
  } 

   if(GetObjectByTag("ps_broken_merc5") == OBJECT_INVALID) // The Bar ( Comm 2,9,11, merchant and butcher)
  {
    CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_merc5", GetLocation(GetWaypointByTag("ps_wp_broken_merc5")));	
    CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_butcher", GetLocation(GetWaypointByTag("ps_wp_broken_butcher")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm2", GetLocation(GetWaypointByTag("ps_wp_broken_comm2")));
    CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm9", GetLocation(GetWaypointByTag("ps_wp_broken_comm9")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm11", GetLocation(GetWaypointByTag("ps_wp_broken_comm11")));
  }   
  
   if(GetObjectByTag("ps_broken_guard6") == OBJECT_INVALID) // Market guards
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard6", GetLocation(GetWaypointByTag("ps_wp_market_guard1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_guard6", GetLocation(GetWaypointByTag("ps_wp_market_guard2")));
  }   

   if(GetObjectByTag("ps_broken_merc1") == OBJECT_INVALID) // Merchants
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_merc1", GetLocation(GetWaypointByTag("ps_wp_broken_merc1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_merc2", GetLocation(GetWaypointByTag("ps_wp_broken_merc2")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_merc3", GetLocation(GetWaypointByTag("ps_wp_broken_merc3")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_merc4", GetLocation(GetWaypointByTag("ps_wp_broken_merc4")));
  }   

   if(GetObjectByTag("ps_broken_comm12") == OBJECT_INVALID) // Nabassu Ghoul, Cat and others
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm12", GetLocation(GetWaypointByTag("ps_wp_broken_comm12")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_vampire", GetLocation(GetWaypointByTag("ps_wp_broken_vampire")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_cat", GetLocation(GetWaypointByTag("ps_wp_broken_cat")));
  }    

   if(GetObjectByTag("ps_broken_mane") == OBJECT_INVALID) // Manes
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane2")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane3")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane4")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane6")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane7")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane8")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane9")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane10")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane11")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_mane", GetLocation(GetWaypointByTag("ps_wp_broken_mane12")));	
  }
  
   if(GetObjectByTag("ps_broken_quasit") == OBJECT_INVALID) // Outside Quasit
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_quasit", GetLocation(GetWaypointByTag("ps_wp_broken_outside_quasit")));
  }  
  
   if(GetObjectByTag("ps_broken_jarilith") == OBJECT_INVALID) // Jarilith
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_jarilith", GetLocation(GetWaypointByTag("ps_wp_broken_jarilith")));	
  } 
  
   if(GetObjectByTag("ps_broken_group1") == OBJECT_INVALID) // 7th Disorder
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_group1", GetLocation(GetWaypointByTag("ps_wp_broken_group1")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_group2", GetLocation(GetWaypointByTag("ps_wp_broken_group2")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_group3", GetLocation(GetWaypointByTag("ps_wp_broken_group3")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_group4", GetLocation(GetWaypointByTag("ps_wp_broken_group4")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_demongolem", GetLocation(GetWaypointByTag("ps_wp_broken_demongolem")));
  }
   
   if(GetObjectByTag("ps_broken_group11") == OBJECT_INVALID) // Chauntea Group
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_group11", GetLocation(GetWaypointByTag("ps_wp_broken_group11")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_group12", GetLocation(GetWaypointByTag("ps_wp_broken_group12")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_group13", GetLocation(GetWaypointByTag("ps_wp_broken_group13")));
  }
       
   if(GetObjectByTag("ps_broken_doctor") == OBJECT_INVALID) // Doctor Jack and his apprentice
  {
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_doctor", GetLocation(GetWaypointByTag("ps_wp_broken_doctor")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_apprentice", GetLocation(GetWaypointByTag("ps_wp_broken_apprentice")));
  }   

  if(GetObjectByTag("ps_broken_comm16") == OBJECT_INVALID)  //Comm 16 (Quasit, walking)
  {
   object oWP = GetWaypointByTag("ps_wp_broken_comm16");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm16", lSpawnpoint);    
  }    
 
  if(GetObjectByTag("ps_broken_comm8") == OBJECT_INVALID)  // Comm 8 (Alu Fiend, walking)
  {
   object oWP = GetWaypointByTag("ps_wp_broken_comm8");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm8", lSpawnpoint);
  }  
  if(GetObjectByTag("ps_broken_comm14") == OBJECT_INVALID)  // Comm 14 (Marquis Cambion, walking)
  {
   object oWP = GetWaypointByTag("ps_wp_broken_comm14");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm14", lSpawnpoint);             
  } 

  if(GetObjectByTag("ps_broken_comm4") == OBJECT_INVALID) // Commoner  4 & 5 
  {
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm4", GetLocation(GetWaypointByTag("ps_wp_broken_comm4")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm5", GetLocation(GetWaypointByTag("ps_wp_broken_comm5")));
  } 

  if(GetObjectByTag("ps_broken_comm13") == OBJECT_INVALID) // Commoner Woman and Child
  {
    CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm13", GetLocation(GetWaypointByTag("ps_wp_broken_comm13")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm6", GetLocation(GetWaypointByTag("ps_wp_broken_comm6")));
  } 
          
  if(GetObjectByTag("ps_broken_comm1") == OBJECT_INVALID) // Commoner 1
  {
    CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm1", GetLocation(GetWaypointByTag("ps_wp_broken_comm1")));
  }  

  if(GetObjectByTag("ps_broken_jorgash") == OBJECT_INVALID) // Jorgash and Succubi
  {
    CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_jorgash", GetLocation(GetWaypointByTag("ps_wp_broken_jorgash")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm10", GetLocation(GetWaypointByTag("ps_wp_broken_comm10")));
  } 

  if(GetObjectByTag("ps_broken_comm30") == OBJECT_INVALID) // Succi and hezrou
  {
  	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm30", GetLocation(GetWaypointByTag("ps_wp_broken_comm30")));
	CreateObject(OBJECT_TYPE_CREATURE, "ps_broken_comm31", GetLocation(GetWaypointByTag("ps_wp_broken_comm31")));
  }  
                              
  PS_SetGlobalInt("BrokenreachEnterLock", 0);
 }
}