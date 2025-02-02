#include "ff_safevar"

void main () {

	object oPC = GetPCSpeaker();
	ClearAllActions();
	PS_SetLocalObject(OBJECT_SELF, "FOLLOW_MASTER", oPC);
	ActionForceFollowObject(oPC, 2.0f);

}