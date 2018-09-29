//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    dazed vs strength check (+14 on strength check); Target knocked down.
    Target dazed down for 1 round per level of caster

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

// End of Spell Cast Hook


    //Declare major variables
    int nPen          = GetPsiPenetration(oManifester);
    int nDuration = d4(1);
    int nTargetDex = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
	int nTargetStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
	int nManifestMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oManifester);
	if (manif.bAugment)
			nManifestMod += 1;
    //Check for metamagic extend
    if(manif.bExtend)	//Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        // Apply the impact effect
        effect eImpact = EffectNWN2SpecialEffectFile("psi_telekineticman.sef", oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImpact, OBJECT_SELF, 2.0);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 460, TRUE));
        if(PRCMyResistPower(oManifester, oTarget, nPen))
        {

            int nCasterRoll = d20(1) + nManifestMod;
            int nTargetRoll = d20(1) + GetAbilityModifier(ABILITY_DEXTERITY, oTarget) + GetSizeModifier(oTarget);
			
            

            // * bullrush succesful, knockdown target for duration of spell
            if (nCasterRoll >= nTargetRoll)
            {
                effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
                effect eKnockdown = EffectDazed();
                effect eKnockdown2 = EffectKnockdown();
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                //Link effects
                effect eLink = EffectLinkEffects(eKnockdown, eVis);
                eLink = EffectLinkEffects(eLink, eKnockdown2);
                //Apply the penalty
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration));
                // * Bull Rush succesful
                FloatingTextStringOnCreature("Trip successful",OBJECT_SELF, FALSE);
            }
            else
            {
                FloatingTextStringOnCreature("Trip unsucessful",OBJECT_SELF, FALSE);
            }
        }
    }
}