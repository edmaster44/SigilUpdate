//::///////////////////////////////////////////////
//:: Psionic Inertial Barrier
//:: x2_s1_psibarr.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Caster gains Damage Reduction that absorbs
    10 points of damage per hit die and lasts
    1 round per hit die

    damage power is +20 for illithids and
    shifter level /3

    Reduction is 10 + some amount per level

    Used by illithids and shifters
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Sept 2003
//:://////////////////////////////////////////////

// edited by Agony_Aunt for SCoD PW

void main()
{
    //Declare major variables
	object oPC = OBJECT_SELF;
	int iLevel = GetTotalLevels(oPC, TRUE);
	int iLimit = iLevel*10;
    int iMax = iLevel*2;
    
    object oTarget = oPC;
    effect eVis = EffectNWN2SpecialEffectFile("sp_inertial_barrier.sef", oTarget);
    effect eDam = EffectDamageReduction(iMax, DAMAGE_POWER_PLUS_TWENTY, iLimit);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDam, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    effect eImpact = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Apply the VFX impact and effects
    if (!GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(GetTotalLevels(oPC, TRUE)));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
}