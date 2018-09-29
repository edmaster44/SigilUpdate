// From conversation with chess master to teleport into the chessboard.

void JumpGroupToLocation(object oTarget, location lDestination)
{
	object oJumper=GetFirstFactionMember(oTarget, FALSE);
	while (GetIsObjectValid(oJumper))
	{
		AssignCommand(oJumper, JumpToLocation(lDestination));
		oJumper=GetNextFactionMember(oTarget, FALSE);
	}
	AssignCommand(oTarget, JumpToLocation(lDestination));
}

void main()
{
object oPC = GetPCSpeaker();
object oTarget= GetWaypointByTag("WP_ps_chessboard_enter");
location lTarget= GetLocation(oTarget);
JumpGroupToLocation(oPC, lTarget);
}