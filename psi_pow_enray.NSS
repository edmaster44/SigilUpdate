/*
   ----------------
   Energy Ray

   prc_all_enrayf
   ----------------

   30/10/04 by Stratovarius
*/ /** @file
    Energy Ray

    Psychokinesis [see text]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Chain, Empower, Maximize, Split Psionic Ray, Twin

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You create a ray of energy of the chosen type that shoots forth from your
    fingertip and strikes a target within range, dealing 1d6 points of damage,
    if you succeed on a ranged touch attack with the ray.

    Cold: A ray of this energy type deals +1 point of damage per die.
    Electricity: Manifesting a ray of this energy type provides a +2 bonus on
                 manifester level checks for the purpose of overcoming power
                 resistance.
    Fire: A ray of this energy type deals +1 point of damage per die.
    Sonic: A ray of this energy type deals -1 point of damage per die and
           ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power�s damage increases by one die (d6).
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_enrgypow"

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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nSpell = GetSpellId();
	
	// constrain to allowed values
		if(nSpell<14376 || nSpell>14379)
		nSpell=14375 + Random(4);

        int nPen             = GetPsiPenetration(oManifester);
        int nNumberOfDice    = 1;
		int nBonus;
        int nTouchAttack,
            nOriginalDamage,
			nBeam,
            nDamage,
			nDamageType,
            i;
        effect eVis;
        effect eRay,
               eDamage;
        object oChainTarget;
		
		if(nSpell == 14376)
		{
			nBeam = VFX_BEAM_COLD;
			nDamageType = DAMAGE_TYPE_COLD;
			nBonus = 1;
		}
		if(nSpell == 14377)
		{
			nBeam = VFX_BEAM_LIGHTNING;
			nDamageType = DAMAGE_TYPE_ELECTRICAL;
			nPen = nPen + 3;
			nBonus = 0;
		}
		if(nSpell == 14378)
		{
			nBeam = VFX_BEAM_FIRE;
			nDamageType = DAMAGE_TYPE_FIRE;
			nBonus = 1;
		}
		if(nSpell == 14379)
		{
			nBeam = VFX_BEAM_SONIC;
			nDamageType = DAMAGE_TYPE_SONIC;
			nBonus = -1;
		}
		
        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Touch attack the main target
            nTouchAttack = TouchAttackRanged(oTarget);

            // Shoot the ray
            eRay = EffectBeam(nBeam, oManifester, BODY_NODE_HAND, !(nTouchAttack > 0));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7f);

            if(nTouchAttack > 0)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Roll damage
                    nDamage = d6(nNumberOfDice)+ nBonus;
					if (manif.bAugment)
					nNumberOfDice += 1;
					if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 1)
					{
						nDamage = 6 + nBonus;
					}
					if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
		            {
		                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
		            }
					effect eDamage = EffectDamage(nDamage, nDamageType);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                }// end if - SR check
            }// end if - Touch attack hit
        }// end for - Twin Power
    }// end if - Successfull manifestation
}