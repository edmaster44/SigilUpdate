#include "ps_inc_functions"

int StartingConditional(int whatlevel)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int hd = PS_GetLevel(oPC);
	if (hd >= whatlevel) return (FALSE);
	return (TRUE);
}