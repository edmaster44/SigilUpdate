/*
   ----------------
   Ectoplasmic Form

   psi_pow_ectoform
   ----------------

   14/5/05 by Stratovarius
*/ /** @file

    Ectoplasmic Form

    Psychometabolism
    Level: Egoist 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 5
    Metapsionics: Extend

    You and all your gear become a partially translucent mass of rippling
    ectoplasm that generally conforms to your normal shape. You gain damage
    reduction 10/+2, and you gain immunity to poison and critical hits. Your
    material armor becomes meaningless, although your size, Dexterity,
    deflection bonuses, and armor bonuses from force effects (such as those
    gained by inertial armor) still apply to your Armor Class.

    You can manifest powers while in ectoplasmic form, but you must make a
    Concentration check (DC 20 + power level) for each power you attempt to
    manifest.


    @todo 2da entries
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/
    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
    	effect eVis     = EffectVisualEffect(VFX_DUR_INVISIBILITY);
        effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		effect ePois = EffectImmunity(IMMUNITY_TYPE_POISON);
		effect eDam = EffectDamageReduction(5, DAMAGE_TYPE_MAGICAL, 0);
		effect eCon = EffectSkillDecrease(1, 10);
        effect eDur     = EffectNWN2SpecialEffectFile("psi_ectoplasmic_form.sef");
        effect eLink    = EffectLinkEffects(eDur, eCrit);
		eLink    = EffectLinkEffects(eLink, eCon);
		eLink    = EffectLinkEffects(eLink, eDam);
		eLink    = EffectLinkEffects(eLink, ePois);

        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}