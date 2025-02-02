#include "ff_safevar"

/*
ps_door-portalopen
by Ceremorph 10/26/2015

This script generates a portal in a doorway after the door is opened. This portal can be activated if a party
member of the door opener possesses the proper portal key. If the "Key" string variable is left blank, the
portal opens when the door does.

This works best with the moongate VFX, developed by MokahTGS. These are:
	moongate_black
	moongate_blue 
	moongate_red
	moongate_silver
Other VFX with a more "flat" appearance should also work well.
*/
#include "NW_I0_TOOL"

void main()

{
	//	Get the float for the duration of the time to pass before the door is closed and locked
	string sPortal		= PS_GetLocalString(OBJECT_SELF, "Portal");		//Tag of portal
	string sKey			= PS_GetLocalString(OBJECT_SELF, "Key");			//Portal key (if any)
	string sFX			= PS_GetLocalString(OBJECT_SELF, "VFX");			//Visual effect to apply
	int iLocked			= PS_GetLocalInt(OBJECT_SELF, "Locked");			//1 for locked door, 2 for unlocked
	float fDelay		= PS_GetLocalFloat(OBJECT_SELF, "Delay");			//Delay (in seconds) to close door
	if (fDelay < 60.0f)
		fDelay = 60.0f;
	
	object oWP			= GetWaypointByTag("wp_"+GetTag(OBJECT_SELF)); 	//spawn portal at the waypoint which matches wp_+DoorTag
	location lPortal	= GetLocation(oWP);								//Door's location

	object oPC			= GetLastOpenedBy();							//Player who opened the door
	
	string SPAWNED 		= "nSpawned";

	if (!GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC)) return;
	
	if(sKey != "")
	{
		if(GetItemPossessedBy(oPC, sKey) != OBJECT_INVALID)  {
			object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, lPortal);	//Create the portal
			SetPlotFlag(oPortal,TRUE);												//Mark the portal as plot
			if (sFX != "") CreateObject(OBJECT_TYPE_PLACED_EFFECT, sFX, lPortal);	//Generate the portal visual effect
			PS_SetLocalInt(OBJECT_SELF, SPAWNED, TRUE);								//Mark the portal as spawned
			DelayCommand(fDelay,ActionCloseDoor(OBJECT_SELF));						//Close the door after fDelay seconds	
		}
		
	} else {
		object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, lPortal);		//Create the portal
		SetPlotFlag(oPortal,TRUE);													//Mark the portal as plot
		if (sFX != "") CreateObject(OBJECT_TYPE_PLACED_EFFECT, sFX, lPortal);		//Generate the portal visual effect
		PS_SetLocalInt(OBJECT_SELF, SPAWNED, TRUE);									//Mark the portal as spawned
		DelayCommand(fDelay,ActionCloseDoor(OBJECT_SELF));							//Close the door after fDelay seconds	
	}	
}
// End