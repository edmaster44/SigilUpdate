//:://////////////////////////////////////////////
//
// Handles the sandstorm wandering minethys
// by MimiFearthegn, 6/19/19
//
//:://////////////////////////////////////////////
#include "hench_i0_ai"
#include "x0_i0_position"

void DoSandstorm(float fDis) {
	
	if (!GetIsObjectValid(GetLocalObject(OBJECT_SELF, "entrance"))) {
	
		object oEnt;
		int nGenerated = FALSE;
		object oWP = GetWaypointByTag("wp_minethys_cityentrance1");
		float fDistanceTo = GetDistanceBetween(oWP, OBJECT_SELF);
		if (GetIsObjectValid(oWP) && GetDistanceBetween(oWP, OBJECT_SELF) <= fDis && !nGenerated) {
			oEnt = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_minethys_ruinentrance", GetLocation(oWP));
			SetLocalObject(OBJECT_SELF, "entrance", oEnt);
			SetMapPinEnabled(oWP, TRUE);
			DelayCommand(600.0f, SetMapPinEnabled(oWP, FALSE));
			nGenerated = TRUE;
		} 
		
		oWP = GetWaypointByTag("wp_minethys_cityentrance2");
		fDistanceTo = GetDistanceBetween(oWP, OBJECT_SELF);
		if (GetIsObjectValid(oWP) && GetDistanceBetween(oWP, OBJECT_SELF) <= fDis && !nGenerated) {
			oEnt = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_minethys_ruinentrance", GetLocation(oWP));
			SetLocalObject(OBJECT_SELF, "entrance", oEnt);
			SetMapPinEnabled(oWP, TRUE);
			DelayCommand(600.0f, SetMapPinEnabled(oWP, FALSE));
			nGenerated = TRUE;
		}
		
		oWP = GetWaypointByTag("wp_minethys_cityentrance3");
		fDistanceTo = GetDistanceBetween(oWP, OBJECT_SELF);
		if (GetIsObjectValid(oWP) && GetDistanceBetween(oWP, OBJECT_SELF) <= fDis && !nGenerated) {
			oEnt = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_minethys_ruinentrance", GetLocation(oWP));
			SetLocalObject(OBJECT_SELF, "entrance", oEnt);
			SetMapPinEnabled(oWP, TRUE);
			DelayCommand(600.0f, SetMapPinEnabled(oWP, FALSE));
			nGenerated = TRUE;
		}
		
		if (nGenerated) {
			FloatingTextStringOnCreature("*The winds uncover a previously buried entrance to the ruins below. . .*", OBJECT_SELF, FALSE);
			DestroyObject(oEnt, 600.0f);
			DelayCommand(600.0f, DeleteLocalObject(OBJECT_SELF, "entrance"));
		}
		
	}

	int nSanity = 0;
	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, fDis, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oObj)) {
	
		if (nSanity > 10)
			break;
		nSanity++;
		
		if (oObj == OBJECT_SELF)
			continue;
	
		int nRand = Random(3)+1;
		if (nRand == 1) {
			int nDamage = d6(2);
			if (ReflexSave(oObj, 25, SAVING_THROW_TYPE_TRAP, OBJECT_SELF)) {
				nDamage /= 2;
			}
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
			eDam = EffectLinkEffects(EffectDamage(nDamage), eDam);
			
			SendMessageToPC(oObj, "The windstorm whips up the sand, throwing it into your face, almost blinding you.");
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObj);
		} else if (nRand == 2) {
			int nDamage = d6(2);
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
			if (!ReflexSave(oObj, 25, SAVING_THROW_TYPE_TRAP, OBJECT_SELF)) {
				effect eKnock = EffectKnockdown();
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oObj, 2.0f);
				SendMessageToPC(oObj, "A piece of flying debris hits you, propelled by the windstorm. You are knocked down.");
			} else {
				SendMessageToPC(oObj, "You barely dodge a piece of flying debris, picked up by the windstorm. It grazes you.");
			}
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObj);
		} else if (nRand == 3) {
			location lTarget = GetRandomLocation(GetArea(OBJECT_SELF), OBJECT_SELF, 20.0f);
			int nDamage = d6();
			if (!ReflexSave(oObj, 25, SAVING_THROW_TYPE_TRAP, OBJECT_SELF)) {
				nDamage = d6(2);
				SendMessageToPC(oObj, "The wind suddenly picks up in intensity, picking you up off your feet, and throwing you across the desert.");
				AssignCommand(oObj, ActionJumpToLocation(lTarget));
			} else {
				SendMessageToPC(oObj, "The wind buffets you mercilessly, nearly picking you up off your feet.");
			}
			
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObj);
		}
		
		oObj = GetNextObjectInShape(SHAPE_SPHERE, fDis, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
	
	}

}

void main () {

    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
	
	float fDistance = 15.0f;
	DoSandstorm(fDistance);

	//Generic HB stuff
	if (HenchCheckHeartbeatCombat()) {
	    HenchResetCombatRound();
	}
	
	//No combat
	CleanCombatVars();
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);
    if (DoStealthAndWander()) {
    	// nothing to do here
    } else if (GetWalkCondition(NW_WALK_FLAG_CONSTANT)) {
    	// sometimes waypoints are not initialized
    	WalkWayPoints();
    }
	
    if (GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}