#include "ff_safevar"

void ProgressButtons(object oHolder, int nStage, int nButtonsPressed) {

	PS_SetLocalInt(oHolder, "progress", nStage+1);
	PS_SetLocalInt(oHolder, "pressed", nButtonsPressed+1);

}

void main(int nPushed) {

	object oPC = GetLastSpeaker();

	object oHolder = OBJECT_SELF;
	int nButtonsPressed = PS_GetLocalInt(oHolder, "pressed");
	int nStage = PS_GetLocalInt(oHolder, "progress"); 
	string sDoor = PS_GetLocalString(oHolder, "door");
	
	
	if (nStage > 3) {
		PS_SetLocalString(oHolder, "doorToOpen", sDoor);
		SendMessageToPC(oPC, "open door");
	} else if (nButtonsPressed > 3) {
		PS_DeleteLocalInt(oHolder, "pressed");
		PS_DeleteLocalInt(oHolder, "progress");
		PS_DeleteLocalString(oHolder, "doorToOpen");
		PS_DeleteLocalString(oHolder, "door");
		PS_SetLocalInt(oHolder, "reset", 1);
		SendMessageToPC(oPC, "resetting");
		return;
	}
	
	int buttonNum = nButtonsPressed+1;
	int nFire = PS_GetLocalInt(oHolder, "firebutton"+IntToString(buttonNum)); 
	int nWater = PS_GetLocalInt(oHolder, "waterbutton"+IntToString(buttonNum)); 
	int nAir = PS_GetLocalInt(oHolder, "airbutton"+IntToString(buttonNum)); 
	int nEarth = PS_GetLocalInt(oHolder, "earthbutton"+IntToString(buttonNum));
	
	if (sDoor == "") {
		if (nPushed == nFire) {
			PS_SetLocalString(oHolder, "door", "dr_mechanus_firedoor_in");
			SendMessageToPC(oPC, "setting door to dr_mechanus_firedoor_in");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (nPushed == nWater) {
			PS_SetLocalString(oHolder, "door", "dr_mechanus_waterdoor_in");
			SendMessageToPC(oPC, "setting door to dr_mechanus_waterdoor_in");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (nPushed == nAir) {
			PS_SetLocalString(oHolder, "door", "dr_mechanus_airdoor_in");
			SendMessageToPC(oPC, "setting door to dr_mechanus_airdoor_in");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (nPushed == nEarth) {
			PS_SetLocalString(oHolder, "door", "dr_mechanus_earthdoor_in");
			SendMessageToPC(oPC, "setting door to dr_mechanus_earthdoor_in");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		}
	} else {
		if (sDoor == "dr_mechanus_firedoor_in" && nPushed == nFire) {
			SendMessageToPC(oPC, "advancing fire");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (sDoor == "dr_mechanus_waterdoor_in" && nPushed == nWater) {
			SendMessageToPC(oPC, "advancing water");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (sDoor == "dr_mechanus_airdoor_in" && nPushed == nAir) {
			SendMessageToPC(oPC, "advancing air");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (sDoor == "dr_mechanus_earthdoor_in" && nPushed == nEarth) {
			SendMessageToPC(oPC, "advancing earth");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else {
			SendMessageToPC(oPC, "advancing nothing");
			PS_SetLocalInt(oHolder, "pressed", nButtonsPressed+1);
		}
	}
	
	nStage = PS_GetLocalInt(oHolder, "progress"); 
	if (nStage > 3) {
		PS_SetLocalString(oHolder, "doorToOpen", sDoor);
	}

}