

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Beastlands";
 string sDescrip = "This valley radiates a feeling of tranquility, and you fear the gentle rush of a large waterfall in the distance. The air is pleasantly cool, and a little humid.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("BeastlandsfallsEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("BeastlandsfallsEnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));

	//Generates the Brux Ranger
	if(GetObjectByTag("ps_brux_ranger") == OBJECT_INVALID)
	{
	object oWP = GetWaypointByTag("wp_brux_ranger");
	location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_brux_ranger", lSpawnpoint);    
	}
	//Generates fish guy
	if(GetObjectByTag("ps_fish_barnaclebob") == OBJECT_INVALID)
	{
		object oWP = GetWaypointByTag("wp_fish_barnaclebob");
		location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_fish_barnaclebob", lSpawnpoint);    
	}
   
  SetGlobalInt("BeastlandsfallsEnterLock", 0);
 }
}