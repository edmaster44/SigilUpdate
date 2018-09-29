#include "ps_inc_functions"

void RearmChest()
{
	// Use custom traps 65-119
	int iTrapType = Random(54) + 65;
	CreateTrapOnObject(iTrapType, OBJECT_SELF, STANDARD_FACTION_HOSTILE, "ps_githchest_ondisarm", "ps_githchest_ontraptriggered");
}

void main()
{
	object oPC = GetLastDisarmed();
	int iDC = GetTrapDisarmDC(OBJECT_SELF);
	int iXPMod = 1 + FloatToInt((31 - IntToFloat(PS_GetLevel(oPC))) / 10);
	GiveXPToCreature(oPC, iDC * iXPMod);
	DelayCommand(900.0, RearmChest());
}