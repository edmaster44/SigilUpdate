int StartingConditional()
{
	object oPC = GetPCSpeaker();
	if (GetFactionLeader(oPC) == oPC) return TRUE;
	return FALSE;
}