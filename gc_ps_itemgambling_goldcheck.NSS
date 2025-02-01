#include "ff_safevar"

int StartingConditional()
{
	object oPC = ((GetPCSpeaker() == OBJECT_INVALID) ? OBJECT_SELF : GetPCSpeaker());
    int nPrice = PS_GetLocalInt(oPC, "SRLG_PRICE");
	if(nPrice > 0) {
		int nPlayerGold = GetGold(oPC);
		return (nPlayerGold >= nPrice) ? 1 : 0;
	}
	else
		return 1;
}