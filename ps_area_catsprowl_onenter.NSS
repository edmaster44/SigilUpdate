#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Beastlands";
 string sDescrip = "This area is basked in a pleasant twilight and the rush of a great waterfall can be heard nearby. Yet despite its gentle air and beautiful scenery, there is a lingering feeling of uncertainty looming in the shadows as countless feline eyes blink in and out of the underbrush, waiting to strike.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("CatsprowlEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("CatsprowlEnterLock", 1); // Only allows one clean up at a time.

  if(GetObjectByTag("quest_catlord_kellar") == OBJECT_INVALID)
  { 
   object oWP = GetWaypointByTag("wp_farro");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "quest_catlord_kellar", lSpawnpoint);    
  }
  
  if(GetObjectByTag("catsprowl_cat1") == OBJECT_INVALID)
  { 
   object oWP = GetWaypointByTag("wp_catsprowl1");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "catsprowl_cat1", lSpawnpoint);    
  }
  
    if(GetObjectByTag("catsprowl_cat2") == OBJECT_INVALID)
  { 
   object oWP = GetWaypointByTag("wp_catsprowl2");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "catsprowl_cat2", lSpawnpoint);    
  }
  
    if(GetObjectByTag("ps_quest_cirro") == OBJECT_INVALID)
  { 
   object oWP = GetWaypointByTag("wp_cirro");
   location lSpawnpoint = GetLocation(oWP);  
   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_quest_cirro", lSpawnpoint);    
  }
  
//  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("CatsprowlEnterLock", 0);
 }
}