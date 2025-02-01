//::///////////////////////////////////////////////
//:: [Mass Charm]
//:: [NW_S0_MsCharm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster attempts to charm a group of individuals
    who's HD can be no more than his level combined.
    The spell starts checking the area and those that
    fail a will save are charmed.  The affected persons
    are Charmed for 1 round per 2 caster levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "X0_I0_SPELLS"
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
                             GetSpellId(),
                             METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT); //sending metapsionic options
// End of Spell Cast Hook

	if(manif.bCanManifest)
	{
	   
	    effect eCharm = EffectCharmed();
	    effect eMind = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
	    effect eImpact = EffectVisualEffect(VFX_IMP_CHARM);
	    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
	
	    effect eLink = EffectLinkEffects(eMind, eCharm);
	    eLink = EffectLinkEffects(eLink, eDur);
	
	    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
	    int nMetaMagic = GetMetaMagicFeat();
	    int nCasterLevel = manif.nManifesterLevel;
	    int nDuration = nCasterLevel/2;
		
		int nAugment = PS_GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT");
		
		int nDC = GetManifesterDC(oManifester);
	    
	    int nCnt = 0;
	    int nRacial;
	    float fDelay;
	    int nAmount = 1;
	    //Check for metamagic extend
	    if (nMetaMagic == METAMAGIC_EXTEND)
	    {
	        nDuration = nCasterLevel;
	    }
	
	    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
	
	    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	    while (GetIsObjectValid(oTarget) && nAmount > 0)
	    {
	        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
	    	{
	            nRacial = GetRacialType(oTarget);
	            fDelay = GetRandomDelay();
	            //Check that the target is humanoid or animal
	            if (PS_GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)  
	            {
	                //SpeakString(IntToString(nAmount) + " and HD of " + IntToString(GetHitDice(oTarget)));
	               		nDC = nDC + 1;
	                    //Fire cast spell at event for the specified target
	                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14340, FALSE));
	                    //Make an SR check
	                    if (!MyResistSpell(OBJECT_SELF, oTarget))
	                	{
	                        //Make a Will save to negate
	                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
	                        {
	                            //Apply the linked effects and the VFX impact
	                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
	                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                        }
	                    }
	                    //Add the creatures HD to the count of affected creatures
	                    //nCnt = nCnt + GetHitDice(oTarget);
	                    nAmount = nAmount - 1;
	                
	            }
				
				else if  ((nRacial == RACIAL_TYPE_DWARF) ||
	                (nRacial == RACIAL_TYPE_ELF) ||
	                (nRacial == RACIAL_TYPE_GNOME) ||
	                (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
	                (nRacial == RACIAL_TYPE_HALFLING) ||
	                (nRacial == RACIAL_TYPE_HUMAN) ||
	                (nRacial == RACIAL_TYPE_HALFELF) ||
	                (nRacial == RACIAL_TYPE_HALFORC) ||
	                (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
	                (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
	                (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
	            {
	                //SpeakString(IntToString(nAmount) + " and HD of " + IntToString(GetHitDice(oTarget)));
	               
	                    //Fire cast spell at event for the specified target
	                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14340, FALSE));
	                    //Make an SR check
	                    if (!MyResistSpell(OBJECT_SELF, oTarget))
	                	{
	                        //Make a Will save to negate
							
	                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
	                        {
	                            //Apply the linked effects and the VFX impact
	                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
	                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                        }
	                    }
	                    //Add the creatures HD to the count of affected creatures
	                    //nCnt = nCnt + GetHitDice(oTarget);
	                    nAmount = nAmount - 1;
	                
	            }
				
	        }
	        //Get next target in spell area
	        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	    }
	}
}