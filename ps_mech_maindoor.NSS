#include "ff_safevar"

void main () {

	string sDoor = PS_GetLocalString(OBJECT_SELF, "doorToOpen");
	
	object oDoorAir = GetNearestObjectByTag("dr_mechanus_airdoor_in");
	object oDoorWater = GetNearestObjectByTag("dr_mechanus_waterdoor_in");
	object oDoorFire = GetNearestObjectByTag("dr_mechanus_firedoor_in");
	object oDoorEarth = GetNearestObjectByTag("dr_mechanus_earthdoor_in");
	
	//Make sure all doors are closed
	AssignCommand( oDoorAir, ActionCloseDoor( oDoorAir ) );
	AssignCommand( oDoorWater, ActionCloseDoor( oDoorWater ) );
	AssignCommand( oDoorFire, ActionCloseDoor( oDoorFire ) );
	AssignCommand( oDoorEarth, ActionCloseDoor( oDoorEarth ) );
	
	//Lock all doors
	SetLocked(oDoorAir, TRUE);
	SetLocked(oDoorWater, TRUE);
	SetLocked(oDoorFire, TRUE);
	SetLocked(oDoorEarth, TRUE);
	
	//Play sound
	PlaySound("as_cv_brickscrp1", TRUE);
	
	//open one door
	object oToOpen = GetNearestObjectByTag(sDoor);
	DelayCommand(1.0f, SetLocked(oToOpen, FALSE));
	DelayCommand(1.1f, AssignCommand(oToOpen, ActionOpenDoor( oToOpen )));
}