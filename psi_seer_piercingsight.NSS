//::///////////////////////////////////////////////
//:: Cone: Fire
//:: NW_S1_ConeFire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of damage eminated from the monster.  Does
    a set amount of damage based upon the creatures HD
    and can be halved with a Reflex Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11, 2001
//:://////////////////////////////////////////////
//:: Updated By: Andrew Nobbs
//:: Updated On: FEb 26, 2003
//:: Note: Changed the faction check to GetIsEnemy
//:://////////////////////////////////////////////
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "NW_I0_SPELLS"
#include "psi_spellhook"

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
                             GetSpellId(), METAPSIONIC_EXTEND);


	if(manif.bCanManifest)
	{
    //Declare major variables
    
	    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_TRUE_SEEING);
		effect eVis2 = EffectNWN2SpecialEffectFile("fx_erinyes_eyes", oTarget);
	    effect eSight = EffectTrueSeeing();
	    effect eLink = EffectLinkEffects(eVis, eSight);
		eLink = EffectLinkEffects(eVis2, eLink);
		
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14338, FALSE));
    	int nDuration = manif.nManifesterLevel;
		
		if(manif.bExtend) nDuration *= 2;
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
	}
}