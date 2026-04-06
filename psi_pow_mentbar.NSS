
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"

void main()
{
    if (!PsiPrePowerCastCode()) return;
    
    object oManifester = OBJECT_SELF;
	int nId = GetSpellId();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oManifester,
                              nId,
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(!manif.bCanManifest) return;
	
	int nBonus = 4;
	if (manif.bAugment) nBonus += 1;
	nBonus += manif.nManifesterLevel / 5;
	if (nBonus > 6) nBonus = 6;
	float fDuration = HoursToSeconds(manif.nManifesterLevel);
	if(manif.bExtend) fDuration *= 2;
	
	effect eLink = EffectLinkEffects(EffectACIncrease(nBonus, AC_DEFLECTION_BONUS),
										EffectVisualEffect(VFX_DUR_GLOBE_MINOR));

	ED_ApplyEffectToObject(oManifester, nId, FALSE, DURATION_TYPE_TEMPORARY, eLink, 
		oManifester, fDuration);


}