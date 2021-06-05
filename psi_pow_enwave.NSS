/*
   ----------------
   Energy Wave

   psi_pow_enwave
   ----------------

   25/2/05 by Stratovarius
*/ /** @file

    Energy Wave

    Psychokinesis [see text]
    Level: Psion/wilder 7
    Manifesting Time: 1 standard action
    Range: 120 ft.
    Area: Cone-shaped spread
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You create a flood of energy of the chosen type out of unstable ectoplasm
    that deals 13d6 points of damage to each creature and object in the area.
    This power originates at your hand and extends outward in a cone.

    Cold: A wave of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold wave is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a wave of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A wave of this energy type deals +1 point of damage per die.
    Sonic: A wave of this energy type deals -1 point of damage per die and
           ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power�s damage
             increases by one die (d6). For each extra two dice of damage, this
             power�s save DC increases by 1.
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
							  METAPSIONIC_TWIN | METAPSIONIC_AUGMENT
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, 14634, 14635, 14636, 14637,
                           VFX_IMP_FROST_L, VFX_IMP_LIGHTNING_M, VFX_IMP_FLAME_M, VFX_IMP_SONIC);
        
        int nPen             = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice    = 13;
		if (manif.bAugment)
			nNumberOfDice += 7;
        int nDamage;
        location lManifester = GetLocation(oManifester);
        location lTarget     = GetSpellTargetLocation();
        float fWidth         = FeetToMeters(120.0f);
		if (manif.bWiden)
			fWidth *= 2;
        float fDelay;
        effect eVis          = EffectVisualEffect(enAdj.nVFX2);
        effect eDamage;
        object oTarget;
		int nVisImp;
		int nDamType;
		
		if (manif.nSpellID == 14634)
		{
			nVisImp = VFX_IMP_FROST_S;
			nDamType = DAMAGE_TYPE_COLD;
		}
		if (manif.nSpellID == 14635)
		{
			nVisImp = VFX_IMP_LIGHTNING_S;
			nDamType = DAMAGE_TYPE_ELECTRICAL;
		}
		if (manif.nSpellID == 14636)
		{
			nVisImp = VFX_IMP_FLAME_S;
			nDamType = DAMAGE_TYPE_FIRE;
		}
		if (manif.nSpellID == 14637)
		{
			nVisImp = VFX_IMP_SONIC;
			nDamType = DAMAGE_TYPE_SONIC;
		}
        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            DoPsiMissileStorm(2, 20, manif.nSpellID, nVisImp, nDamType, -1, nNumberOfDice);
        }// end for - Twin Power
    }// end if - Successfull manifestation
}