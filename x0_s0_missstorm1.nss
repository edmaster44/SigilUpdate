//::///////////////////////////////////////////////
//:: Isaacs Lesser Missile Storm
//:: x0_s0_MissStorm1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 10 missiles, each doing 1d6 damage to all
 targets in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:
// ChazM 10/19/06 - modified params to DoMissileStorm()
//Mymothersmeatloaf 6/21/2020: Added missiles damage from casting stat
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
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nDamageDice = (nCL/3) + (PML/6);
	if (nCL < 20 && !GetIsObjectValid(GetSpellCastItem())){
	nDamageDice = (20/3) + (PML/6);
	} 
	
// End of Spell Cast Hook

   //SpawnScriptDebugger();
    DoMissileStorm(nDamageDice, 30, SPELL_ISAACS_LESSER_MISSILE_STORM, VFX_IMP_MAGBLUE, DAMAGE_TYPE_MAGICAL, -1, 1);
}