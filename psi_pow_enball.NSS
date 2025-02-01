/*
   ----------------
   Energy Ball

   psi_pow_enball
   ----------------

   31/7/05 by Stratovarius
*/ /** @file

    Energy Ball

    Psychokinesis [see text]
    Level: Kineticist 4
    Manifesting Time: 1 standard action
    Range: Long (400 ft. + 40 ft./level)
    Area: 20-ft.-radius spread
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You create an explosion of energy of the chosen type that deals 7d6 points
    of damage to every creature or object within the area. The explosion creates
    almost no pressure.

    Cold: A ball of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold ball is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a ball of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A ball of this energy type deals +1 point of damage per die.
    Sonic: A ball of this energy type deals -1 point of damage per die and
           ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power�s damage
             increases by one die (d6). For each extra two dice of damage, this
             power�s save DC increases by 1.

    @todo 2da
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

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, 14529, 14530, 14531, 14532,
                           VFX_FNF_ICESTORM, VFX_FNF_ELECTRIC_EXPLOSION, VFX_FNF_FIREBALL, VFX_FNF_SOUND_BURST);
        int nDC           = GetManifesterDC(oManifester) + enAdj.nDCMod;
		if (manif.bAugment)
			nDC += 2;
        int nPen          = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice = 8;
		if (manif.bAugment)
			nNumberOfDice += 3;
        int nDieSize      = 6;
        int nDamage;
        location lOrigin  = GetSpellTargetLocation();
        float fRadius     = FeetToMeters(20.0f);
		if (manif.bWiden)
			fRadius *= 2;
        float fDelay;
        effect eVis       = EffectVisualEffect(enAdj.nVFX1);
        effect eFNF       = EffectVisualEffect(enAdj.nVFX2);
        effect eDamage;
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do area VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lOrigin);

            // Loop over targets in the line shape
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lOrigin, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                // Difficulty & faction limits on targeting
                if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester))
                {
                    // Make an SR check
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Roll damage
                        nDamage = d6(nNumberOfDice);
						if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 1)
						{
							nDamage = 6*nNumberOfDice;
						}
						if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
			            {
			                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
			            }
                        // Do save
                        if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                        {
                            // Cold has a fort save for half
                            if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, enAdj.nSaveType))
                                nDamage /= 2;
                        }
						
						
                        else
                            // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

                        if(nDamage > 0)
                        {
                            eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                            fDelay = GetDistanceBetweenLocations(lOrigin, GetLocation(oTarget)) / 20.0f;
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }// end if - There was still damage remaining to be dealt after adjustments
                    }// end if - SR check
                }// end if - Allowed to target this object

                // Get next target
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lOrigin, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}