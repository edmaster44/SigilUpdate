/*////////////////////////////////////////////////////////////
//A script for frightened townsfolk
//It makes them run away when they see a PC
//Used by the Frightened Commoner template
/*//////////////////////////////////////////////////////////*/
void main() {
	// * if not running normal or better Ai then exit for performance reasons
    // * if not running normal or better Ai then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

        // script hidden object shouldn't react (for cases where AI not turned off)
    if (GetScriptHidden(OBJECT_SELF)) return;

    object oLastPerceived = GetLastPerceived();
    int bSeen = GetLastPerceptionSeen();
	
	
	//Only run away from PCs, and only if we actually see them
	if (GetIsObjectValid(oLastPerceived) && GetIsPC(oLastPerceived) && bSeen) {
		ActionMoveAwayFromObject(oLastPerceived, TRUE, 30.0f);
		DestroyObject(OBJECT_SELF, 10.0f);
	}
}