/*
   ----------------
   Banishment, Psionic

   psi_pow_banish
   ----------------

   28/4/05 by Stratovarius
*/ /** @file

    Banishment, Psionic

    Psychoportation
    Level: Nomad 6
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Targets: One or more extraplanar creatures, no two of which can be more than 30 ft. apart
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 11
    Metapsionics: Twin

    This spell forces extraplanar creatures back to their home plane if they fails a save. Affected creatures include summons,
    outsiders, and elementals. You can banish up to 2 HD per caster level.

    Augment: For every 2 additional power points you spend, this power�s save DC
            increases by 1 and your manifester level increases by 1 for the
            purpose of overcoming power resistance.
*/
#include "psi_inc_manifest"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

/**
 * This function contains the actual execution of the power. Separated from main() for easier implementation
 * of Twin Power.
 */
void DoPower(struct manifestation manif, object oMainTarget, int nDC, int nPen, int nBanishableHD, effect eVis);


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
                              METAPSIONIC_TWIN | METAPSIONIC_AUGMENT);

    if(manif.bCanManifest)
    {
        // Get more data
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nBanishableHD = 2 * manif.nManifesterLevel;
        effect eVis       = EffectVisualEffect(VFX_IMP_UNSUMMON);

        // Apply augmentation
		if (manif.bAugment) {
        	nDC  += 2;
       	 	nPen += 2;
		}
		
	   	int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
	        if(!GetIsDead(oTarget) &&
		       (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER ||
		        GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL
		        )
		       )
	    	{
		        //Check for Power Resistance
		        if (PRCMyResistPower(manif.oManifester, oTarget, nPen))
		        {
		            //Make a saving throw check
		            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
		            {
		                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
		                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		            }
		        }
	    	}


   			location lLoc = GetSpellTargetLocation();
			object oMaster;

    		// Do some VFX
    		effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
   		 	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());


    		//Get the first object in the are of effect
    		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    		// Loop until out of valid targets or HD to banish
    		while(GetIsObjectValid(oTarget) && nBanishableHD > 0)
    		{
		        //does the creature have a master.
		        oMaster = GetMaster(oTarget);
		        if (oMaster == OBJECT_INVALID)
		        {
		            oMaster = OBJECT_SELF;  // TO prevent problems with invalid objects
		        }

		        // * Is the creature a summoned associate
		        // * or is the creature an outsider
		        // * and is there enough points in the pool
		        if(// Target validity tests
		           (// Special conditions
		            (// It's a summon, but not an astral construct
		             GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget &&
		             GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT
		             ) || // End - Non-AC summon
		            // A familiar
		            GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
		            // A Bonded Summoner familiar
		            GetTag(OBJECT_SELF) == "BONDFAMILIAR"                     ||
		            // An animal companion
		            GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget
		            ) || // End - Special conditions
		           // The target is an elemental or an outsider
		           GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL ||
		           GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER
		           )// End - Target validity tests
		        {
		            // * March 2003. Added a check so that 'friendlies' will not be
		            // * unsummoned.
		            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, manif.oManifester))
		            {
		                // * Must be enough points in the pool to destroy target
		                if(nBanishableHD >= GetHitDice(oTarget))
		                {
		                    // * Make SR and will save checks
		                    if(PRCMyResistPower(manif.oManifester, oTarget, nPen) &&
		                      !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE)
		                       )
		                    {
		                        //Apply the VFX and delay the destruction of the summoned monster so
		                        //that the script and VFX can play.
		                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
		                        if(GetPlotFlag(oTarget) == FALSE)
		                        {
		                            nBanishableHD -= GetHitDice(oTarget);
		                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
		                            //Which is bad when you have plot-specific things being done in that
		                            //OnDeath script... so lets kill it.
		                            effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
		                            //just to be extra-sure... :)
		                            effect eDeath = EffectDeath(FALSE, FALSE);
		                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
		                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
		                            //DeathlessFrenzyCheck(oTarget);
		                        }
		                    }
		                }
		            }// rep check
		        }
		
		        //Get next creature in the shape.
		        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
		    }
		}
    }
}