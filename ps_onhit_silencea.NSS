//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications

#include "X0_I0_SPELLS"
#include "nw_i0_generic"
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    location lTarget = GetLocation(GetAreaOfEffectCreator());
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    int nCasterLevel = GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(GetAreaOfEffectCreator());
	int nID = GetOnHitAbilityID(GetAreaOfEffectCreator());
    effect eDur2 = EffectVisualEffect( VFX_DUR_SPELL_SILENCE );
    effect eSilence = EffectSilence();
    effect eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    effect eLink = EffectLinkEffects(eDur2, eSilence);
    eLink = EffectLinkEffects(eLink, eImmune);
	SetEffectSpellId(eLink, SPELL_SILENCE);

    object oTarget = GetEnteringObject();
	int bHostile = FALSE;

	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
    {
	    if(!GetIsInCombat(oTarget))
			SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE) );
	    if ( !OnHitResistSpell(oCaster,oTarget) )
    	{   
        	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(40));
			string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> silences "+GetName(oTarget)+"</color>";
			SendMessageToPC(oCaster, sReport);
       	}
    }
	else
	{
	    //Fire cast spell at event for the specified target
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(40));
		string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> silences "+GetName(oTarget)+"</color>";
		SendMessageToPC(oCaster, sReport);
        SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE, FALSE) );
		//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	}
	if(!GetLocalInt(oTarget, EVENFLW_SILENCE))
		SetLocalObject(oTarget, EVENFLW_SILENCE, OBJECT_SELF);
	else 
		SetLocalObject(oTarget, EVENFLW_SILENCE, OBJECT_INVALID);
}