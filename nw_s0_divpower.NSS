//::///////////////////////////////////////////////
//:: Divine Power
//:: NW_S0_DivPower.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 21, 2001
//:://////////////////////////////////////////////
// (Update JLR - OEI 07/19/05) -- Changed STR Bonus to +6 instead of <Min 18>
// Changed for Sigil: City of Doors

#include "ps_inc_functions"
#include "nw_i0_spells"
#include "x2_inc_spellhook"

void ApplyDivinePowerProperly(object oPC, object oTARGET, int nID, int nMETA)
{
	int nLVL = GetTotalLevels(oPC, TRUE);
    int nSPL = PS_GetCasterLevel(oPC);
	int nBAB = GetTRUEBaseAttackBonus(oPC);
	if (nSPL > nLVL) nSPL = nLVL;
    effect eVFX = EffectVisualEffect(VFX_DUR_SPELL_DIVINE_POWER);
    effect eSTR = EffectAbilityIncrease(ABILITY_STRENGTH, 6);
    effect eHP = EffectTemporaryHitpoints(nSPL);
    effect eBAB = EffectBABMinimum(nSPL);
	effect eDISP = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oPC, SPELL_DIVINE_POWER));
    effect eLINK = EffectLinkEffects(eSTR, eVFX);
	eLINK = EffectLinkEffects(eLINK, eBAB);
    eLINK = EffectLinkEffects(eLINK, eDISP);
	eLINK = SetEffectSpellId(eLINK, nID);
    eHP = EffectLinkEffects(eHP, eDISP);
	eHP = SetEffectSpellId(eHP, nID);
	
    //Fire cast spell at event for the specified target
    SignalEvent(oTARGET, EventSpellCastAt(oPC, SPELL_DIVINE_POWER, FALSE));
	
	//Meta-Magic
    if (nMETA == METAMAGIC_EXTEND) nSPL = nSPL * 2;

    //Apply Link and VFX effects to the target
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLINK, oTARGET, TurnsToSeconds(nSPL));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTARGET, TurnsToSeconds(nSPL));
}

void main()
{
	
	//Spellcast Hook Code. Added 2003-06-23 by GeorgZ.
	//If you want to make changes to all spells, check x2_inc_spellhook.nss to find out more.
	//If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
    if (!X2PreSpellCastCode()) return;

    //Declare major variables
	object oPC = OBJECT_SELF;
    object oTARGET = GetSpellTargetObject();
	int nID = GetSpellId();
	int nMETA = GetMetaMagicFeat();
    RemoveEffectsFromSpell(oTARGET, nID);
	DelayCommand(0.0, ApplyDivinePowerProperly(oPC, oTARGET, nID, nMETA));
}