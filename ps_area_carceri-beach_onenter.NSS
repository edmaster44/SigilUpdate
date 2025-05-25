

#include "ps_inc_planarlocations"
#include "enft_startengine"

//Split out so we can do a random white caravel
void SpawnShip() {

	if(GetObjectByTag("ps_minethys_whiteship") == OBJECT_INVALID) {
		object oWP = GetWaypointByTag("wp_minethys_whiteship");
		location lSpawnpoint = GetLocation(oWP);  
		object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_minethys_whiteship", lSpawnpoint);   
		
		DestroyObject(oSpawn, 240.0f);
	}
	
}

void main () {

	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
		
	string sDescrip = GetLocalString(GetArea(oPC), "planar_description");
	string sPlane = GetLocalString(GetArea(oPC), "plane");
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	if (GetIsPC(oPC))
		startEngine(oPC);

	int iLock = GetGlobalInt("CarceriEnterLock");
	if ( iLock == 0 )
	{
		SetGlobalInt("CarceriEnterLock", 1); // Only allows one clean up at a time.
		
		
		//have white caravel turn up at some point
		float fRandom = IntToFloat(Random(10));
		DelayCommand(fRandom, SpawnShip());
		
		//General / Permanent NPCs
		if(GetObjectByTag("ps_porphatys_petitioner1") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_porphatys_petitioner1");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_porphatys_petitioner1", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_porphatys_petitioner2") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_porphatys_petitioner2");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_porphatys_petitioner2", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_porphatys_gadov") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_porphatys_gadov");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_porphatys_gadov", lSpawnpoint);    
		}
		if(GetObjectByTag("ps_porphatys_oldpriest") == OBJECT_INVALID)
		{
		   object oWP = GetWaypointByTag("wp_porphatys_oldpriest");
		   location lSpawnpoint = GetLocation(oWP);  
		   object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ps_porphatys_oldpriest", lSpawnpoint);    
		}
		
		SetGlobalInt("CarceriEnterLock", 0);
		
	}
	
}