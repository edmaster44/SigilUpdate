int StartingConditional(string sTag)
{
   object oPC = GetPCSpeaker();
	return GetItemPossessedBy(oPC, sTag) != OBJECT_INVALID;
}