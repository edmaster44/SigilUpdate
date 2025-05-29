/*
   ----------------
   Concussion Blast

   psi_pow_concblst
   ----------------

   6/11/04 by Stratovarius
*/ /** @file

    Concussion Blast

    Psychokinesis [Force]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    A subject you select is pummeled with telekinetic force for 1d6 points of
    force damage. Concussion blast always affects a subject within range that
    you can see, even if the subject is in melee or has cover or concealment
    (you cannot use this power against creatures with total cover or total
    concealment).

    Augment: You can augment this power in one or both of the following ways.
    1. For every 2 additional power points you spend, this power�s damage
       increases by 1d6 points.
    2. For every 2 additional power points you spend, this power can affect an
       additional target. Any additional target cannot be more than 15 feet
       from another target of the power.
*/
#include "psi_inc_manifest"
#include "psi_inc_pwresist"
#include "psi_spellhook"

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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );
    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 1;
		if (manif.bAugment)
			nNumberOfDice += 1;
        effect eVis       = EffectVisualEffect(VFX_IMP_MAGBLUE);

		int nDamage;
    	effect eDamage;
		
        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
			//Check for Power Resistance
		    if(PRCMyResistPower(manif.oManifester, oTarget, nPen))
		    {
			
				int nCasterRoll = 8;
				if (manif.bAugment)
				{
					nCasterRoll = 10;
				}
				
	            int nTargetRoll = d20(1) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget);
	
	            if (HasSizeIncreasingSpellEffect(oTarget) || GetHasSpellEffect(803, oTarget))
                nTargetRoll = nTargetRoll + 4;
				
				if (nCasterRoll >= nTargetRoll)
	            {
	                effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	              
	                effect eKnockdown = EffectKnockdown();
	                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	                //Link effects
	                effect eLink = EffectLinkEffects(eKnockdown, eVis);
	                
	                //Apply the penalty
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
	                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration));
	                // * Bull Rush succesful
	                FloatingTextStrRefOnCreature(8966,OBJECT_SELF, FALSE);
	            }
	            else
	            {
	                FloatingTextStrRefOnCreature(8967,OBJECT_SELF, FALSE);
	            }
		        // Roll damage
		        nDamage = d6(nNumberOfDice);
				if (manif.bMaximize)
						nDamage = 6*nNumberOfDice;
				if (manif.bEmpower)
						nDamage = nDamage + (nDamage/2);
		        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
		
		        // Apply damage
		        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		    }
		}
    }// end if - Successfull manifestation
}