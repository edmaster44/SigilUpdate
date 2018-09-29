#include "hench_i0_ai"

int HasInstrumentEquipped() {
	object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
	if (GetIsObjectValid(oItem))
	{
		if (GetBaseItemType(oItem) == BASE_ITEM_DRUM ||
			GetBaseItemType(oItem) == BASE_ITEM_FLUTE ||
			GetBaseItemType(oItem) == BASE_ITEM_MANDOLIN)
			return TRUE;
		else
			return FALSE;
	}
	else
		return FALSE;
}

void SetCorrectMusicalAnimation(object oItem) {

	if (GetBaseItemType(oItem) == BASE_ITEM_DRUM)
		SetLocalString(OBJECT_SELF, "ANIMATION", "idledrum");
	else if (GetBaseItemType(oItem) == BASE_ITEM_MANDOLIN)
		SetLocalString(OBJECT_SELF, "ANIMATION", "idleguitar");
	else if (GetBaseItemType(oItem) == BASE_ITEM_FLUTE)
	{
		if (GetTag(oItem) == "ps_music_bagpipe" ||
			GetTag(oItem) == "ps_it_bagpipe")
			SetLocalString(OBJECT_SELF, "ANIMATION", "bagpipe");
		else
			SetLocalString(OBJECT_SELF, "ANIMATION", "idleflute");
	}
}

void EquipInstrument() {
	
	object oItem = GetFirstItemInInventory(OBJECT_SELF);
	while (GetIsObjectValid(oItem))
	{
		if (GetBaseItemType(oItem) == BASE_ITEM_DRUM ||
			GetBaseItemType(oItem) == BASE_ITEM_FLUTE ||
			GetBaseItemType(oItem) == BASE_ITEM_MANDOLIN)
		{
			ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND);
			SetCorrectMusicalAnimation(oItem);
			return;
		}
	}	

}

void main()
{
	object playerTag = GetLocalObject(OBJECT_SELF, "FOLLOW_MASTER");
	if (GetIsObjectValid(playerTag))
	{
		if (GetArea(playerTag) != GetArea(OBJECT_SELF))
		{
			ClearAllActions();
			AssignCommand(OBJECT_SELF, ActionJumpToObject(playerTag));
		}
		else
			ActionForceFollowObject(playerTag);
		return;
	}	
	
	int wanderBool = GetLocalInt(OBJECT_SELF, "WANDER");
	if (wanderBool == 1)
	{
		AssignCommand(OBJECT_SELF, ActionRandomWalk());
		return;
	}
	
	int playMusic = GetLocalInt(OBJECT_SELF, "PLAY_INSTRUMENT");
	if (playMusic == 1)
	{
		if (HasInstrumentEquipped())
		{
			PlayCustomAnimation(OBJECT_SELF,  GetLocalString(OBJECT_SELF, "ANIMATION"), TRUE);
			return;
		}
		else
			EquipInstrument();
	}

	string anim = GetLocalString(OBJECT_SELF, "ANIMATION");
	if (anim != "")
	{
		if (GetNumActions(OBJECT_SELF) <= 0)
			PlayCustomAnimation(OBJECT_SELF, anim, TRUE);
		return;
	}

//  Jug_Debug(GetName(OBJECT_SELF) + " faction leader " + GetName(GetFactionLeader(OBJECT_SELF)));
    // * if not running normal or better AI then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

//    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION,  PERCEPTION_HEARD)))
//    {
//      Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()));
//    }

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