//::///////////////////////////////////////////////
//:: Mass Cure Moderate Wounds
//:: NW_S0_MaCurMod
//:://////////////////////////////////////////////
/*
	Mass Cure Moderate Wounds
	PHB, pg. 216
	School:			Conjuration (Healing)
	Components: 	Verbal, Somatic
	Range:			Close
	Target:			One creature/level
	Duration:		Instantaneous
	
	This uses positive energy to cure 2d8 points of damage +1 
	point per caster level (maximum +30). This affects first the 
	caster and his immediate party, then the nearest friendly 
	aligned targets (not the Neutral faction, though) within range 
	of the caster. This spell can be spontaneously cast.

*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////
// JLR - OEI 08/23/05 -- Metamagic changes
// AFW-OEI 06/18/2007: Will save for 1/2.

#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 




// Brock H. - OEI 10/06/05 -- Added code to heal faction, then nearby, and cap based on level
int CureFaction( int nMaxToCure, effect eVis, effect eVis2, object oCaster); 
int CureNearby( int nMaxToCure, effect eVis, effect eVis2, object oCaster); 

void main()
{

    //Declare major variables
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLvl = PS_GetCasterLevel(oCaster);
    effect eVis = EffectVisualEffect( VFX_IMP_SUNSTRIKE );
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_L);
	effect eImpact = EffectVisualEffect(VFX_HIT_CURE_AOE);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());    

	// Cure people in your faction, and then anybody nearby
	int nMaxToCure = nCasterLvl;
	int nCuredInFaction = CureFaction( nMaxToCure, eVis, eVis2, oCaster);
	nMaxToCure = nMaxToCure - nCuredInFaction;
	CureNearby( nMaxToCure, eVis, eVis2, oCaster);

}

void CureObject( object oTarget, effect eVis, effect eVis2, object oCaster)
{
	int nCasterLvl = PS_GetCasterLevel(oCaster);
	int nDamagen, nModify, nHurt;
	effect eKill, eHeal;
	float fDelay = GetRandomDelay();
	int nBonus = nCasterLvl;
	if ( nBonus > 30 ) // Cap the bonus at 30
		nBonus = 30;

	//Check if racial type is undead
	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
	        //Make SR check
	        if (!OnHitResistSpell(oCaster, oTarget))
	        {
				if (GetHasSpell(SPELL_MASS_CURE_MODERATE_WOUNDS, oCaster))
	            	nModify = d8(2) + nCasterLvl;
				else
					nModify = d8() + nCasterLvl;
	
	            //Make Fort save
	            if (MySavingThrow(SAVING_THROW_WILL, oTarget, GetOnHitAbilityDC(oCaster), SAVING_THROW_TYPE_NONE, oCaster, fDelay))
	            {
	                nModify /= 2;
	            }
	            //Calculate damage
	            nHurt =  nModify;
	            //Set damage effect
	            eKill = EffectDamage(nHurt, DAMAGE_TYPE_POSITIVE);
	            //Apply damage effect and VFX impact
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	        }
	    }
	}
	else
	{
	    // * May 2003: Heal Neutrals as well
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	        if (GetHasSpell(SPELL_MASS_CURE_MODERATE_WOUNDS, oCaster))
	           	nModify = d8(2) + nCasterLvl;
			else
				nModify = d8() + nCasterLvl;
	        //Set healing effect
	        nModify = nModify + nCasterLvl;
	        eHeal = EffectHeal(nModify);
	        //Apply heal effect and VFX impact
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
	    }
	}
	
}



int CureFaction( int nMaxToCure, effect eVis, effect eVis2, object oCaster) // returns the # cured
{
	int nNumCured = 0;
	int bPCOnly=FALSE;
	object oTarget = GetFirstFactionMember( oCaster, bPCOnly );
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
	if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
	{
		CureObject( oTarget, eVis, eVis2, oCaster);
		nNumCured++;
	}
		oTarget = GetNextFactionMember( oCaster, bPCOnly );
	}

	return nNumCured;
}


int CureNearby( int nMaxToCure, effect eVis, effect eVis2, object oCaster) // returns the # cured
{
	int nNumCured = 0;

    //Get first target in shape
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    while ( GetIsObjectValid(oTarget) && nNumCured < nMaxToCure )
    {
		if ( !GetFactionEqual( oTarget, oCaster ) || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ) // We've already done faction checks
		{
 			CureObject( oTarget, eVis, eVis2, oCaster);
			nNumCured++;
		}

        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }

	return nNumCured;
}