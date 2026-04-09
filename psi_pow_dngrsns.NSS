/*
   ----------------
   Danger Sense

   psi_pow_dngrsns
   ----------------

   12/12/04 by Stratovarius
*/ /**

    Danger Sense

    Clairsentience
    Level: Psion/wilder 3, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: 5
    Metapsionics: Extend

    You can sense the presence of danger before your senses would normally allow
    it. Your intuitive sense alerts you to danger from traps, giving you a +4
    insight bonus on Reflex saves to avoid traps and a +4 insight bonus to
    Armor Class against attacks by traps.

    Augment: If you spend 3 additional power points, this power also gives
             you the uncanny dodge ability

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
                              METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT 
                              );

    if(manif.bCanManifest)
    {
        int nBonus;
		if (manif.bAugment)
		{
			nBonus = 2;
		}
		else
		{
			nBonus = 1;
		}
        float fDuration = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Create effect
		effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
        effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBonus, SAVING_THROW_TYPE_TRAP);
    	effect eAC     = VersusTrapEffect(EffectACIncrease(nBonus));
        effect eVis    = EffectNWN2SpecialEffectFile("psi_seer_hit2.sef", oTarget);
    	
    	effect eLink   = EffectLinkEffects(eVis, eReflex);
               eLink   = EffectLinkEffects(eLink, eAC);
			   eLink   = EffectLinkEffects(eLink, eSneak);
		
        // Apply effect
		if (!GetHasSpellEffect(GetSpellId(), oTarget))
		{
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		}
    }
}