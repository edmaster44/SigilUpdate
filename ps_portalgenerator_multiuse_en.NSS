#include "ff_safevar"

/*
ps_portalgenerator_multiuse_en
by Dedic8ed 2/28/2011

This script is designed to replace the portal generation system in the Sigil: City of Doors persistant world.
Instead of needing individual scripts for each portal, a single script will handle all portal generations; the
requirements are:
The tag of an item to act as portal key to generate the portal
The tag of a placed waypoint at the point of the portal
The name of the visual effect that will be called by the portal
The tag of a placeable which will act as the portal
*/

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter) && !GetIsDM(oEnter) && !GetIsDMPossessed(oEnter)) return;

string sKey		= PS_GetLocalString(OBJECT_SELF, "key"); 		//portal key tag
string sWaypt	= PS_GetLocalString(OBJECT_SELF, "wp");	 	//portal waypoint tag
string sFx		= PS_GetLocalString(OBJECT_SELF, "fx");		//portal visual effect name
string sPortal	= PS_GetLocalString(OBJECT_SELF, "portal");	//portal tag

if(CheckPartyForItem(oEnter, sKey) || GetHasFeat(2380, oEnter, FALSE)) 						//Check for portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag(sWaypt));		//Determine the location of the waypoint
if(!PS_GetLocalInt(OBJECT_SELF, SPAWNED))						//Ensure the portal is not already existant
{
PS_SetLocalInt(OBJECT_SELF, SPAWNED, TRUE);					//Mark the portal as open

CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, lPortal);		//Create the portal

object oPortal	= GetNearestObjectByTag(sPortal, OBJECT_SELF, 1);
CreateObject(OBJECT_TYPE_PLACED_EFFECT, sFx, lPortal);		//Generate the portal visual effect

string sRename	= PS_GetLocalString(OBJECT_SELF, "rename");	//New name for the portal object (optional)
if (sRename == "") return;
SetFirstName(oPortal, sRename);								//Rename the portal object (optional)
}
}
}