/*
   ----------------
   Knock, Psionic

   psi_pow_knock
   ----------------

   7//11/04 by Stratovarius
*/ /** @file

    Knock, Psionic

    Psychoportation
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Area: 50m -radius burst centered on you
    Duration: Instantaneous; see text
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Widen

   When you manifest this power, you open all locks in the area.
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
	object oTarget = GetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
		int nDuration = 2 + manif.nManifesterLevel; 
		int nBonus = 10;
		
		if (manif.bEmpower) nBonus += nBonus / 2;
		if (manif.bExtend) nDuration *= 2;
		
		effect eOpen = EffectSkillIncrease(SKILL_OPEN_LOCK, nBonus);
		eOpen = SetEffectSpellId(eOpen, manif.nSpellID);
		SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, manif.nSpellID, FALSE));
		PS_RemoveEffects(OBJECT_SELF, manif.nSpellID);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOpen, OBJECT_SELF, TurnsToSeconds(nDuration)); 
		
        int nResistFlag;
        effect eVis      = EffectVisualEffect(VFX_IMP_KNOCK);
        float fDelay;
        float fRadius    = 50.0f;
		if (manif.bWiden)
			fRadius *= 2;
        location lTarget = GetSpellTargetLocation();

        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            // Let the AI know
            SignalEvent(oTarget, EventSpellCastAt(oManifester, SPELL_KNOCK));
            fDelay = GetRandomDelay(0.5, 2.5);

            if(!GetPlotFlag(oTarget) && GetLocked(oTarget))
    	    {
    	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    	        AssignCommand(oTarget, ActionUnlockObject(oTarget));
    	    }// end if - Target is locked and not plot
    	    oTarget = GetNextObjectInShape(SHAPE_SPHERE,fRadius, lTarget, FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

        }// end while - Target loop
    }// end if - Successfull manifestation
}