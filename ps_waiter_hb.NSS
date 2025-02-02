#include "ff_safevar"

/* Script Created by Agony_Aunt/Loki for SCoD PW. Waiter who can be summoned to provide refreshments for a party*/

/* need to randomize what he is doing, for example, walking up and offering drinks, speaking (rarely unless addressing someone directly),
wandering around the local area (within defined range of spawn location), or play some animation.
Also summoner must be able to command him to return to spawn point or stay still or go away.
May need variables set to define current action if we need to follow up
Definitely need to set variable on spawn to define spawn location so that we can control how far it should wander.
Need convo to be able to set bar location, change spawn location, etc.
Remember to set owner after spawn as only owner can command.
commands.  Set Bar, Set Service Area, Stay, Follow... be active, stop... etc????
Also set tag based on owner name upon summon to ensure they are unique
*/

#include "x0_i0_position"
#include "nw_i0_generic"
#include "ps_waiter_inc"


// Local vars: 
// "LastAction" (int) - stores last action
// "LastClient" (object) - stores the last client approached/spoken to (avoid speaking to same one twice in a row and for tracking who to talk to
// "SpawnLocation" (location) - on spawn this is stored to determine the area in which it should serve.  It can be changed by convo command
// "BarLocation" (location) - a default point to return to.. a waiting point or a bar.  Same as spawn location by default
// "Owner" (object) - useful for sending messages to. -  Need recheck on this somewhere, perhaps in gc_ script
// "OwnerName" (string) - (need then to get object!) for checking use for NPC remote.
// "ClientListEntry"+<integer> (objects) - stores list of possible clients.
// "ServiceStatus" (int) - WAITER_ACTIVE or WAITER_INACTIVE. Setting things like follow should deactive it.



void main()
{
	object oOwner = PS_GetLocalObject(OBJECT_SELF, "Owner");
	
	if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
	
	if (PS_GetLocalInt(OBJECT_SELF, "ServiceStatus") == WAITER_ACTIVE)
	{
		if (PS_GetLocalInt(OBJECT_SELF, "LastAction") == WAITER_ACTION_WALK_TO_CLIENT)
		{
			// then we should now speak to them using a list of possible things to say.
			object oClient = PS_GetLocalObject(OBJECT_SELF, "LastClient");
			TurnToFaceObject(oClient, OBJECT_SELF);
			WaiterSpeakToClient(OBJECT_SELF, oClient);
			PS_SetLocalInt(OBJECT_SELF, "LastAction", WAITER_ACTION_SPEAK_TO_CLIENT);
		}
		else if (PS_GetLocalInt(OBJECT_SELF, "LastAction") == WAITER_ACTION_SPEAK_TO_CLIENT)
		{
			// wait for one round, ie: do nothing
			PS_SetLocalInt(OBJECT_SELF, "LastAction", WAITER_ACTION_WAIT);
		}
		else if (PS_GetLocalInt(OBJECT_SELF, "LastAction") == WAITER_ACTION_RETURN_TO_BAR)
		{
			// wait for one round, ie: do nothing
			SetFacing(GetFacingFromLocation(PS_GetLocalLocation(OBJECT_SELF, "BarLocation")));
			PS_SetLocalInt(OBJECT_SELF, "LastAction", WAITER_ACTION_WAIT);
		}
		else if (PS_GetLocalInt(OBJECT_SELF, "LastAction") == WAITER_IN_CONVO)
		{
			// wait for one round, ie: do nothing
			PS_SetLocalInt(OBJECT_SELF, "LastAction", WAITER_ACTION_WAIT);
		}
		else
		{
			// let's choose an action... or not.
			int iAction = d12();
			//SendMessageToPC(oOwner, "DEBUG: Random Action = " + IntToString(iAction));
			if (iAction == 1)
			{
				// walk to client, will speak to client.
				object oTarget = WaiterSelectClientInLocalArea();
				//SendMessageToPC(oOwner, "DEBUG: Looking for a client and found: " + GetName(oTarget));
				if (oTarget != OBJECT_INVALID)
				{
					PS_SetLocalObject(OBJECT_SELF, "LastClient", oTarget);
					PS_SetLocalInt(OBJECT_SELF, "LastAction", WAITER_ACTION_WALK_TO_CLIENT);
					WaiterMoveToClient(OBJECT_SELF, oTarget);
				}
			}
			else if (iAction < 5)
			{
				// walk around a little
				// locks onto nearest object next to spawn location as GetRandomLocation requires an object not a location
				location lNewLoc = GetRandomLocation(GetArea(OBJECT_SELF), GetNearestObjectToLocation(OBJECT_TYPE_ALL, PS_GetLocalLocation(OBJECT_SELF, "SpawnLocation")), WAITER_RADIUS);
				ActionMoveToLocation(lNewLoc, FALSE);
			}
			else if (iAction < 9)
			{
				//return to bar
				PS_SetLocalInt(OBJECT_SELF, "LastAction", WAITER_ACTION_RETURN_TO_BAR);
				WaiterMoveToBar(OBJECT_SELF);
			}
			else // 5 or 6
			{
				// just stands around.
				PlayImmobileAmbientAnimations();
			}
		}
	}
}