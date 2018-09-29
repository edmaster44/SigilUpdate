//::///////////////////////////////////////////////
//:: [Confusion]
//:: [NW_S0_Confusion.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures within a 15 foot radius must
//:: save or be confused for a number of rounds
//:: equal to the casters level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30 , 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"
 
void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    int nDuration = 1;
    int nMetaMagic = GetMetaMagicFeat();
    //effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);	// NWN1 VFX
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);	// NWN1 VFX
    effect eStun = EffectStunned();
    effect eMind = EffectVisualEffect( VFX_DUR_STUN );
	effect eDaze = EffectDazed();
	effect eMindD = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	effect eNaus= EffectSlow();
    effect eCon= EffectAbilityDecrease( ABILITY_CONSTITUTION, 4 );
    effect eStr= EffectAbilityDecrease( ABILITY_STRENGTH, 4 );
    effect eDex= EffectAbilityDecrease( ABILITY_DEXTERITY, 4 );
    effect eDur1 = EffectVisualEffect( VFX_DUR_NAUSEA );
    effect eDur2 = EffectVisualEffect( VFX_DUR_SICKENED );
    effect eSick1 = EffectLinkEffects( eCon, eStr );
    effect eSick2 = EffectLinkEffects( eSick1, eDex );
    effect eLink3 = EffectLinkEffects( eNaus, eDur1 );
    effect eLink4 = EffectLinkEffects( eSick2, eDur2 );
	effect eSign = EffectNWN2SpecialEffectFile("fx_cerulean_sign.sef");
	
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// NWN1 VFX
    float fDelay;
    //Link duration VFX and confusion effects
    effect eLink1 = EffectLinkEffects(eMind, eStun);
	effect eLink2 = EffectLinkEffects(eMindD, eDaze);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX

    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());	// NWN1 VFX

    //Search through target area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
        if (GetRacialType(oTarget)== RACIAL_TYPE_ABERRATION)
    	{
			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
           //Fire cast spell at event for the specified target
	           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1222));
			   ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSign, (GetSpellTargetLocation()),4.0f);
	           fDelay = GetRandomDelay();
	           //Make SR Check and faction check
	          
	                //Make Will Save
	                if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
	                {
	                   //Apply linked effect and VFX Impact
	                   
	
	                   //Perform metamagic checks
	                   if (nMetaMagic == METAMAGIC_EXTEND)
	                   {
	                       nDuration = nDuration * 2;
	                   }
					   if (GetHitDice(oTarget) > (GetCasterLevel(OBJECT_SELF) + 5))
					   {
						   oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
					   } 
					   if (GetHitDice(oTarget) < (GetCasterLevel(OBJECT_SELF) - 10))
					   {
					  	   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, RoundsToSeconds(nDuration)));
					   }
					   if (GetHitDice(oTarget) < (GetCasterLevel(OBJECT_SELF) - 5))
					   {
					       DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, (RoundsToSeconds(nDuration) * 2)));
					   }
					   if (GetHitDice(oTarget) < (GetCasterLevel(OBJECT_SELF) + 5))
					   {
					   	   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink4, oTarget, (RoundsToSeconds(nDuration) + (RoundsToSeconds(3)))));	
					   }
					   if (GetHitDice(oTarget) < (GetCasterLevel(OBJECT_SELF)))
					   {
					   		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink3, oTarget, (RoundsToSeconds(nDuration) + (RoundsToSeconds(2)))));
					   }	
	                  
	                }
	            
				 
			}
	
        }
		else if (!GetRacialType(oTarget)== RACIAL_TYPE_ABERRATION)
		{
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
		}
        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	}
}