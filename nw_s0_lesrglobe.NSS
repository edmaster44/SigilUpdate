//::///////////////////////////////////////////////
//:: Lesser Globe of Invulnerability
//:: NW_S0_LesrGlobe.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster is immune to 3rd levels spells and lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

// Flatted Fifth June 4, 2024 - Changed duration from 6 seconds per level to 30 seconds + 5 seconds per level,
//					changed call to GetCasterLevel to PS_GetCasterLevel, made able to target allies

#include "ps_inc_functions"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


	//Declare major variables
    object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_GLOBE_INV_LESS);
    effect eSpell = EffectSpellLevelAbsorption(3, 0);
    //Link Effects
    effect eLink = EffectLinkEffects(eVis, eSpell);
    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
	//nDuration = RoundsToSeconds(nDuration);  // default duration
	nDuration = 30 + (6 * nDuration);
	if (nDuration > 180) nDuration = 180;
    int nMetaMagic = GetMetaMagicFeat();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_GLOBE_OF_INVULNERABILITY, FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, IntToFloat(nDuration));
}