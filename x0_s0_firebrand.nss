//::///////////////////////////////////////////////
//:: Firebrand
//:: x0_x0_Firebrand
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// * Fires a flame arrow to every target in a
// * colossal area
// * Each target explodes into a small fireball for
// * 1d6 damage / level (max = 15 levels)
// * Only nLevel targets can be affected
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 29 2002
//:://////////////////////////////////////////////
//:: Last Updated By:
// ChazM 10/19/06 - modified params to DoMissileStorm()
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_functions"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
	if (!X2PreSpellCastCode())
	{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}

// End of Spell Cast Hook

	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	int nPML = PS_GetPureMageCL(OBJECT_SELF);
	int nDamageDice;

	if (nCL < ITEM_MIN_CL && !GetIsObjectValid(GetSpellCastItem())){
		nDamageDice = ITEM_MIN_CL + nPML;
	}
	else
	{
		nDamageDice = nCL + nPML;
	}

	DoMissileStorm(nDamageDice, 30, SPELL_FIREBRAND, VFX_HIT_SPELL_FIRE, DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE, 1);
}