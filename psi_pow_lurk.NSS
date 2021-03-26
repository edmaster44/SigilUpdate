/*
   ----------------
   

    Lurk

    Psychometabolism
    Level: Psychic Warrior
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 3
    Metapsionics: Extend

    Your body and all your equipment are subsumed by your shadow. As a living
    shadow, you drift in and out of the shadow plane, giving you total
    concealement (20% miss chance).

    While in your shadow body, you gain damage reduction 10/+1 and darkvision.

*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "psi_inc_teleport"

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
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink =                          EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL );
               eLink = EffectLinkEffects(eLink, EffectUltravision());
			   eLink = EffectLinkEffects(eLink, EffectConcealment(20));
               eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("fx_shadowfiend_2.sef"));
        effect eVis  = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

       // Make sure the target is not prevented from extra-dimensional movement
       if(!GetCanTeleport(oTarget, GetArea(oTarget)))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            //GoInvis(manif, oTarget);
        }// end if - The target can move extradimensionally
    }// end if - Successfull manifestation
}