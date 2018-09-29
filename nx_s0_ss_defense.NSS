// Defensive spell Script for NX1 Silver Sword of Gith
// Adds combination premonition and spell mantle spell to sword.
// CGaw OEI 6/19/07

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void PlayCustomAnimationWrapper(object oObject, string sAnimationName, int nLoop, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, nLoop, fSpeed);
}

void CastSpell()
{
    /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,`
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    object oTarget = GetSpellTargetObject();
	


    //Declare major variables
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamageLimit = nCasterLevel * 10;
    int nMetaMagic = GetMetaMagicFeat();
    effect eStone = EffectDamageReduction(30, GMATERIAL_METAL_ADAMANTINE, nDamageLimit, DR_TYPE_GMATERIAL);
//  effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
//	eStone = EffectLinkEffects(eStone, eVis);
	float fSpellDuration = HoursToSeconds(nCasterLevel);	
	
//    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SPELL_MANTLE );
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nAbsorb = d8() + 8;
	
    effect eAbsob = EffectSpellLevelAbsorption(9, nAbsorb);
//    effect eLink = EffectLinkEffects(eDur, eAbsob);
	
    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveEffectsFromSpell(oTarget, SPELL_LEAST_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);

    //Apply the VFX impact and effects
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbsob, oTarget, RoundsToSeconds(nDuration));

	
    RemoveEffectsFromSpell(oTarget, SPELL_PREMONITION);
    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, fSpellDuration);
}

void main()
{
	object oCaster = OBJECT_SELF;
	
	effect eCastVis1 = EffectNWN2SpecialEffectFile("sp_magic_circle.sef");
	effect eCastVis2 = EffectNWN2SpecialEffectFile("sp_abjuration_aoe.sef");
	effect eCastVis3 = EffectNWN2SpecialEffectFile("sp_transmutation_aoe_2.sef");
	effect eCastVis4 = EffectNWN2SpecialEffectFile("sp_sanctuary_hit.sef");
	
	DelayCommand(0.75f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCastVis1, oCaster));
	DelayCommand(1.75f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCastVis2, oCaster));
	DelayCommand(2.75f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCastVis3, oCaster));
	DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCastVis4, oCaster));
	
	PlayCustomAnimationWrapper(oCaster, "1hs_2attack02", 0, 0.75f);
	DelayCommand(1.0f, PlayCustomAnimationWrapper(oCaster, "throwarmsloop", 0, 1.0f));
	DelayCommand(2.0f, PlayCustomAnimationWrapper(oCaster, "%", 0, 1.0f));
	
	DelayCommand(2.0f, CastSpell());
}