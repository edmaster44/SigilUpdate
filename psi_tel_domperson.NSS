//::///////////////////////////////////////////////
//:: [Dominate Person]
//:: [NW_S0_DomPers.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: RPGplayer1 01/05/2009: Will affect all playable humanoids (Planetouched, Grey Orcs, Yuan-ti)

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

#include "psi_inc_psifunc"

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
                             METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT); //sending metapsionic options
// End of Spell Cast Hook

	if(manif.bCanManifest)
	{
    //Declare major variables
	    
	    effect eDom = EffectDominated();
	    eDom = GetScaledEffect(eDom, oTarget);
	
	    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DOM_PERSON);
		effect eLink = EffectLinkEffects(eDom, eVis);
	    int nMetaMagic = GetMetaMagicFeat();
	    int nCasterLevel = manif.nManifesterLevel;
	    int nDuration = nCasterLevel;
	    nDuration = GetScaledDuration(nDuration, oTarget);
	    int nRacial = GetRacialType(oTarget);
		int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF);
		int nDC = GetManifesterDC(oManifester);
		
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
	    //Make sure the target is a humanoid
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
	        if(GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
	        {
			   nDC = nDC + 1;
	           //Make SR Check
	           if (!MyResistSpell(OBJECT_SELF, oTarget))
	    	   {
	                //Make Will Save
	                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
	                {
	                    //Check for metamagic extension
	                    if(GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
	                    {
	                        nDuration = nDuration * 2;
	                    }
	                    //Apply linked effects and VFX impact
						
						if (GetIsPC(oTarget))
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
						else
	                    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
	                }
	            }
	        }
		
			else if  (GetIsPlayableRacialType(oTarget) ||
				(nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
				(nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
				(nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
				(nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN) )
	        {
	           //Make SR Check
	           if (!MyResistSpell(OBJECT_SELF, oTarget))
	    	   {
	                //Make Will Save
	                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
	                {
	                    //Check for metamagic extension
	                    if(GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
	                    {
	                        nDuration = nDuration * 2;
	                    }
	                    //Apply linked effects and VFX impact
						
						if (GetIsPC(oTarget))
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
						else
	                    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
	                }
	            }
	        }
	    }
	}
}