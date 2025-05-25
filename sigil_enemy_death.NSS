

#include "sigil_enemy_inc"

void main()
{
	object oENEMY = OBJECT_SELF;
	if (GetLocalInt(oENEMY, "ENEMY_NOREWARD") == TRUE) return;
	object oPC = GetLastKiller();
	EnemyReward(oPC, oENEMY);
}