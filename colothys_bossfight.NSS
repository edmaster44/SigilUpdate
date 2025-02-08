#include "ff_safevar"

#include "ps_inc_spawns"

void SpawnWyvern(object oTrigger, location lTarget);

int GetEbolakhanAlive();

void main () {

	int nStage = PS_GetLocalInt(OBJECT_SELF, "stage");
	object oWP;
	
	object oPC = PS_GetLocalObject(OBJECT_SELF, "TriggeredBy");
	
	if (nStage <= 1) {
		oWP = GetWaypointByTag("wp_gardenboss_guardian1");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardianm");
	
		oWP = GetWaypointByTag("wp_gardenboss_guardian3");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardianm");
				
		oWP = GetWaypointByTag("wp_gardenboss_vine1");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_greenvise");
		
		oWP = GetWaypointByTag("wp_gardenboss_vine2");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_greenvise");
		
		PS_SetLocalInt(OBJECT_SELF, "stage", nStage+1);
		DelayCommand(12.0f, ExecuteScript("colothys_bossfight", OBJECT_SELF));
	}
	else if (nStage <= 2) {
		oWP = GetWaypointByTag("wp_gardenboss_guardian4");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardian");
		
		oWP = GetWaypointByTag("wp_gardenboss_guardian5");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardian");
		
		oWP = GetWaypointByTag("wp_gardenboss_guardian2");
		SpawnWyvern(OBJECT_SELF, GetLocation(oWP));
		
		PS_SetLocalInt(OBJECT_SELF, "stage", nStage+1);
		DelayCommand(12.0f, ExecuteScript("colothys_bossfight", OBJECT_SELF));
	}
	else if (nStage <= 3) {
	
		oWP = GetWaypointByTag("wp_gardenboss_guardian1");
		SpawnWyvern(OBJECT_SELF, GetLocation(oWP));
			
		oWP = GetWaypointByTag("wp_gardenboss_guardian2");
		SpawnWyvern(OBJECT_SELF, GetLocation(oWP));	
		
		oWP = GetWaypointByTag("wp_gardenboss_guardian3");
		SpawnWyvern(OBJECT_SELF, GetLocation(oWP));
			
		oWP = GetWaypointByTag("wp_gardenboss_vine1");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_assassinvine");
			
		oWP = GetWaypointByTag("wp_gardenboss_vine2");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_assassinvine");		
			
		oWP = GetWaypointByTag("wp_gardenboss_main");
		SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_ebolakhan");
		
		PS_SetLocalInt(OBJECT_SELF, "stage", nStage+1);
		DelayCommand(12.0f, ExecuteScript("colothys_bossfight", OBJECT_SELF));
	
	} else if (GetEbolakhanAlive()) {
	
		if (nStage < 10) { //Sanity check!
	
			oWP = GetWaypointByTag("wp_gardenboss_guardian1");
			SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardianm");
				
			oWP = GetWaypointByTag("wp_gardenboss_guardian2");
			SpawnWyvern(OBJECT_SELF, GetLocation(oWP));
			
			oWP = GetWaypointByTag("wp_gardenboss_guardian3");
			SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardianm");
				
			oWP = GetWaypointByTag("wp_gardenboss_guardian4");
			SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardian");
					
			oWP = GetWaypointByTag("wp_gardenboss_guardian5");
			SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_guardian");
				
			oWP = GetWaypointByTag("wp_gardenboss_vine1");
			SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_greenvise");
				
			oWP = GetWaypointByTag("wp_gardenboss_vine2");
			SpawnEncounterCreature(OBJECT_SELF, oPC, GetLocation(oWP), "c_colothys_assassinvine");
			
		}
		
		PS_SetLocalInt(OBJECT_SELF, "stage", nStage+1);
		DelayCommand(12.0f, ExecuteScript("colothys_bossfight", OBJECT_SELF));
	
	} else {
		object oFruit1 = GetObjectByTag("pl_gardenfruit_1");
		object oFruit2 = GetObjectByTag("pl_gardenfruit_2");
		SetUseableFlag(oFruit1, TRUE);
		SetUseableFlag(oFruit2, TRUE);
		PS_SetLocalInt(oFruit1, "reward", 1);
		PS_SetLocalInt(oFruit2, "reward", 1);
		
		int nTime = PS_GetTime();
		PS_SetLocalInt(oFruit1, "lastlooted", nTime);
		PS_SetLocalInt(oFruit2, "lastlooted", nTime);
	}
}

int GetEbolakhanAlive() {

	object oBoss = GetObjectByTag("c_colothys_ebolakhan");
	if (!GetIsObjectValid(oBoss))
		oBoss = GetObjectByTag("c_colothys_ebolakhan2");
	if (!GetIsObjectValid(oBoss))
		oBoss = GetObjectByTag("c_colothys_ebolakhan3");
			
	if (!GetIsObjectValid(oBoss))
		return FALSE;
	
	if (GetIsDead(oBoss))
		return FALSE;
		
	return TRUE;

}

location RandomSource(object oTrigger) {

	object oArea = GetArea(oTrigger);
	vector vPosition = GetPosition(oTrigger);
	float fZ = vPosition.z + 20.0 + IntToFloat(Random(10));
	float fX;
	float fY;
	int nHeight = GetAreaSize(AREA_HEIGHT, oArea);
	int nWidth = GetAreaSize(AREA_WIDTH, oArea);
	
	float fXMax = IntToFloat(nWidth * 10);
	float fYMax = IntToFloat(nHeight * 10);
	
	if (d2(1) == 1)// X axis
		{
		fY = 1.0;
		if(d2(1) == 2) fY = fYMax - 1.0;	
		fX = IntToFloat(Random(FloatToInt(fXMax)));
	
		}
	else// Y axis
		{
		fX = 1.0;
		if(d2(1) == 2) fX = fXMax - 1.0;
		fY = IntToFloat(Random(FloatToInt(fYMax)));
		}
	
	vector vSource = Vector(fX, fY, fZ);
	location lSource = Location(oArea, vSource, 0.0);
	
	return lSource;
}

void SpawnWyvern(object oTrigger, location lTarget) {
	location lTarget = GetRandomLocation(GetArea(oTrigger), oTrigger, 5.0);
	lTarget = CalcSafeLocation(oTrigger, lTarget, 5.0, TRUE, FALSE);
	location lSource = RandomSource(oTrigger);
		
	object oSource = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ",lSource);
	TurnToFaceObject(oTrigger, oSource);
		
	AssignCommand(oSource, ActionCastSpellAtLocation(1919, lTarget, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	DestroyObject(oSource, 10.0);
}