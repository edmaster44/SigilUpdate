

int StartingConditional() {

	object oPC = GetPCSpeaker();
	
	int nDebtor = GetLocalInt(OBJECT_SELF, "DEBTOR_INDEX");
	int nBounty = GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_BOUNTY");
	int nAmount = nBounty*3;
	
	if ( GetGold(oPC) >= nAmount ) return TRUE;
	
	return FALSE;

}