void RearmChest()
{
	// Use custom traps 65-119
	int iTrapType = Random(54) + 65;
	CreateTrapOnObject(iTrapType, OBJECT_SELF, STANDARD_FACTION_HOSTILE, "ps_githchest_ondisarm", "ps_githchest_ontraptriggered");
}

void main()
{
	ExecuteScript("ps_traps_custom", OBJECT_SELF);
	DelayCommand(900.0, RearmChest());
}