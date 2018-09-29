/*
   ----------------
   Energy Adaption, Specified

   psi_pow_enadpts
   ----------------

   6/11/04 by Stratovarius
*/ /**

    Energy Adaption, Specified

    Psychometabolism [see text]
    Level: Psion/wilder 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 3
    Metapsionics: Extend

    Your body assimilates some of the effect of an energy attack and converts it
    to harmless light. You gain resistance 10 against any attack that deals
    acid, cold, electricity, fire, or sonic damage.

    When you absorb damage, you radiate visible light that illuminates a 60-foot
    radius for a number of rounds equal to the points of damage you successfully
    resisted.

    The energy resistance provided by this power increases to 20 points at 9th
    manifester level and to a maximum of 30 points at 13th level.

    This power�s subtype is the same as the type of damage it protects against.
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
        int nResist, nEnergyType, nVFX;
        if     (manif.nManifesterLevel < 9)  nResist = 10;
        else if(manif.nManifesterLevel < 13) nResist = 20;
        else                                 nResist = 30;

        switch(manif.nSpellID)
        {
            case 14421:
                nEnergyType = DAMAGE_TYPE_ACID;
                nVFX        = VFX_DUR_LIGHT_GREY_10;
                break;
            case 14422:
                nEnergyType = DAMAGE_TYPE_COLD;
                nVFX        = VFX_DUR_LIGHT_BLUE_10;
                break;
            case 14423:
                nEnergyType = DAMAGE_TYPE_ELECTRICAL;
                nVFX        = VFX_DUR_LIGHT_YELLOW_10;
                break;
            case 14424:
                nEnergyType = DAMAGE_TYPE_FIRE;
                nVFX        = VFX_DUR_LIGHT_RED_10;
                break;
            case 14425:
                nEnergyType = DAMAGE_TYPE_SONIC;
                nVFX        = VFX_DUR_LIGHT_WHITE_10;
                break;

            default:
                return;
        }

        int nProtection = VFX_DUR_PROTECTION_ELEMENTS; /// @todo Remove once the VFX_DUR_PROTECTION_ENERGY_* are working

        effect eLink =                          EffectDamageResistance(nEnergyType, nResist);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(nVFX));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(nProtection));
        effect eVis  = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}