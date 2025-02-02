#include "ff_safevar"

//::///////////////////////////////////////////////
//:: SetListeningPatterns
//:: NW_C2_DEFAULT4
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    by the generic script after dialogue or a
    shout is initiated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////

#include "hench_i0_monsho"
#include "ginc_behavior"

void main()
{
    // * if petrified, jump out
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF) == TRUE)
    {
        return;
    }

    // * If dead, exit directly.
    if (GetIsDead(OBJECT_SELF))
    {
        return;
    }

    // notify walkwaypoints that we've been stopped and need to restart.
    PS_SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, 100);
	
	//Gets any conversation set as variable previously
	string sConversation = PS_GetLocalString(OBJECT_SELF, "DEFAULT_CONVERSATION");

    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    object oIntruder;
    int iFocused = GetIsFocused();

    if (nMatch == -1 && GetCommandable(OBJECT_SELF))
    {
		  // For private conversation flagged creatures, if the conversation is
		  // begin started anew, flag the initiator as restarting the
		  // conversation and command them to begin it again, but in private
		  // mode.
		  //
        if (GetIsPC(oShouter) && PS_GetLocalInt(OBJECT_SELF, "PS_CONV_PRIVATE") != FALSE)
		  {
				ActionStartConversation(oShouter, sConversation, TRUE);
				return;
		  }

        if (GetCommandable(OBJECT_SELF))
        {
            ClearAllActions();
			// hack to detect SoZ
			if (GetStringLength(PS_GetGlobalString("co_beluethHangOut")) > 1)
			{
            	BeginConversation(sConversation, OBJECT_INVALID, TRUE);
			}
			else
			{
            	BeginConversation(sConversation);
			}
        }
        else
        // * July 31 2004
        // * If only charmed then allow conversation
        // * so you can have a better chance of convincing
        // * people of lowering prices
        if (GetHasEffect(EFFECT_TYPE_CHARMED) == TRUE)
        {
            ClearActions(CLEAR_NW_C2_DEFAULT4_29);
			// hack to detect SoZ
			if (GetStringLength(PS_GetGlobalString("co_beluethHangOut")) > 1)
			{
            	BeginConversation(sConversation, OBJECT_INVALID, TRUE);
			}
			else
			{
            	BeginConversation(sConversation);
			}
        }

    }
    else if(nMatch != -1 && GetIsObjectValid(oShouter) && !GetIsPC(oShouter) &&
		GetIsFriend(oShouter) && (iFocused <= FOCUSED_STANDARD) &&
		GetIsValidRetaliationTarget(oIntruder))
    {
        if(nMatch == 4)
        {
            oIntruder = PS_GetLocalObject(oShouter, "NW_BLOCKER_INTRUDER");
        }
        else if (nMatch == 5 || nMatch == 1)
        {
            oIntruder = PS_GetLocalObject(oShouter, sHenchLastTarget);
            if(!GetIsObjectValid(oIntruder))
            {
                oIntruder = GetLastHostileActor(oShouter);
                if(!GetIsObjectValid(oIntruder))
                {
                    oIntruder = GetAttemptedAttackTarget();
                    if(!GetIsObjectValid(oIntruder))
                    {
                        oIntruder = GetAttemptedSpellTarget();
                        if(!GetIsObjectValid(oIntruder))
                        {
                            oIntruder = OBJECT_INVALID;
                        }
                    }
                }
            }
        }
//		Jug_Debug(GetName(OBJECT_SELF) + " respond to shout " + GetName(oShouter) + " match " + IntToString(nMatch) + " intruder " + GetName(oIntruder));
		if (GetObjectSeen(oShouter) || LineOfSightObject(oShouter, OBJECT_SELF) || !HenchEnemyOnOtherSideOfDoor(oShouter))
		{
//			Jug_Debug(GetName(OBJECT_SELF) + " really respond to shout");
        	HenchMonRespondToShout(oShouter, nMatch, oIntruder);
		}
    }

    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}