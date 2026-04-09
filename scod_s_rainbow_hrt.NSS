//::///////////////////////////////////////////////
//:: Rainbow Dweomer Heartbeat - for Rainbow Dweomer Spell
//:: [scod_s_rainbow_hrt.nss]
//:://////////////////////////////////////////////
//:: Workhorse script of Rainbow Dweomer. Goes on summon.
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-10-2019
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

const float dweomer_closeness = 5.0f;

//The victims should move to stay in the radius
void MoveTargetToSpell(object oTarget, location lLocation) {
	location lLoc = CalcSafeLocation(oTarget, lLocation, dweomer_closeness, TRUE, TRUE);
	AssignCommand(oTarget, ActionMoveToLocation(lLoc, FALSE));
}

//Get the firework effect!
string GetRandomFireworkEffect() {
	int nRandom = d12();
	switch (nRandom) {
		case 1: return "ror_firework_blue";
		case 2: return "ror_firework_blueyellow";
		case 3: return "ror_firework_green";
		case 4: return "ror_firework_grnblue";
		case 5: return "ror_firework_grnyell";
		case 6: return "ror_firework_lavendar";
		case 7: return "ror_firework_red";
		case 8: return "ror_firework_yellow";
		default: return "ror_firework_rainbow";
	}
	
	return "ror_firework_rainbow";
}

//raises the firework location into the air slightly
location GetFireworkLocation(location lLoc) {
	object oArea = GetAreaFromLocation(lLoc);
	float fOrientation = GetFacingFromLocation(lLoc);
	vector pos = GetPositionFromLocation(lLoc);
	
	pos.x += Random(3);
	pos.y += Random(3);
	pos.z += d4();
	
	return Location(oArea, pos, fOrientation);
}

void main()
{

	//Remove me if there is no caster
	object oCaster = GetLocalObject(OBJECT_SELF, "Caster");
	if (!GetIsObjectValid(oCaster)) {
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
	//Remove me if the duration has run out
	int nDuration = GetLocalInt(OBJECT_SELF, "Duration");
	float fDur = RoundsToSeconds(nDuration);
	if (PS_GetTimestamp_Age_Seconds(OBJECT_SELF, "Rainbow_Timestamp") >= FloatToInt(fDur)) {
		RemoveHenchman(oCaster, OBJECT_SELF);
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
	//Set DC
	int nSaveDC = GetLocalInt(OBJECT_SELF, "SaveDC");
	
	//Target location
	location lTarget = GetLocation(OBJECT_SELF);
	
	//let's see a firework!
	string sEffect = GetRandomFireworkEffect();
	location lVis = GetFireworkLocation(lTarget);
	effect eVis = EffectNWN2SpecialEffectFile(sEffect);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lVis);

	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)) {
	
		if (oTarget == OBJECT_SELF || oTarget == oCaster) {
			//cannot fascinate self
		} else if (GetHasSpellEffect(SPELL_RAINBOW_DWEOMER, oTarget)) {
		
			if (GetDistanceBetween(OBJECT_SELF, oTarget) > dweomer_closeness)
				MoveTargetToSpell(oTarget, lTarget);
		
		} else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
		
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_RAINBOW_DWEOMER));
	
			//You need a mind to be effected
	        if (GetIsBlind(oTarget) == FALSE) {
			
	            if (!MyResistSpell(oCaster, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
				
	                if (!GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF )) {
						
						effect eFasc = EffectFascinate();
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFasc, oTarget, fDur);
						SetEffectSpellId(eFasc, SPELL_RAINBOW_DWEOMER);
						
						if (GetDistanceBetween(OBJECT_SELF, oTarget) > dweomer_closeness)
							MoveTargetToSpell(oTarget, lTarget);
					
						//Make sure being damaged breaks the spell
						SetLocalString(oTarget, "DamagedScript", "scod_s_creature_distracted");
					
	                }
	            }
	        }
	    }
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

	
    // BMA-OEI 7/04/06 - Check if in group and using group campaign flag
    // May not be needed if we change nwn2_scriptsets.2da PCDominate entry to use nw_g0_dominate
    if (GetGlobalInt(CAMPAIGN_SWITCH_FORCE_KILL_DOMINATED_GROUP) == TRUE )
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

	// do not interrupt player queued actions
    if (GetHasPlayerQueuedAction(OBJECT_SELF))
    {
        return;
    }

    if ((GetLocalObject(OBJECT_SELF,"NW_L_FORMERMASTER") != OBJECT_INVALID)
        && (GetLocalInt(OBJECT_SELF, "haveCheckedFM") != 1))
    {
        SetLocalInt(OBJECT_SELF, "haveCheckedFM", 1);
        SetAssociateState(NW_ASC_AGGRESSIVE_SEARCH, FALSE);
        SetLocalInt(OBJECT_SELF, sHenchStealthMode, 0);
        SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
        SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
    }

	HenchCheckOutOfCombatStealth(oRealMaster);

    CleanCombatVars();
    SetLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_POLL, FALSE);

    int bIsScouting = GetLocalInt(OBJECT_SELF, sHenchScoutingFlag);
    if (bIsScouting)
    {
        if (GetDistanceToObject(oRealMaster) < 6.0)
        {
			//	"Please get out of my way."
            SpeakStringByStrRef(230435);
        }
        object oScoutTarget = GetLocalObject(OBJECT_SELF, sHenchScoutTarget);
        if (GetDistanceBetween(oScoutTarget, oRealMaster) > henchMaxScoutDistance)
        {
            DeleteLocalInt(OBJECT_SELF, sHenchScoutingFlag);
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