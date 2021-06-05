/*
   ----------------
   Precognition, Defensive

   psi_pow_defpre
   ----------------

   31/10/04 by Stratovarius
*/ /** @file

    Precognition, Defensive

    Clairsentience
    Level: Psion/wilder 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 1
    Metapsionics: Extend

    Your awareness extends a fraction of a second into the future, allowing you to
    better evade an opponent�s blows.
    You gain a +1 insight bonus to AC and on all saving throws.

    Augment:  For every 3 additional power points you spend, the insight bonus
              gained increases by 1.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus = 1;
		
        effect eLink =                          EffectACIncrease(nBonus, AC_DODGE_BONUS);
               eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_MINOR));
        float fDur = 60.0 * manif.nManifesterLevel;

    	if(manif.bExtend) fDur *= 2;
		
		if (manif.bAugment)
		fDur = fDur + (60.0 * manif.nManifesterLevel);
		
		if (!GetHasSpellEffect(GetSpellId(), oTarget))
		{
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
		}
    }
}