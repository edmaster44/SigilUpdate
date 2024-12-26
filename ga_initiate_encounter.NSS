//	ga_initiate_encounter
/*
    Transitions the party to the encounter map and destroys the overland version
	of the creature.
*/
// JH/EF-OEI: 01/16/08
// NLC: 03/08 - Updated to use new Dialog Skills and to add Parameters for Forcing groups hostile.

#include "ginc_overland"

/*

Warning: ga_initiate_encounter.nss(12): Warning: NSC6010: Entry point function "main" has a default value for argument "bGroup1ForceHostile", but the runtime will select default argument values from a hardcoded list of defaults for script entry point symbols.  Consider removing explicit default arguments from the function and handling the actual runtime default values (which are zero, OBJECT_INVALID, and an empty string, as appropriate).
*/
void main(int nDialogSkill, int nSkillDC, int bGroup1ForceHostile, int bGroup2ForceHostile, 
			int bGroup3ForceHostile, int bGroup4ForceHostile, int bGroup5ForceHostile)
{
	object oPC = GetFactionLeader(GetFirstPC());
	InitiateEncounter(nDialogSkill, nSkillDC, bGroup1ForceHostile, bGroup2ForceHostile, bGroup3ForceHostile, bGroup4ForceHostile, bGroup5ForceHostile, oPC);
	
	/*	Removes the overland map version of the creature.	*/
	if (GetIsObjectValid(OBJECT_SELF))
	{
		DestroyObject(OBJECT_SELF, 0.2f);
	}
}