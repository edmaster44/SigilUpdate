#include "ff_safevar"

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "x0_i0_position"
//#include "ginc_item"
#include "x2_inc_itemprop"

//using same consts as in ps_inc_faction so using remote functions for weapons works same as badge.

const string FACTION_NPC_LEFT_HAND = "LeftHandWep";
const string FACTION_NPC_RIGHT_HAND = "RightHandWep";
const string NPC_REMOTE_FEEDBACK_PREFIX = "<COLOR=lawngreen><b>NPC REMOTE:</b> ";

void NPCRemoteDestroyWeapon(object oHench, object oPC)
{
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	if (oWeapon == OBJECT_INVALID)
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "No valid weapon found to destroy on target");
	else
	{
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + GetName(oHench) + " is destroying " + GetName(oWeapon));
		PS_SetLocalObject(oHench, FACTION_NPC_RIGHT_HAND, OBJECT_INVALID);
		DestroyObject(oWeapon, 0.1);
	}
}

// should only bed used with a delay command, or at least that is the intention
void NPCRemoteCheckRightHandWithDelay(object oHench, object oPC, int iRanged, object oOriginal, object oNew)
{
	
	string sMeleeOrRanged;
	
	if (iRanged == TRUE)
		sMeleeOrRanged = "ranged";
	else
		sMeleeOrRanged = "melee";
	
	if (oNew == oOriginal)
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "No " + sMeleeOrRanged +" weapon found to change");
	else
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + GetName(oHench) + "has removed " + GetName(oOriginal) + " and equipped " + GetName(oNew));
	
}

void NPCRemoteEquipAnyMelee(object oHench, object oPC)
{
	object oItem = GetFirstItemInInventory(oHench);
	object oCurrentRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	object oNewRightHand;

	while(GetIsObjectValid(oItem))
    {
       	if (IPGetIsMeleeWeapon(oItem))
	    {
           	AssignCommand(oHench, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
       	}
       	oItem = GetNextItemInInventory(oHench);
    }
	
	oNewRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	
	DelayCommand(0.5, NPCRemoteCheckRightHandWithDelay(oHench, oPC, FALSE, oCurrentRightHand, oNewRightHand));
}

void NPCRemoteEquipAnyRanged(object oHench, object oPC)
{
	object oItem = GetFirstItemInInventory(oHench);
	object oCurrentRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	object oNewRightHand;

	while(GetIsObjectValid(oItem))
    {
       	if (IPGetIsRangedWeapon(oItem))
	    {
           	AssignCommand(oHench, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
       	}
       	oItem = GetNextItemInInventory(oHench);
    }
	
	oNewRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	
	DelayCommand(0.5, NPCRemoteCheckRightHandWithDelay(oHench, oPC, TRUE, oCurrentRightHand, oNewRightHand));
}

void NPCRemoteEquipAnyRangedDelay(object oHench, object oPC)
{
	if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench) == OBJECT_INVALID)
		NPCRemoteEquipAnyMelee(oHench, oPC);
}

void NPCRemoteEquipWeapons(object oHench, object oPC)
{
	object oItemRight = PS_GetLocalObject(oHench, FACTION_NPC_RIGHT_HAND);
	object oItemLeft = PS_GetLocalObject(oHench, FACTION_NPC_LEFT_HAND);
	
	if (oItemRight != OBJECT_INVALID)
	{
		SendMessageToPC(oPC, "DEBUG: Thinks got a valid weapon to equip: " + GetName(oItemRight));
		
		DelayCommand(0.3, AssignCommand(oHench, ActionEquipItem(oItemRight, INVENTORY_SLOT_RIGHTHAND)));
		//ExecuteScript("hench_o0_equip", oHench);
		
		if (oItemLeft != OBJECT_INVALID)
		{
			SendMessageToPC(oPC, "DEBUG: Trying to equip: " + GetName(oItemLeft));
			DelayCommand(0.6, AssignCommand(oHench, ActionEquipItem(oItemLeft, INVENTORY_SLOT_LEFTHAND)));	
		}
	}
	else
	{
		// we will try and equip shield first so if one hander is equipped after, there will be a shield as well.
		// otherwise a two hander will cause a switch.
		SendMessageToPC(oPC, "DEBUG: No tagged weapon found so trying any weapons");
		object oItem = GetFirstItemInInventory(oHench);
		int bShieldFound = FALSE;
		int iItemType;
		
    	while(GetIsObjectValid(oItem) & bShieldFound == FALSE)
    	{
			iItemType = GetBaseItemType(oItem);
        	if (iItemType == BASE_ITEM_LARGESHIELD | iItemType == BASE_ITEM_TOWERSHIELD | iItemType == BASE_ITEM_SMALLSHIELD)
	        {
            	AssignCommand(oHench, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));
				bShieldFound = TRUE;
        	}
        	oItem = GetNextItemInInventory(oHench);
    	}
	
		//try melee
		NPCRemoteEquipAnyMelee(oHench, oPC);
		
		// wait a bit, then check to see if something equipped, and if not, try ranged
		DelayCommand(0.5, NPCRemoteEquipAnyRangedDelay(oHench, oPC));
	}
}

void NPCRemoteUnequipWeapons(object oHench, object oPC)
{
	object oItemLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oHench);
	if (GetIsObjectValid(oItemLeft) == TRUE)
		{
			SetIdentified(oItemLeft, TRUE);
			PS_SetLocalObject(oHench, FACTION_NPC_LEFT_HAND, oItemLeft);
			AssignCommand(oHench, ActionUnequipItem(oItemLeft));
		}
	
	object oItemRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oHench);
	if (GetIsObjectValid(oItemRight) == TRUE)
		{
			SetIdentified(oItemRight, TRUE);
			PS_SetLocalObject(oHench, FACTION_NPC_RIGHT_HAND, oItemRight);
			AssignCommand(oHench, ActionUnequipItem(oItemRight));
		}

}

void NPCToolPlayAnim(object oSummon, object oPC, int iParam)
{
	string sAnimName;
	int iLooping = TRUE;
	
	switch(iParam)
	{
		case 0:
			sAnimName = "idle";
			break;
		case 1:
			sAnimName = "dance01";
			break;
		case 2:
			sAnimName = "dance02";
			break;
		case 3:
			sAnimName = "playguitar";
			break;
		case 4:
			sAnimName = "playflute";
			break;
		case 5:
			sAnimName = "playdrum";
			break;
	}
	
	PlayCustomAnimation(oSummon, sAnimName, iLooping, 1.0);
}

void main(int iFunction, int iParam)
{
	object oPC = OBJECT_SELF;
	object oSummon = PS_GetLocalObject(oPC, "RCTag");
	
	// modify the distance
	float fRange;
	float fAngle; 
	
	if (GetIsObjectValid(oSummon) == TRUE)
	{
		switch (iFunction)
		{
			case 1:
				// Move forward
				{
					fRange = IntToFloat(iParam) / 2;
					AssignCommand(oSummon, ActionForceMoveToLocation(GetAheadLocation(oSummon, fRange),FALSE,5.0));
					break;
				}
			case 2:
				// Move back
				{
					fRange = IntToFloat(iParam) / 2;
					AssignCommand(oSummon, ActionForceMoveToLocation(GetBehindLocation(oSummon, fRange),FALSE,5.0));
					break;
				}
			case 3:
				// Rotate right... for some strange reason
				{
					fAngle = IntToFloat(iParam);
					float fOrientation = GetFacing(oSummon);
					
					if ((fOrientation - fAngle) < 0.0)
						fAngle = 360.0 + fOrientation - fAngle;
					else
						fAngle = fOrientation - fAngle;
					
					AssignCommand(oSummon, SetFacing(fAngle, FALSE));
				}
				break;
			case 4:
				// Rotate left... its bizarre... should be the other way around
				{
					fAngle = IntToFloat(iParam);
					float fOrientation = GetFacing(oSummon);
					
					if ((fOrientation + fAngle) > 360.0)
						fAngle = fOrientation + fAngle - 360.0;
					else
						fAngle = fOrientation + fAngle;
					
					AssignCommand(oSummon, SetFacing(fAngle, FALSE));
				}
				break;
				
			case 5:
				// equip weapons
				{
					NPCRemoteEquipWeapons(oSummon, oPC);
					break;
				}
			
			case 6:
				// remove weapons
				{
					NPCRemoteUnequipWeapons(oSummon, oPC);
					break;
				}
			
			case 7:
				// tag target
				{
					// actually we don't need to really take additional action because script already tags
					SendMessageToPC(oPC, "Target is tagged");
					break;
				}
				
			case 8:
				// destroy weapon
				{
					NPCRemoteDestroyWeapon(oSummon, oPC);
					break;
				}
			
			case 9:
				// play anims
				{
					NPCToolPlayAnim(oSummon, oPC, iParam);
					break;
				}
				
			case 10:
				// any melee
				{
					NPCRemoteEquipAnyRanged(oSummon, oPC);
					break;
				}
				
			case 11:
				// any ranged
				{
					NPCRemoteEquipAnyMelee(oSummon, oPC);
					break;
				}
			default:
				SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "Invalid function selected");
				break;
		}
		
	}
	else
	{
		// can probably delete this.  Would only be relevant if NPC disappeared between
		// using the controller item and selecting an option, and the if condition traps that
		// hopefully someone would realize that the summon they were controlling was gone.
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "You did not target one of your own NPCs");
	}	
}