/*
   ----------------
   Matter Agitation

   psi_pow_mttrag
   ----------------

   6/12/04 by Stratovarius
*/ /** @file

    Matter Agitation

    Psychokinesis
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One object or creature
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend

    You can excite the structure of an object, heating it to the point of
    combustion over time. The agitation grows more intense in the second and
    third rounds after you manifest the power, as described below.

    1st Round: Readily flammable material (paper, dry grass, tinder, torches)
               ignites. Skin reddens. (1 point of fire damage)
    2nd Round: Wood smolders and smokes, metal becomes hot to the touch, skin
               blisters, hair smolders, paint shrivels, water boils. (1d4 points
               of fire damage)
    3rd and Subsequent Rounds: Wood ignites, metal scorches. Skin burns and hair
                               ignites, lead melts. (1d6 points of fire damage)
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

void RunImpact(object oManifester, object oTarget, int nSpellID, int nLastBeat, int nCurrentBeat = 0);

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
        int nPen        = GetPsiPenetration(oManifester);
        int nBeats      = manif.nManifesterLevel;
        if(manif.bExtend) nBeats *= 2;
        effect eVis     = EffectVisualEffect(VFX_IMP_FLAME_S);
        effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        float fDuration = 6.0f * nBeats;

        // Let the AI know
		SignalEvent(oTarget, EventSpellCastAt(oManifester, manif.nSpellID));

        // SR check
        if(PRCMyResistPower(oManifester, oTarget, nPen))
        {
            // Apply impact VFX
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Apply an effect for the heartbeat to track
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);

            // Start impact heartbeat
            RunImpact(oManifester, oTarget, manif.nSpellID, nBeats);
        }// end if - SR check
    }// end if - Successfull manifestation
}

void RunImpact(object oManifester, object oTarget, int nSpellID, int nLastBeat, int nCurrentBeat = 0)
{
    // Check for expiration
    if(nCurrentBeat++ <= nLastBeat &&
       GetHasSpellEffect(nSpellID, oTarget))
    {
        // Determine damage
        int nDamage;
        switch(nCurrentBeat)
        {
            case 0:  nDamage = 1;    break;
            case 1:  nDamage = d4(); break;
            default: nDamage = d6(); break;
        }

        // Create effects
        effect eFlame = EffectVisualEffect(VFX_IMP_FLAME_S);
        effect eSmoke = EffectVisualEffect(VFX_DUR_SMOKE);
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);

        // Apply VFX
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSmoke, oTarget, 6.0f);

        // Apply damage
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDam, oTarget);

        // Schedule next impact
        DelayCommand(6.0f, RunImpact(oManifester, oTarget, nSpellID, nLastBeat, nCurrentBeat));
    }
}