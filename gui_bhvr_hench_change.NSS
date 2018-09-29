// gui_bhvr_hench_change
/*
	Behavior script for the character sheet behavior sub-panel
*/

#include "gui_bhvr_inc"

#include "hench_i0_assoc"
#include "hench_i0_equip"


void HenchSetBehaviorOnObject(int nCondition, int bNewState, object oPlayerObject, object oTargetObject, string sScreen)
{
	switch (nCondition)
	{
		case HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH:
			SetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH, bNewState, oTargetObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232502, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232503, "");
			}
			break;
		case HENCH_ASC_USE_RANGED_WEAPON:
			SetAssociateState(NW_ASC_USE_RANGED_WEAPON, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232504, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232505, "");
			}
			ChangeEquippedWeapons(oTargetObject);
 			break;
		case HENCH_ASC_MELEE_DISTANCE_NEAR:
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR, TRUE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_MED, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR, FALSE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232507, "");
			break;
		case HENCH_ASC_MELEE_DISTANCE_MED:
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_MED, TRUE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR, FALSE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232508, "");
			break;
		case HENCH_ASC_MELEE_DISTANCE_FAR:
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_MED, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR, TRUE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232509, "");
			break;

		case HENCH_ASC_ENABLE_BACK_AWAY:
			SetHenchAssociateState(HENCH_ASC_ENABLE_BACK_AWAY, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232511, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232512, "");
			}
			break;

		case HENCH_ASC_DISABLE_SUMMONS:
			SetHenchAssociateState(HENCH_ASC_DISABLE_SUMMONS, bNewState, oTargetObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232514, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232515, "");
			}
			break;

		case HENCH_ASC_ENABLE_DUAL_WIELDING:
			SetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, TRUE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, FALSE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232517, "");
			ChangeEquippedWeapons(oTargetObject);
			break;
		case HENCH_ASC_DISABLE_DUAL_WIELDING:
			SetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, TRUE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232518, "");
			ChangeEquippedWeapons(oTargetObject);
			break;
		case 384 /*HENCH_ASC_ENABLE_DUAL_WIELDING + HENCH_ASC_DISABLE_DUAL_WIELDING*/:
			SetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, FALSE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232519, "");
			ChangeEquippedWeapons(oTargetObject);
			break;
		
		case HENCH_ASC_DISABLE_DUAL_HEAVY:
			SetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_HEAVY, bNewState, oTargetObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232521, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232522, "");
			}
			ChangeEquippedWeapons(oTargetObject);
			break;

		case HENCH_ASC_DISABLE_SHIELD_USE:
			SetHenchAssociateState(HENCH_ASC_DISABLE_SHIELD_USE, bNewState, oTargetObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232524, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232525, "");
			}
			ChangeEquippedWeapons(oTargetObject);
			break;
			
		case HENCH_ASC_RECOVER_TRAPS:
			SetHenchAssociateState(HENCH_ASC_RECOVER_TRAPS, bNewState, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, FALSE, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232528, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232529, "");
			}
			break;			
			
		case HENCH_ASC_NON_SAFE_RECOVER_TRAPS:
			SetHenchAssociateState(HENCH_ASC_RECOVER_TRAPS, bNewState, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232527, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232529, "");
			}
			break;	
			
		case HENCH_ASC_AUTO_OPEN_LOCKS:
			SetHenchAssociateState(HENCH_ASC_AUTO_OPEN_LOCKS, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232531, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232532, "");
			}
			break;
			
		case HENCH_ASC_AUTO_PICKUP:
			SetHenchAssociateState(HENCH_ASC_AUTO_PICKUP, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232534, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232535, "");
			}
			break;
			
		case HENCH_ASC_DISABLE_POLYMORPH:
			SetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH, bNewState, oTargetObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232537, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232538, "");
			}
			break;
			
		case HENCH_ASC_DISABLE_INFINITE_BUFF:
			SetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF, bNewState, oTargetObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232540, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232541, "");
			}
			break;

		case HENCH_ASC_ENABLE_HEALING_ITEM_USE:
			SetHenchAssociateState(HENCH_ASC_ENABLE_HEALING_ITEM_USE, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232543, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232544, "");
			}
			break;
			
		case HENCH_ASC_DISABLE_AUTO_HIDE:			
			SetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE, bNewState, oTargetObject);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232546, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232547, "");
			}
			break;
			
		case HENCH_ASC_GUARD_DISTANCE_NEAR:
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR, TRUE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR, FALSE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232549, "");
			break;
		case HENCH_ASC_GUARD_DISTANCE_MED:
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED, TRUE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR, FALSE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232550, "");
			break;
		case HENCH_ASC_GUARD_DISTANCE_FAR:
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR, TRUE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232551, "");
			break;
		case HENCH_ASC_GUARD_DISTANCE_DEFAULT:
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED, FALSE, oTargetObject);
			SetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR, FALSE, oTargetObject);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232552, "");
			break;
		case HENCH_ASC_NO_MELEE_ATTACKS:		
			SetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232561, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232562, "");
			}
			break;
		case HENCH_ASC_MELEE_DISTANCE_ANY:		
			SetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_ANY, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232564, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 232565, "");
			}
			break;
		case HENCH_ASC_PAUSE_EVERY_ROUND:		
			SetHenchAssociateState(HENCH_ASC_PAUSE_EVERY_ROUND, bNewState, oTargetObject);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchPauseEveryRoundOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchPauseEveryRoundOff);
			}
			break;

		default:
			PrettyError( "gui_bhvr_hench_change: Behavior " + IntToString( nCondition ) + " definition does not exist." );
	}	

}

// Set Behavior on all companions in the party and on this player's controlled character.
void HenchSetBehaviorAll(int nCondition, int bNewState)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	string sScreen = SCREEN_CHARACTER;

	
	object oPC = OBJECT_SELF;
	//PrettyMessage("OBJECT_SELF = " + GetName(OBJECT_SELF));
	// object oOwnedChar = GetOwnedCharacter(oPC); // OBJECT_SELF is the owned char, and this function will return ""
	int i = 1;
	//PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
    // We stop when there are no more valid PC's in the party.
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		//PrettyMessage("SetBehaviorAll: Party char # " + IntToString(i) + " = " + GetName(oPartyMember));
		i++;
 		if (GetIsRosterMember(oPartyMember) || (oPartyMember == oPC))
		{
			HenchSetBehaviorOnObject(nCondition, bNewState, oPlayerObject, oPartyMember, sScreen);
		}
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
	
	object oTargetObject = oPlayerObject;

	HenchGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}


// Set Behavior on currently controlled character
void HenchSetBehavior(int nCondition, int bNewState, int iExamined)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	string sScreen;
	
	if (iExamined == 0) // looking at our own character sheet
	{
		oTargetObject = oPlayerObject;
		sScreen = SCREEN_CHARACTER;
	}
	else 	// looking at an examined character sheet
	{
		oTargetObject = GetPlayerCreatureExamineTarget(oPlayerObject);
		sScreen = SCREEN_CREATUREEXAMINE;
	}
	
	HenchSetBehaviorOnObject(nCondition, bNewState, oPlayerObject, oTargetObject, sScreen);
	HenchGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}


void main(int nCondition, int bNewState, int bAll, int iExamined)
{
	// PrettyError( "gui_bhvr_hench_change." );
			
	if (bAll)
	{
		HenchSetBehaviorAll(nCondition, bNewState);
	}
	else
	{
		HenchSetBehavior(nCondition, bNewState, iExamined);
	}
}