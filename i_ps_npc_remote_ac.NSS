#include "ff_safevar"

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/
const string NPC_REMOTE_FEEDBACK_PREFIX = "<COLOR=lawngreen><b>NPC REMOTE:</b> ";

void GiveFeedback(object oPC, object oSummon, object oTarget, object oOriginal, object oOldItemInSlot, int iTargetInvSlot)
{
	if (GetItemInSlot(iTargetInvSlot, oSummon) == oTarget)
	{
		if (oOldItemInSlot != OBJECT_INVALID)
		{
			SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + GetName(oSummon) + " unequipped " + GetName(oOldItemInSlot));
		}
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + GetName(oSummon) + " received and equipped " + GetName(oTarget));
		DestroyObject(oOriginal, 0.1);
	}
	else
	{
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + GetName(oSummon) + " cannot equip " + GetName(oTarget));
		DestroyObject(oTarget, 0.1);
	}
}
				

void main()
{
	object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
	object oSummon;
	int iTargetInvSlot;
	int iBaseItemType = GetBaseItemType(oTarget);
	object oOldItemInSlot;
	object oOriginal;
				
	if (GetMaster(oTarget) == oPC || PS_GetLocalString(oTarget, "OwnerName") == GetName(oPC))
	{
		PS_SetLocalObject(oPC, "RCTag", oTarget);
		AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_npc_remote", TRUE, FALSE, TRUE, TRUE));
	}
	else if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM & GetItemPossessor(oTarget) == oPC)
	{
		oSummon = PS_GetLocalObject(oPC, "RCTag");
		if (GetIsObjectValid(oSummon) == TRUE)
		{
			switch (iBaseItemType)
			{
				case BASE_ITEM_AMULET:
					iTargetInvSlot = INVENTORY_SLOT_NECK;
					break;
					
				case BASE_ITEM_BELT:
					iTargetInvSlot = INVENTORY_SLOT_BELT;
					break;
					
				case BASE_ITEM_ARMOR:
					iTargetInvSlot = INVENTORY_SLOT_CHEST;
					break;
				
				case BASE_ITEM_BOOTS:
					iTargetInvSlot = INVENTORY_SLOT_BOOTS;
					break;
					
				case BASE_ITEM_BRACER:
				case BASE_ITEM_GLOVES:
					iTargetInvSlot = INVENTORY_SLOT_ARMS;
					break;
				
				case BASE_ITEM_CLOAK:
					iTargetInvSlot = INVENTORY_SLOT_CLOAK;
					break;
					
				case BASE_ITEM_HELMET:
					iTargetInvSlot = INVENTORY_SLOT_HEAD;
					break;
			
				case BASE_ITEM_SMALLSHIELD:
				case BASE_ITEM_LARGESHIELD:
				case BASE_ITEM_TOWERSHIELD:
				case BASE_ITEM_TORCH:
				case BASE_ITEM_MANDOLIN:
				case BASE_ITEM_FLUTE:
				case BASE_ITEM_DRUM:
					iTargetInvSlot = INVENTORY_SLOT_LEFTHAND;
					break;
				
				case BASE_ITEM_RING:
					//check first then second ring slot
					// so you can give rings max, and if they already have a ring you loose out.
					if (GetItemInSlot(INVENTORY_SLOT_LEFTRING, oSummon) == OBJECT_INVALID)
						iTargetInvSlot = INVENTORY_SLOT_LEFTRING;
					else
						iTargetInvSlot = INVENTORY_SLOT_RIGHTRING;
					break;
				
				case BASE_ITEM_THROWINGAXE:
				case BASE_ITEM_SHURIKEN:
				case BASE_ITEM_DART:
					iTargetInvSlot = INVENTORY_SLOT_RIGHTHAND;
					break;
				
				case BASE_ITEM_ARROW:
					iTargetInvSlot = INVENTORY_SLOT_ARROWS;
					break;
					
				case BASE_ITEM_BOLT:
					iTargetInvSlot = INVENTORY_SLOT_BOLTS;
					break;
					
				case BASE_ITEM_BULLET:
					iTargetInvSlot = INVENTORY_SLOT_BULLETS;
					break;	
				
				case BASE_ITEM_ALLUSE_SWORD:
				case BASE_ITEM_BASTARDSWORD:
				case BASE_ITEM_BATTLEAXE:
				case BASE_ITEM_CLUB:
				case BASE_ITEM_DAGGER:
				case BASE_ITEM_DWARVENWARAXE:
				case BASE_ITEM_FALCHION:
				case BASE_ITEM_FLAIL:
				case BASE_ITEM_GREATAXE:
				case BASE_ITEM_GREATSWORD:
				case BASE_ITEM_HALBERD:
				case BASE_ITEM_HANDAXE:
				case BASE_ITEM_HEAVYCROSSBOW:
				case BASE_ITEM_KAMA:
				case BASE_ITEM_KATANA:
				case BASE_ITEM_KUKRI:
				case BASE_ITEM_LIGHTCROSSBOW:
				case BASE_ITEM_LIGHTFLAIL:
				case BASE_ITEM_LIGHTHAMMER:
				case BASE_ITEM_LIGHTMACE:
				case BASE_ITEM_LONGBOW:
				case BASE_ITEM_LONGSWORD:
				case BASE_ITEM_MACE:
				case BASE_ITEM_MAGICSTAFF:
				case BASE_ITEM_MORNINGSTAR:
				case BASE_ITEM_QUARTERSTAFF:
				case BASE_ITEM_RAPIER:
				case BASE_ITEM_SCIMITAR:
				case BASE_ITEM_SCYTHE:
				case BASE_ITEM_SHORTBOW:
				case BASE_ITEM_SHORTSWORD:
				case BASE_ITEM_SLING:
				case BASE_ITEM_SPEAR:
				case BASE_ITEM_SICKLE:
				case BASE_ITEM_WARHAMMER:
				case BASE_ITEM_WARMACE:
					iTargetInvSlot = INVENTORY_SLOT_RIGHTHAND;
					break;
				
				case BASE_ITEM_HEALERSKIT:
				case BASE_ITEM_POTIONS:
				case BASE_ITEM_SCROLL:
					iTargetInvSlot = -2;
					break;
					
				default:
				// not allowed to give these items.
					iTargetInvSlot = -1;
				break;
			}
			
			if (iTargetInvSlot == -2)
			{
				oOriginal = oTarget;
				oTarget = CopyItem(oOriginal, oSummon, TRUE);
				SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "You gave " + GetName(oSummon) + " " + GetName(oTarget));
				DestroyObject(oOriginal);
			}
			else if (iTargetInvSlot >= 0)
			{
				oOriginal = oTarget;
				oTarget = CopyItem(oOriginal, oSummon, TRUE);
				oOldItemInSlot = GetItemInSlot(iTargetInvSlot, oSummon);
				DelayCommand(0.2, AssignCommand(oSummon, ActionEquipItem(oTarget, iTargetInvSlot)));
				DelayCommand(0.4, GiveFeedback(oPC, oSummon, oTarget, oOriginal, oOldItemInSlot, iTargetInvSlot));
			}
			else
			{
				SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "You cannot give items of this type to NPCs. Equippable items only.");
			}				
		}
		else
		{
			SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "You must tag an NPC you control first");
		}
	}
	else
	{
		SendMessageToPC(oPC, NPC_REMOTE_FEEDBACK_PREFIX + "This will only work on your own NPCs or an item you are wanting to give an NPC");
	}
}