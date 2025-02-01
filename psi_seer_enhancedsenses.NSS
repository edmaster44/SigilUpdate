//::///////////////////////////////////////////////
//:: Clairaudience / Clairvoyance
//:: NW_S0_ClairAdVo.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the target creature a bonus of +10 to
    spot and listen checks
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 21, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/24/05 -- Metamagic changes
// BDF - OEI 6/26/06 -- NWN2 VFX updates
#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
                             GetSpellId(),
                             METAPSIONIC_EXTEND); //sending metapsionic options
// End of Spell Cast Hook


    //Declare major variables
	if(manif.bCanManifest)
	{
		effect eInvisSee = EffectSeeInvisible();
	    effect eSpot = EffectSkillIncrease(SKILL_SPOT, 4);
	    effect eListen = EffectSkillIncrease(SKILL_LISTEN, 4);
		effect eSearch = EffectSkillIncrease(SKILL_SEARCH, 4);
		effect eSurvival = EffectSkillIncrease(SKILL_SURVIVAL, 4);
		effect eImmunityBlind = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
		effect eImmunityDeaf = EffectImmunity(IMMUNITY_TYPE_DEAFNESS);
	    //effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);	// NWN1 VFX
	    effect eVis = EffectNWN2SpecialEffectFile("psi_seer_hit2.sef", oManifester);	// NWN2 VFX
	    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
	
	    effect eLink = EffectLinkEffects(eSpot, eListen);
		eLink = EffectLinkEffects(eLink, eImmunityBlind);
		eLink = EffectLinkEffects(eLink, eImmunityDeaf);
		eLink = EffectLinkEffects(eLink, eSearch);
		eLink = EffectLinkEffects(eLink, eInvisSee);
		eLink = EffectLinkEffects(eLink, eSurvival);
	    eLink = EffectLinkEffects(eLink, eVis);
	    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX
	
	   
	    float fDuration = RoundsToSeconds(manif.nManifesterLevel);
	    if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
		{
			fDuration = fDuration * 2;
		}
	    //Meta-Magic checks
	    
	
	    //Make sure the spell has not already been applied
	    if(!GetHasSpellEffect(14337, oTarget))
	    {
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, FALSE));
	
	         //Apply linked and VFX effects
	         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	    }
	}
}