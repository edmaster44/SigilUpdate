//::///////////////////////////////////////////////
//:: Avoid Planar Effects
//:: NW_S0_ProEnergy
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Offers 30 points of elemental resistance.  If 40
    points of a single elemental type is done to the
    protected creature the spell fades
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

#include "nw_i0_spells"
#include "nwn2_inc_spells"
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
	int nDuration = GetCasterLevel(OBJECT_SELF);
    
    int nResistance = 2;
    int nMetaMagic = GetMetaMagicFeat();
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, 0);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, 0);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResistance, 0);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResistance, 0);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, 0);
    effect eDur = EffectNWN2SpecialEffectFile("sp_avoidplanareffects.sef", oTarget);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1390, FALSE));	// JLR - OEI 07/11/05 -- Name Changed

    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eElec);
    eLink = EffectLinkEffects(eLink, eDur);
	
	float fDuration = IntToFloat(nDuration);


    //Check for metamagic extension
	fDuration = ApplyMetamagicDurationMods( fDuration );
    int nDurType = ApplyMetamagicDurationTypeMods( DURATION_TYPE_TEMPORARY );
    
     RemoveEffectsFromSpell(oTarget, GetSpellId());
    
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}