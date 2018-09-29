// From entering the light to return from chess game.

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
	object oPC = GetEnteringObject();
	object oTarget= GetWaypointByTag("ps_wp_returnfromchess");
	location lTarget= GetLocation(oTarget);
	JumpGroupToLocation(oPC, lTarget);
}