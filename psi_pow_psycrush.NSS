/*
    ----------------
    Psychic Crush

    psi_pow_psycrush
    ----------------

    23/2/04 by Stratovarius
*/ /** @file

    Psychic Crush

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 5
    Manifesting Time: 1 standard action
    Range: Close (25 ft. +5 ft./2 levels)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will partial; see text
    Power Resistance: Yes
    Power Points: 9
    Metapsionics: Empower, Maximize, Twin

    Your will abruptly and brutally crushes the mental essence of any one
    creature, debilitating its acumen. The target must make a Will save with a
    +4 bonus* or collapse unconscious and dying at -1 hit points. If the target
    succeeds on the save, it takes 3d6 points of damage.

    Augment: For every 2 additional power points you spend, this power�s damage
             increases by 1d6 points.


    * Due to the way saves are handled in NWN, this has been implemented as a
      lowered DC instead.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

void AvoidDR(object oTarget, int nDamage);

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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester) - 4;
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 3;
		if (manif.bAugment)
			nNumberOfDice += 2;
        int nDamage;
        effect eStun      = EffectStunned();
        effect eVis       = EffectNWN2SpecialEffectFile("psi_psychic_crush", oTarget);

        // Let the AI know
        SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for immunity and Power Resistance
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oManifester) &&
               PRCMyResistPower(oManifester, oTarget, nPen)
               )
            {
                // Apply VFX
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				
				nDamage = d6(nNumberOfDice);
				
                // Save - Will partial. On fail stun and HP set to 1
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f);
                    nDamage = GetCurrentHitPoints(oTarget) - 1;
                }
                // Apply damage
                AvoidDR(oTarget, nDamage);
            }// end if - Immunity and SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

void AvoidDR(object oTarget, int nDamage)
{
    int nCurHP         = GetCurrentHitPoints(oTarget);
    int nTargetHP      = nCurHP - nDamage;
    int nDamageToApply = nDamage;
    effect eDamage;

    // Try magical damage
    eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_MAGICAL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

    // Check if the target's HP dropped enough. Skip if the target died on the way
    if(GetCurrentHitPoints(oTarget) > nTargetHP && !GetIsDead(oTarget))
    {
        // Didn't, try again, this time with Divine damage
        nDamageToApply = GetCurrentHitPoints(oTarget) - nTargetHP;

        eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_DIVINE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

        // Check if the target's HP dropped enough. Skip if the target died on the way
        if(GetCurrentHitPoints(oTarget) > nTargetHP && !GetIsDead(oTarget))
        {
            // Didn't, try again, this time with Positive damage
            nDamageToApply = GetCurrentHitPoints(oTarget) - nTargetHP;

            eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_POSITIVE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

            // If it still didn't work, just give up. The blighter probably has immunities to everything else, too, anyway
            return;
        }
    }
}