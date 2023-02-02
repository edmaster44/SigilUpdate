/*
   ----------------
   Elf Sight

   psi_pow_elfsight
   ----------------

   6/11/04 by Stratovarius
*/ /** @file

    Elf Sight

    Psychometabolism
    Level: Psion/wilder 2, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: Psion/wilder 3, psychic warrior 1
    Metapsionics: Extend

    You gain low-light vision (as an elf) for the duration of the power, as
    well as a +4 bonus on Search and Spot checks.
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
	object oChest 		= GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
      /*  effect eLink =                          EffectSkillIncrease(SKILL_SPOT,   4);
               eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 4));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_CLAIRAUD));
        effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);*/
        float fDuration = HoursToSeconds(manif.nManifesterLevel);
		itemproperty iKeenSight = ItemPropertyBonusFeat(800);	//
        if(manif.bExtend) fDuration *= 2;

		AddItemProperty(DURATION_TYPE_TEMPORARY,iKeenSight,oChest,fDuration);
       /* ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);*/
    }
}