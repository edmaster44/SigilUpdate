#include "ff_safevar"

/*

    Companion and Monster AI

    This file contains some modifications of and additions to
    the default associate functions / behaviors.

*/

#include "x0_i0_assoc"
#include "hench_i0_act"
#include "ginc_companion"

// void main() {    }


// TODO move to flags?
//const string sHenchDisableAutoHide = "HenchDisableAutoHide";

// TODO move to flags ???
//const string sHenchDontCastMelee = "DoNotCastMelee";

//const string sHenchFamiliarChallenge = "NewFamiliarChallenge";
//const string sHenchFamiliarToDeath = "FamiliarToTheDeath";

//const string sHenchAniCompChallenge = "NewAniCompChallenge";
//const string sHenchAniCompToDeath = "AniCompToTheDeath";

// these constants are used for remembering associate settings between summons
const string sHenchFamiliarPreStr = "Fam";
const string sHenchAniCompPreStr = "Ani";
const string sHenchSummonPreStr = "Sum";
const string sHenchDominatePreStr = "Dom";
const string sHenchDefSettingsSet = "HENCH_DEF_SETTINGS_SET";

const string sHenchLastPlayerAttackTarget   = "HenchLastPlayerAttackTarget";


// constants for healing and buffing
const int HENCH_CNTX_MENU_OFF           = 0;
const int HENCH_CNTX_MENU_HEAL          = 1;
const int HENCH_CNTX_MENU_BUFF_LONG     = 2;
const int HENCH_CNTX_MENU_BUFF_MEDIUM   = 3;
const int HENCH_CNTX_MENU_BUFF_SHORT    = 4;
// constants so player controlled character gets flags set too
const int HENCH_CNTX_MENU_PC_ATTACK_NEAREST     = 100;
const int HENCH_CNTX_MENU_PC_FOLLOW_MASTER      = 101;
const int HENCH_CNTX_MENU_PC_GUARD_MASTER       = 102;
const int HENCH_CNTX_MENU_PC_STAND_GROUND       = 103;
// constants for scouting
const int HENCH_CNTX_MENU_SCOUT                 = 104;
// constants for follow
const int HENCH_CNTX_MENU_FOLLOW_TARGET         = 105;
const int HENCH_CNTX_MENU_FOLLOW_ME             = 106;
const int HENCH_CNTX_MENU_FOLLOW_NO_ONE         = 107;
const int HENCH_CNTX_MENU_FOLLOW_RESET          = 108;
const int HENCH_CNTX_MENU_FOLLOW_RESET_ALL      = 109;
const int HENCH_CNTX_MENU_FOLLOW_SINGLE         = 114;
const int HENCH_CNTX_MENU_FOLLOW_DOUBLE         = 115;
const int HENCH_CNTX_MENU_FOLLOW_NO_ONE_ALL     = 116;
// constants for guarding
const int HENCH_CNTX_MENU_GUARD_TARGET          = 110;
const int HENCH_CNTX_MENU_GUARD_ME              = 111;
const int HENCH_CNTX_MENU_GUARD_RESET           = 112;
const int HENCH_CNTX_MENU_GUARD_RESET_ALL       = 113;
// constants for weapon equipping
const int HENCH_CNTX_MENU_SET_WEAPON            = 200;
const int HENCH_CNTX_MENU_RESET_WEAPON          = 201;
// constants for global actions
const int HENCH_SAVE_GLOBAL_SETTINGS			= 300;
const int HENCH_LOAD_GLOBAL_SETTINGS			= 301;
const int HENCH_RESET_GLOBAL_SETTINGS			= 302;

const string henchHealCountStr = "HenchCurHealCount";
const string henchHealTypeStr = "HenchHealType";
const string henchHealStateStr = "HenchHealState";
const string henchHealSpellTarget =  "Henchman_Spell_Target";

// maximum scout distance
const float henchMaxScoutDistance = 35.0;

// gets the prepending string for an associate setting
string HenchGetAssocString(int iAssocType);

// sets the default settings for an associate on summons
// setting is copied to be on master too
void HenchSetDefSettings(object oCreature = OBJECT_SELF);

// gets the default settings for an associate
// (copy from master if needed)
void HenchGetDefSettings(object oCreature = OBJECT_SELF);

// Modified form of ResetHenchmenState
// sets the henchmen to commandable, deletes locals
// having to do with doors and clears actions
// Modified by Tony K to clear more things
void HenchResetHenchmenState();

// set additional behaviors supported by this AI (HENCH_ASC_*)
void SetHenchAssociateState(int nCondition, int bValid, object oCreature);

// set party behaviors supported by this AI (HENCH_PARTY_*)
void SetHenchPartyState(int nCondition, int bValid, object oCreature);

// clear out persisted information (tag and object)
void HenchClearPersistedObject(object oTarget, string storageString);

// get persisted object from target, restore object from tag if needed
// object returned must be faction, otherwise null returned
object HenchGetPersistedObject(object oTarget, string storageString);

// set persisted object for target
void HenchSetPersistedObject(object oTarget, object oObject, string storageString);

// get the creature you follow, OBJECT_INVALID if none
object HenchGetFollowLeader();

// follow your leader, or stand still if none
void HenchFollowLeader();

// set your leader to follow
void HenchSetLeader(object oTarget, object oLeader);

// set no leader to follow, stand ground
void HenchSetNoLeader(object oTarget);

// reset leader back to current master (creature PC is controlling)
void HenchSetDefaultLeader(object oTarget);

// get creature you are defending, return OBJECT_INVALID if none
object HenchGetDefendee();

// set creature you are defending
void HenchSetDefendee(object oTarget, object oDefendee);

// reset creature you are defending to current master (creature PC is controlling)
void HenchSetDefaultDefendee(object oTarget);

// turn on or off out of combat stealth
void HenchCheckOutOfCombatStealth(object oRealMaster);

// User defined event handler for possessing a party member
// Forces unpossessed, non-associates to follow the new leader
// Modified to adjust follow leader setting
void HenchPlayerControlPossessed(object oCreature);

// User defined event handler for EVENT_PLAYER_CONTROL_CHANGED (2052)
// Modified to adjust follow leader setting
void HenchHandlePlayerControlChanged(object oCreature);

// set up the GUI with all the info for the selectable states
// oPlayerObject - the player object who's looking at the GUI
// oTargetObject - the object who's information is being displayed in the GUI
// sScreen - The GUI screen being looked at.
void HenchGuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen, int bFirstTime = FALSE);

// checks if party member sees or hears nearby enemies
int HenchCheckPartyMemberInCombat(object oPartyMember);

// check if a puppet mode pause should be done when action queue is empty
int HenchCheckPlayerPause();


string HenchGetAssocString(int iAssocType)
{
    if (iAssocType == ASSOCIATE_TYPE_FAMILIAR)
    {
        return sHenchFamiliarPreStr;
    }
    else if (iAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION)
    {
        return sHenchAniCompPreStr;
    }
    else if (iAssocType == ASSOCIATE_TYPE_SUMMONED)
    {
        return sHenchSummonPreStr;
    }
    else if (iAssocType == ASSOCIATE_TYPE_DOMINATED)
    {
        return sHenchDominatePreStr;
    }
    return "null";
}


void HenchSetDefSettings(object oCreature = OBJECT_SELF)
{
    int iAssocType = GetAssociateType(oCreature);
    if ((iAssocType == ASSOCIATE_TYPE_NONE) ||
        (iAssocType == ASSOCIATE_TYPE_HENCHMAN))
    {
        return;
    }

    string preDefStr = HenchGetAssocString(iAssocType);
    object oPC = GetMaster(oCreature);
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    PS_SetLocalInt(oPC, preDefStr + sAssociateMasterConditionVarname, PS_GetLocalInt(oCreature, sAssociateMasterConditionVarname));
    PS_SetLocalInt(oPC, preDefStr + sHenchStealthMode, PS_GetLocalInt(oCreature, sHenchStealthMode));
    PS_SetLocalInt(oPC, preDefStr + sHenchStopCasting, PS_GetLocalInt(oCreature, sHenchStopCasting));
    PS_SetLocalInt(oPC, preDefStr + sHenchDontDispel, PS_GetLocalInt(oCreature, sHenchDontDispel));
    PS_SetLocalInt(oPC, preDefStr + henchAssociateSettings, PS_GetLocalInt(oCreature, henchAssociateSettings));
}


void HenchGetDefSettings(object oCreature = OBJECT_SELF)
{
    if (PS_GetLocalInt(oCreature, sHenchDefSettingsSet))
    {
        return;
    }

    PS_SetLocalInt(oCreature, sHenchDefSettingsSet, TRUE);

    int iAssocType = GetAssociateType(oCreature);
    if ((iAssocType == ASSOCIATE_TYPE_NONE) ||
        (iAssocType == ASSOCIATE_TYPE_HENCHMAN))
    {
        return;
    }

    string preDefStr = HenchGetAssocString(iAssocType);
    object oPC = GetMaster(oCreature);
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    object oTarget;
    object oSource;
    string preSrcStr;
        // check if the PC has never had settings copied
        // for associate type
    if (!PS_GetLocalInt(oPC, preDefStr + sHenchDefSettingsSet))
    {
        PS_SetLocalInt(oPC, preDefStr + sHenchDefSettingsSet, TRUE);
        oTarget = oPC;
        oSource = oCreature;
        preSrcStr = preDefStr;
        preDefStr = "";
    }
    else
    {
        oTarget = oCreature;
        oSource = oPC;
        preSrcStr = "";
    }

    PS_SetLocalInt(oTarget, preSrcStr + sAssociateMasterConditionVarname,
        PS_GetLocalInt(oSource, preDefStr + sAssociateMasterConditionVarname));
    PS_SetLocalInt(oTarget, preSrcStr + sHenchStealthMode,
        PS_GetLocalInt(oSource, preDefStr + sHenchStealthMode));
    PS_SetLocalInt(oTarget, preSrcStr + sHenchStopCasting,
        PS_GetLocalInt(oSource, preDefStr + sHenchStopCasting));
    PS_SetLocalInt(oTarget, preSrcStr + sHenchDontDispel,
        PS_GetLocalInt(oSource, preDefStr + sHenchDontDispel));
    PS_SetLocalInt(oTarget, preSrcStr + henchAssociateSettings,
        PS_GetLocalInt(oSource, preDefStr + henchAssociateSettings));
}

/*
void HenchSetAssociateFlee(float fChallenge, int bFightToDeath)
{
    object oPC = GetPCSpeaker();
    int iAssocType = GetAssociateType(OBJECT_SELF);
    // Set the variables
    if (iAssocType == ASSOCIATE_TYPE_FAMILIAR)
    {
        PS_SetLocalFloat(oPC, sHenchFamiliarChallenge, fChallenge);
        PS_SetLocalInt(oPC, sHenchFamiliarToDeath, bFightToDeath);
    }
    else if (iAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION)
    {
        PS_SetLocalFloat(oPC, sHenchAniCompChallenge, fChallenge);
        PS_SetLocalInt(oPC, sHenchAniCompToDeath, bFightToDeath);
    }
}*/


void HenchResetHenchmenState()
{
    SetCommandable(TRUE);
    PS_DeleteLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");
    PS_DeleteLocalInt(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH_HP");
    PS_DeleteLocalInt(OBJECT_SELF, henchHealCountStr);
    PS_DeleteLocalInt(OBJECT_SELF, henchHealTypeStr);
    PS_DeleteLocalInt(OBJECT_SELF, henchHealStateStr);
    PS_DeleteLocalObject(OBJECT_SELF, henchHealSpellTarget);
    SetAssociateState(NW_ASC_IS_BUSY, FALSE);
    ClearForceOptions();
    ClearAllActions();
}


void SetHenchAssociateState(int nCondition, int bValid, object oCreature)
{
    int nPlot = PS_GetLocalInt(oCreature, henchAssociateSettings);
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    PS_SetLocalInt(oCreature, henchAssociateSettings, nPlot);
}


void SetHenchPartyState(int nCondition, int bValid, object oCreature)
{
    object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oCreature));
    int nPlot = PS_GetLocalInt(oPlayerCharacter, henchPartySettings);
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    PS_SetLocalInt(oPlayerCharacter, henchPartySettings, nPlot);
}


void HenchClearPersistedObject(object oTarget, string storageString)
{
    PS_DeleteLocalObject(oTarget, storageString);
    PS_DeleteLocalString(oTarget, storageString);
    PS_DeleteLocalInt(oTarget, storageString);
}


object HenchGetPersistedObject(object oTarget, string storageString)
{
    object oObject = PS_GetLocalObject(oTarget, storageString);

    if (!GetIsObjectValid(oObject))
    {
        string tagToFollow = PS_GetLocalString(oTarget, storageString);
        if (tagToFollow != "")
        {
            oObject = GetObjectByTag(tagToFollow);
            if (GetIsObjectValid(oObject) && GetFactionEqual(oObject, oTarget))
            {
                PS_SetLocalObject(oTarget, storageString, oObject);
            }
            else
            {
                PS_DeleteLocalString(oTarget, storageString);
            }
//          Jug_Debug(GetName(oTarget) + " try to get persisted object from in " + GetName(oObject) + " in module " + GetName(GetModule()));
        }
    }
    if (GetIsObjectValid(oObject))
    {
        if (!GetFactionEqual(oObject, oTarget))
        {
            oObject = OBJECT_INVALID;
            HenchClearPersistedObject(oTarget, storageString);
        }
        else
        {
            int assocType = PS_GetLocalInt(oTarget, storageString);
            if (assocType != GetAssociateType(oObject))
            {
                object oAssociate = GetAssociate(assocType, oObject);
                if (GetIsObjectValid(oAssociate))
                {
                    oObject = oAssociate;
                    PS_SetLocalObject(oTarget, storageString, oObject);
                }
            }
        }
    }
    return oObject;
}


void HenchSetPersistedObject(object oTarget, object oObject, string storageString)
{
    int assocType = GetAssociateType(oObject);
    if (assocType != ASSOCIATE_TYPE_NONE)
    {
        oObject = GetMaster(oObject);
    }
    PS_SetLocalObject(oTarget, storageString, oObject);
    PS_SetLocalString(oTarget, storageString, GetTag(oObject));
    PS_SetLocalInt(oTarget, storageString, assocType);

    // prevent circular leaders
    object oNextObject = oObject;
    while (GetIsObjectValid(oNextObject))
    {
        if (oNextObject == oTarget)
        {
            HenchClearPersistedObject(oNextObject, storageString);
            break;
        }
        oNextObject = HenchGetPersistedObject(oNextObject, storageString);
    }
}


const string sHenchFollowTarget = "HenchFollowTarget";

object HenchGetFollowLeader()
{
    if (PS_GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag))
    {
        return GetCurrentMaster();
    }
    else
    {
        object oLeader = HenchGetPersistedObject(OBJECT_SELF, sHenchFollowTarget);
        if (GetIsObjectValid(oLeader))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " following " + GetName(oLeader) + " in module " + GetName(GetModule()));
            return oLeader;
        }
        else if (!PS_GetLocalInt(OBJECT_SELF, sHenchFollowTarget))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " following current master in module " + GetName(GetModule()));
            return GetCurrentMaster();
        }
        else
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " not following in module " + GetName(GetModule()));
            return OBJECT_INVALID;
        }
    }
}


void HenchFollowLeader()
{
	if (GetAssociateState(NW_ASC_MODE_PUPPET) && !GetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW))
	{
		return;
	}
    object oLeader =  HenchGetFollowLeader();
    if (GetCurrentAction() == ACTION_FOLLOW)
    {
        ClearAllActions();
    }	
    if (!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && GetIsObjectValid(oLeader))
    {
        ActionForceFollowObject(oLeader, GetFollowDistance());
    }
}


void HenchSetLeader(object oTarget, object oLeader)
{
    HenchSetPersistedObject(oTarget, oLeader, sHenchFollowTarget);
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            HenchFollowLeader();
        }
        else
        {
            AssignCommand(oTarget, HenchFollowLeader());
        }
    }
}


void HenchSetNoLeader(object oTarget)
{
    HenchClearPersistedObject(oTarget, sHenchFollowTarget);
    PS_SetLocalInt(oTarget, sHenchFollowTarget, TRUE);
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            ClearAllActions();
        }
        else
        {
            AssignCommand(oTarget, ClearAllActions());
        }
    }
}


void HenchSetDefaultLeader(object oTarget)
{
    HenchClearPersistedObject(oTarget, sHenchFollowTarget);
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            HenchFollowLeader();
        }
        else
        {
            AssignCommand(oTarget, HenchFollowLeader());
        }
    }
}


const string sHenchDefendTarget = "HenchDefendTarget";

object HenchGetDefendee()
{
    object oDefendee = HenchGetPersistedObject(OBJECT_SELF, sHenchDefendTarget);
    if (GetIsObjectValid(oDefendee))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " defending " + GetName(oDefendee) + " in module " + GetName(GetModule()));
        return oDefendee;
    }
//  Jug_Debug(GetName(OBJECT_SELF) + " defending current master in module " + GetName(GetModule()));
    return GetCurrentMaster();
}


void HenchSetDefendee(object oTarget, object oDefendee)
{
    HenchSetPersistedObject(oTarget, oDefendee, sHenchDefendTarget);
}


void HenchSetDefaultDefendee(object oTarget)
{
    HenchClearPersistedObject(oTarget, sHenchDefendTarget);
}


void HenchCheckOutOfCombatStealth(object oRealMaster)
{
    if (!(PS_GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag) &&
		!GetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE)))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " checking stealth");
        // Check to see if should re-enter stealth mode
        int nStealth = PS_GetLocalInt(GetTopMaster(), sHenchStealthMode);
        if ((nStealth == 1) || (nStealth == 2))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " going back to stealth");
            if (!GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
        }
        else
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " going out of stealth");
            if (GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE) ||
				!GetActionMode(oRealMaster, ACTION_MODE_STEALTH))
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " turning off stealth");
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
            }
        }
    }
}


void HenchPlayerControlPossessed(object oCreature)
{
//  Jug_Debug( "ginc_companion: " + GetName( oCreature ) + " has been possessed (EVENT_PLAYER_CONTROL_CHANGED)." );
    object oLeader = GetFactionLeader( oCreature );
    if ( oLeader == oCreature )
    {
        //Jug_Debug( "ginc_companion: " + GetName( oCreature ) + " is the new party leader!" );
        object oPM = GetFirstFactionMember( oCreature, FALSE );
        while ( GetIsObjectValid( oPM ) == TRUE )
        {
            // If I'm currently following somebody
            if ( GetCurrentAction( oPM ) == ACTION_FOLLOW )
            {
                //Jug_Debug(GetName(oPM) + " going to follow ");
                // But I'm not possessed, not myself, and not an associate
                if ( ( GetIsPC( oPM ) == FALSE ) &&
                     ( oPM != oLeader ) &&
                     ( GetAssociateType( oPM ) == ASSOCIATE_TYPE_NONE ) &&
 					 (!GetAssociateState(NW_ASC_MODE_PUPPET, oPM) || GetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW)))
               {
                    AssignCommand( oPM, ClearAllActions() );
                    AssignCommand( oPM, HenchFollowLeader());
                }
            }

            oPM = GetNextFactionMember( oCreature, FALSE );
        }
    }
}


void HenchHandlePlayerControlChanged(object oCreature)
{
    if (GetIsPC(oCreature))
    {
        HenchPlayerControlPossessed(oCreature);
    }
    else
    {
		if (GetCurrentAction(oCreature) == ACTION_ATTACKOBJECT)
		{
			PS_SetLocalObject(oCreature, sHenchLastPlayerAttackTarget, GetAttemptedAttackTarget());
//			Jug_Debug(GetName(oCreature) + " setting attack target to " + GetName(GetAttemptedAttackTarget()));		
		}
		else
		{
			PS_DeleteLocalObject(oCreature, sHenchLastPlayerAttackTarget);
//			Jug_Debug(GetName(oCreature) + " clearing attack target");		
		}	
        PlayerControlUnpossessed(oCreature);
    }
}


void HenchGuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen, int bFirstTime)
{
    HenchGetDefSettings(oTargetObject);
    HenchSetDefSettings(oTargetObject);

    int iState;

    // associate settings

        // weapon switching
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_WEAPON_SWITCH_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_WEAPON_SWITCH_STATE_BUTTON_OFF", iState);

        // use ranged weapons
    iState = GetAssociateState(NW_ASC_USE_RANGED_WEAPON, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RANGED_WEAPONS_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RANGED_WEAPONS_STATE_BUTTON_OFF", !iState);

        // switch to melee distance
    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_NEAR", iState);
    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_MED, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_MED", iState);
    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_FAR", iState);

            // back away
    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_BACK_AWAY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_BACK_AWAY_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_BACK_AWAY_STATE_BUTTON_OFF", !iState);

        // summons
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_SUMMONS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SUMMONS_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SUMMONS_STATE_BUTTON_OFF", iState);

        // dual wielding
    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_ON", iState);
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_OFF", iState);
    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, oTargetObject) || GetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_DEFAULT", !iState);

    // heavy off hand
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_HEAVY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HEAVY_OFF_HAND_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HEAVY_OFF_HAND_STATE_BUTTON_OFF", iState);

    // shield use
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_SHIELD_USE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SHIELD_USE_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SHIELD_USE_STATE_BUTTON_OFF", iState);

    // recover traps
    iState = GetHenchAssociateState(HENCH_ASC_RECOVER_TRAPS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_STATE_BUTTON_ON", iState && GetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, oTargetObject));
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_SAFE_STATE_BUTTON_ON", iState && !GetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, oTargetObject));
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_STATE_BUTTON_OFF", !iState);

    // auto open locks
    iState = GetHenchAssociateState(HENCH_ASC_AUTO_OPEN_LOCKS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_OPEN_LOCKS_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_OPEN_LOCKS_STATE_BUTTON_OFF", !iState);

    // auto pickup
	iState = GetHenchAssociateState(HENCH_ASC_AUTO_PICKUP, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_PICKUP_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_PICKUP_STATE_BUTTON_OFF", !iState);

    // polymorph
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_POLYMORPH_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_POLYMORPH_STATE_BUTTON_OFF", iState);

    // infinite buff
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_INFINITE_BUFF_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_INFINITE_BUFF_STATE_BUTTON_OFF", iState);

    // enable cure and healing item use
    iState = GetHenchAssociateState(HENCH_ASC_ENABLE_HEALING_ITEM_USE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_HEAL_ITEM_USE_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_HEAL_ITEM_USE_STATE_BUTTON_OFF", !iState);

    // disable automatic hiding
    iState = GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HIDING_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HIDING_STATE_BUTTON_OFF", iState);

        // guard distance
    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_NEAR", iState);
    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_MED", iState);
    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_FAR", iState);
    iState = GetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR | HENCH_ASC_GUARD_DISTANCE_MED | HENCH_ASC_GUARD_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_DEFAULT", !iState);

    string userText = GetStringByStrRef(232555); 	// Following
    object oLeader = HenchGetPersistedObject(oTargetObject, sHenchFollowTarget);
    if (GetIsObjectValid(oLeader))
    {
        userText += GetName(oLeader);
    }
    else if (!PS_GetLocalInt(oTargetObject, sHenchFollowTarget))
    {
        if (!GetAssociateType(oTargetObject))
        {
            userText += GetStringByStrRef(232556);	// PC
        }
        else
        {
            userText += GetStringByStrRef(232557);	// Master (default)
        }
    }
    else
    {
        userText += GetStringByStrRef(232558);	// no one
    }
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_FOLLOW_TARGET_BUTTON_TEXT", -1, userText);

    userText = GetStringByStrRef(232559);
    object oDefender = HenchGetPersistedObject(oTargetObject, sHenchDefendTarget);
    if (GetIsObjectValid(oDefender))
    {
        userText += GetName(oDefender);
    }
    else
    {
        if (!GetAssociateType(oTargetObject))
        {
            userText += GetStringByStrRef(232556);	// PC
        }
        else
        {
            userText += GetStringByStrRef(232557);	// Master (default)
        }
    }
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DEFEND_TARGET_BUTTON_TEXT", -1, userText);

    // disable melee attacks
    iState = GetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_MELEE_ATTACK_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_MELEE_ATTACK_STATE_BUTTON_OFF", !iState);

    // use melee weapons if any members of party are in melee range of target
    iState = GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_ANY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_MELEE_ANY_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_MELEE_ANY_STATE_BUTTON_OFF", !iState);

    // pause every round if in puppet mode and pause and switch is turned on
	if (bFirstTime)
	{
	    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_EVERY_ROUND_COL_HEADER", -1, sHenchPauseEveryRound);
	}
    iState = GetHenchAssociateState(HENCH_ASC_PAUSE_EVERY_ROUND, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_EVERY_ROUND_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_EVERY_ROUND_STATE_BUTTON_OFF", !iState);

    if (sScreen == "SCREEN_CHARACTER")
    {
        // party options

        // unequip weapons outside of combat
        iState = GetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_UNEQUIP_WEAPONS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_UNEQUIP_WEAPONS_STATE_BUTTON_OFF", !iState);

        // summon familiars outside of combat
        iState = GetHenchPartyState(HENCH_PARTY_SUMMON_FAMILIARS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_FAMILIARS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_FAMILIARS_STATE_BUTTON_OFF", !iState);

        // summon animal companions outside of combat
        iState = GetHenchPartyState(HENCH_PARTY_SUMMON_COMPANIONS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_COMPANIONS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_COMPANIONS_STATE_BUTTON_OFF", !iState);
		
        // ally damage
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_LOW", GetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, oTargetObject) || 
			!(GetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, oTargetObject) || GetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, oTargetObject)));
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_MED", GetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, oTargetObject));
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_HIGH", GetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, oTargetObject));		

        // disable peaceful follow mode
        iState = GetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PEACEFUL_FOLLOW_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PEACEFUL_FOLLOW_STATE_BUTTON_OFF", iState);

        // disable self buff or heal
        iState = GetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SELF_BUFF_OR_HEAL_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SELF_BUFF_OR_HEAL_STATE_BUTTON_OFF", iState);

        // disable showing weapon switching messages
		if (bFirstTime)
		{
	        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_WEAP_SWITCH_MESS_COL_HEADER", -1, sHenchWeapSwitchMess);
		}
        iState = GetHenchPartyState(HENCH_PARTY_DISABLE_WEAPON_EQUIP_MSG, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_WEAP_SWITCH_MESS_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_WEAP_SWITCH_MESS_STATE_BUTTON_OFF", iState);

        // disable showing weapon switching messages
		if (bFirstTime)
		{
	        SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_FOLLOW_COL_HEADER", -1, sHenchPuppetFollow);
		}
        iState = GetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_FOLLOW_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_FOLLOW_STATE_BUTTON_OFF", !iState);
								
        // global options

        // monster stealth
        iState = GetHenchOption(HENCH_OPTION_STEALTH);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_STEALTH_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_STEALTH_STATE_BUTTON_OFF", !iState);

        // monster wander
        iState = GetHenchOption(HENCH_OPTION_WANDER);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_WANDER_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_WANDER_STATE_BUTTON_OFF", !iState);

        // monster open doors
        iState = GetHenchOption(HENCH_OPTION_OPEN);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_OPEN_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_OPEN_STATE_BUTTON_OFF", !iState);

        // monster unlock doors
        iState = GetHenchOption(HENCH_OPTION_UNLOCK);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_UNLOCK_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_UNLOCK_STATE_BUTTON_OFF", !iState);

        // knockdown
        iState = GetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED);
        if (iState)
        {
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_ON", FALSE);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_SOMETIMES", FALSE);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_OFF", TRUE);
        }
        else
        {
            iState = GetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_ON", !iState);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_SOMETIMES", iState);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_OFF", FALSE);
        }

        // auto behavior set
        iState = GetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BEHAVIOR_SET_STATE_BUTTON_OFF", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BEHAVIOR_SET_STATE_BUTTON_ON", !iState);

        // non members of PC party automatically use long duration buffs at start of combat
        iState = GetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_LONG_STATE_BUTTON_ON", iState && !GetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_MED_STATE_BUTTON_ON", iState && GetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_STATE_BUTTON_OFF", !iState);

        // non members of PC party get healing potions, etc. at start of combat
        iState = GetHenchOption(HENCH_OPTION_ENABLE_ITEM_CREATION);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_CREATE_ITEMS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_CREATE_ITEMS_STATE_BUTTON_OFF", !iState);

        // non members of PC party are able to use equipped items (run at start of combat)
        iState = GetHenchOption(HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_USE_EQUIPPED_ITEMS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_USE_EQUIPPED_ITEMS_STATE_BUTTON_OFF", !iState);

        // Warlock hideous blow single round
        iState = GetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HIDEOUS_BLOW_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HIDEOUS_BLOW_STATE_BUTTON_OFF", !iState);
		
        // Monster ally damage (area of effect spells)
        iState = GetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_ALLY_DAMAGE_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_ALLY_DAMAGE_STATE_BUTTON_OFF", !iState);
	
        // heartbeat detection of enemies
		if (bFirstTime)
		{
        	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_COL_HEADER", -1, sHenchHBDetect);
        	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_SEEN_TEXT_BUTTON_ON", -1, sHenchHBSeenOnly);
		}
        iState = GetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_STATE_BUTTON_ON", !iState && !GetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_SEEN_STATE_BUTTON_ON", !iState && GetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_STATE_BUTTON_OFF", iState);

        // puppet mode pause and switch
		if (bFirstTime)
		{
        	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_AND_SWITCH_COL_HEADER", -1, sHenchPauseAndSwitch);
		}
        iState = GetHenchOption(HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_AND_SWITCH_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_AND_SWITCH_STATE_BUTTON_OFF", !iState);
	}
}


int HenchCheckPartyMemberInCombat(object oPartyMember)
{
    object oClosestSeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                    oPartyMember, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
                    CREATURE_TYPE_IS_ALIVE, TRUE);
    if (GetIsObjectValid(oClosestSeen) && (GetDistanceBetween(oPartyMember, oClosestSeen) < 20.0))
    {
//		Jug_Debug(GetName(oPartyMember) + " seen enemy " + GetName(oClosestSeen));
        return TRUE;
    }
    object oClosestHeard = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                    oPartyMember, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
                    CREATURE_TYPE_IS_ALIVE, TRUE);
   	return GetIsObjectValid(oClosestHeard) && (GetDistanceBetween(oPartyMember, oClosestHeard) < 20.0) &&
		LineOfSightObject(oPartyMember, oClosestHeard);
}


int HenchCheckPlayerPause()
{
	if (!GetHenchOption(HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH))
	{
		return FALSE;
	}
	int bEnemyFound;
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " test enemies for " + GetName(oPartyMember));
		if (HenchCheckPartyMemberInCombat(oPartyMember))
		{
			bEnemyFound = TRUE;
			break;
		}
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
	if (!bEnemyFound)
	{
		return FALSE;
	}
		
//	Jug_Debug(GetName(OBJECT_SELF) + " last attack target was " + GetName(PS_GetLocalObject(OBJECT_SELF, sHenchLastPlayerAttackTarget)) + " current is " + GetName(GetAttemptedAttackTarget()));
	
	if (GetHenchAssociateState(HENCH_ASC_PAUSE_EVERY_ROUND) ||
		(GetCurrentAction() != ACTION_ATTACKOBJECT) ||
		(PS_GetLocalObject(OBJECT_SELF, sHenchLastPlayerAttackTarget) != GetAttemptedAttackTarget()))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " pausing game in combat, controlling " + GetName(GetFactionLeader(OBJECT_SELF)));
		SetPause(TRUE);		
		// this call crashes the toolset when compiling
//		if (!GetIsCompanionPossessionBlocked(OBJECT_SELF))
		{
			SetOwnersControlledCompanion(GetFactionLeader(OBJECT_SELF), OBJECT_SELF);		
		}
		return TRUE;			
	}	
	return FALSE;			
}