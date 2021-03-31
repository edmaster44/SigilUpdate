/*
   ----------------
   Dispelling Buffer

   psi_pow_displbuf
   ----------------

   15/8/05 by Stratovarius
*/ /** @file

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

    You create a psychokinetic shield around the subject that improves the
    chance that any powers affecting the subject will resist a dispel psionics
    power (or a dispel magic spell) or a negation effect that targets a specific
    power (such as shatter mind blank). When dispelling buffer is manifested on
    a creature or object, add +5 to the DC of the dispel check for each ongoing
    effect that is subject to being dispelled.

    Special: When a psychic warrior manifests this power, the range is personal
             and the target is the manifester.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "aaa_constants"
#include "x2_inc_itemprop"


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
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

							   if(manif.bCanManifest)
    {
        effect eDur     = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
		effect eGlobe	= EffectSpellLevelAbsorption(6,0);
			effect elink =EffectLinkEffects(eDur,eGlobe);
        float fDuration = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Set a VFX for the monitor to watch
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, elink, oTarget, fDuration);
        // Start the monitor
 }
 }