

//#include "sigil_enemy_inc"

//void main()
//{
//	object oENEMY = OBJECT_SELF;
//	object oPC = GetLastDamager(oENEMY);
//	int nENEMY = GetLocalInt(oENEMY, "ENEMY_HEART");
//	int nROUND = GetLocalInt(oENEMY, "ENEMY_ROUND");
//	int nPHASE = GetLocalInt(oENEMY, "ENEMY_PHASE");
//	int nDIFF = GetLocalInt(oENEMY, "ENEMY_DIFF");
//	if (nDIFF < 1) nDIFF = 1;
//	else if (nDIFF > 4) nDIFF = 4;
//	switch (nENEMY)
//	{
//		case 101: BossInfiltrator(oENEMY, nDIFF, nPHASE, nROUND); break;
//		case 102: BossGorshtak(oENEMY, nDIFF, nPHASE, nROUND); break;
//		case 103: BossBellaville(oENEMY, nDIFF, nPHASE, nROUND); break;
//		default: return;
//	}
//}