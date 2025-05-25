

void main () {

	object oPC = GetPCSpeaker();
	ClearAllActions();
	SetLocalObject(OBJECT_SELF, "FOLLOW_MASTER", oPC);
	ActionForceFollowObject(oPC, 2.0f);

}