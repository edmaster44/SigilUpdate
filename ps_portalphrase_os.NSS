//:://////////////////////////////////////////////
/*
    On spawn in script that sets listening patterns
	for a phrase-based portal
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////
#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"

void main () {

    SetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT);      //OPTIONAL BEHAVIOR - Fire User Defined Event 1004

    SetListeningPatterns();    // Goes through and sets up which shouts the NPC will listen to.
    SetListening(OBJECT_SELF, TRUE);
	
	//Colothys Portal Out
    SetListenPattern(OBJECT_SELF, "Hope", 0076);
    SetListenPattern(OBJECT_SELF, "hope", 0077);

	//Colothys Other Carceri Portals
    SetListenPattern(OBJECT_SELF, "Despair", 0078);
    SetListenPattern(OBJECT_SELF, "despair", 0079);

}