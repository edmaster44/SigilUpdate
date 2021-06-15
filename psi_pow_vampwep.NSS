/*
   ----------------
   Vampiric Blade

   psi_pow_vampwep
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Vampiric Blade

    Psychometabolism
    Level: Psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 5
    Metapsionics: Extend

    When this power is manifested, your weapon takes on an
    ominous glimmer. Each time you make a successful attack against a
    living creature, you are healed of some amount of damage.

    Your weapon attack gains the vampiric regeneration quality, with power equal
    to half your manifester level for the duration of the power.
*/


#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"


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

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = IPGetTargetedOrEquippedMeleeWeapon();
    
    // Validity check
    if(!GetIsObjectValid(oTarget))
    {
        FloatingTextStrRefOnCreature(83615, oManifester); // Item must be weapon or creature holding a weapon
    	return;
    }    
       struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis         = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
        itemproperty ipVReg =  ItemPropertyVampiricRegeneration (manif.nManifesterLevel / 2);
        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Apply the itemproperties
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipVReg, oTarget, fDuration);

        // Do some VFX
                           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
    }
}