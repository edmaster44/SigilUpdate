//::///////////////////////////////////////////////
//:: Invocation: Darkness
//:: NW_S0_IDarkness.nss
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Mimi Fearthegn 7/26/20 - Turned this into Call of the Beast

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_planarlocations"
#include "ps_inc_onhit"

//picks out the right creature resref for area / hd
string GetCreatureResref(object oPC, int nHD);

//Spawns in the actual creature and assigns variables
void SpawnInSummon(object oPC, string sResRef);

void main() {

	/* 
	  Spellcast Hook Code 
	  Added 2003-06-23 by GeorgZ
	  If you want to make changes to all spells,
	  check x2_inc_spellhook.nss to find out more
	*/
    if (!X2PreSpellCastCode()) {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    //Declare major variables
	object oCaster = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	
	int nCreatures = 1+(nCasterLevel/5);
	int nHD = 1+(nCasterLevel/3);
	
	SendMessageToPC(oCaster, "Summoning "+IntToString(nCreatures)+" creatures of "+IntToString(nHD)+" HD");
	
	string sCreature = GetCreatureResref(oCaster, nHD);
	SendMessageToPC(oCaster, "Chosen creature: "+sCreature);
	
	float fDelay = 0.0f;
	int nSpawned = 0;
	
	for (nSpawned = 0; nSpawned < nCreatures; nSpawned++) {
		DelayCommand(fDelay, SpawnInSummon(oCaster, sCreature));
		fDelay += 0.5f;
	}
	
}

void SpawnInSummon(object oPC, string sResRef) {

	SendMessageToPC(oPC, "Creating "+sResRef);

	location lTarget = CalcSafeLocation(oPC, GetLocation(oPC), 8.0f, TRUE, FALSE);
	effect eVFX = EffectNWN2SpecialEffectFile("fx_teleport_new");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
	
	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget);
	SetLocalObject(oCreature, abilityCaster, oPC);
	SetLocalObject(oCreature, "FOLLOW_MASTER", oPC);
}

string GetCreatureResref(object oPC, int nHD) {

	string sPlane = GetPlanarArea(oPC);
	
	if (nHD <= 2)
		nHD = 1;
	else if (nHD <= 5)
		nHD = 2;
	else if (nHD <= 8)
		nHD = 3;
	else
		nHD = 4;
	
	string sRealHD = IntToString(nHD);
	
	if (sPlane == ELEMENTAL_AIR)
		return "ps_summon_cob_air"+sRealHD;
	else if (sPlane == ELEMENTAL_FIRE || sPlane == ELEMENTAL_MAGMA)
		return "ps_summon_cob_fire"+sRealHD;
	else if (sPlane == ELEMENTAL_WATER || sPlane == ELEMENTAL_ICE)
		return "ps_summon_cob_water"+sRealHD;
	else if (sPlane == ELEMENTAL_EARTH || sPlane == ELEMENTAL_OOZE)
		return "ps_summon_cob_earth"+sRealHD;
		
	else if (GetPlanarAlignmentLawChaos(sPlane) == STRONG_CHAOS || GetPlanarAlignmentGoodEvil(sPlane) == MILD_CHAOS)
		return "ps_summon_cob_chaos"+sRealHD;
	else if (GetPlanarAlignmentLawChaos(sPlane) == STRONG_LAW || GetPlanarAlignmentGoodEvil(sPlane) == MILD_LAW)
		return "ps_summon_cob_law"+sRealHD;
	else if (GetPlanarAlignmentGoodEvil(sPlane) == STRONG_EVIL || GetPlanarAlignmentGoodEvil(sPlane) == MILD_EVIL)
		return "ps_summon_cob_evil"+sRealHD;
	else if (GetPlanarAlignmentGoodEvil(sPlane) == STRONG_GOOD || GetPlanarAlignmentGoodEvil(sPlane) == MILD_GOOD)
		return "ps_summon_cob_good"+sRealHD;

	return "ps_summon_cob_fey"+sRealHD;

}