#include "ff_safevar"
/*
   ----------------
   Mind Trap

   psi_pow_mindtrap
   ----------------

   17/2/05 by Stratovarius
*/ /** @file

    Mind Trap

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 3
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round
    Saving Throw: None
    Power Resistance: No
    Power Points: 5
    Metapsionics: Extend

    You set up a trap in your mind against psionic intruders. Anyone who attacks
    you with a telepathy power immediately loses 1d6 power points. This power�s
    effect does not negate a power being used against you.

    Manifesting the power is a swift action, like manifesting a quickened power,
    and it counts toward the normal limit of one quickened power per round.

    Augment: For every additional power point you spend, this power�s duration
             increases by 1 round.
*/
#include "psi_inc_manifest"
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        float fDuration = 6.0f;
		if (manif.bAugment)
			fDuration *= 3;
        if(manif.bExtend) fDuration *= 2;

        // Set the marker local
        PS_SetLocalInt(oTarget, "PRC_Power_MindTrap_Active", TRUE);

        // Set a VFX for the monitor to watch
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);

        // Start the monitor
        DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
    }
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       GetHasSpellEffect(nSpellID, oTarget))
    {
        // Clear the marker
        PS_DeleteLocalInt(oTarget, "PRC_Power_MindTrap_Active");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}