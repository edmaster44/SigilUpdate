object GetNearestEncounterMonsterNotTeleported(string sTag);

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
	
	object oMonster = GetNearestEncounterMonsterNotTeleported(sMonster);
	if (GetIsObjectValid(oMonster)) {
		
		//SendMessageToPC(oPC, "Moving "+GetTag(oMonster)+" to "+sWP);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oMonster, 3.0f);
		AssignCommand(oMonster, JumpToLocation(lWP));
		SetLocalInt(oMonster, "Teleported", 1);
		return;
		
	} else {
	
		SendMessageToPC(oPC, "Monster not found.");
	
	}

}

object GetNearestEncounterMonsterNotTeleported(string sTag) {

	int n = 1;
	for (n = 1; n < 10; n++) {
		object oMonster = GetNearestObjectByTag(sTag, OBJECT_SELF, n);
		if (GetIsObjectValid(oMonster) && GetLocalInt(oMonster, "Teleported") == 0) 
			return oMonster;
		oMonster = GetNearestObjectByTag(sTag+"2", OBJECT_SELF, n);
		if (GetIsObjectValid(oMonster) && GetLocalInt(oMonster, "Teleported") == 0) 
			return oMonster;
		oMonster = GetNearestObjectByTag(sTag+"3", OBJECT_SELF, n);
		if (GetIsObjectValid(oMonster) && GetLocalInt(oMonster, "Teleported") == 0) 
			return oMonster;
	}
	
	return OBJECT_INVALID;

}