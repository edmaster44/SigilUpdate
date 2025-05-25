
/*
   ----------------
   Crisis of Breath

   psi_pow_crsbrth
   ----------------

   19/4/05 by Stratovarius
   3/8/15 edited for SCOD by Xndar
*/ /** @file

    Crisis of Breath

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Telepath 3
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One breathing humanoid
    Duration: 1 round/level
    Saving Throw: Will negates, Fortitude partial; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Extend, Twin, Widen

    You compel the subject to purge its entire store of air in one explosive
    exhalation, and thereby disrupt the subject�s autonomic breathing cycle.
    The subject�s lungs do not automatically function again while the power�s
    duration lasts.

    If the target succeeds on a Will save when crisis of breath is manifested,
    it is unaffected by this power. If it fails its Will save, it can still
    continue to breathe by remaining in place and gasping for breath.

    An affected creature can attempt to take actions normally (instead of
    consciously controlling its breathing), but each round it does so, beginning
    in the round when it failed its Will save, the subject risks blacking out
    from lack of oxygen. It must succeed on a Fortitude save at the end of any
    of its turns in which it did not consciously take a breath. The DC of this
    save increases by 1 in every consecutive round after the first one that goes
    by without a breath; the DC drops back to its original value if the subject
    spends an action to take a breath.

    If a subject fails a Fortitude save, it falls to 1 HP. In the following
    round, it drops to -1 hit points and is dying.

    Augment: You can augment this power in one or more of the following ways.
    1. If you spend 2 additional power points, this power can also affect an
       animal, fey, giant, magical beast, or monstrous humanoid.
    2. If you spend 4 additional power points, this power can also affect an
       aberration, dragon, elemental, or outsider in addition to the creature
       types mentioned above.
    3. If you spend 6 additional power points, this power can affect up to
       four creatures all within a 20-ft.-radius burst.
    In addition, for every 2 additional power points you spend to achieve any of
    these effects, this power�s save DC increases by 1.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

int CheckRace(struct manifestation manif, object oTarget);

void RunImpact(object oTarget, location lTarget, object oManifester, int nSpellID, int nDC, int nRound = 0, int bGoingToDie = FALSE, float fDur = 0.0f);


void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  Edited 2015-8-3 by Xndar
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
        float fDur = 6.0f * manif.nManifesterLevel;

        if(manif.bExtend) fDur *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do the primary target if it hasn't been already affected in the previous iteration
            if(!GetLocalInt(oTarget, "PRC_CrisisOfBreathMarker"))
            {
                if(CheckRace(manif, oTarget))
                {
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                        {
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDur);
                            RunImpact(oTarget, GetLocation(oTarget), oManifester, manif.nSpellID, nDC, 0, FALSE, fDur);

                            // Set a marker on the target for next iteration, so the heartbeat won't get run twice
                            SetLocalInt(oTarget, "PRC_CrisisOfBreathMarker", TRUE);
                        }
                    }
                    else
                    {
                        effect eSmoke = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oTarget);
                    }
                }// end if - Target is of an affectable type
            }// end if - Target has no been affected yet
        }// end for - Twin Power
    }// end if - Successfull manifestation
    SetLocalInt(oTarget, "PRC_CrisisOfBreathMarker", FALSE);
}

int CheckRace(struct manifestation manif, object oTarget)
{
	int nRacial = GetRacialType(oTarget);
	int bTargetRace = FALSE;
	//Verify that the Racial Type is humanoid
	if(nRacial == RACIAL_TYPE_DWARF              ||
       nRacial == RACIAL_TYPE_ELF                ||
       nRacial == RACIAL_TYPE_GNOME              ||
       nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID ||
       nRacial == RACIAL_TYPE_HALFLING           ||
       nRacial == RACIAL_TYPE_HUMAN              ||
       nRacial == RACIAL_TYPE_HALFELF            ||
       nRacial == RACIAL_TYPE_HALFORC            ||
       nRacial == RACIAL_TYPE_HUMANOID_ORC       ||
       nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN
       )
    {
        bTargetRace = TRUE;
    }
    // First augmentation option adds animal, fey, giant, magical beast, and monstrous humanoid to possible target types
    if(manif.bAugment 							  &&
       (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS ||
        nRacial == RACIAL_TYPE_FEY                ||
        nRacial == RACIAL_TYPE_GIANT              ||
        nRacial == RACIAL_TYPE_ANIMAL             ||
        nRacial == RACIAL_TYPE_MAGICAL_BEAST      ||
        nRacial == RACIAL_TYPE_BEAST			  ||
        nRacial == RACIAL_TYPE_ABERRATION		  ||
        nRacial == RACIAL_TYPE_DRAGON 			||
		nRacial == RACIAL_TYPE_OUTSIDER			||
		nRacial == RACIAL_TYPE_SHAPECHANGER
        ))
    {
        bTargetRace = TRUE;
    }

	return bTargetRace;
}

void RunImpact(object oTarget, location lTarget, object oManifester, int nSpellID, int nDC, int nRound = 0, int bGoingToDie = FALSE, float fDur = 0.0f)
{
	if (fDur <= 0.0f)
		return;
    // Make sure the target is still alive
    if(!GetIsDead(oTarget))
    {
        // Did the target start choking to death last round?
        if(bGoingToDie = TRUE)
        {
            // HP goes to -1 and we end the effect. The target may or may not have a
            // chance of survival depending on how well a module follows PnP dying rules
            int nCurHP = GetCurrentHitPoints(oTarget);
            effect eDam = EffectDamage(nCurHP + 1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            return;
        }
        // Has the target moved?
        else if(GetLocation(oTarget) != lTarget)
        {
            // Adjust save by amount of rounds spent without breath
            int nDCTemp = nDC + nRound;
            nRound += 1;

            // Roll fortitude
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDCTemp, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                int nCurHP = GetCurrentHitPoints(oTarget);
                effect eDam = EffectDamage(nCurHP - 1);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                bGoingToDie = TRUE;
            }
        }
        // Not moved, reset counter
        else
            nRound = 0;

        // Schedule next check
        DelayCommand(6.0f, RunImpact(oTarget, GetLocation(oTarget), oManifester, nSpellID, nDC, nRound, bGoingToDie, fDur-6.0f));
    }
}