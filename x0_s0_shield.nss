//::///////////////////////////////////////////////
//:: Shield
//:: x0_s0_shield.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Immune to magic Missile
    +4 general AC
    DIFFERENCES: should be +7 against one opponent
    but this cannot be done.
    Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: Last Update By: FlattedFifth, May 31, 2024

// FlattedFifth - June 3, 2024. Changed spell target from OBJECT_SELF to GetSpellTargetObject()
//				Changed vfx to get it to appear on target properly.
// Flatted Fifth June 4, 2024 - changed call from GetCasterLevel to PS_GetCasterLevel, nerfed duration from 1 hour per level
//				to 30 minutes + 1 minute per level (default is 1 minute per level, ffs)

#include "ps_inc_functions"


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 

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



    //Declare major variables
    //object oTarget = OBJECT_SELF;
	object oTarget = GetSpellTargetObject(); 
	int nID = GetSpellId();
    //effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);


    effect eArmor = EffectACIncrease(5, AC_SHIELD_ENCHANTMENT_BONUS);	// AFW-OEI 11/02/2006 change from Deflection to Shield bonus.
    effect eSpell = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
   	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_SHIELD_OF_FAITH);
//	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_SANCTUARY);
//	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

    effect eLink = EffectLinkEffects(eArmor, eSpell);
  

    //float fDuration = HoursToSeconds(PS_GetCasterLevel(OBJECT_SELF)); //Duration 1 hour per level, not my change but the comment was wrong -FlattedFifth
    float fDuration = IntToFloat((60 * 30) + (60 * PS_GetCasterLevel(OBJECT_SELF))); // still too long but w/e, FlattedFifth
	fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nID, FALSE));


    //RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());
	RemoveEffectsFromSpell(oTarget, nID);
    
    //Apply VFX impact and bonus effects
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(nDurType, eDur, oTarget, fDuration);
	ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}