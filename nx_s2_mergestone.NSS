//::///////////////////////////////////////////////
//:: Merge with Stone
//:: nx_s2_mergestone
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	This spell is based on the Stoneskin spell
	(nw_s0_stoneskn).

    Gives the creature touched 5/Adamantine
    damage reduction.  This lasts for five rounds
	or until twenty points of damage are absorbed.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////


#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget  = OBJECT_SELF;
    int iCasterLevel = GetTotalLevels(oTarget, TRUE);
	int nAmount     = iCasterLevel * 10;
	
    float fDuration = RoundsToSeconds(5 + iCasterLevel);
    fDuration       = ApplyMetamagicDurationMods(fDuration);
    int nDurType    = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Define the damage reduction effect
	int iReduction = iCasterLevel;
	if (iReduction < 5) iReduction = 5;
	
    effect eStone = EffectDamageReduction(iReduction, GMATERIAL_METAL_ADAMANTINE, nAmount, DR_TYPE_GMATERIAL);
    effect eVis1  = EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );
	eStone        = EffectLinkEffects( eStone, eVis1 );
	eStone = ExtraordinaryEffect(eStone);

	
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MERGE_WITH_STONE, FALSE));
	RemoveEffectsFromSpell(oTarget, SPELLABILITY_MERGE_WITH_STONE);
    ApplyEffectToObject(nDurType, eStone, oTarget, fDuration);
}