int StartingConditional(int whatlevel)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int hd = GetHitDice(oPC);
	if (hd >= whatlevel) return (FALSE);
	return (TRUE);
}