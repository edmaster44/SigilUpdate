

//::///////////////////////////////////////////////
//:: Default On Heartbeat
//:: NW_C2_DEFAULT1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script will have people perform default
    animations.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
#include "hench_i0_ai"


void main()
{
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

	//Check if we've been commanded to follow someone (i.e. fake summon)
	//If so, then make sure we stay in the same area
	//Should allow enough freedom that they can go fight; unlike with mimi_npc_heartbeat setup
	object playerTag = GetLocalObject(OBJECT_SELF, "FOLLOW_MASTER");
	if (GetIsObjectValid(playerTag))
	{
		if (GetArea(playerTag) != GetArea(OBJECT_SELF)) {
			ClearAllActions();
			AssignCommand(OBJECT_SELF, ActionJumpToObject(playerTag));
		} else if (GetDistanceToObject(playerTag) > 15.0f) {
			ClearAllActions();
			ActionForceFollowObject(playerTag);
		}
		return;
	} else if (GetLocalInt(OBJECT_SELF, "IS_SUMMONED") > 0) {
		DestroyObject(OBJECT_SELF, 0.2f);
	}
	
	//Script hook
	string sHBScript = GetLocalString(OBJECT_SELF, "HeartbeatScript");
	if (sHBScript != "")
		ExecuteScript(sHBScript, OBJECT_SELF);

    if (GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
    {
        if(HenchTalentAdvancedBuff(40.0))
        {
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);
            // TODO evaluate continue with combat
            return;
        }
    }

	if (HenchCheckHeartbeatCombat())
	{
	    HenchResetCombatRound();
	}
    if (GetHasEffect(EFFECT_TYPE_SLEEP))
    {
        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
            if(d10() > 6)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            }
        }
    }

    // If we have the 'constant' waypoints flag set, walk to the next
    // waypoint.
    else if (GetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION) ||
		!GetIsObjectValid(GetNearestSeenOrHeardEnemyNotDead(GetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING))))
    {
        if (GetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen))
        {
            // continue to move to target
	        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
	        {
	            HenchDetermineSpecialBehavior();
	        }
			else
			{
	        	HenchDetermineCombatRound();
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
    }
    else if (GetUseHeartbeatDetect())
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " starting combat round in heartbeat");
//		Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()));
        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
        {
            HenchDetermineSpecialBehavior();
        }
		else
		{
        	HenchDetermineCombatRound();
		}
    }
	else
	{
		CleanCombatVars();
	}
    if (GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}