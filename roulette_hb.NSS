#include "ff_safevar"

//Roulette modified by Stephen Spann  (sspann@worldnet.att.net)
//originally from Charles Adam's 'Casino Bertix' module
//now includes the 00 slot, Five-Number bets, Corner Bets, and Split Bets.
//and uses SetListenPattern() cues instead of a conversation.
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
#include "NW_I0_GENERIC"
#include "roulette_end_rnd"
#include "roulette_include"

void main()
{
    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
    {
        if(TalentAdvancedBuff(40.0))
        {
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);
            return;
        }
    }

    if(GetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING))
    {
        int nDay = FALSE;
        if(GetIsDay() || GetIsDawn())
        {
            nDay = TRUE;
        }
        if(PS_GetLocalInt(OBJECT_SELF, "NW_GENERIC_DAY_NIGHT") != nDay)
        {
            if(nDay == TRUE)
            {
                PS_SetLocalInt(OBJECT_SELF, "NW_GENERIC_DAY_NIGHT", TRUE);
            }
            else
            {
                PS_SetLocalInt(OBJECT_SELF, "NW_GENERIC_DAY_NIGHT", FALSE);
            }
            WalkWayPoints();
        }
    }

    if(!GetHasEffect(EFFECT_TYPE_SLEEP))
    {
        //if(!GetIsPostOrWalking())
       // {
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                if(!GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)))
                {
                    if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL) && !IsInConversation(OBJECT_SELF))
                    {
                        if(GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS) || GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN))
                        {
                            PlayMobileAmbientAnimations();
                        }
                        else if(GetIsEncounterCreature() &&
                        !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)))
                        {
                            PlayMobileAmbientAnimations();
                        }
                        else if(GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS) &&
                           !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)))
                        {
                            PlayImmobileAmbientAnimations();
                        }
                    }
                    else
                    {
                        DetermineSpecialBehavior();
                    }
                }
                else
                {
                    //DetermineCombatRound();
                }
            }
        //}
    }
    else
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
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1001));
    }
int TIMER=1;
if(TIMER)
    {
        if(PS_GetLocalInt(OBJECT_SELF,"ROULETTE") < (TIMER * nBetweenSpins))
            {
                PS_SetLocalInt(OBJECT_SELF,"ROULETTE",
                    PS_GetLocalInt(OBJECT_SELF,"ROULETTE")+1);
                return;
            }
        PS_DeleteLocalInt(OBJECT_SELF,"ROULETTE");
        PS_SetLocalInt(OBJECT_SELF,"DEALING",1);
        SpeakString ("All bets off!  Spinning the wheel!");
        ActionMoveToObject(GetObjectByTag("roulettewheel"));
        ActionInteractObject(GetObjectByTag("roulettewheel"));
        //CreateObject(OBJECT_TYPE_PLACEABLE,"solred",GetLocation(GetObjectByTag("roulettewheel")));
        //CreateObject(OBJECT_TYPE_PLACEABLE,"solwhite",GetLocation(GetObjectByTag("roulettewheel")));
        //DestroyObject(GetObjectByTag("RouletteLight1"),fSpin);
        //DestroyObject(GetObjectByTag("RouletteLight2"),fSpin);
        //ActionDoCommand(ActionWait(fSpin));
        object oPC=GetFirstPC();
        int nRandom = Random(38);
        EndRouletteRound(OBJECT_SELF,nRandom);
        while(GetIsObjectValid(oPC))
            {
                if (PS_GetLocalInt(oPC,"iBet")!=0)
                    {
                    if (GetHouse() > 0)
						EndRouletteRound(oPC,nRandom);
                    PS_SetLocalInt(oPC,"iBet",0);
                    }
                oPC=GetNextPC();
            }
		if (GetHouse() > 0) {
       		ActionDoCommand(DelayCommand(fSpin,SpeakString("Opening bets up for the next round!")));
        	PS_SetLocalInt(OBJECT_SELF,"DEALING",0);
		}
    }
}