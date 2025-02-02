#include "ff_safevar"

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

#include "nw_i0_generic"
#include "cw_inc_intellect"

int CW_Helpless(object o)
{
 effect e=GetFirstEffect(o);
 
 while(GetIsEffectValid(e))
  {
   if(GetEffectType(e)==EFFECT_TYPE_STUNNED || 
      GetEffectType(e)==EFFECT_TYPE_PARALYZE || 
	  GetEffectType(e)==EFFECT_TYPE_SLEEP)
	   return TRUE;
	   
   e=GetNextEffect(o);
  }

 return FALSE;
}

//Look for corpses
void CW_IntellectCorpse()
{
 object o=GetFirstObjectInShape(SHAPE_SPHERE, 25.0f, GetLocation(OBJECT_SELF), TRUE);
 
 while(GetIsObjectValid(o))
  {
   if(GetIsDead(o) &&//Has to be dead
      PS_GetLocalInt(o, "CW_INTCORPSE")==1 &&
	  PS_GetLocalInt(o, "CW_NODEVOUR")!=1)
    {
	 AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
	 AssignCommand(OBJECT_SELF, ActionMoveToLocation(GetLocation(o), TRUE));
	 PS_SetLocalString(OBJECT_SELF, "X2_SPECIAL_COMBAT_AI_SCRIPT", "cw_intellectai");
	 PS_SetLocalObject(OBJECT_SELF, "CW_CORPSE", o);
	 return;
	}
   else if(CW_Helpless(o) &&//Has to be incapacitated
	  PS_GetLocalInt(o, "CW_NODEVOUR")!=1 &&
	  !GetFactionEqual(o, OBJECT_SELF))
    {
	 AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
	 AssignCommand(OBJECT_SELF, ActionMoveToLocation(GetLocation(o), TRUE));
	 PS_SetLocalString(OBJECT_SELF, "X2_SPECIAL_COMBAT_AI_SCRIPT", "cw_intellectai");
	 PS_SetLocalObject(OBJECT_SELF, "CW_CORPSE", o);
	 return;
	}
   else//Now, if the enemy is part of our faction and not a devourer, mark them as being possible to raise
    {
	 if(GetFactionEqual(o, OBJECT_SELF) &&
	    GetAppearanceType(o)!=GetAppearanceType(OBJECT_SELF) &&
		PS_GetLocalInt(o, "CW_NODEVOUR")!=1 &&
		PS_GetLocalString(o, "DeathScript")!="cw_spawnintellect")
		 {
		  PS_SetLocalInt(o, "CW_INTCORPSE", 1);
		  ExecuteScript("cw_intellectrespawn", o);
		 }
	}
	
   o=GetNextObjectInShape(SHAPE_SPHERE, 25.0f, GetLocation(OBJECT_SELF), TRUE);
  }
}

void CW_FindCorpse()
{
 object o=PS_GetLocalObject(OBJECT_SELF, "CW_CORPSE");

 AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
 AssignCommand(OBJECT_SELF, ActionMoveToLocation(GetLocation(o)));
 
 if(GetDistanceBetween(OBJECT_SELF, o)<=3.5f)
  {
   if(GetIsPC(GetFactionLeader(o)))
    CW_SpawnIntellect(OBJECT_SELF, o, TRUE);
   else
    CW_SpawnIntellect(OBJECT_SELF, o, FALSE);
  }
}

void main()
{
//  Jug_Debug(GetName(OBJECT_SELF) + " faction leader " + GetName(GetFactionLeader(OBJECT_SELF)));
    // * if not running normal or better AI then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
	
	
	if(PS_GetLocalInt(OBJECT_SELF, "CW_HBONCE")!=1)
	 {
	  PS_SetLocalInt(OBJECT_SELF, "CW_HBONCE", 1);
	  SetCustomHeartbeat(OBJECT_SELF, 3000);
	 }	

//    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION,  PERCEPTION_HEARD)))
//    {
//      Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()));
//    }

	if(!GetIsObjectValid(PS_GetLocalObject(OBJECT_SELF, "CW_CORPSE")) || //We don't have a corpse
	   PS_GetLocalInt(PS_GetLocalObject(OBJECT_SELF, "CW_CORPSE"), "CW_NODEVOUR")==1)//Or the corpse has been devoured
	 {
	  PS_DeleteLocalString(OBJECT_SELF, "X2_SPECIAL_COMBAT_AI_SCRIPT");
	  PS_DeleteLocalObject(OBJECT_SELF, "CW_CORPSE");
	 }
	else//We do!
	 {
	  CW_FindCorpse();
	  return;
	 }

    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
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
    if(GetHasEffect(EFFECT_TYPE_SLEEP))
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
    else if (!GetIsObjectValid(GetNearestSeenOrHeardEnemyNotDead(HENCH_MONSTER_DONT_CHECK_HEARD_MONSTER)))
    {
        CleanCombatVars();
        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
        {
            HenchDetermineSpecialBehavior();
        }
        else if (PS_GetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen))
        {
            // continue to move to target
            MoveToLastSeenOrHeard();
        }
        else
        {
            PS_SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);
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
//        Jug_Debug(GetName(OBJECT_SELF) + " starting combat round in heartbeat");
//      Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()));
        HenchDetermineCombatRound();
    }
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
	
 CW_IntellectCorpse();
}
