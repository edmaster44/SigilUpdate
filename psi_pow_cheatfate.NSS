 /*
   ----------------
`	Cheat Fate

   psi_pow_cheatfate
   ----------------

   25/2/04 by Stratovarius
*/ /** @file

Clairsentience

Level: Psion 9

Range: Personal

Duration: 1 minute/manifester level

Saving Throw: Will partial (see text)

Power Resistance: No

Power Points: 17

Metapsionics: None

In manifesting this power, the psion is able to fix the time of their death to a specific point in the near future. By fixing the time of their own death, the laws of cause and effect, as well as those forces playing on time itself work against any attempt to bring the manifesters death about before its newly appointed time. This grants the psion a +8 bonus to their dodge AC, and immunity to death magic, level/ability drain, and critical hits for the duration of the power.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_alterations"

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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester);
		effect eLink    = EffectACIncrease(2, AC_DODGE_BONUS);
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
               
               
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CURSED));
              
        effect eVis     =                         EffectVisualEffect(VFX_IMP_HEAD_ODD);
               eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION));
               eVis     = EffectLinkEffects(eVis, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE));
		effect eDeath; 
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;
		if (GetHasSpellEffect(14697,oManifester))
        {

            FloatingTextStringOnCreature("This power does not stack with other instances of itself.",OBJECT_SELF, FALSE);
            return;
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
      
		
        //ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 6, DURATION_TYPE_TEMPORARY, FALSE, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Apply ASF to hide
        //AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_PLUS_50_PERCENT), GetPCSkin(oTarget), fDuration);
    }
}