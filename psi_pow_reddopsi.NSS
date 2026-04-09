/*
   ----------------
   Reddopsi

   psi_pow_reddopsi
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Reddopsi

    Psychokinesis
    Level: Kineticist 7
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 13
    Metapsionics: Extend

    When you manifest reddopsi, powers targeted against you rebound to affect
    the original manifester. This effect reverses powers that have only you as a
    target (except dispel psionics and similar powers or effects). Powers that
    affect an area can�t be reversed. Reddopsi also can�t reverse any power with
    a range of touch.

    Should you rebound a power back against a manifester who also is protected
    by reddopsi, the power rebounds once more upon you.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

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
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eDur     = EffectVisualEffect( VFX_DUR_SPELL_SPELL_MANTLE );
		int nAbsorb = d8() + 8;
		int nDuration = 6 * manif.nManifesterLevel;
		if(manif.bExtend) nDuration *= 2;

		// Set the marker local
		effect eAbsob = EffectSpellLevelAbsorption(9, nAbsorb);
	    effect eLink = EffectLinkEffects(eDur, eAbsob);
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
	    RemoveEffectsFromSpell(oTarget, GetSpellId());
	    RemoveEffectsFromSpell(oTarget, SPELL_LEAST_SPELL_MANTLE);
	    RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
	    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);
	
	    //Apply the VFX impact and effects
		//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }// end if - Successfull manifestation
}