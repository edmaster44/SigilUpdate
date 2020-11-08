#include "ps_inc_functions"

void LockChest()
{
	SetLocked(OBJECT_SELF, TRUE);
}

void main()
{
	object oPC = GetLastUnlocked();
	int iDC = GetLockUnlockDC(OBJECT_SELF);
	int iXPMod = 1 + FloatToInt((31 - IntToFloat(PS_GetLevel(oPC))) / 10);
	PS_GiveXPReward(oPC, iDC * iXPMod);

	DelayCommand(900.0, LockChest());
}