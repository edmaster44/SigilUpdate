

// nw_s1_wyvernland
//
// Spawn a Carcerian Vulture at the end of the Wyvern Swoop
#include "ps_inc_spawns"

void main()
{
	string sResRef = "c_colothys_vulture";// ResRef of creature to spawn
	location lLoc = GetSpellTargetLocation();
	object oCaster = OBJECT_SELF;
	object oPC = GetLocalObject(oCaster, "TriggeredBy");
	
	SpawnEncounterCreature(oCaster, oPC, lLoc, sResRef);
	DelayCommand(0.1, PlaySound("fs_Stomp2"));
	
}