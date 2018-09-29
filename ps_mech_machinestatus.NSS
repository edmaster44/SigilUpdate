// 1 = broken
// 2 = fixed
int StartingConditional(int nStatus)
{

	object oPC = GetPCSpeaker();
	string sTag = GetTag(OBJECT_SELF);
	
	if (nStatus == 1 && GetLocalInt(oPC, sTag+"_broken") > 0) {
		return TRUE;
	}
	if (nStatus == 2 && GetLocalInt(oPC, sTag+"_fixed") > 0) {
		return TRUE;
	}
	return FALSE;
	
}