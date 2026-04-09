/*
   ----------------
   Energy Adaptation

   psi_pow_enadapt
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Energy Adaptation

    Psychometabolism [Acid, Cold, Electricity, Fire, Sonic]
    Level: Psion/wilder 4, psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 7
    Metapsionics: Extend

    Your body assimilates some of the effect of an energy attack and converts it
    to harmless light. You gain resistance 10 against any attack that deals
    acid, cold, electricity, fire, or sonic damage.

    When you absorb damage, you radiate visible light that illuminates a 60-foot
    radius for a number of rounds equal to the points of damage you successfully
    resisted.

    The energy resistance provided by this power increases to 20 points at 9th
    manifester level and to a maximum of 30 points at 13th level.
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
	// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        float fDuration = 600.0 * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;
        int nResist;
        if     (manif.nManifesterLevel < 9)  nResist = 10;
        else if(manif.nManifesterLevel < 13) nResist = 20;
        else                                 nResist = 30;

        effect eLink =                          EffectDamageResistance(DAMAGE_TYPE_ACID,       nResist);
               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD,       nResist));
               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist));
               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE,       nResist));
               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC,      nResist));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_LIGHT_ORANGE_15));
        effect eVis  = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}