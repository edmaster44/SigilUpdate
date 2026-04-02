#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
/*
   ----------------
   Dispelling Buffer

   psi_pow_displbuf
   ----------------

   7/22/2021 by edmaster44
* @file

    Dispelling Buffer

  
	
	*/
	
void main()
{

 /*Spellcast Hook Code
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
	object oTarget = OBJECT_SELF;
	int nId = GetSpellId();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget, nId,
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(!manif.bCanManifest) return;
    
	int nDuration = manif.nManifesterLevel;
	if(manif.bExtend) nDuration *= 2;
	int nBonus = 20;
	int nMaxBonus = 40;
	if (manif.bAugment){
		nBonus += 5;
		nMaxBonus += 5;
	}	
    nBonus += manif.nManifesterLevel;
	if (nBonus > nMaxBonus) nBonus = nMaxBonus;
	
    effect eSR = EffectSpellResistanceIncrease(nBonus);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE );
    effect eLink = EffectLinkEffects(eDur, eSR);


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
	PS_ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
	
}