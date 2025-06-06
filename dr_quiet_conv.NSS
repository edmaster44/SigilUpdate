

//:://////////////////////////////////////////////////
//:: dr_quiet_conv
/*
  Starts up only private / quiet conversations
 */
//:://////////////////////////////////////////////////


#include "nw_i0_generic"
#include "ginc_behavior"

void main()
{

    // * if petrified, jump out
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF) == TRUE)
    {
        return;
    }

    // * If dead, exit directly.
    if (GetIsDead(OBJECT_SELF) == TRUE)
    {
        return;
    }

    // notify walkwaypoints that we've been stopped and need to restart.
    SetLocalInt(OBJECT_SELF, VAR_KICKSTART_REPEAT_COUNT, 100);
	
	//Gets any conversation set as variable previously
	string sConversation = GetLocalString(OBJECT_SELF, "DEFAULT_CONVERSATION");

    // See if what we just 'heard' matches any of our
    // predefined patterns
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    int iFocused = GetIsFocused();

    if (nMatch == -1)
    {
        // Not a match -- start an ordinary conversation
        if (GetCommandable(OBJECT_SELF))
        {
            ClearActions(CLEAR_NW_C2_DEFAULT4_29);
            ActionStartConversation(GetLastSpeaker(), sConversation, TRUE, TRUE, FALSE, FALSE);
        }
        else
        // * July 31 2004
        // * If only charmed then allow conversation
        // * so you can have a better chance of convincing
        // * people of lowering prices
        if (GetHasEffect(EFFECT_TYPE_CHARMED) == TRUE)
        {
            ClearActions(CLEAR_NW_C2_DEFAULT4_29);
			ActionStartConversation(GetLastSpeaker(), sConversation, TRUE, TRUE, FALSE, FALSE);
        }
    }   
    // Respond to shouts from friendly non-PCs only
    else if (GetIsObjectValid(oShouter)
               && !GetIsPC(oShouter)
               && GetIsFriend(oShouter)
               && (iFocused <= FOCUSED_STANDARD) )
    {
        object oIntruder = OBJECT_INVALID;
        // Determine the intruder if any
        if(nMatch == 4)
        {
            oIntruder = GetLocalObject(oShouter, "NW_BLOCKER_INTRUDER");
        }
        else if (nMatch == 5)
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

        // Actually respond to the shout
        if (iFocused <= FOCUSED_STANDARD)
			if (GetIsValidRetaliationTarget(oIntruder))	//DBR 5/30/06 - this if line put in for quest giving/plot NPC's
            	RespondToShout(oShouter, nMatch, oIntruder);
    }

    // Send the user-defined event if appropriate
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}