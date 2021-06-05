/*
   ----------------
   Energy Bolt

   psi_pow_enbolt
   ----------------

   6/11/04 by Stratovarius

    Psychokinesis [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: 120 ft.
    Area: 120-ft. line
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You release a powerful stroke of energy of the chosen type that deals 5d6
    points of damage to every creature or object within the area. The beam
    begins at your fingertips.

    Cold: A bolt of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold bolt is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a bolt of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A bolt of this energy type deals +1 point of damage per die.
    Sonic: A bolt of this energy type deals -1 point of damage per die and
           ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power�s damage
             increases by one die (d6). For each extra two dice of damage,
             this power�s save DC increases by 1.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_enrgypow"


float GetVFXLength(location lManifester, float fLength, float fAngle);

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
        
        int nDC              = GetManifesterDC(oManifester);
		if (manif.bAugment)
			nDC += 1;
        int nPen             = GetPsiPenetration(oManifester);
        int nNumberOfDice    = 7;
		if (manif.bAugment)
			nNumberOfDice += 3;
        int nDieSize         = 6;
        int nDamage;
        location lManifester = GetLocation(oManifester);
        location lTarget     = GetSpellTargetLocation();
        vector vOrigin       = GetPosition(oManifester);
        float fLength        = FeetToMeters(120.0f);
		if (manif.bWiden)
			fLength *= 2;
        float fDelay;
        effect eVis          = EffectVisualEffect(VFX_IMP_MAGBLUE);
        effect eDamage;
        object oTarget;
		effect eStun = EffectCutsceneParalyze();
		
    	effect eBeam = EffectNWN2SpecialEffectFile("psi_forcebeam.sef", oManifester);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeam, oManifester);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oManifester, 4.0f);
		
		
		

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Loop over targets in the line shape
            oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester)
                   )
                {
                    // Make an SR check
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Roll damage
                        nDamage = d6(nNumberOfDice);
						if (manif.bMaximize)
						{
							nDamage = 6*nNumberOfDice;
						}
				 		if (manif.bEmpower)
						{
							nDamage = nDamage + (nDamage/2);
						}



                        if(nDamage > 0)
                        {
                            fDelay = GetDistanceBetweenLocations(lManifester, GetLocation(oTarget)) / 20.0f;
                            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                            DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                            DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }// end if - There was still damage remaining to be dealt after adjustments
                    }// end if - SR check
                }// end if - Target validity check

               // Get next target
                oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}