void main(int nDiff)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	SetLocalInt(oPC,"DIFF",nDiff);
}