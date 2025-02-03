void main()
{
	object oPC = GetLastUsedBy();
	object oBOSS = GetObjectByTag("herald_of_annhilation");
	if ((GetIsInCombat(oBOSS) == TRUE) || (GetIsInCombat(oPC) == TRUE))
	{
		FloatingTextStringOnCreature("Cannot be used during combat.", oPC, FALSE);
		return;
	}
	object oWAY;
	string sSELF = GetTag(OBJECT_SELF);
	if (sSELF == "portal_in") 
	{
		if (GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1)
		{
			oWAY = GetObjectByTag("wp_herald_annhi_start");
			AssignCommand(oPC, ActionJumpToObject(oWAY));
		}
		else BeginConversation("heraldofannhi_convo", oPC, TRUE);
	}
	else if (sSELF == "portal_out")
	{
		oWAY = GetObjectByTag("wp_herald_annhi_out");
		AssignCommand(oPC, ActionJumpToObject(oWAY));
	}
}