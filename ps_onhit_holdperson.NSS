//:://////////////////////////////////////////////////////////////////////////
//:: Level 7 Arcane Spell: Mass Hold Person
//:: nw_s0_mshldper.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/29/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Mass Hold Person
        PHB, pg. 241

        School:		    Evocation
        Components: 	Verbal, Somatic
        Range:		    Medium
        Target:		    All targets within a 30 ft. radius
        Duration:		1 round / level
        Saving Throw:	Will negates
        Spell Resist:	Yes

        Paralyzes all targets that fail their saves. Each round targets 
        can try and make a new save.

*/
//:://////////////////////////////////////////////////////////////////////////

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void HoldTarget( object oTarget, float fDuration, int nSaveDC, object oCaster);


void main()
{

    //Declare major variables
    location locTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	int nRounds = GetCasterLevel(oCaster);
	int nSaveDC = GetOnHitAbilityDC(OBJECT_SELF);
	

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget );
    while (GetIsObjectValid(oTarget) )
    {
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
	
	        //Make sure the target is a humanoid
	        if (GetIsPlayableRacialType(oTarget) ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN) 
	        {
				float fDuration = RoundsToSeconds( GetScaledDuration(nRounds, oTarget) );
	            HoldTarget( oTarget, fDuration, nSaveDC, oCaster);
	        }
	    }

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget);
    }
}



void HoldTarget( object oTarget, float fDuration, int nSaveDC, object oCaster )
{

    effect eParal 	= EffectParalyze(nSaveDC, SAVING_THROW_WILL);
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_HOLD_PERSON );
	eParal = EffectLinkEffects( eParal, eHit );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));

	float fDelay = GetRandomDelay( 0.25, 1.25 );

	//Make SR Check
	if ( OnHitResistSpell(OBJECT_SELF, oTarget) == 0 )
	{
		//Make Will save
		if (!OnHitSavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
		{
			//Apply paralyze effect and VFX impact
			//DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
			DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, fDuration ) );
			string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> paralyzes "+GetName(oTarget)+"</color>";
			DelayCommand(fDelay, SendMessageToPC(oCaster, sReport));
		}
	}

}