#include "ff_safevar"
/*
   ----------------
   Dimensional Anchor

   psi_pow_dimanch
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Dimensional Anchor

    Psychoportation
    Level: Nomad 4
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Extend, Split Psionic Ray, Twin

    A green ray springs from your outstretched hand. You must make a ranged
    touch attack to hit the target. Any creature or object struck by the ray
    is covered with a shimmering emerald field that completely blocks
    extradimensional travel. Forms of movement barred by a dimensional anchor
    include astral projection, blink, dimension door, ethereal jaunt,
    etherealness, gate, maze, plane shift, shadow walk, teleport, and similar
    spell-like or psionic abilities. The spell also prevents the use of a gate
    or teleportation circle for the duration of the spell.

    A dimensional anchor does not prevent summoned creatures from disappearing
    at the end of a summoning spell.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_teleport"

void DispelMe(object oTarget);

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
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.nManifesterLevel)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);
		object oPortal = GetObjectByTag("scod_s_unstableportal");
        effect eVis  = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
        float fDur = 60.0 * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Perform the Touch Attach
		    int nTouchAttack = TouchAttackRanged(oTarget);
		
		    // Shoot the ray
		    effect eRay = EffectBeam(VFX_BEAM_ENCHANTMENT, manif.oManifester, BODY_NODE_HAND, !(nTouchAttack > 0));
		    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
			if(oTarget == oPortal)
			{
				DestroyObject(oPortal);
			}
		    // Apply effect if hit
		    if(nTouchAttack > 0)
		    {
		        //Check for Power Resistance
		        if(PRCMyResistPower(manif.oManifester, oTarget, nPen))
		        {
		            if(!PS_GetLocalInt(oTarget, "DIMENSIONAL_ACHORED"))
		            {
		                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur);
		                PS_SetLocalInt(oTarget, "DIMENSIONAL_ACHORED", TRUE);
						FloatingTextStringOnCreature("Dimensional Anchor Successful",oManifester, FALSE);
		                // Start the monitor
		                DelayCommand(fDur, DispelMe(oTarget));
		
		            }
		        }
		    }
        }
    }
}

void DispelMe(object oTarget) {
	PS_SetLocalInt(oTarget, "DIMENSIONAL_ACHORED", FALSE);
}