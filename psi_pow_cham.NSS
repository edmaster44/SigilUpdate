/*
   ----------------
   Chameleon

   psi_pow_cham
   ----------------

   11/5/05 by Stratovarius
*/ /** @file

    Chameleon

    Psychometabolism
    Level: Egoist 2, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 1
    Metapsionics: Extend

    Your skin and equipment take on the color and texture of nearby objects,
    including floors and walls. You receive a +10 enhancement bonus on Hide checks.
*/
#include "psi_inc_manifest"
#include "psi_inc_pwresist"
#include "psi_spellhook"

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
		int nHide = 10;
		if (GetSubRace(OBJECT_SELF) == 1)
		{
			nHide = 15;
		}
        effect eLink =                          EffectSkillIncrease(SKILL_HIDE, nHide);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDur = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }
}