// gb_comp_heart
/*
	companion heartbeat
*/
// ChazM 12/5/05
// BMA-OEI 2/6/06 cleaned up comments, preserve action queue
// BMA-OEI 2/8/06 removed debug
// BMA-OEI 2/23/06 added 0.5f minimal follow distance
// ChazM 2/23/06 added commented PrettyDebugs.
// BMA-OEI 2/28/06 increase min follow distance = 2.0f	
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// ChazM 8/18/06 added debug calls.
			
//:://////////////////////////////////////////////////
//:: X0_CH_HEN_HEART
/*

  OnHeartbeat event handler for henchmen/associates.

*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////


#include "X0_INC_HENAI"
#include "hench_i0_ai"
#include "hench_i0_assoc"


void main()
{
/*	Jug_Debug(GetName(OBJECT_SELF) + " local vars");
	int varIndex = 1;
	while (TRUE)
	{
		string varName = GetVariableName(OBJECT_SELF, varIndex); 
		if (GetStringLength(varName) <= 0)
		{
			break;
		}
		int varType = GetVariableType(OBJECT_SELF, varIndex);
		switch (varType)
		{
			case VARIABLE_TYPE_NONE:
				Jug_Debug(varName + " is untyped");
				break;
			case VARIABLE_TYPE_INT:
				Jug_Debug(varName + " int value " + IntToString(GetLocalInt(OBJECT_SELF, varName)));
				break;
			case VARIABLE_TYPE_FLOAT:
				Jug_Debug(varName + " float value " + FloatToString(GetLocalFloat(OBJECT_SELF, varName)));
				break;
			case VARIABLE_TYPE_STRING:
				Jug_Debug(varName + " string value " + GetLocalString(OBJECT_SELF, varName));
				break;
			case VARIABLE_TYPE_DWORD:
				Jug_Debug(varName + " object value " + GetName(GetLocalObject(OBJECT_SELF, varName)));
				break;
			case VARIABLE_TYPE_LOCATION:
				Jug_Debug(varName + " location value " + LocationToString(GetLocalLocation(OBJECT_SELF, varName)));
				break;
			default:
				Jug_Debug(varName + " unknown type");
				break;			
		}		
		varIndex++;
	} */

	//option for a custom hb script (ease of AI hookup)
	string sHBScript=GetLocalString(OBJECT_SELF, "hb_script");
	if (sHBScript != "")
	{
		ExecuteScript(sHBScript, OBJECT_SELF);
	}

	if (GetIsPC(OBJECT_SELF))
	{
//		Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat exit due to isPC action " + IntToString(GetCurrentAction()) + " PC " + IntToString(GetIsPC(OBJECT_SELF)));
		return;		// heartbeat gets called on load for PC sometimes
	}
	
//	float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;
//	Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

	int bDying = (GetIsDead(OBJECT_SELF) || GetIsHenchmanDying(OBJECT_SELF));
	
    // If we're dying or busy, we return
    // (without sending the user-defined event)
	// file: nw_i0_generic, x0_i0_henchmen, assoc, x0_i0_states, henai
    int bBusy = GetAssociateState(NW_ASC_IS_BUSY);

	if (bDying || bBusy)
	{
		return;
	}
	
	if (GetAssociateState(NW_ASC_MODE_PUPPET))
	{
		if (!GetHasPlayerQueuedAction(OBJECT_SELF) && HenchCheckHeartbeatCombat(FALSE))
		{
			HenchCheckPlayerPause();
		}
	}	
	
	ExecuteScript("gb_assoc_heart", OBJECT_SELF);
}