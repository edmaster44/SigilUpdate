

void main ()
{
	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
		
	object oDoorKeeper = GetNearestObjectByTag("ps_gb_goldmane");
	if (!GetIsObjectValid(oDoorKeeper))
		return;

	int lastTime = GetLocalInt(OBJECT_SELF, "timestamp");
	if (lastTime == GetTimeMinute())
		return;
		
	if ((GetRacialType(oPC) == RACIAL_TYPE_OUTSIDER) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
	{
		AssignCommand(oDoorKeeper, ActionSpeakString("I'm keeping my eye on you. . . you better not cause any trouble. *eyes follow "+GetName(oPC)+" around the room*"));
		SetLocalInt(OBJECT_SELF, "timestamp", GetTimeMinute());
	}
}