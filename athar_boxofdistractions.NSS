

//Makes the named target come running to the box
void ComeRunning(string sTag, object self) {
	object oTarget = GetNearestObjectByTag(sTag);
	if (GetIsObjectValid(oTarget) && GetArea(oTarget) == GetArea(self)) {
		if (!GetIsLocationValid(GetLocalLocation(self, sTag)))
			SetLocalLocation(self, sTag, GetLocation(oTarget));
		AssignCommand(oTarget, ActionForceMoveToObject(self, TRUE, 3.0f));
		
	}
}

//Go back to your previous location.
void GoHome(string sTag, object self) {

	object oTarget = GetNearestObjectByTag(sTag);
	location myHome = GetLocalLocation(self, sTag);
	if (GetIsLocationValid(myHome))
		AssignCommand(oTarget, ActionForceMoveToLocation(myHome, FALSE, 3.0f));
}

//Main function
void main() {

	int timer = GetLocalInt(OBJECT_SELF, "rounds_in_existence");
	
	if (timer > 10)
		DestroyObject(OBJECT_SELF);
		
	if (timer > 8) {
	
		GoHome("ps_lowerward_cambion1", OBJECT_SELF);
		GoHome("ps_lowerward_cambion2", OBJECT_SELF);
		GoHome("ps_npc_hermespriestess", OBJECT_SELF);
		
	} else {
		
		ComeRunning("ps_lowerward_cambion1", OBJECT_SELF);
		ComeRunning("ps_lowerward_cambion2", OBJECT_SELF);
		ComeRunning("ps_npc_hermespriestess", OBJECT_SELF);
	}
	
	SetLocalInt(OBJECT_SELF, "rounds_in_existence", timer+1);

}