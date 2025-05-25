
/*
   ----------------
   Energy Stun

   psi_pow_enstun
   ----------------

   6/11/04 by Stratovarius
*/ /** @file

    Energy Stun

    Psychokinesis [see text]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Area: 5-ft.-radius burst
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You release a powerful stroke of the chosen energy type that encircles all
    creatures in the area, dealing 1d6 points of damage to each of them. In
    addition, any creature that fails its save for half damage must succeed on
    a Will save or be stunned for 1 round.

    Cold: A stroke of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold stun is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a stroke of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A stroke of this energy type deals +1 point of damage per die.
    Sonic: A stroke of this energy type deals -1 point of damage per die and
           ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power�s damage
             increases by one die (d6) and its save DC increases by 1.
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, 14435, 14436, 14437, 14438,
                           VFX_FNF_ICESTORM, VFX_FNF_ELECTRIC_EXPLOSION, VFX_FNF_FIREBALL, VFX_FNF_SOUND_BURST);
        int nDC           = GetManifesterDC(oManifester) + enAdj.nDCMod;
		if (manif.bAugment)
			nDC += 1;
        int nPen          = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice = 1;
		if (manif.bAugment)
			nNumberOfDice += 1;
        int nDamage, bStun;
        location lTarget  = GetSpellTargetLocation();
        float fRadius     = FeetToMeters(5.0f);
		if (manif.bWiden)
			fRadius *= 2.0f;
        float fDelay;
        effect eVis       = EffectVisualEffect(enAdj.nVFX1);
        effect eExplode   = EffectVisualEffect(enAdj.nVFX2);
        effect eLink      =                          EffectStunned();
               
        effect eStun      = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_STUN));
        effect eDamage;
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do area VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

            // Loop over targets in the line shape
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&
                   GetIsEnemy(oTarget, oManifester)
                   )
                {
                    // Make an SR check
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Reset stun marker
                        bStun = FALSE;
                        // Roll damage
						nDamage = d6(nNumberOfDice)+(enAdj.nBonusPerDie*nNumberOfDice);
						if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXMIZE") == 1)
						{
							nDamage = 6 + (enAdj.nBonusPerDie*nNumberOfDice);
						}
						if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
			            {
			                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
			            }

                        // Do save
                        if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                        {
                            // Cold has a fort save for half
                            if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, enAdj.nSaveType))                     
                                nDamage /= 2;
                            // Failed save, now Will save vs Stun
                            else if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                                bStun = TRUE;
                        }
                        else {
                            // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                            if(nDamage == (nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType))) {
                                // Failed save, now Will save vs Stun
                                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                                    bStun = TRUE;
							}
						}

                        // Damage, VFX and stun if the target didn't manage to avoid the whole thing (Evasion)
                        if(nDamage > 0)
                        {
                            eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) / 20.0f;
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                            if(bStun)
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0f));
                        }// end if - There was still damage remaining to be dealt after adjustments
                    }// end if - SR check
                }// end if - Target validity check

                // Get next target
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end if - Twin Power
    }// end if - Successfull manifestation
}