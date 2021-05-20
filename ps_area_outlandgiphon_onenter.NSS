#include "ps_inc_planarlocations"
void main() {

 	object oPC = GetEnteringObject();
	string sPlane = "Outlands";
	string sDescrip = "You come upon an ornate stone bridge, crossing a river. The bridge is fortified, and flies the flag of the Harmonium. Those with a sense for magic might detect magic radiating off the bridge, although that magic's purpose is not immediately clear.";
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	int iLock = GetGlobalInt("OutlandsGiphonEnterLock");
	if ( iLock == 0 ) {
		SetGlobalInt("OutlandsGiphonEnterLock", 1); // Only allows one clean up at a time.
		
		if(GetObjectByTag("ps_npc_dharran") == OBJECT_INVALID) { 
			object oWP = GetWaypointByTag("wp_ps_npc_dharran");
			object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_npc_dharran", GetLocation(oWP));  
		}
		   
		SetGlobalInt("OutlandsGiphonEnterLock", 0);
	}
}