#include "ff_safevar"

void SpawnProperGroup(object oSPAWN, location lSPAWN)
{
	if (PS_GetLocalInt(oSPAWN, "SPAWNED") == TRUE) return;
	PS_SetLocalInt(oSPAWN, "SPAWNED", TRUE);
	DelayCommand(1.0, PS_DeleteLocalInt(oSPAWN, "SPAWNED")); //To avoid double spawns.
	string sENEMY;
	object oENEMY;
	int nSPAWN;
	int nENEMY;
	int nCOUNT = 1;
	while (nCOUNT < 5)
	{
		nENEMY = PS_GetLocalInt(oSPAWN, "ENEMY_QTY_" + IntToString(nCOUNT));
		if (nENEMY < 1) return;
		if (nENEMY > 10) nENEMY = 10; //Sanity Check
		nSPAWN = 0;
		sENEMY = PS_GetLocalString(oSPAWN, "ENEMY_TAG_" + IntToString(nCOUNT));
		while (nSPAWN < nENEMY)
		{
			oENEMY = CreateObject(OBJECT_TYPE_CREATURE, sENEMY, lSPAWN);
			nSPAWN = nSPAWN + 1;
		}
		nCOUNT = nCOUNT + 1;
	}
}

void main()
{
	object oPC = GetLastPerceived();
	if (GetObjectType(oPC) != OBJECT_TYPE_CREATURE) return;
	if (GetResRef(oPC) == "sigil_mobs") return;
	object oSPAWN = OBJECT_SELF;
	SetScriptHidden(oSPAWN, TRUE);
	location lSPAWN = GetLocation(oSPAWN);
	object oNPC = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lSPAWN);
	while (oNPC != OBJECT_INVALID)
	{
		if (GetIsEnemy(oNPC, oSPAWN) == TRUE)
		{
			//There are monsters spawned already. Check again in 30 seconds.
			DelayCommand(30.0, SetScriptHidden(oSPAWN, FALSE));
			return;
		}
		oNPC = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lSPAWN);
	}
	if (GetIsPC(oPC) == FALSE) return;
	float fRESPAWN = PS_GetLocalFloat(oSPAWN, "RESPAWN");
	if (fRESPAWN <= 0.0f) fRESPAWN = 300.0;
	int nDIFF = PS_GetLocalInt(oPC, "DIFF");
	if (nDIFF < 1) nDIFF = 1;
	else if (nDIFF > 4) nDIFF = 4;
	PS_SetLocalInt(oSPAWN, "ENEMY_DIFF", nDIFF);
	DelayCommand(0.0f, SpawnProperGroup(oSPAWN, lSPAWN));
	DelayCommand(fRESPAWN, SetScriptHidden(oSPAWN, FALSE));	
}