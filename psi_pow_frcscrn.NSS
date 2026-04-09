
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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
	int nId = GetSpellId();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget, nId, METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND);

    if(!manif.bCanManifest) return;
	
	effect eLink    = EffectACIncrease(6, AC_SHIELD_ENCHANTMENT_BONUS);
    eLink    = EffectLinkEffects(EffectNWN2SpecialEffectFile("psi_forcescreen.sef"), eLink);
	if (manif.bAugment){
		effect eDR = EffectDamageReduction(5, GMATERIAL_METAL_COLD_IRON, 0, DR_TYPE_GMATERIAL);
		eLink = EffectLinkEffects(eDR, eLink);
	}
	int nDur = manif.nManifesterLevel;
	if(manif.bExtend) nDur *= 2;

	SignalEvent(oTarget, EventSpellCastAt(oManifester, nId, FALSE));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur));
   
}