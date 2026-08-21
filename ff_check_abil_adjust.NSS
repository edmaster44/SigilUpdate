int StartingConditional(){
	object oPC = OBJECT_SELF;
	object oEss = GetItemPossessedBy(oPC, "ps_essence");
	int nAdjustments = GetLocalInt(oEss, "startability");
	
	int nRace = GetSubRace(oPC);
	if (nRace == RACIAL_SUBTYPE_HUMAN && nAdjustments < 2) return TRUE;
	if ((nRace == RACIAL_SUBTYPE_HALFELF || nRace == RACIAL_SUBTYPE_HALFDROW) &&
		nAdjustments < 1) return TRUE;
	return FALSE;
}