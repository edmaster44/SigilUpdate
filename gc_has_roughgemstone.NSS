#include "ps_inc_gemstones"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	if (GetHasRoughGemstone(oPC))
		return TRUE;
	else
		return FALSE;
}