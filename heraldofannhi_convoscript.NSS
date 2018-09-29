void main(int nCOMMAND)
{
	object oPC = GetPCSpeaker();
	int nPARTY;
	object oPARTY = GetFirstFactionMember(oPC);
	while (oPARTY != OBJECT_INVALID)
	{
		nPARTY = nPARTY + 1;
		oPARTY = GetNextFactionMember(oPC);
	}
	if (nPARTY <= 4)
	{
		object oWAY = GetObjectByTag("wp_herald_annhi_start");
		JumpPartyToArea(oPC, oWAY);
	}
	else FloatingTextStringOnCreature("Only groups with 4 or less players may attempt this challenge.", oPC, FALSE);
}