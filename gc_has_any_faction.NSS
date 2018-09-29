int GetFaction(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
	{
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();

	int nFaction = GetFaction(oPC);
	
    if ( nFaction > 0 ) return TRUE;

    return FALSE;

}