#include "ff_safevar"

// Tag Team on activate script script. Links with a nearby Tag Team.
// By Electrohydra
// Last edit 19/09/2015

void main()
{
	object tagteam = GetSpellCastItem();
	object oPC = GetItemPossessor(tagteam);
	object oTarget = GetSpellTargetObject();
	
	if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget)) == "tagteam"
		|| (GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget)) == "tagteam"))
	{
		PS_SetLocalString(oPC, "tagteamtarget", GetName(oTarget));
		SendMessageToPC(oPC, "Tag Team linked.");
	}
	else
		SendMessageToPC(oPC, "Target is not using a Tag Team.");
}