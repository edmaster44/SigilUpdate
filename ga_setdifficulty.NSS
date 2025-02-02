#include "ff_safevar"

void main(int nDiff)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	PS_SetLocalInt(oPC,"DIFF",nDiff);
}