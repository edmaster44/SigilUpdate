#include "ff_safevar"

/*
ps_hb_animate_multiuse
by Dedic8ed 2/26/2011

Script designed for easy application of animations to be place as heartbeat scripts in NPCs.
To apply, place in NPC's on_heartbeat dialog. Set a variable of "anim" on the NPC, and assign
the animation name desired. This animation will loop at all times for this NPC, then switches
to normal NPC heartbeat behavior.

To find the name of a given animation, search for racial animations inside the lod-merged
zipfiles in your NWN2 install folder, under Data. Not all races have all animations, so
verify using the racial (and sexual if appropriate) prefixes, e.g., P_HHF for human females,
P_DDM for dwarf males, etc.
*/

void main()
{
	//	Get the string for the animation name from the NPC's variables
	string sAnim	= PS_GetLocalString(OBJECT_SELF, "anim");
	float fSpeed	= PS_GetLocalFloat(OBJECT_SELF, "speed");

	/*	Verify the NPC is not currently involved in conversation. If this is so, the script
		will cease running*/
	if (!IsInConversation(OBJECT_SELF))
	
		//Play the ainmation
		{
			PlayCustomAnimation(OBJECT_SELF, sAnim, TRUE, fSpeed);
		}
	//Run the rest of the default heartbeat script	
	ExecuteScript("nw_c2_default1", OBJECT_SELF);
}