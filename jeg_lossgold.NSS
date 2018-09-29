void main()
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int gp = GetGold(oPC);
	int tithe = FloatToInt(gp * 0.10);
	TakeGoldFromCreature(tithe, oPC, TRUE);
}