#include "ps_inc_faction"
#include "ps_inc_training"


//Timestamp - stolen from Astral Ship! Ha!
int TrapStamp()
{
	int iCurrentTime = GetCalendarYear()*812851200 + GetCalendarMonth()*2419200 + GetCalendarDay()*86400 + GetTimeHour()*3600 + GetTimeMinute()*60 + GetTimeSecond();	
	return iCurrentTime;
}

void ClearEffects(object oTarget) {
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect)) {
		RemoveEffect(oTarget, eEffect);
		eEffect = GetNextEffect(oTarget);
	}
}

int PCTooClose(object oPC, object oTarget) {
	if (GetStealthMode(oPC) != STEALTH_MODE_ACTIVATED && GetDistanceBetween(oPC, oTarget) < 20.0f)
		return TRUE;
	return FALSE;
}

void TryEscape(object oPC, object oTrap, object oTarget) {
	if (!GetIsObjectValid(oTarget) || !GetIsObjectValid(oTrap) || !GetIsObjectValid(oPC))
		return; 
		
	if (GetDistanceBetween(oPC, oTarget) > 20.0f) {
		SendMessageToPC(oPC, "<Color=DarkOliveGreen>A "+GetName(oTarget)+" frees itself from the trap, and escapes!");
		ClearEffects(oTarget);
		location randomLoc = FindHenchSpawnPoint(oPC);
		AssignCommand(oTarget, ActionMoveToLocation(randomLoc, TRUE));
		DestroyObject(oTarget, 1.0f);
		SetLocalInt(oTrap, "caughtThing", 0);
	}
	
}

void CatchAnimal(object oPC, object oTrap, object oTarget) {
	if (!GetIsObjectValid(oTarget) || !GetIsObjectValid(oTrap) || !GetIsObjectValid(oPC))
		return; 

	if (GetTag(oTarget) == "ps_trap_greendragon") {
		if (GetLocalInt(oTarget, "nowHostile") > 0)
			return;
		SendMessageToPC(oPC, "<Color=DarkOliveGreen>A dragon is angered by your trap's attempts to catch it, and goes on a rampage!");
		DestroyObject(oTrap, 0.2f);
		ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
		AssignCommand(oTarget, ActionAttack(oPC));
		SetLocalInt(oTarget, "nowHostile", 1);
	} else {
		effect eParalyze = EffectCutsceneParalyze();
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eParalyze, oTarget);
		SendMessageToPC(oPC, "<Color=DarkOliveGreen>A "+GetName(oTarget)+" is caught in your trap!");
		effect eVis = EffectNWN2SpecialEffectFile("sp_entangle_hit", oTarget);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
		SetLocalInt(oTrap, "caughtThing", 1);
		
		if (GetTag(oTarget) == "ps_trap_whitestag") {
			DelayCommand(60.0f, TryEscape(oPC, oTrap, oTarget));
		}
	}
}

void AnimalEscape(object oPC, object oTrap, object oTarget, location lOrigin) {
	if (!GetIsObjectValid(oTarget) || !GetIsObjectValid(oTrap) || !GetIsObjectValid(oPC))
		return; 

	SendMessageToPC(oPC, "<Color=DarkOliveGreen>A trap springs, but fails to capture the "+GetName(oTarget)+". It escapes.");
	AssignCommand(oTarget, ActionMoveToLocation(lOrigin));
	DestroyObject(oTarget, 1.0f);
	DestroyObject(oTrap, 0.2);

}

string GetAnimalByArea(object oArea, int nSize) {

	object oHolder = GetNearestObjectByTag("obj_trapsystem");
	string sAnimal = "ps_trap_rabbit";
	if (GetArea(oHolder) != oArea)
		return "";
		
	int nRand = Random(100);
	if (nSize == 1) {
		if (nRand <= 1)
			return GetLocalString(oHolder, "smallAnimal_1");
		else if (nRand <= 7)
			return GetLocalString(oHolder, "smallAnimal_6"); 
		else if (nRand <= 29)
			return GetLocalString(oHolder, "smallAnimal_12");  
		else if (nRand <= 54)
			return GetLocalString(oHolder, "smallAnimal_25"); 
		else
			return GetLocalString(oHolder, "smallAnimal_50");    
	} else if (nSize == 2) {
		if (nRand <= 1)
			return GetLocalString(oHolder, "medAnimal_1");
		else if (nRand <= 7)
			return GetLocalString(oHolder, "medAnimal_6"); 
		else if (nRand <= 29)
			return GetLocalString(oHolder, "medAnimal_12");  
		else if (nRand <= 54)
			return GetLocalString(oHolder, "medAnimal_25"); 
		else
			return GetLocalString(oHolder, "medAnimal_50");    
	} else if (nSize == 3) {
		if (nRand <= 1)
			return GetLocalString(oHolder, "largeAnimal_1");
		else if (nRand <= 7)
			return GetLocalString(oHolder, "largeAnimal_6"); 
		else if (nRand <= 29)
			return GetLocalString(oHolder, "largeAnimal_12");  
		else if (nRand <= 54)
			return GetLocalString(oHolder, "largeAnimal_25"); 
		else
			return GetLocalString(oHolder, "largeAnimal_50");    
	}
	return sAnimal;

}

int CanSpawnAnimal(location randomLoc, object oPC, object oTrap) {
	object oHolder = GetNearestObjectByTag("obj_trapsystem");
	if (!GetIsObjectValid(oHolder) || GetArea(oHolder) != GetArea(oPC)) 
		return FALSE;
		
	int nLastSpawned = GetLocalInt(oHolder, "lastSpawned");
	int rightNow = abs(TrapStamp());
	int diff = abs(rightNow-nLastSpawned);
	if (diff < 120) {
		return FALSE;
	}
	
	object oNearestCreature = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, randomLoc);
	if (GetDistanceBetweenLocations(randomLoc, GetLocation(oNearestCreature)) < 10.0f) {
		//SendMessageToPC(oPC, "too close to other creature");
		return FALSE;
	}
		
	if (GetIsLocationValid(randomLoc) && GetDistanceBetweenLocations(GetLocation(oPC), randomLoc) >= 10.0f && 
	(GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED || GetDistanceBetween(oPC, oTrap) > 30.0f)) {
		SetLocalInt(oHolder, "lastSpawned", rightNow);
		return TRUE;
	}
	return FALSE;
}

int CheckForTraps(object oPC, float fDistance) {

	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oPC), FALSE, OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oObj)) {
		if (GetTag(oObj) == "plc_trap_largeanimal" || GetTag(oObj) == "plc_trap_medanimal" || GetTag(oObj) == "plc_trap_smallanimal")
			return TRUE;
		oObj = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oPC), FALSE, OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_CREATURE);
	}
	return FALSE;
}

void main () {

	object oTrap = OBJECT_SELF;
	object oPC = GetLocalObject(oTrap, "creator");
	object oTarget = GetLocalObject(oTrap, "target");
	location lOrigin = GetLocalLocation(oTrap, "startingLoc");
	int nSize = GetLocalInt(oTrap, "animalSize");
	int nStage = GetLocalInt(oTrap, "stage");
	
	int timeSinceSpawned = GetLocalInt(oTrap, "timeSpawned");
	if (timeSinceSpawned == 0) {
		SetLocalInt(oTrap, "timeSpawned", TrapStamp());
	} else if (abs(TrapStamp())-abs(timeSinceSpawned) > 600) { //remove trap after 10 minutes
		DestroyObject(oTrap);
		return;
	}
	
	if (GetLocalInt(oTrap, "caughtThing") == 1)
		return;
		
	string sAnimal = GetAnimalByArea(GetArea(oPC), nSize); //"ps_trap_rabbit";	
	if (sAnimal == "") {
		SendMessageToPC(oPC, "<Color=DarkOliveGreen>This trap is not suitable for this area. Either choose a different sized trap, or move somewhere else.");
		DestroyObject(oTrap, 0.5f);
		return;
	}
	
	if (!GetIsObjectValid(oTarget)) {
		location randomLoc = FindHenchSpawnPoint(oPC);
		SetLocalLocation(oTrap, "startingLoc", randomLoc);
		
		if (CanSpawnAnimal(randomLoc, oPC, oTrap)) {
			object oRabbit = CreateObject(OBJECT_TYPE_CREATURE, sAnimal, randomLoc);
			SetLocalObject(oTrap, "target", oRabbit);
		} 
		DelayCommand(6.0f, ExecuteScript("trap_animal", oTrap));
		return;
	} 
	
	int nListen = GetSkillRank(SKILL_LISTEN, oTarget, TRUE);
	int nSpot = GetSkillRank(SKILL_SPOT, oTarget, TRUE);
	int nSilence = GetSkillRank(SKILL_MOVE_SILENTLY, oPC);
	int nHide = GetSkillRank(SKILL_HIDE, oPC);
	
	if (nListen >= nSilence || PCTooClose(oPC, oTarget)) {
		string sMessage = GetLocalString(oTarget, "OnListen");
		SendMessageToPC(oPC, "<Color=DarkOliveGreen>"+sMessage);
		if (GetLocalInt(oTarget, "isHostile")) {
			if (GetLocalInt(oTarget, "nowHostile") > 0)
				return;
			ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
			AssignCommand(oTarget, ActionAttack(oPC));
			SetLocalInt(oTarget, "nowHostile", 1);
		} else {
			AssignCommand(oTarget, ActionMoveToLocation(lOrigin));
			DestroyObject(oTarget, 1.0f);
		}
		DelayCommand(8.0f, ExecuteScript("trap_animal", oTrap));
		return;
	} 
	if (nSpot >= nHide || PCTooClose(oPC, oTarget)) {
		string sMessage = GetLocalString(oTarget, "OnSpot");
		SendMessageToPC(oPC, "<Color=DarkOliveGreen>"+sMessage);
		if (GetLocalInt(oTarget, "isHostile")) {
			if (GetLocalInt(oTarget, "nowHostile") > 0)
				return;
			AssignCommand(oTarget, ClearAllActions());
			ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
			AssignCommand(oTarget, ActionAttack(oPC));
			SetLocalInt(oTarget, "nowHostile", 1);
		} else {
			AssignCommand(oTarget, ActionMoveToLocation(lOrigin));
			DestroyObject(oTarget, 1.0f);
		}
		DelayCommand(8.0f, ExecuteScript("trap_animal", oTrap));
		return;
	}
		
	
	if (GetDistanceBetween(oTrap, oTarget) > 1.0f) {
		if (nStage > 3 || Random(4) > 2) {
			if (GetLocalInt(oTarget, "nowMoving") == 0) //make sure we don't clear actions when we're already moving
				AssignCommand(oTarget, ClearAllActions());
			DelayCommand(0.2f, AssignCommand(oTarget, ActionForceMoveToLocation(GetLocation(oTrap))));
			DelayCommand(1.0f, ExecuteScript("trap_animal", oTrap));
			SetLocalInt(oTarget, "nowMoving", 1);
			return;
		} else if (GetLocalInt(oTarget, "nowMoving") == 0) {
			AssignCommand(oTarget, ActionRandomWalk());
		}
	} else {
		int nDC = GetLocalInt(oTarget, "CatchDC");
		if (GetHasSkill(SKILL_SET_TRAP, oPC)) {
			if (GetIsTrainingSkillSuccessful(oPC, SKILL_SET_TRAP, nDC)) 
				CatchAnimal(oPC, oTrap, oTarget);
			else 
				AnimalEscape(oPC, oTrap, oTarget, lOrigin);
		} else {
			if (GetIsTrainingAbilitySuccessful(oPC, ABILITY_DEXTERITY, nDC))
				CatchAnimal(oPC, oTrap, oTarget);
			else 
				AnimalEscape(oPC, oTrap, oTarget, lOrigin);
		}
		return;
	}
	
	SetLocalInt(oTrap, "stage", nStage+1);
	DelayCommand(8.0f, ExecuteScript("trap_animal", oTrap));

}