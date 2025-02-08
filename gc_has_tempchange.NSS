#include "ff_safevar"

int StartingConditional(object oPC)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iChange		= PS_GetLocalInt(oItem, "TempChange");
	return iChange;
}