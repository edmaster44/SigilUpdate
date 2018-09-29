/*
   ----------------
   Inertial Barrier

   psi_pow_inertbar
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Inertial Barrier

    Psychokinesis
    Level: Kineticist 4, psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 7
    Metapsionics: Extend

    You create a skin-tight psychokinetic barrier around yourself that resists
    blows, cuts, stabs, and slashes. You gain damage reduction 5/-.
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
                              METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT
                              );

    if(manif.bCanManifest)
    {
        // Determine amount of damage reduction and duration
        int nDamageReduction = 5;
		if (manif.bAugment)
			nDamageReduction += 2;
        float fDur = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        // Create effects
    	effect eLink =                          EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nDamageReduction);
    	       eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    nDamageReduction));
    	       eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    nDamageReduction));
    	       eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("psi_inertialbarrier.sef"));

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }
}