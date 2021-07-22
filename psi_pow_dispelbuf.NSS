#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
/*
   ----------------
   Dispelling Buffer

   psi_pow_displbuf
   ----------------

   7/22/2021 by edmaster44
* @file

    Dispelling Buffer

    Psychokinesis
    Level: Kineticist 6, psychic warrior 6
    Manifesting Time: 1 standard action
    Range: Personal or close (25 ft. + 5 ft./2 levels); see text
    Target: You or one willing creature or one object; see text
    Duration: 1 hour/level
    Saving Throw: None
    Power Resistance: No
    Power Points: 11
    Metapsionics: Extend
	This adds Spell Resistence on the Psychic Warrior 
	
	*/
	
	void main()
{

 /*Spellcast Hook Code
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
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
		int nDuration = 60 * manif.nManifesterLevel;
		if(manif.bExtend) nDuration *= 2;
		
    int nBonus = 15 + manif.nManifesterLevel;
    effect eSR = EffectSpellResistanceIncrease(nBonus);
    //effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE );
    //effect eDur2 = EffectVisualEffect(249);
    effect eLink = EffectLinkEffects(eSR, eDur);
    //eLink = EffectLinkEffects(eLink, eDur2);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPELL_RESISTANCE, FALSE));
	}
	}