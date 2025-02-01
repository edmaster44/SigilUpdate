#include "ff_safevar"

void main() {

	object oSelf = OBJECT_SELF;
	object oPC = GetPCSpeaker();
	int maxRioters = PS_GetLocalInt(oSelf, "NUM_RIOTERS");
	
	int n = 1;
	for (n = 1; n <= maxRioters; n++) {
		
		object oRioter = PS_GetLocalObject(oSelf, "FELLOW_RIOTER_"+IntToString(n));
		if (GetIsObjectValid(oRioter)) {
			AssignCommand(oRioter, ActionMoveAwayFromObject(oPC, FALSE, 60.0f));
			DestroyObject(oRioter, 3.0f);
		}
	
	}

}