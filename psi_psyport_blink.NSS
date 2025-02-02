//::///////////////////////////////////////////////
//:: Displacement
//:: x0_s0_displace
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target gains a 50% concealment bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
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
	object oManifester = OBJECT_SELF;
   	object oTarget     = GetSpellTargetObject();
   	struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                             GetSpellId(), METAPSIONIC_AUGMENT);
// End of Spell Cast Hook
	if(manif.bCanManifest)
	{
		int nConcealR = 40;
		int nConcealM = 25;
		if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
		{
			nConcealR = 50;
			nConcealM = 35;
		}
	    //Declare major variables
	    
	    effect eMissRange = EffectConcealment(nConcealR, MISS_CHANCE_TYPE_VS_RANGED);
		effect eMissMelee = EffectConcealment(nConcealM, MISS_CHANCE_TYPE_VS_MELEE);
		effect eLink = EffectLinkEffects(eMissRange, eMissMelee);
	    effect eVis = EffectNWN2SpecialEffectFile("psi_blink", OBJECT_SELF);
	    eLink = EffectLinkEffects(eLink, eVis);
	    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
	
	    int nMetaMagic = GetMetaMagicFeat();
	    
	    int nDuration = 2;
	
	    if (GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
		{
			nDuration = nDuration * 2;
			DelayCommand(12.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nDuration)));
		}
	
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14321, FALSE));
	
	    //Apply the VFX impact and effects
	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
	    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
	}
}