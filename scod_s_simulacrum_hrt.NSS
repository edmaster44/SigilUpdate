//:://////////////////////////////////////////////
//:: Workhorse script for Glamers that active attract attention
//:: Goes on the summon
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-17-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_time"
#include "x2_inc_spellhook"
#include "x0_i0_position"
#include "hench_i0_act"
#include "hench_i0_ai"
#include "hench_i0_equip"
#include "hench_i0_initialize"
#include "hench_i0_assoc"
#include "x2_inc_summscale"
#include "x0_inc_henai"
#include "ginc_group"

void main () {

	//Remove me if there is no caster
	object oCaster = PS_GetLocalObject(OBJECT_SELF, "Caster");
	if (!GetIsObjectValid(oCaster)) {
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
	//Remove me if the duration has run out
	float fDur = PS_GetLocalFloat(OBJECT_SELF, "Duration");
	if (PS_GetTimestamp_Age_Seconds(OBJECT_SELF, "Simulacrum_Timestamp") >= FloatToInt(fDur)) {
		RemoveHenchman(oCaster, OBJECT_SELF);
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
	// BMA-OEI 7/04/06 - Check if in group and using group campaign flag
    // May not be needed if we change nwn2_scriptsets.2da PCDominate entry to use nw_g0_dominate
    if (PS_GetGlobalInt(CAMPAIGN_SWITCH_FORCE_KILL_DOMINATED_GROUP) == TRUE )
    {
        string sGroupName = GetGroupName( OBJECT_SELF );
        if ( sGroupName != "" )
        {
            if ( GetHasEffectType(OBJECT_SELF, EFFECT_TYPE_DOMINATED) == TRUE )
            {
                if ( GetIsGroupDominated(sGroupName) == TRUE )
                {
                    RemoveEffectsByType( OBJECT_SELF, EFFECT_TYPE_DOMINATED );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF );
                }
            }
        }
    }

    // GZ: Fallback for timing issue sometimes preventing epic summoned creatures from leveling up to their master's level.
    // There is a timing issue with the GetMaster() function not returning the fof a creature
    // immediately after spawn. Some code which might appear to make no sense has been added
    // to the nw_ch_ac1 and x2_inc_summon files to work around this
    // This code is only run at the first heartbeat
    int nLevel = SSMGetSummonFailedLevelUp(OBJECT_SELF);
    if (nLevel != 0)
    {
        int nRet;
        if (nLevel == -1) // special shadowlord treatment
        {
            SSMScaleEpicShadowLord(OBJECT_SELF);
        }
        else if  (nLevel == -2)
        {
            SSMScaleEpicFiendishServant(OBJECT_SELF);
        }
        else
        {
            nRet = SSMLevelUpCreature(OBJECT_SELF, nLevel, CLASS_TYPE_INVALID);
            if (nRet == FALSE)
            {
                WriteTimestampedLogEntry("WARNING - nw_ch_ac1:: could not level up " + GetTag(OBJECT_SELF) + "!");
            }
        }

        // regardless if the actual levelup worked, we give up here, because we do not
        // want to run through this script more than once.
        SSMSetSummonLevelUpOK(OBJECT_SELF);
    }

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck();

    // * if I am dominated, ask for some help
    // TK removed SendForHelp
//    if (GetHasEffect(EFFECT_TYPE_DOMINATED, OBJECT_SELF) == TRUE && GetIsEncounterCreature(OBJECT_SELF) == FALSE)
//    {
//        SendForHelp();
//    }

        // restore associate settings
    HenchGetDefSettings();

	// JWR-OEI Added per TTP bug 553
	if (GetScriptHidden(OBJECT_SELF))
	{
		// in case they are script hidden (like on overland map)
		// they'll stop buffing themselves.
		ClearAllActions();
		return;
	}
    if (GetAssociateState(NW_ASC_IS_BUSY))
    {
        return;
    }
    if (!GetIAmNotDoingAnything())
    {
        return;
    }
    object oRealMaster = GetCurrentMaster();
    if (!GetIsObjectValid(oRealMaster))
    {
        return;
    }

    if (!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && !GetAssociateState(NW_ASC_MODE_PUPPET))
    {
        if (HenchCheckHeartbeatCombat())
        {
            HenchResetCombatRound();
        }
        if (!GetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION) && HenchGetIsEnemyPerceived(GetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING)))
        {
            HenchDetermineCombatRound();
            return;
        }
        if (PS_GetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen))
        {
            HenchDetermineCombatRound();
            return;
        }
    }
    HenchResetCombatRound();

	// do not interrupt player queued actions
    if (GetHasPlayerQueuedAction(OBJECT_SELF))
    {
        return;
    }

    if ((PS_GetLocalObject(OBJECT_SELF,"NW_L_FORMERMASTER") != OBJECT_INVALID)
        && (PS_GetLocalInt(OBJECT_SELF, "haveCheckedFM") != 1))
    {
        PS_SetLocalInt(OBJECT_SELF, "haveCheckedFM", 1);
        SetAssociateState(NW_ASC_AGGRESSIVE_SEARCH, FALSE);
        PS_SetLocalInt(OBJECT_SELF, sHenchStealthMode, 0);
        SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
        SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
    }

	HenchCheckOutOfCombatStealth(oRealMaster);

    CleanCombatVars();
    PS_SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);

    if (PS_GetLocalInt(OBJECT_SELF, henchHealCountStr))
    {
//        Jug_Debug(GetName(OBJECT_SELF) + " HB checking heal count " + IntToString(PS_GetLocalInt(OBJECT_SELF, henchHealCountStr)));
        ActionDoCommand(ActionWait(2.5));
        ActionDoCommand(ExecuteScript("hench_o0_heal", OBJECT_SELF));
        return;
    }

        //25% chance that..
    if ((d4() == 1) &&
        !GetAssociateState(NW_ASC_MODE_PUPPET) &&
        (PS_GetLocalInt(OBJECT_SELF, sHenchStopCasting) != 10) &&
        !PS_GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag) &&
        // if we're not excluding the ability to use feats and abilities
        !PS_GetLocalIntState(OBJECT_SELF, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ABILITY))
    {
        //and if we have the summon familiar feat
        if (GetHenchPartyState(HENCH_PARTY_SUMMON_FAMILIARS) && (GetHasFeat(FEAT_SUMMON_FAMILIAR, OBJECT_SELF) || GetHasSpell(SPELLABILITY_SUMMON_FAMILIAR, OBJECT_SELF)))
        {
            object oAssociate = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
            // with no current familiar stat
            if (!GetIsObjectValid(oAssociate))
            {
                // summon my familiar and decrement use
                SummonFamiliar();
                DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_FAMILIAR);
            }
        }
        // or if we have the animal companion feat
        else if (GetHenchPartyState(HENCH_PARTY_SUMMON_COMPANIONS) && (GetHasFeat(FEAT_ANIMAL_COMPANION, OBJECT_SELF) || GetHasSpell(SPELLABILITY_SUMMON_ANIMAL_COMPANION, OBJECT_SELF)))
        {
            object oAssociate = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);
            // and no current companion
            if (!GetIsObjectValid(oAssociate))
            {
                //summon companion and decrement us
                SummonAnimalCompanion();
                DecrementRemainingFeatUses(OBJECT_SELF, FEAT_ANIMAL_COMPANION);
            }
        }
    }
    // TODO add auto cure????   if (NonCombatCureEffects())

    if (!GetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF) &&
        !GetAssociateState(NW_ASC_MODE_PUPPET) &&
        (PS_GetLocalInt(OBJECT_SELF, sHenchStopCasting) != 10) &&
        !PS_GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag) &&
        (GetDistanceToObject(oRealMaster) <= 10.0) &&
		!GetIsOverlandMap(GetArea(OBJECT_SELF)))
    {
        if (GetLevelByClass(CLASS_TYPE_WARLOCK))
        {
            if (!(PS_GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE) & TALENT_EXCLUDE_SPELL))
            {
                if (TryCastWarlockBuffSpells(FALSE))
                {
                    return;
                }
            }
            else
            {
                gbFoundInfiniteBuffSpell = TRUE;
            }
        }
        if (GetLevelByClass(CLASS_TYPE_BARD) &&
            !(GetCreatureNegEffects(OBJECT_SELF) & HENCH_EFFECT_TYPE_SILENCE))
        {
            if (!(PS_GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE) & TALENT_EXCLUDE_ABILITY))
            {
                if (TryCastBardBuffSpells())
                {
                    return;
                }
            }
            else
            {
                gbFoundInfiniteBuffSpell = TRUE;
            }
        }

        if (!gbFoundInfiniteBuffSpell)
        {
            // didn't find anything, don't keep looking
            SetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF, TRUE, OBJECT_SELF);
        }
    }

    if (HenchCheckArea())
    {
        return;
    }

    ClearWeaponStates();

    if (PS_GetLocalInt(OBJECT_SELF, HENCH_AI_COMBAT_EQUIP))
    {
        PS_DeleteLocalInt(OBJECT_SELF, HENCH_AI_COMBAT_EQUIP);
        if (!GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH) && !GetAssociateState(NW_ASC_MODE_PUPPET))
        {
            ClearAllActions();
            if (GetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS))
            {
                UnequipWeapons();
            }
            else
            {
				HenchEquipDefaultWeapons();
            }
            return;
        }
    }

    int bIsScouting = PS_GetLocalInt(OBJECT_SELF, sHenchScoutingFlag);
    if (bIsScouting)
    {
        if (GetDistanceToObject(oRealMaster) < 6.0)
        {
			//	"Please get out of my way."
            SpeakStringByStrRef(230435);
        }
        object oScoutTarget = PS_GetLocalObject(OBJECT_SELF, sHenchScoutTarget);
        if (GetDistanceBetween(oScoutTarget, oRealMaster) > henchMaxScoutDistance)
        {
            PS_DeleteLocalInt(OBJECT_SELF, sHenchScoutingFlag);
            bIsScouting = FALSE;
        }
        else
        {
            if (CheckStealth() && !GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
            ActionMoveToObject(oScoutTarget, FALSE, 1.0);
        }
    }

    if(!bIsScouting && !GetAssociateState(NW_ASC_MODE_STAND_GROUND) &&
		(!GetAssociateState(NW_ASC_MODE_PUPPET) || GetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW)) &&
        (GetNumActions(OBJECT_SELF) == 0) && !GetIsFighting(OBJECT_SELF) &&
        (GetDistanceToObject(HenchGetFollowLeader()) > GetFollowDistance()))
    {
        ClearAllActions();
        HenchFollowLeader();
    }

    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}