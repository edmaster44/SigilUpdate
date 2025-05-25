

//::///////////////////////////////////////////////
//:: Stone Serpent Heartbeat
//:: ps_custom_serpent_hrt
//:://////////////////////////////////////////////
/*
    Handles serpent "teleportation"
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: 6/9/19
//:://////////////////////////////////////////////
#include "hench_i0_ai"
#include "x0_i0_position"
#include "ps_inc_melee"

void PlayCustomAnim(object oSelf, string sAnim, float speed = 0.5f) {
	PlayCustomAnimation(oSelf, sAnim, FALSE, speed);
}

//We don't have to actually make rolls, because creature AI kicks in on its own
//We just need to provide the animation!
void MeleeAttack(object oSelf, object oTarget) {
	//TurnToFaceObject(oTarget, oSelf);
	//PlayCustomAnimation(oSelf, "gen_cast", TRUE, 0.5f);
	PlayCustomAnim(oSelf, "gen_cast", 0.5f);
	DelayCommand(2.0f, PlayCustomAnim(oSelf, "gen_cast", 0.5f));
	DelayCommand(4.0f, PlayCustomAnim(oSelf, "gen_cast", 0.5f));
}

//AttemptMeleeAttackMainHand, redone for monster hit
//returns 0 for miss, 1 for hit, 2 for critical
//No weapon required
int CheckMonsterHit(object oAttacker, object oTarget, int ThreatRange = 19) {
	
	int irange;
	int conceal = ConcealmentCheck(oTarget,irange); 
	int imiss;
	
	//Concealment check
	if(conceal > 0 && conceal > d100()) {
	
		imiss = 1;	
	
		if(GetHasFeat(408, oAttacker)) {
			if(conceal > d100()) imiss = 1;
			else imiss = 0;
		}
	
	}
	
	//Concealment miss!
	if(imiss == 1) {
		SendMessageToPC(oTarget, GetName(oAttacker)+" attacks you and misses! (concealment failure)");
		return 0;
	}
	
	//Etherealness miss!
	if(GetHasSpellEffect(443,oTarget) || GetHasSpellEffect(724,oTarget)) {
		SendMessageToPC(oTarget, GetName(oAttacker)+" attacks you and misses! (etherealness failure)");
		return 0;	
	}
				
	int roll = d20();
	int iRangerBonus;
			
	//AC Calculations
	int TargetAC = GetAC(oTarget); 
	if(FlatFooted(oAttacker, oTarget)) {
		TargetAC = TargetAC - GetDodgeAC(oTarget);
	}
	
	//AB Calculations
	int iAttackerAB = AttackerTotalAB(oAttacker); 
	int RangerFavored;
	
	if(GetLevelByClass(CLASS_TYPE_RANGER,oAttacker) > 0 && GetIsRangerFavored(oAttacker, oTarget) > 0) {
		iAttackerAB = iAttackerAB + CalculateRangerBonus(oAttacker);
	}
	
	int iAttack = roll + iAttackerAB;
	
	if(roll == 20 || iAttack >= TargetAC && roll > 1) {
	
		SendMessageToPC(oTarget, GetName(oAttacker)+" attacks you and hits! " + IntToString(iAttack)+" vs "+IntToString(TargetAC));
		
		if(roll >= ThreatRange)
		{
			int confirmationRoll = d20();
			int confirmationTotal = confirmationRoll + iAttackerAB;
	
			if (confirmationRoll == 20 || confirmationTotal >= TargetAC && confirmationRoll > 1) {
				return 2;
			}
		}
	
		return 1;	
	}
	
	SendMessageToPC(oTarget, GetName(oAttacker)+" attacks you and misses! "+IntToString(iAttack)+" vs "+IntToString(TargetAC));
	return 0;
}

void DoAcidGlobeEffect(object oSelf, object oTarget) {

	int nHit = CheckMonsterHit(oSelf, oTarget, 19);
	
	if (nHit == 0) {
		effect eVis = EffectVisualEffect(VFX_IMP_ACID_S, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		return;
	}

	int nDamage = d6(8);
	if (nHit == 2) {
		nDamage *= 2; //critical hit!
	}
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	eDam = EffectLinkEffects(EffectVisualEffect(VFX_IMP_ACID_L), eDam);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	
	eDam = EffectDamage(nDamage/2, DAMAGE_TYPE_ACID);
	eDam = EffectLinkEffects(EffectVisualEffect(VFX_IMP_ACID_S), eDam);
	DelayCommand(6.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	DelayCommand(6.0f, SendMessageToPC(oTarget, "Secondary acid damage applied."));
	DelayCommand(12.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	DelayCommand(12.0f, SendMessageToPC(oTarget, "Secondary acid damage applied."));

}

void SpawnAcidGlobe(object oSelf, object oTarget) {
	location lTarget = GetLocation(oTarget);
	location lSource = GetLocation(oSelf);
	int spellID = 873; //acid arrow
	float fTravelTime = GetProjectileTravelTime(lSource, lTarget, PROJECTILE_PATH_TYPE_DEFAULT);
	SpawnSpellProjectile(oSelf, oTarget, lSource, lTarget, spellID, PROJECTILE_PATH_TYPE_DEFAULT);
	DelayCommand(fTravelTime, DoAcidGlobeEffect(oSelf, oTarget));
}

void RangedAttack(object oSelf, object oTarget) {
	ClearAllActions();
	TurnToFaceObject(oTarget, oSelf);
	if (GetDistanceToObject(oTarget) < 3.0f) {
		MeleeAttack(oSelf, oTarget);
		return;
	}
	
	PlayCustomAnim(oSelf, "def_cast");
	DelayCommand(0.5f, SpawnAcidGlobe(oSelf, oTarget));
	
}

int GetNumberMeleeEngaged(object oSelf, object oTarget) {

	float fDis = 1.5f;
	
	int count = 0;
	object oFound = GetFirstObjectInShape(SHAPE_SPHERE, fDis, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oFound)) {
	
		if (!GetIsEnemy(oFound))
			count++;
			
		oFound = GetNextObjectInShape(SHAPE_SPHERE, fDis, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);
	}
	
	return count;

}

void BurrowTo(object oSelf, location lTarget) {

	effect vfx = EffectNWN2SpecialEffectFile("fx_global_earth_elemental_arise");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vfx, GetLocation(oSelf));
	PlayCustomAnim(oSelf, "proneb");
	DelayCommand(0.2f, SetScriptHidden(oSelf, TRUE, TRUE));
	DelayCommand(0.3f, AssignCommand(oSelf, ActionJumpToLocation(lTarget)));
	DelayCommand(0.3f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, vfx, lTarget));
	DelayCommand(0.37f, PlayCustomAnim(oSelf, "standupb"));
	DelayCommand(0.4f, SetScriptHidden(oSelf, FALSE, TRUE));
	
}

void SnakeCombatRound(object oSelf) {

	float meleeDis = 2.0f;
	float rangedDis = 20.0f;
	
	float fDamPercen = IntToFloat(GetCurrentHitPoints(oSelf))/IntToFloat(GetMaxHitPoints(oSelf));
	
	//teleports to our enemy!
	object oTarget = GetNearestSeenOrHeardEnemyNotDead(GetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING));
	if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget)) {
		PlayCustomAnimation(oSelf, "idle", TRUE, 1.0f);
		return;
	}
	
	if (fDamPercen < 0.25f) {
		if (GetDistanceToObject(oTarget) <= meleeDis) {
			location lLoc = GetRandomLocation(GetArea(oSelf), oTarget, rangedDis);
			BurrowTo(oSelf, lLoc);
			DelayCommand(0.5f, MeleeAttack(oSelf, oTarget));
		} else {
			RangedAttack(oSelf, oTarget);
		}
	} else {
		if (GetDistanceToObject(oTarget) > rangedDis) {
			location lLoc = GetRandomLocation(GetArea(oSelf), oTarget, rangedDis-5.0f);
			BurrowTo(oSelf, lLoc);
			DelayCommand(0.5f, MeleeAttack(oSelf, oTarget));
		} else if (GetDistanceToObject(oTarget) > meleeDis) {
			if (GetNumberMeleeEngaged(oSelf, oTarget) > 1 || d100() < 25)
				RangedAttack(oSelf, oTarget);
			else {
				BurrowTo(OBJECT_SELF, GetLocation(oTarget));
				DelayCommand(0.5f, MeleeAttack(oSelf, oTarget));
			}
		} else {
			MeleeAttack(oSelf, oTarget);
		}
	}
}

void main()
{

	if (HenchCheckHeartbeatCombat()) {
		SnakeCombatRound(OBJECT_SELF);
	}

    // If we have the 'constant' waypoints flag set, walk to the next
    // waypoint.
    else if (GetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION) ||
		!GetIsObjectValid(GetNearestSeenOrHeardEnemyNotDead(GetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING))))
    {
        if (GetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen))
        {
            // continue to move to target
	        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
	            HenchDetermineSpecialBehavior();
	        } else {
				SnakeCombatRound(OBJECT_SELF);
			}
        }
        else
        {
        	CleanCombatVars();
            SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);
            if (DoStealthAndWander())
            {
                // nothing to do here
            }
            // sometimes waypoints are not initialized
            else if (GetWalkCondition(NW_WALK_FLAG_CONSTANT))
            {
                WalkWayPoints();
            }
            else
            {
                if(!IsInConversation(OBJECT_SELF))
                {
                    if(GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS) ||
                        GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN))
                    {
                        PlayMobileAmbientAnimations();
                    }
                    else if(GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS))
                    {
                        PlayImmobileAmbientAnimations();
                    }
                }
            }
        }
    } else if (GetUseHeartbeatDetect())
    {
		if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
            HenchDetermineSpecialBehavior();
        } else {
			SnakeCombatRound(OBJECT_SELF);
		}
    } else {
		CleanCombatVars();
	}
	
    if (GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT)) {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}