// gui_option_hench_change
/*
	Global option script for the character sheet behavior sub-panel
*/

#include "gui_bhvr_inc"

#include "hench_i0_assoc"


void HenchSetOption(int nCondition, int bNewState, object oPlayerObject, object oTargetObject, string sScreen)
{
	switch (nCondition)
	{
		case HENCH_OPTION_STEALTH:
			SetHenchOption(HENCH_OPTION_STEALTH, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233032, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233033, "");
			}
			break;
			
		case HENCH_OPTION_WANDER:
			SetHenchOption(HENCH_OPTION_WANDER, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233035, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233036, "");
			}
			break;
			
		case HENCH_OPTION_OPEN:
			SetHenchOption(HENCH_OPTION_OPEN, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233038, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233039, "");
			}
			break;
			
		case HENCH_OPTION_UNLOCK:
			SetHenchOption(HENCH_OPTION_UNLOCK, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233041, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233042, "");
			}
			break;
			
		case HENCH_OPTION_KNOCKDOWN_DISABLED:
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED, bNewState);
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES, FALSE);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233044, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233047, "");
			}
			break;
		case HENCH_OPTION_KNOCKDOWN_SOMETIMES:		
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED, FALSE);
			SetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES, TRUE);
			SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233046, "");
			break;
			
		case HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET:
			SetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET, bNewState);
			if (!bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233049, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233050, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_AUTO_BUFF:
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF, bNewState);
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF, FALSE);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233052, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233054, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF:
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF, bNewState);
			SetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233053, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233054, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_ITEM_CREATION:
			SetHenchOption(HENCH_OPTION_ENABLE_ITEM_CREATION, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233056, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233057, "");
			}
			break;
			
		case HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE:
			SetHenchOption(HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233059, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233060, "");
			}
			break;

		case HENCH_OPTION_HIDEOUS_BLOW_INSTANT:
			SetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233062, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233063, "");
			}
			break;

		case HENCH_OPTION_MONSTER_ALLY_DAMAGE:
			SetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233065, "");
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, 233066, "");
			}
			break;
			
		case HENCH_OPTION_DISABLE_HB_DETECTION:
			SetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION, !bNewState);
			SetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING, FALSE);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchHBDetectOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchHBDetectOff);
			}
			break;
			
		case HENCH_OPTION_DISABLE_HB_HEARING:
			SetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION, FALSE);
			SetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchHBSeeOnlyOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchHBDetectOff);
			}
			break;
			
		case HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH:
			SetHenchOption(HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH, bNewState);
			if (bNewState)
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchPauseAndSwitchOn);
			}
			else
			{
				SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, -1, sHenchPauseAndSwitchOff);
			}
			break;
			
		default:
			PrettyError( "gui_bhvr_hench_change: Behavior " + IntToString( nCondition ) + " definition does not exist." );
	}
}


void main(int nCondition, int bNewState)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	string sScreen;
	
	oTargetObject = oPlayerObject;
	sScreen = SCREEN_CHARACTER;
	
	HenchSetOption(nCondition, bNewState, oPlayerObject, oTargetObject, sScreen);
	HenchGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}