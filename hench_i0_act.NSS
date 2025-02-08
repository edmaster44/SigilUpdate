#include "ff_safevar"

/*

    Companion and Monster AI

    This file contains functions used in the default On* scripts
    for henchman actions during noncombat. This includes dealing
    with traps, locks, items, and containers

*/

#include "hench_i0_generic"

//void main() {  }

// Removes master force trap and locks
void ClearForceOptions();

// force associate to open given lock
void OpenLock(object oLock);

// force associate to disarm given trap
void ForceTrap(object oTrap);

// true if free to work with trap, locks, items
int GetIAmNotDoingAnything();

// checks if associate should do any actions with
// traps, locks, or items
int HenchCheckArea(int nClearActions = FALSE);


// strings for actions
const string sLockMasterFailed = "tk_master_lock_failed";
const string sForceTrap = "tk_force_trap";
const string sItemDropped = "tk_item_dropped";



void ClearForceOptions()
{
    PS_DeleteLocalObject(OBJECT_SELF, sLockMasterFailed);
    PS_DeleteLocalInt(OBJECT_SELF, sForceTrap);
}


void OpenLock(object oLock)
{
    if (GetIsObjectValid(oLock))
    {
        PS_SetLocalObject(OBJECT_SELF, sLockMasterFailed, oLock);
        ExecuteScript("hench_o0_act", OBJECT_SELF);
    }
}


void ForceTrap(object oTrap)
{
    if (GetIsObjectValid(oTrap))
    {
        PS_SetLocalObject(OBJECT_SELF, sLockMasterFailed, oTrap);
        PS_SetLocalInt(OBJECT_SELF, sForceTrap, TRUE);
        ExecuteScript("hench_o0_act", OBJECT_SELF);
    }
}


int GetIAmNotDoingAnything()
{
    int currentAction = GetCurrentAction(OBJECT_SELF);

    return !IsInConversation(OBJECT_SELF)
        && !GetIsObjectValid(GetAttemptedAttackTarget())
        && !GetIsObjectValid(GetAttemptedSpellTarget())
        && currentAction != ACTION_REST
        && currentAction != ACTION_DISABLETRAP
        && currentAction != ACTION_OPENLOCK
        && currentAction != ACTION_USEOBJECT
        && currentAction != ACTION_RECOVERTRAP
        && currentAction != ACTION_EXAMINETRAP
        && currentAction != ACTION_PICKUPITEM
        && currentAction != ACTION_HEAL
        && currentAction != ACTION_TAUNT;
}


int HenchCheckArea(int nClearActions = FALSE)
{
    //    only execute if we have something to do
    if (!GetAssociateState(NW_ASC_MODE_STAND_GROUND) &&
		(!GetAssociateState(NW_ASC_MODE_PUPPET) || GetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW)) &&
		!PS_GetLocalInt(OBJECT_SELF, sHenchDontAttackFlag) &&
        GetIAmNotDoingAnything() &&
        ((GetHasSkill(SKILL_DISABLE_TRAP) && GetAssociateState(NW_ASC_DISARM_TRAPS)) ||				
		GetHenchAssociateState(HENCH_ASC_AUTO_OPEN_LOCKS | HENCH_ASC_AUTO_PICKUP) ||		
        GetIsObjectValid(PS_GetLocalObject(OBJECT_SELF, sLockMasterFailed))))
    {
        if (!PS_GetLocalInt(OBJECT_SELF, "tk_doing_action"))
        {
            ExecuteScript("hench_o0_act", OBJECT_SELF);
            return PS_GetLocalInt(OBJECT_SELF, "tk_action_result");
        }
        else
        {
            ActionDoCommand(ExecuteScript("hench_o0_act", OBJECT_SELF));
            return TRUE;
        }
    }
    else
    {
        ClearForceOptions();
    }
    return FALSE;
}