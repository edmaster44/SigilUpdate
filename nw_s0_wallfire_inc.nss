//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

// (Update JLR - OEI 07/19/05) -- Changed Dmg to 2d6 + lvl (max 20), double dmg to Undead


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_functions"

int GetWallOfFireDamage(object oCaster, object oTarget, struct dSpellData data, int PML, int nMetaMagic){

	int nDamage = d6(2) + (PML / 3);

	//Enter Metamagic conditions
	if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 12 + (PML / 3);
	else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += nDamage / 2;

	nDamage += data.nCL;  // JLR - OEI 07/19/05
	
	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) nDamage *= 2;

	return nDamage;
}





