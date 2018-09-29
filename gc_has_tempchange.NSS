int StartingConditional(object oPC)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iChange		= GetLocalInt(oItem, "TempChange");
	return iChange;
}