#include "ff_safevar"

//::///////////////////////////////////////////////
//:: On Blocked
//:: gb_assoc_block
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This will cause blocked creatures to open
    or smash down doors depending on int and
    str.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////

#include "hench_i0_generic"
#include "hench_i0_assoc"
#include "hench_i0_ai"


void main()
{
    object oDoor = GetBlockingDoor();

//    Jug_Debug("******" + GetName(OBJECT_SELF) + " is blocked by " + GetName(oDoor));

    object oRealMaster = GetCurrentMaster();

    if (GetObjectType(oDoor) == OBJECT_TYPE_DOOR && GetIsObjectValid(oRealMaster)
        && !PS_GetLocalInt(OBJECT_SELF, sHenchScoutingFlag) && !IsOnOppositeSideOfDoor(oDoor, oRealMaster, OBJECT_SELF))
    {
        ClearAllActions();
        ClearForceOptions();
        if (GetIsObjectValid(PS_GetLocalObject(OBJECT_SELF, sHenchLastTarget)) || PS_GetLocalInt(OBJECT_SELF, sHenchLastHeardOrSeen))
        {
            PS_DeleteLocalObject(OBJECT_SELF, sHenchLastTarget);
            ClearEnemyLocation();
            if (!PS_GetLocalInt(oDoor, "tkDoorWarning"))
            {
 				if (((GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_HENCHMAN) || (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_NONE)))
				{
					//	"Something is on the other side of this door."
                	SpeakStringByStrRef(230438);
				}
                PS_SetLocalInt(oDoor, "tkDoorWarning", TRUE);
            }
        }
		HenchFollowLeader();
        return;
    }

    if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) && GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) >= 3)
    {
        DoDoorAction(oDoor, DOOR_ACTION_OPEN);
    }
    else if (GetIsDoorActionPossible(oDoor, DOOR_ACTION_UNLOCK))
    {
        DoDoorAction(oDoor, DOOR_ACTION_UNLOCK);
    }
    else if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) >= 16)
    {
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
    }
}