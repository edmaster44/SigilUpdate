void main() {

	object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC))
		return;
		
	//SendMessageToPC(oPC, "Should be teleporting something.");

	string sWP = GetLocalString(OBJECT_SELF, "Teleport_Waypoint");
	string sMonster = GetLocalString(OBJECT_SELF, "Teleport_Monster");
	
	effect eVis = EffectNWN2SpecialEffectFile("fx_teleport");
	
	object oWP = GetWaypointByTag(sWP);
	if (!GetIsObjectValid(oWP))
		return;
		
	location lWP = GetLocation(oWP);
	
	object oMonster = GetNearestObjectByTag(sMonster);
	if (GetIsObjectValid(oMonster) && GetLocalInt(oMonster, "Teleported") == 0) {
		
		//SendMessageToPC(oPC, "Moving "+GetTag(oMonster)+" to "+sWP);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oMonster, 3.0f);
		AssignCommand(oMonster, ActionJumpToLocation(lWP));
		SetLocalInt(oMonster, "Teleported", 1);
		return;
		
	}
	
	oMonster = GetNearestObjectByTag(sMonster+"2");
	if (GetIsObjectValid(oMonster) && GetLocalInt(oMonster, "Teleported") == 0) {
	
		//SendMessageToPC(oPC, "Moving "+GetTag(oMonster)+" to "+sWP);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oMonster, 3.0f);
		AssignCommand(oMonster, ActionJumpToLocation(lWP));
		SetLocalInt(oMonster, "Teleported", 1);
		return;
	
	}
	
	oMonster = GetNearestObjectByTag(sMonster+"3");
	if (GetIsObjectValid(oMonster) && GetLocalInt(oMonster, "Teleported") == 0) {
	
		//SendMessageToPC(oPC, "Moving "+GetTag(oMonster)+" to "+sWP);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oMonster, 3.0f);
		AssignCommand(oMonster, ActionJumpToLocation(lWP));
		SetLocalInt(oMonster, "Teleported", 1);
		return;
	
	}

}