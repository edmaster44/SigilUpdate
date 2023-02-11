/*
   ----------------
   Energy Retort

   psi_pow_rgeofremorhaz
   ----------------

You skin pulses with a red glow.

Your skin pulses, generating a heat so intense that anything touching your body takes 4d6 points of fire damage. Creatures striking you with natural attacks or unarmed attacks are subject to this damage as well. Creatures striking with melee weapons do not take damage from your heat, but their weapons do take damage. You and your possessions are immune to your own heat (but you are not resistant or immune to heat from other sources).

Augment: For every 2 additional power points you spend, the power deals an additional 1d6 points of damage.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_enrgypow"

void main()
{

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
                              METAPSIONIC_AUGMENT  | METAPSIONIC_EXTEND 
                                      );
float fDuration   = 60.0f * manif.nManifesterLevel;
if(manif.bExtend) fDuration *= 2;
int nNumberOfDice = 4;
int nDamage = d6(nNumberOfDice);
if (manif.bAugment)
			nNumberOfDice = nNumberOfDice+1;
effect eVis  = EffectNWN2SpecialEffectFile("psi_energyretort_fire.sef", oManifester);
effect eShield = EffectDamageShield(nDamage, DAMAGE_BONUS_1, DAMAGE_TYPE_FIRE);
	   		  eShield = EffectLinkEffects(eShield, eVis);

if (GetHasSpellEffect(14306, oTarget))
	   {
	   		FloatingTextStringOnCreature("This power does not stack with other instances of itself.",OBJECT_SELF, FALSE);
	   		return;
	   }
	   else
	   {
	   		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oTarget, fDuration);
	   }				

}