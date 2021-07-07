//::///////////////////////////////////////////////
//:: Isaacs Greater Missile Storm
//:: x0_s0_MissStorm2
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 20 missiles, each doing 3d6 damage to each
 target in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:
// ChazM 10/19/06 - modified params to DoMissileStorm()
// 6/21/2020 Will do extra 1d6 for every 4 points invested in int.

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nDamageDice = (2*nCL)/3;
	
    DoMissileStorm(nDamageDice, 30, SPELL_ISAACS_GREATER_MISSILE_STORM, VFX_IMP_MAGBLUE, DAMAGE_TYPE_MAGICAL, -1, 1);
}