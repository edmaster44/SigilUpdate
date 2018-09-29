#include "sigil_enemy_inc"

void Command()
{
	
}

void BossInfiltrator(object oBOSS, int nDIFF, int nPHASE, int nROUND)
{
	switch (nPHASE)
	{
		case 1:
			switch (nROUND)
			{
				case 1: Command(); break;
				case 3: Command(); break;
				case 5: Command(); break;
				case 7: Command(); break;
			}
			break;
		default:
			switch (nROUND)
			{
				case 2: Command(); break;
				case 4: Command(); break;
				case 6: Command(); break;
				case 8: Command(); break;
			}
	}
}

void BossGorshtak(object oBOSS, int nDIFF, int nPHASE, int nROUND)
{
	
	switch (nPHASE)
	{
		case 1:
			switch (nROUND)
			{
				case 0:
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
					break;
				case 7:
					break;
				case 8:
					break;
				case 9:
					break;
				case 10:
					break;
				default:
			}
			break;
			
		default:
			switch (nROUND)
			{
				case 0:
				case 3:
				case 6:
				case 9:
					break;
				case 1:
					break;
				case 2:
					break;
				case 4:
					break;
				case 5:
					break;
				case 7:
					break;
				case 8:
					break;
				case 10:
					break;
				default:
					
			}
	}
	
}

void BossBellaville(object oBOSS, int nDIFF, int nPHASE, int nROUND)
{
	
}

void main()
{
	object oENEMY = OBJECT_SELF;
	if (GetLocalInt(oENEMY, "ENEMY_CUTSCENE") == TRUE) return;
	if (GetIsInCombat(oENEMY) == FALSE)
	{
		int nIDLE = GetLocalInt(oENEMY, "ENEMY_IDLE");
		if (nIDLE < 1) SetLocalInt(oENEMY, "ENEMY_IDLE", nIDLE + 1);
		else EncounterReset(oENEMY);
		return;
	}
	DeleteLocalInt(oENEMY, "ENEMY_IDLE");
	int nROUND = GetLocalInt(oENEMY, "ENEMY_ROUND");
	int nPHASE = GetLocalInt(oENEMY, "ENEMY_PHASE");
	int nDIFF = GetLocalInt(oENEMY, "ENEMY_DIFF");
	if (nDIFF < 1) nDIFF = 1;
	else if (nDIFF > 4) nDIFF = 4;
	int nENEMY = GetLocalInt(oENEMY, "ENEMY_HEART");
	switch (nENEMY)
	{
		case 101: BossInfiltrator(oENEMY, nDIFF, nPHASE, nROUND); break;
		case 102: BossGorshtak(oENEMY, nDIFF, nPHASE, nROUND); break;
		case 103: BossBellaville(oENEMY, nDIFF, nPHASE, nROUND); break;
		default: return;
	}
	DelayCommand(0.0f, SetLocalInt(oENEMY, "ENEMY_ROUND", nROUND + 1));
}