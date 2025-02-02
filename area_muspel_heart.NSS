#include "ff_safevar"

#include "sigil_enemy_inc"
#include "x0_i0_position"

void ExecuteCustomMeteorSwarm(object oTarget)
{
	if (oTarget == OBJECT_INVALID) return;
	
	location lTarget = GetLocation(oTarget);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM);
	float fTravelTime;
	// 6.0 is the duration of the bombardment; 8 is the number of meteors that will spawn regardless of targets
	float fDelay = 6.0f / 8.0f;	
	float fDelay2 = 0.0f;
	string sWP = "wp_party_central";
	location lWP;
	object oWP;
	int nDIR = 1;
	while (nDIR <= 8)
	{
		switch (nDIR)
		{
			case 1: lWP = GetAheadLocation(oTarget); break;
			case 2: lWP = GetBehindLocation(oTarget); break;
			case 3: lWP = GetRightLocation(oTarget); break;
			case 4: lWP = GetLeftLocation(oTarget); break;
			case 5: lWP = GetAheadLeftLocation(oTarget); break;
			case 6: lWP = GetAheadRightLocation(oTarget); break;
			case 7: lWP = GetFlankingLeftLocation(oTarget); break;
			case 8: lWP = GetFlankingRightLocation(oTarget); break;
			default: return;
		}
		fTravelTime = GetProjectileTravelTime(lTarget, lWP, PROJECTILE_PATH_TYPE_DEFAULT);
		oWP = CreateObject(OBJECT_TYPE_WAYPOINT, sWP, lWP);
		DelayCommand(fDelay2, SpawnSpellProjectile(oTarget, oWP, lTarget, lWP, SPELL_METEOR_SWARM, PROJECTILE_PATH_TYPE_DEFAULT));
		DelayCommand(fDelay2 + fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lWP));
		fDelay2 = fDelay2 + fDelay;
		DestroyObject(oWP, 6.0);
		nDIR = nDIR + 1;
	}
}

void main()
{
	object oAREA = OBJECT_SELF;
	if (PS_GetLocalInt(oAREA, "WRECK_HAVOC") != TRUE) return;
	int nDIFF = PS_GetLocalInt(oAREA, "ENEMY_DIFF");
	if (nDIFF < 1) nDIFF = 1;
	else if (nDIFF > 4) nDIFF = 4;
	int nCOUNT;
	string sPOINT = "vfx_muspel_swarm";
	location lPOINT;
	object oPOINT = GetObjectByTag(sPOINT);
	while (oPOINT != OBJECT_INVALID)
	{
		//ActionCastFakeSpellAtLocation(SPELL_METEOR_SWARM_TARGET_LOCATION, GetLocation(oPOINT));
		ExecuteCustomMeteorSwarm(oPOINT);
		nCOUNT = nCOUNT + 1;
		oPOINT = GetObjectByTag(sPOINT, nCOUNT);
	}
	int nIGNORE = 25 * nDIFF;
	object oPC = GetFirstObjectInArea(oAREA);
	while (oPC != OBJECT_INVALID)
	{
		if (GetIsOwnedByPlayer(oPC) == TRUE) InflictDamage(oPC, 100, DAMAGE_TYPE_FIRE, nIGNORE);
		oPC = GetNextObjectInArea(oAREA);
	}
}