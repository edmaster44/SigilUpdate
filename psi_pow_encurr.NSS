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
		struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, 14565, 14566, 14567, 14568,
                           VFX_FNF_ICESTORM, VFX_FNF_ELECTRIC_EXPLOSION, VFX_FNF_FIREBALL, VFX_FNF_SOUND_BURST);
	
	// constrain to allowed values
		if(nSpell<14565 || nSpell>14568)
		nSpell=14564 + Random(4);

        int nPen             = GetPsiPenetration(oManifester);
        int nNumberOfDice    = 9;
		int nDC           = GetManifesterDC(oManifester) + enAdj.nDCMod;
		int nBonus;
		object oFirstTarget = GetSpellTargetObject();
		object oHolder;
        int nOriginalDamage,
			nDamStrike,
			nBeam,
			nSavingThrowType,
            nDamage,
			nDamageType,
            i;
        effect eVis;
        effect eRay,
               eDamage;
        object oChainTarget;
		
		if(nSpell == 14565)
		{
			nBeam = VFX_BEAM_COLD;
			nDamageType = DAMAGE_TYPE_COLD;
			nSavingThrowType = SAVING_THROW_TYPE_COLD;
			nBonus = 1;
		}
		if(nSpell == 14566)
		{
			nBeam = VFX_BEAM_LIGHTNING;
			nDamageType = DAMAGE_TYPE_ELECTRICAL;
			nSavingThrowType = SAVING_THROW_TYPE_ELECTRICITY;
			nPen = nPen + 3;
			nBonus = 0;
		}
		if(nSpell == 14567)
		{
			nBeam = VFX_BEAM_FIRE;
			nDamageType = DAMAGE_TYPE_FIRE;
			nSavingThrowType = SAVING_THROW_TYPE_FIRE;
			nBonus = 1;
		}
		if(nSpell == 14568)
		{
			nBeam = VFX_BEAM_SONIC;
			nDamageType = DAMAGE_TYPE_SONIC;
			nSavingThrowType = SAVING_THROW_TYPE_SONIC;
			nBonus = -1;
		}
		
        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Touch attack the main target
            

            // Shoot the ray
            eRay = EffectBeam(nBeam, oManifester, BODY_NODE_HAND);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oFirstTarget, 1.7f);

            if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oTarget, nPen))
                {
                    // Roll damage
                    nDamage = d6(nNumberOfDice)+ nBonus;
					if (manif.bAugment)
					nNumberOfDice += 6;
					if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXMIZE") == 1)
					{
						nDamage = 54 + nBonus;
					}
					if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
		            {
		                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
		            }
					nDamStrike = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSavingThrowType);
					effect eDamage = EffectDamage(nDamStrike, nDamageType);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                }// end if - SR check
            }
			
			float fDelay = 0.2;
    		int nCnt = 0;
			
			eRay = EffectBeam(nBeam, oFirstTarget, BODY_NODE_HAND);
			
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
		    while (GetIsObjectValid(oTarget) && nCnt < manif.nManifesterLevel)
		    {
		        //Make sure the caster's faction is not hit and the first target is not hit
		        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
		        {
		            //Connect the new lightning stream to the older target and the new target
		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eRay,oTarget,0.5));
		
		            //Fire cast spell at event for the specified target
		            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
		            //Do an SR check
		            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
		            {
		
		                nDamage = d6(nNumberOfDice) ;
		
		                if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXMIZE") == 1)
		                {
		                    nDamage = 54;//Damage is at max
		                }
		                if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
		                {
		                    nDamage = nDamage + (nDamage/2); //Damage/is +50%
		                }
		                //Adjust damage via Reflex Save or Evasion or Improved Evasion
		                nDamStrike = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSavingThrowType);
		                //Apply the damage and VFX impact to the current target
		                eDamage = EffectDamage(nDamStrike /2, nDamageType);
		                if(nDamStrike > 0) //age > 0)
		                {
		                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
		                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
		                }
		            }
		            oHolder = oTarget;
		
		            //change the currect holder of the lightning stream to the current target
		            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		            {
		            	eRay = EffectBeam(nBeam, oHolder, BODY_NODE_HAND);
		            }
		            else
		            {
		                // * April 2003 trying to make sure beams originate correctly
		                effect eNewRay = EffectBeam(nBeam, oHolder, BODY_NODE_HAND);
		                if(GetIsEffectValid(eNewRay))
		                {
		                    eRay =  eNewRay;
		                }
		            }
		
		            fDelay = fDelay + 0.1f;
		        //}
		        //Count the number of targets that have been hit.
		        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		        {
		            nCnt++;
		        }
			} //FIX: Now only counts those that pass faction check
		
		        // April 2003: Setting the new origin for the beam
		       // oFirstTarget = oTarget;
		
		        //Get the next target in the shape.
		        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
		    }
        }// end for - Twin Power
    }// end if - Successfull manifestation
}