

void ProgressButtons(object oHolder, int nStage, int nButtonsPressed) {

	SetLocalInt(oHolder, "progress", nStage+1);
	SetLocalInt(oHolder, "pressed", nButtonsPressed+1);

}

void main(int nPushed) {

	object oPC = GetLastSpeaker();

	object oHolder = OBJECT_SELF;
	int nButtonsPressed = GetLocalInt(oHolder, "pressed");
	int nStage = GetLocalInt(oHolder, "progress"); 
	string sDoor = GetLocalString(oHolder, "door");
	
	
	if (nStage > 3) {
		SetLocalString(oHolder, "doorToOpen", sDoor);
		SendMessageToPC(oPC, "open door");
	} else if (nButtonsPressed > 3) {
		DeleteLocalInt(oHolder, "pressed");
		DeleteLocalInt(oHolder, "progress");
		DeleteLocalString(oHolder, "doorToOpen");
		DeleteLocalString(oHolder, "door");
		SetLocalInt(oHolder, "reset", 1);
		SendMessageToPC(oPC, "resetting");
		return;
	}
	
	int buttonNum = nButtonsPressed+1;
	int nFire = GetLocalInt(oHolder, "firebutton"+IntToString(buttonNum)); 
	int nWater = GetLocalInt(oHolder, "waterbutton"+IntToString(buttonNum)); 
	int nAir = GetLocalInt(oHolder, "airbutton"+IntToString(buttonNum)); 
	int nEarth = GetLocalInt(oHolder, "earthbutton"+IntToString(buttonNum));
	
	if (sDoor == "") {
		if (nPushed == nFire) {
			SetLocalString(oHolder, "door", "dr_mechanus_firedoor_in");
			SendMessageToPC(oPC, "setting door to dr_mechanus_firedoor_in");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (nPushed == nWater) {
			SetLocalString(oHolder, "door", "dr_mechanus_waterdoor_in");
			SendMessageToPC(oPC, "setting door to dr_mechanus_waterdoor_in");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (nPushed == nAir) {
			SetLocalString(oHolder, "door", "dr_mechanus_airdoor_in");
			SendMessageToPC(oPC, "setting door to dr_mechanus_airdoor_in");
			ProgressButtons(oHolder, nStage, nButtonsPressed);
		} else if (nPushed == nEarth) {
			SetLocalString(oHolder, "door", "dr_mechanus_earthdoor_in");
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
			SetLocalInt(oHolder, "pressed", nButtonsPressed+1);
		}
	}
	
	nStage = GetLocalInt(oHolder, "progress"); 
	if (nStage > 3) {
		SetLocalString(oHolder, "doorToOpen", sDoor);
	}

}